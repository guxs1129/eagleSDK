
//
//  EGEngine.m
//  AFNetworking
//
//  Created by pantao on 2017/12/22.
//

#import "EGEngine.h"
#import <objc/runtime.h>
#import <objc/message.h>

#if TARGET_OS_IPHONE
#import <UIKit/UIApplication.h>
#endif

#if CGFLOAT_IS_DOUBLE
#define CGFloatValue doubleValue
#else
#define CGFloatValue floatValue
#endif

#pragma mark -- EGBoxing

@implementation EGBoxing

#define EGBOXING_GEN(_name, _prop, _type) \
+ (instancetype)_name:(_type)obj  \
{   \
EGBoxing *boxing = [[EGBoxing alloc] init]; \
boxing._prop = obj;   \
return boxing;  \
}

EGBOXING_GEN(boxObj, obj, id)
EGBOXING_GEN(boxPointer, pointer, void *)
EGBOXING_GEN(boxClass, cls, Class)
EGBOXING_GEN(boxWeakObj, weakObj, id)
EGBOXING_GEN(boxAssignObj, assignObj, id)

- (id)unbox
{
    if (self.obj) return self.obj;
    if (self.weakObj) return self.weakObj;
    if (self.assignObj) return self.assignObj;
    if (self.cls) return self.cls;
    return self;
}
- (void *)unboxPointer
{
    return self.pointer;
}
- (Class)unboxClass
{
    return self.cls;
}
@end

typedef struct {double d;} EGDouble;
typedef struct {float f;} EGFloat;

static NSMethodSignature *fixSignature(NSMethodSignature *signature)
{
#if TARGET_OS_IPHONE
#ifdef __LP64__
    if (!signature) {
        return nil;
    }
    
    if ([[UIDevice currentDevice].systemVersion floatValue] < 7.09) {
        BOOL isReturnDouble = (strcmp([signature methodReturnType], "d") == 0);
        BOOL isReturnFloat = (strcmp([signature methodReturnType], "f") == 0);
        
        if (isReturnDouble || isReturnFloat) {
            NSMutableString *types = [NSMutableString stringWithFormat:@"%s@:", isReturnDouble ? @encode(EGDouble) : @encode(EGFloat)];
            for (int i = 2; i < signature.numberOfArguments; i++) {
                const char *argType = [signature getArgumentTypeAtIndex:i];
                [types appendFormat:@"%s", argType];
            }
            signature = [NSMethodSignature signatureWithObjCTypes:[types UTF8String]];
        }
    }
#endif
#endif
    return signature;
}

#pragma mark -- EGFix

@interface NSObject (EGFix)
- (NSMethodSignature *)eg_methodSignatureForSelector:(SEL)aSelector;
+ (void)eg_fixMethodSignature;
@end

@implementation NSObject (EGFix)
const static void *EGFixedFlagKey = &EGFixedFlagKey;
- (NSMethodSignature *)eg_methodSignatureForSelector:(SEL)aSelector
{
    NSMethodSignature *signature = [self eg_methodSignatureForSelector:aSelector];
    return fixSignature(signature);
}
+ (void)eg_fixMethodSignature
{
#if TARGET_OS_IPHONE
#ifdef __LP64__
    if ([[UIDevice currentDevice].systemVersion floatValue] < 7.1) {
        NSNumber *flag = objc_getAssociatedObject(self, EGFixedFlagKey);
        if (!flag.boolValue) {
            SEL originalSelector = @selector(methodSignatureForSelector:);
            SEL swizzledSelector = @selector(eg_methodSignatureForSelector:);
            Method originalMethod = class_getInstanceMethod(self, originalSelector);
            Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
            BOOL didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
            if (didAddMethod) {
                class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
            } else {
                method_exchangeImplementations(originalMethod, swizzledMethod);
            }
            objc_setAssociatedObject(self, EGFixedFlagKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
#endif
#endif
}
@end

#pragma mark -- EGEngine

static JSContext *_context;
static NSString *_regexStr = @"(?<!\\\\)\\.\\s*(\\w+)\\s*\\(";
static NSString *_replaceStr = @".__c(\"$1\")(";
static NSRegularExpression* _regex;
static NSObject *_nullObj;
static NSObject *_nilObj;
static NSMutableDictionary *_registeredStruct;
static NSMutableDictionary *_currInvokeSuperClsName;
static BOOL _autoConvert;
static BOOL _convertOCNumberToString;

static NSMutableDictionary *_JSOverideMethods;
static NSMutableDictionary *_TMPMemoryPool;
static NSMutableDictionary *_propKeys;
static NSMutableDictionary *_JSMethodSignatureCache;
static NSLock              *_JSMethodSignatureLock;
static NSRecursiveLock     *_JSMethodForwardCallLock;
static NSMutableArray      *_pointersToRelease;

#ifdef DEBUG
static NSArray *_JSLastCallStack;
#endif

static void (^_exceptionBlock)(NSString *log) = ^void(NSString *log) {
    NSCAssert(NO, log);
};

@implementation EGEngine

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

+ (void)startEngine
{
    if (![JSContext class] || _context) {
        return;
    }
    JSContext *context = [[JSContext alloc] init];
    context[@"_OC_defineClass"] = ^(NSString *classDeclaration, JSValue *instanceMethods, JSValue *classMethods) {
        return defineClass(classDeclaration, instanceMethods, classMethods);
    };
    context[@"_OC_callI"] = ^id(JSValue *obj, NSString *selectorName, JSValue *arguments, BOOL isSuper) {
        return callSelector(nil, selectorName, arguments, obj, isSuper);
    };
    context[@"_OC_callC"] = ^id(NSString *className, NSString *selectorName, JSValue *arguments) {
        return callSelector(className, selectorName, arguments, nil, NO);
    };
    context[@"_OC_log"] = ^() {
        NSArray *args = [JSContext currentArguments];
        for (JSValue *jsVal in args) {
            id obj = formatJSToOC(jsVal);
            NSLog(@"EGPatch.log: %@", obj == _nilObj ? nil : (obj == _nullObj ? [NSNull null]: obj));
        }
    };
    _context = context;
    _nilObj = [[NSObject alloc] init];
    _JSMethodSignatureLock = [[NSLock alloc] init];
    _JSMethodForwardCallLock = [[NSRecursiveLock alloc] init];
    _registeredStruct = [[NSMutableDictionary alloc] init];
    _currInvokeSuperClsName = [[NSMutableDictionary alloc] init];
    NSString *path = [[NSBundle bundleForClass:[EGEngine class]] pathForResource:@"EGPatch" ofType:@"js"];
    if (!path) _exceptionBlock(@"can't find EGPatch.js");
    NSString *jsCore = [[NSString alloc] initWithData:[[NSFileManager defaultManager] contentsAtPath:path] encoding:NSUTF8StringEncoding];

    if ([_context respondsToSelector:@selector(evaluateScript:withSourceURL:)]) {
        [_context evaluateScript:jsCore withSourceURL:[NSURL URLWithString:@"EGPatch.js"]];
    } else {
        [_context evaluateScript:jsCore];
    }
}

+ (JSValue *)evaluateScript:(NSString *)script
{
    return [self _evaluateScript:script withSourceURL:[NSURL URLWithString:@"main.js"]];
}

+ (JSValue *)_evaluateScript:(NSString *)script withSourceURL:(NSURL *)resourceURL
{
    if (!script || ![JSContext class]) {
        _exceptionBlock(@"script is nil");
        return nil;
    }
    [self startEngine];
    
    if (!_regex) {
        _regex = [NSRegularExpression regularExpressionWithPattern:_regexStr options:0 error:nil];
    }
    NSString *formatedScript = [NSString stringWithFormat:@";(function(){try{\n%@\n}catch(e){_OC_catch(e.message, e.stack)}})();", [_regex stringByReplacingMatchesInString:script options:0 range:NSMakeRange(0, script.length) withTemplate:_replaceStr]];
    @try {
        if ([_context respondsToSelector:@selector(evaluateScript:withSourceURL:)]) {
            return [_context evaluateScript:formatedScript withSourceURL:resourceURL];
        } else {
            return [_context evaluateScript:formatedScript];
        }
    }
    @catch (NSException *exception) {
        _exceptionBlock([NSString stringWithFormat:@"%@", exception]);
    }
    return nil;
}

#pragma mark - Utils

static NSString *trim(NSString *string)
{
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

static BOOL blockTypeIsObject(NSString *typeString)
{
    return [typeString rangeOfString:@"*"].location != NSNotFound || [typeString isEqualToString:@"id"];
}

static BOOL blockTypeIsScalarPointer(NSString *typeString)
{
    NSUInteger location = [typeString rangeOfString:@"*"].location;
    NSString *typeWithoutAsterisk = trim([typeString stringByReplacingOccurrencesOfString:@"*" withString:@""]);
    
    return (location == typeString.length-1 &&
            !NSClassFromString(typeWithoutAsterisk));
}

static NSString *convertEGSelectorString(NSString *selectorString)
{
    NSString *tmpJSMethodName = [selectorString stringByReplacingOccurrencesOfString:@"__" withString:@"-"];
    NSString *selectorName = [tmpJSMethodName stringByReplacingOccurrencesOfString:@"_" withString:@":"];
    return [selectorName stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
}

static NSDictionary *_wrapObj(id obj)
{
    if (!obj || obj == _nilObj) {
        return @{@"__isNil": @(YES)};
    }
    return @{@"__obj": obj, @"__clsName": NSStringFromClass([obj isKindOfClass:[EGBoxing class]] ? [[((EGBoxing *)obj) unbox] class]: [obj class])};
}

static id formatOCToJS(id obj)
{
    if ([obj isKindOfClass:[NSString class]] || [obj isKindOfClass:[NSDictionary class]] || [obj isKindOfClass:[NSArray class]] || [obj isKindOfClass:[NSDate class]]) {
        return _autoConvert ? obj: _wrapObj([EGBoxing boxObj:obj]);
    }
    if ([obj isKindOfClass:[NSNumber class]]) {
        return _convertOCNumberToString ? [(NSNumber*)obj stringValue] : obj;
    }
    if ([obj isKindOfClass:NSClassFromString(@"NSBlock")] || [obj isKindOfClass:[JSValue class]]) {
        return obj;
    }
    return _wrapObj(obj);
}

static id genCallbackBlock(JSValue *jsVal)
{
#define BLK_TRAITS_ARG(_idx, _paramName) \
if (_idx < argTypes.count) { \
NSString *argType = trim(argTypes[_idx]); \
if (blockTypeIsScalarPointer(argType)) { \
[list addObject:formatOCToJS([EGBoxing boxPointer:_paramName])]; \
} else if (blockTypeIsObject(trim(argTypes[_idx]))) {  \
[list addObject:formatOCToJS((__bridge id)_paramName)]; \
} else {  \
[list addObject:formatOCToJS([NSNumber numberWithLongLong:(long long)_paramName])]; \
}   \
}
    
    NSArray *argTypes = [[jsVal[@"args"] toString] componentsSeparatedByString:@","];
    if (argTypes.count > [jsVal[@"argCount"] toInt32]) {
        argTypes = [argTypes subarrayWithRange:NSMakeRange(1, argTypes.count - 1)];
    }
    id cb = ^id(void *p0, void *p1, void *p2, void *p3, void *p4, void *p5) {
        NSMutableArray *list = [[NSMutableArray alloc] init];
        BLK_TRAITS_ARG(0, p0)
        BLK_TRAITS_ARG(1, p1)
        BLK_TRAITS_ARG(2, p2)
        BLK_TRAITS_ARG(3, p3)
        BLK_TRAITS_ARG(4, p4)
        BLK_TRAITS_ARG(5, p5)
        JSValue *ret = [jsVal[@"cb"] callWithArguments:list];
        return formatJSToOC(ret);
    };
    
    return cb;
}

#pragma mark - Implements

static const void *propKey(NSString *propName) {
    if (!_propKeys) _propKeys = [[NSMutableDictionary alloc] init];
    id key = _propKeys[propName];
    if (!key) {
        key = [propName copy];
        [_propKeys setObject:key forKey:propName];
    }
    return (__bridge const void *)(key);
}
static id getPropIMP(id slf, SEL selector, NSString *propName) {
    return objc_getAssociatedObject(slf, propKey(propName));
}
static void setPropIMP(id slf, SEL selector, id val, NSString *propName) {
    objc_setAssociatedObject(slf, propKey(propName), val, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark --

static char *methodTypesInProtocol(NSString *protocolName, NSString *selectorName, BOOL isInstanceMethod, BOOL isRequired)
{
    Protocol *protocol = objc_getProtocol([trim(protocolName) cStringUsingEncoding:NSUTF8StringEncoding]);
    unsigned int selCount = 0;
    struct objc_method_description *methods = protocol_copyMethodDescriptionList(protocol, isRequired, isInstanceMethod, &selCount);
    for (int i = 0; i < selCount; i ++) {
        if ([selectorName isEqualToString:NSStringFromSelector(methods[i].name)]) {
            char *types = malloc(strlen(methods[i].types) + 1);
            strcpy(types, methods[i].types);
            free(methods);
            return types;
        }
    }
    free(methods);
    return NULL;
}

/*************************************************************消息转发*************************************************************/
static JSValue *getJSFunctionInObjectHierachy(id slf, NSString *selectorName)
{
    Class cls = object_getClass(slf);
    if (_currInvokeSuperClsName[selectorName]) {
        cls = NSClassFromString(_currInvokeSuperClsName[selectorName]);
        selectorName = [selectorName stringByReplacingOccurrencesOfString:@"_EGSUPER_" withString:@"_EG"];
    }
    JSValue *func = _JSOverideMethods[cls][selectorName];
    while (!func) {
        cls = class_getSuperclass(cls);
        if (!cls) {
            return nil;
        }
        func = _JSOverideMethods[cls][selectorName];
    }
    return func;
}

static void EGExecuteORIGForwardInvocation(id slf, SEL selector, NSInvocation *invocation)
{
    SEL origForwardSelector = @selector(ORIGforwardInvocation:);
    
    if ([slf respondsToSelector:origForwardSelector]) {
        NSMethodSignature *methodSignature = [slf methodSignatureForSelector:origForwardSelector];
        if (!methodSignature) {
            _exceptionBlock([NSString stringWithFormat:@"unrecognized selector -ORIGforwardInvocation: for instance %@", slf]);
            return;
        }
        NSInvocation *forwardInv= [NSInvocation invocationWithMethodSignature:methodSignature];
        [forwardInv setTarget:slf];
        [forwardInv setSelector:origForwardSelector];
        [forwardInv setArgument:&invocation atIndex:2];
        [forwardInv invoke];
    } else {
        Class superCls = [[slf class] superclass];
        Method superForwardMethod = class_getInstanceMethod(superCls, @selector(forwardInvocation:));
        void (*superForwardIMP)(id, SEL, NSInvocation *);
        superForwardIMP = (void (*)(id, SEL, NSInvocation *))method_getImplementation(superForwardMethod);
        superForwardIMP(slf, @selector(forwardInvocation:), invocation);
    }
}

static NSString *extractStructName(NSString *typeEncodeString)
{
    NSArray *array = [typeEncodeString componentsSeparatedByString:@"="];
    NSString *typeString = array[0];
    int firstValidIndex = 0;
    for (int i = 0; i< typeString.length; i++) {
        char c = [typeString characterAtIndex:i];
        if (c == '{' || c=='_') {
            firstValidIndex++;
        }else {
            break;
        }
    }
    return [typeString substringFromIndex:firstValidIndex];
}

static int sizeOfStructTypes(NSString *structTypes)
{
    const char *types = [structTypes cStringUsingEncoding:NSUTF8StringEncoding];
    int index = 0;
    int size = 0;
    while (types[index]) {
        switch (types[index]) {
#define EG_STRUCT_SIZE_CASE(_typeChar, _type)   \
case _typeChar: \
size += sizeof(_type);  \
break;
                
                EG_STRUCT_SIZE_CASE('c', char)
                EG_STRUCT_SIZE_CASE('C', unsigned char)
                EG_STRUCT_SIZE_CASE('s', short)
                EG_STRUCT_SIZE_CASE('S', unsigned short)
                EG_STRUCT_SIZE_CASE('i', int)
                EG_STRUCT_SIZE_CASE('I', unsigned int)
                EG_STRUCT_SIZE_CASE('l', long)
                EG_STRUCT_SIZE_CASE('L', unsigned long)
                EG_STRUCT_SIZE_CASE('q', long long)
                EG_STRUCT_SIZE_CASE('Q', unsigned long long)
                EG_STRUCT_SIZE_CASE('f', float)
                EG_STRUCT_SIZE_CASE('F', CGFloat)
                EG_STRUCT_SIZE_CASE('N', NSInteger)
                EG_STRUCT_SIZE_CASE('U', NSUInteger)
                EG_STRUCT_SIZE_CASE('d', double)
                EG_STRUCT_SIZE_CASE('B', BOOL)
                EG_STRUCT_SIZE_CASE('*', void *)
                EG_STRUCT_SIZE_CASE('^', void *)
                
            case '{': {
                NSString *structTypeStr = [structTypes substringFromIndex:index];
                NSUInteger end = [structTypeStr rangeOfString:@"}"].location;
                if (end != NSNotFound) {
                    NSString *subStructName = [structTypeStr substringWithRange:NSMakeRange(1, end - 1)];
                    NSDictionary *subStructDefine = [EGExtension registeredStruct][subStructName];
                    NSString *subStructTypes = subStructDefine[@"types"];
                    size += sizeOfStructTypes(subStructTypes);
                    index += (int)end;
                    break;
                }
            }
                
            default:
                break;
        }
        index ++;
    }
    return size;
}

static NSDictionary *getDictOfStruct(void *structData, NSDictionary *structDefine)
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSArray *itemKeys = structDefine[@"keys"];
    const char *structTypes = [structDefine[@"types"] cStringUsingEncoding:NSUTF8StringEncoding];
    int position = 0;
    
    for (NSString *itemKey in itemKeys) {
        switch(*structTypes) {
#define EG_STRUCT_DICT_CASE(_typeName, _type)   \
case _typeName: { \
size_t size = sizeof(_type); \
_type *val = malloc(size);   \
memcpy(val, structData + position, size);   \
[dict setObject:@(*val) forKey:itemKey];    \
free(val);  \
position += size;   \
break;  \
}
                EG_STRUCT_DICT_CASE('c', char)
                EG_STRUCT_DICT_CASE('C', unsigned char)
                EG_STRUCT_DICT_CASE('s', short)
                EG_STRUCT_DICT_CASE('S', unsigned short)
                EG_STRUCT_DICT_CASE('i', int)
                EG_STRUCT_DICT_CASE('I', unsigned int)
                EG_STRUCT_DICT_CASE('l', long)
                EG_STRUCT_DICT_CASE('L', unsigned long)
                EG_STRUCT_DICT_CASE('q', long long)
                EG_STRUCT_DICT_CASE('Q', unsigned long long)
                EG_STRUCT_DICT_CASE('f', float)
                EG_STRUCT_DICT_CASE('F', CGFloat)
                EG_STRUCT_DICT_CASE('N', NSInteger)
                EG_STRUCT_DICT_CASE('U', NSUInteger)
                EG_STRUCT_DICT_CASE('d', double)
                EG_STRUCT_DICT_CASE('B', BOOL)
                
            case '*':
            case '^': {
                size_t size = sizeof(void *);
                void *val = malloc(size);
                memcpy(val, structData + position, size);
                [dict setObject:[EGBoxing boxPointer:val] forKey:itemKey];
                position += size;
                break;
            }
            case '{': {
                NSString *subStructName = [NSString stringWithCString:structTypes encoding:NSASCIIStringEncoding];
                NSUInteger end = [subStructName rangeOfString:@"}"].location;
                if (end != NSNotFound) {
                    subStructName = [subStructName substringWithRange:NSMakeRange(1, end - 1)];
                    NSDictionary *subStructDefine = [EGExtension registeredStruct][subStructName];
                    int size = sizeOfStructTypes(subStructDefine[@"types"]);
                    NSDictionary *subDict = getDictOfStruct(structData + position, subStructDefine);
                    [dict setObject:subDict forKey:itemKey];
                    position += size;
                    structTypes += end;
                    break;
                }
            }
        }
        structTypes ++;
    }
    return dict;
}

static id _unboxOCObjectToJS(id obj)
{
    if ([obj isKindOfClass:[NSArray class]]) {
        NSMutableArray *newArr = [[NSMutableArray alloc] init];
        for (int i = 0; i < [(NSArray*)obj count]; i ++) {
            [newArr addObject:_unboxOCObjectToJS(obj[i])];
        }
        return newArr;
    }
    if ([obj isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
        for (NSString *key in [obj allKeys]) {
            [newDict setObject:_unboxOCObjectToJS(obj[key]) forKey:key];
        }
        return newDict;
    }
    if ([obj isKindOfClass:[NSString class]] ||[obj isKindOfClass:[NSNumber class]] || [obj isKindOfClass:NSClassFromString(@"NSBlock")] || [obj isKindOfClass:[NSDate class]]) {
        return obj;
    }
    return _wrapObj(obj);
}

static id getArgument(id valObj){
    if (valObj == _nilObj ||
        ([valObj isKindOfClass:[NSNumber class]] && strcmp([valObj objCType], "c") == 0 && ![valObj boolValue])) {
        return nil;
    }
    return valObj;
}

static id (*new_msgSend1)(id, SEL, id,...) = (id (*)(id, SEL, id,...)) objc_msgSend;
static id (*new_msgSend2)(id, SEL, id, id,...) = (id (*)(id, SEL, id, id,...)) objc_msgSend;
static id (*new_msgSend3)(id, SEL, id, id, id,...) = (id (*)(id, SEL, id, id, id,...)) objc_msgSend;
static id (*new_msgSend4)(id, SEL, id, id, id, id,...) = (id (*)(id, SEL, id, id, id, id,...)) objc_msgSend;
static id (*new_msgSend5)(id, SEL, id, id, id, id, id,...) = (id (*)(id, SEL, id, id, id, id, id,...)) objc_msgSend;
static id (*new_msgSend6)(id, SEL, id, id, id, id, id, id,...) = (id (*)(id, SEL, id, id, id, id, id, id,...)) objc_msgSend;
static id (*new_msgSend7)(id, SEL, id, id, id, id, id, id, id,...) = (id (*)(id, SEL, id, id, id, id, id, id,id,...)) objc_msgSend;
static id (*new_msgSend8)(id, SEL, id, id, id, id, id, id, id, id,...) = (id (*)(id, SEL, id, id, id, id, id, id, id, id,...)) objc_msgSend;
static id (*new_msgSend9)(id, SEL, id, id, id, id, id, id, id, id, id,...) = (id (*)(id, SEL, id, id, id, id, id, id, id, id, id, ...)) objc_msgSend;
static id (*new_msgSend10)(id, SEL, id, id, id, id, id, id, id, id, id, id,...) = (id (*)(id, SEL, id, id, id, id, id, id, id, id, id, id,...)) objc_msgSend;

static id invokeVariableParameterMethod(NSMutableArray *origArgumentsList, NSMethodSignature *methodSignature, id sender, SEL selector) {
    
    NSInteger inputArguments = [(NSArray *)origArgumentsList count];
    NSUInteger numberOfArguments = methodSignature.numberOfArguments;
    
    NSMutableArray *argumentsList = [[NSMutableArray alloc] init];
    for (NSUInteger j = 0; j < inputArguments; j++) {
        NSInteger index = MIN(j + 2, numberOfArguments - 1);
        const char *argumentType = [methodSignature getArgumentTypeAtIndex:index];
        id valObj = origArgumentsList[j];
        char argumentTypeChar = argumentType[0] == 'r' ? argumentType[1] : argumentType[0];
        if (argumentTypeChar == '@') {
            [argumentsList addObject:valObj];
        } else {
            return nil;
        }
    }
    
    id results = nil;
    numberOfArguments = numberOfArguments - 2;
    
    //If you want to debug the macro code below, replace it to the expanded code:
    //https://gist.github.com/bang590/ca3720ae1da594252a2e
#define EG_G_ARG(_idx) getArgument(argumentsList[_idx])
#define EG_CALL_MSGSEND_ARG1(_num) results = new_msgSend##_num(sender, selector, EG_G_ARG(0));
#define EG_CALL_MSGSEND_ARG2(_num) results = new_msgSend##_num(sender, selector, EG_G_ARG(0), EG_G_ARG(1));
#define EG_CALL_MSGSEND_ARG3(_num) results = new_msgSend##_num(sender, selector, EG_G_ARG(0), EG_G_ARG(1), EG_G_ARG(2));
#define EG_CALL_MSGSEND_ARG4(_num) results = new_msgSend##_num(sender, selector, EG_G_ARG(0), EG_G_ARG(1), EG_G_ARG(2), EG_G_ARG(3));
#define EG_CALL_MSGSEND_ARG5(_num) results = new_msgSend##_num(sender, selector, EG_G_ARG(0), EG_G_ARG(1), EG_G_ARG(2), EG_G_ARG(3), EG_G_ARG(4));
#define EG_CALL_MSGSEND_ARG6(_num) results = new_msgSend##_num(sender, selector, EG_G_ARG(0), EG_G_ARG(1), EG_G_ARG(2), EG_G_ARG(3), EG_G_ARG(4), EG_G_ARG(5));
#define EG_CALL_MSGSEND_ARG7(_num) results = new_msgSend##_num(sender, selector, EG_G_ARG(0), EG_G_ARG(1), EG_G_ARG(2), EG_G_ARG(3), EG_G_ARG(4), EG_G_ARG(5), EG_G_ARG(6));
#define EG_CALL_MSGSEND_ARG8(_num) results = new_msgSend##_num(sender, selector, EG_G_ARG(0), EG_G_ARG(1), EG_G_ARG(2), EG_G_ARG(3), EG_G_ARG(4), EG_G_ARG(5), EG_G_ARG(6), EG_G_ARG(7));
#define EG_CALL_MSGSEND_ARG9(_num) results = new_msgSend##_num(sender, selector, EG_G_ARG(0), EG_G_ARG(1), EG_G_ARG(2), EG_G_ARG(3), EG_G_ARG(4), EG_G_ARG(5), EG_G_ARG(6), EG_G_ARG(7), EG_G_ARG(8));
#define EG_CALL_MSGSEND_ARG10(_num) results = new_msgSend##_num(sender, selector, EG_G_ARG(0), EG_G_ARG(1), EG_G_ARG(2), EG_G_ARG(3), EG_G_ARG(4), EG_G_ARG(5), EG_G_ARG(6), EG_G_ARG(7), EG_G_ARG(8), EG_G_ARG(9));
#define EG_CALL_MSGSEND_ARG11(_num) results = new_msgSend##_num(sender, selector, EG_G_ARG(0), EG_G_ARG(1), EG_G_ARG(2), EG_G_ARG(3), EG_G_ARG(4), EG_G_ARG(5), EG_G_ARG(6), EG_G_ARG(7), EG_G_ARG(8), EG_G_ARG(9), EG_G_ARG(10));
    
#define EG_IF_REAL_ARG_COUNT(_num) if([argumentsList count] == _num)
    
#define EG_DEAL_MSGSEND(_realArgCount, _defineArgCount) \
if(numberOfArguments == _defineArgCount) { \
EG_CALL_MSGSEND_ARG##_realArgCount(_defineArgCount) \
}
    
    EG_IF_REAL_ARG_COUNT(1) { EG_CALL_MSGSEND_ARG1(1) }
    EG_IF_REAL_ARG_COUNT(2) { EG_DEAL_MSGSEND(2, 1) EG_DEAL_MSGSEND(2, 2) }
    EG_IF_REAL_ARG_COUNT(3) { EG_DEAL_MSGSEND(3, 1) EG_DEAL_MSGSEND(3, 2) EG_DEAL_MSGSEND(3, 3) }
    EG_IF_REAL_ARG_COUNT(4) { EG_DEAL_MSGSEND(4, 1) EG_DEAL_MSGSEND(4, 2) EG_DEAL_MSGSEND(4, 3) EG_DEAL_MSGSEND(4, 4) }
    EG_IF_REAL_ARG_COUNT(5) { EG_DEAL_MSGSEND(5, 1) EG_DEAL_MSGSEND(5, 2) EG_DEAL_MSGSEND(5, 3) EG_DEAL_MSGSEND(5, 4) EG_DEAL_MSGSEND(5, 5) }
    EG_IF_REAL_ARG_COUNT(6) { EG_DEAL_MSGSEND(6, 1) EG_DEAL_MSGSEND(6, 2) EG_DEAL_MSGSEND(6, 3) EG_DEAL_MSGSEND(6, 4) EG_DEAL_MSGSEND(6, 5) EG_DEAL_MSGSEND(6, 6) }
    EG_IF_REAL_ARG_COUNT(7) { EG_DEAL_MSGSEND(7, 1) EG_DEAL_MSGSEND(7, 2) EG_DEAL_MSGSEND(7, 3) EG_DEAL_MSGSEND(7, 4) EG_DEAL_MSGSEND(7, 5) EG_DEAL_MSGSEND(7, 6) EG_DEAL_MSGSEND(7, 7) }
    EG_IF_REAL_ARG_COUNT(8) { EG_DEAL_MSGSEND(8, 1) EG_DEAL_MSGSEND(8, 2) EG_DEAL_MSGSEND(8, 3) EG_DEAL_MSGSEND(8, 4) EG_DEAL_MSGSEND(8, 5) EG_DEAL_MSGSEND(8, 6) EG_DEAL_MSGSEND(8, 7) EG_DEAL_MSGSEND(8, 8) }
    EG_IF_REAL_ARG_COUNT(9) { EG_DEAL_MSGSEND(9, 1) EG_DEAL_MSGSEND(9, 2) EG_DEAL_MSGSEND(9, 3) EG_DEAL_MSGSEND(9, 4) EG_DEAL_MSGSEND(9, 5) EG_DEAL_MSGSEND(9, 6) EG_DEAL_MSGSEND(9, 7) EG_DEAL_MSGSEND(9, 8) EG_DEAL_MSGSEND(9, 9) }
    EG_IF_REAL_ARG_COUNT(10) { EG_DEAL_MSGSEND(10, 1) EG_DEAL_MSGSEND(10, 2) EG_DEAL_MSGSEND(10, 3) EG_DEAL_MSGSEND(10, 4) EG_DEAL_MSGSEND(10, 5) EG_DEAL_MSGSEND(10, 6) EG_DEAL_MSGSEND(10, 7) EG_DEAL_MSGSEND(10, 8) EG_DEAL_MSGSEND(10, 9) EG_DEAL_MSGSEND(10, 10) }
    
    return results;
}

static void getStructDataWithDict(void *structData, NSDictionary *dict, NSDictionary *structDefine)
{
    NSArray *itemKeys = structDefine[@"keys"];
    const char *structTypes = [structDefine[@"types"] cStringUsingEncoding:NSUTF8StringEncoding];
    int position = 0;
    for (NSString *itemKey in itemKeys) {
        switch(*structTypes) {
#define EG_STRUCT_DATA_CASE(_typeStr, _type, _transMethod) \
case _typeStr: { \
int size = sizeof(_type);    \
_type val = [dict[itemKey] _transMethod];   \
memcpy(structData + position, &val, size);  \
position += size;    \
break;  \
}
                
                EG_STRUCT_DATA_CASE('c', char, charValue)
                EG_STRUCT_DATA_CASE('C', unsigned char, unsignedCharValue)
                EG_STRUCT_DATA_CASE('s', short, shortValue)
                EG_STRUCT_DATA_CASE('S', unsigned short, unsignedShortValue)
                EG_STRUCT_DATA_CASE('i', int, intValue)
                EG_STRUCT_DATA_CASE('I', unsigned int, unsignedIntValue)
                EG_STRUCT_DATA_CASE('l', long, longValue)
                EG_STRUCT_DATA_CASE('L', unsigned long, unsignedLongValue)
                EG_STRUCT_DATA_CASE('q', long long, longLongValue)
                EG_STRUCT_DATA_CASE('Q', unsigned long long, unsignedLongLongValue)
                EG_STRUCT_DATA_CASE('f', float, floatValue)
                EG_STRUCT_DATA_CASE('F', CGFloat, CGFloatValue)
                EG_STRUCT_DATA_CASE('d', double, doubleValue)
                EG_STRUCT_DATA_CASE('B', BOOL, boolValue)
                EG_STRUCT_DATA_CASE('N', NSInteger, integerValue)
                EG_STRUCT_DATA_CASE('U', NSUInteger, unsignedIntegerValue)
                
            case '*':
            case '^': {
                int size = sizeof(void *);
                void *val = [(EGBoxing *)dict[itemKey] unboxPointer];
                memcpy(structData + position, &val, size);
                break;
            }
            case '{': {
                NSString *subStructName = [NSString stringWithCString:structTypes encoding:NSASCIIStringEncoding];
                NSUInteger end = [subStructName rangeOfString:@"}"].location;
                if (end != NSNotFound) {
                    subStructName = [subStructName substringWithRange:NSMakeRange(1, end - 1)];
                    NSDictionary *subStructDefine = [EGExtension registeredStruct][subStructName];
                    NSDictionary *subDict = dict[itemKey];
                    int size = sizeOfStructTypes(subStructDefine[@"types"]);
                    getStructDataWithDict(structData + position, subDict, subStructDefine);
                    position += size;
                    structTypes += end;
                    break;
                }
            }
            default:
                break;
                
        }
        structTypes ++;
    }
}

static id _formatOCToJSList(NSArray *list)
{
    NSMutableArray *arr = [NSMutableArray new];
    for (id obj in list) {
        [arr addObject:formatOCToJS(obj)];
    }
    return arr;
}

static id callSelector(NSString *className, NSString *selectorName, JSValue *arguments, JSValue *instance, BOOL isSuper)
{
    NSString *realClsName = [[instance valueForProperty:@"__realClsName"] toString];
    
    if (instance) {
        instance = formatJSToOC(instance);
        if (class_isMetaClass(object_getClass(instance))) {
            className = NSStringFromClass((Class)instance);
            instance = nil;
        } else if (!instance || instance == _nilObj || [instance isKindOfClass:[EGBoxing class]]) {
            return @{@"__isNil": @(YES)};
        }
    }
    id argumentsObj = formatJSToOC(arguments);
    
    if (instance && [selectorName isEqualToString:@"toJS"]) {
        if ([instance isKindOfClass:[NSString class]] || [instance isKindOfClass:[NSDictionary class]] || [instance isKindOfClass:[NSArray class]] || [instance isKindOfClass:[NSDate class]]) {
            return _unboxOCObjectToJS(instance);
        }
    }
    
    Class cls = instance ? [instance class] : NSClassFromString(className);
    SEL selector = NSSelectorFromString(selectorName);
    
    NSString *superClassName = nil;
    if (isSuper) {
        NSString *superSelectorName = [NSString stringWithFormat:@"SUPER_%@", selectorName];
        SEL superSelector = NSSelectorFromString(superSelectorName);
        
        Class superCls;
        if (realClsName.length) {
            Class defineClass = NSClassFromString(realClsName);
            superCls = defineClass ? [defineClass superclass] : [cls superclass];
        } else {
            superCls = [cls superclass];
        }
        
        Method superMethod = class_getInstanceMethod(superCls, selector);
        IMP superIMP = method_getImplementation(superMethod);
        
        class_addMethod(cls, superSelector, superIMP, method_getTypeEncoding(superMethod));
        
        NSString *EGSelectorName = [NSString stringWithFormat:@"_EG%@", selectorName];
        JSValue *overideFunction = _JSOverideMethods[superCls][EGSelectorName];
        if (overideFunction) {
            overrideMethod(cls, superSelectorName, overideFunction, NO, NULL);
        }
        
        selector = superSelector;
        superClassName = NSStringFromClass(superCls);
    }
    
    
    NSMutableArray *_markArray;
    
    NSInvocation *invocation;
    NSMethodSignature *methodSignature;
    if (!_JSMethodSignatureCache) {
        _JSMethodSignatureCache = [[NSMutableDictionary alloc]init];
    }
    if (instance) {
        [_JSMethodSignatureLock lock];
        if (!_JSMethodSignatureCache[cls]) {
            _JSMethodSignatureCache[(id<NSCopying>)cls] = [[NSMutableDictionary alloc]init];
        }
        methodSignature = _JSMethodSignatureCache[cls][selectorName];
        if (!methodSignature) {
            methodSignature = [cls instanceMethodSignatureForSelector:selector];
            methodSignature = fixSignature(methodSignature);
            _JSMethodSignatureCache[cls][selectorName] = methodSignature;
        }
        [_JSMethodSignatureLock unlock];
        if (!methodSignature) {
            _exceptionBlock([NSString stringWithFormat:@"unrecognized selector %@ for instance %@", selectorName, instance]);
            return nil;
        }
        invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
        [invocation setTarget:instance];
    } else {
        methodSignature = [cls methodSignatureForSelector:selector];
        methodSignature = fixSignature(methodSignature);
        if (!methodSignature) {
            _exceptionBlock([NSString stringWithFormat:@"unrecognized selector %@ for class %@", selectorName, className]);
            return nil;
        }
        invocation= [NSInvocation invocationWithMethodSignature:methodSignature];
        [invocation setTarget:cls];
    }
    [invocation setSelector:selector];
    
    NSUInteger numberOfArguments = methodSignature.numberOfArguments;
    NSInteger inputArguments = [(NSArray *)argumentsObj count];
    if (inputArguments > numberOfArguments - 2) {
        // calling variable argument method, only support parameter type `id` and return type `id`
        id sender = instance != nil ? instance : cls;
        id result = invokeVariableParameterMethod(argumentsObj, methodSignature, sender, selector);
        return formatOCToJS(result);
    }
    
    for (NSUInteger i = 2; i < numberOfArguments; i++) {
        const char *argumentType = [methodSignature getArgumentTypeAtIndex:i];
        id valObj = argumentsObj[i-2];
        switch (argumentType[0] == 'r' ? argumentType[1] : argumentType[0]) {
                
#define EG_CALL_ARG_CASE(_typeString, _type, _selector) \
case _typeString: {                              \
_type value = [valObj _selector];                     \
[invocation setArgument:&value atIndex:i];\
break; \
}
                
                EG_CALL_ARG_CASE('c', char, charValue)
                EG_CALL_ARG_CASE('C', unsigned char, unsignedCharValue)
                EG_CALL_ARG_CASE('s', short, shortValue)
                EG_CALL_ARG_CASE('S', unsigned short, unsignedShortValue)
                EG_CALL_ARG_CASE('i', int, intValue)
                EG_CALL_ARG_CASE('I', unsigned int, unsignedIntValue)
                EG_CALL_ARG_CASE('l', long, longValue)
                EG_CALL_ARG_CASE('L', unsigned long, unsignedLongValue)
                EG_CALL_ARG_CASE('q', long long, longLongValue)
                EG_CALL_ARG_CASE('Q', unsigned long long, unsignedLongLongValue)
                EG_CALL_ARG_CASE('f', float, floatValue)
                EG_CALL_ARG_CASE('d', double, doubleValue)
                EG_CALL_ARG_CASE('B', BOOL, boolValue)
                
            case ':': {
                SEL value = nil;
                if (valObj != _nilObj) {
                    value = NSSelectorFromString(valObj);
                }
                [invocation setArgument:&value atIndex:i];
                break;
            }
            case '{': {
                NSString *typeString = extractStructName([NSString stringWithUTF8String:argumentType]);
                JSValue *val = arguments[i-2];
#define EG_CALL_ARG_STRUCT(_type, _methodName) \
if ([typeString rangeOfString:@#_type].location != NSNotFound) {    \
_type value = [val _methodName];  \
[invocation setArgument:&value atIndex:i];  \
break; \
}
                EG_CALL_ARG_STRUCT(CGRect, toRect)
                EG_CALL_ARG_STRUCT(CGPoint, toPoint)
                EG_CALL_ARG_STRUCT(CGSize, toSize)
                EG_CALL_ARG_STRUCT(NSRange, toRange)
                @synchronized (_context) {
                    NSDictionary *structDefine = _registeredStruct[typeString];
                    if (structDefine) {
                        size_t size = sizeOfStructTypes(structDefine[@"types"]);
                        void *ret = malloc(size);
                        getStructDataWithDict(ret, valObj, structDefine);
                        [invocation setArgument:ret atIndex:i];
                        free(ret);
                        break;
                    }
                }
                
                break;
            }
            case '*':
            case '^': {
                if ([valObj isKindOfClass:[EGBoxing class]]) {
                    void *value = [((EGBoxing *)valObj) unboxPointer];
                    
                    if (argumentType[1] == '@') {
                        if (!_TMPMemoryPool) {
                            _TMPMemoryPool = [[NSMutableDictionary alloc] init];
                        }
                        if (!_markArray) {
                            _markArray = [[NSMutableArray alloc] init];
                        }
                        memset(value, 0, sizeof(id));
                        [_markArray addObject:valObj];
                    }
                    
                    [invocation setArgument:&value atIndex:i];
                    break;
                }
            }
            case '#': {
                if ([valObj isKindOfClass:[EGBoxing class]]) {
                    Class value = [((EGBoxing *)valObj) unboxClass];
                    [invocation setArgument:&value atIndex:i];
                    break;
                }
            }
            default: {
                if (valObj == _nullObj) {
                    valObj = [NSNull null];
                    [invocation setArgument:&valObj atIndex:i];
                    break;
                }
                if (valObj == _nilObj ||
                    ([valObj isKindOfClass:[NSNumber class]] && strcmp([valObj objCType], "c") == 0 && ![valObj boolValue])) {
                    valObj = nil;
                    [invocation setArgument:&valObj atIndex:i];
                    break;
                }
                if ([(JSValue *)arguments[i-2] hasProperty:@"__isBlock"]) {
                    JSValue *blkJSVal = arguments[i-2];
                    Class EGBlockClass = NSClassFromString(@"EGBlock");
                    if (EGBlockClass && ![blkJSVal[@"blockObj"] isUndefined]) {
                        __autoreleasing id cb = [EGBlockClass performSelector:@selector(blockWithBlockObj:) withObject:[blkJSVal[@"blockObj"] toObject]];
                        [invocation setArgument:&cb atIndex:i];
                        Block_release((__bridge void *)cb);
                    } else {
                        __autoreleasing id cb = genCallbackBlock(arguments[i-2]);
                        [invocation setArgument:&cb atIndex:i];
                    }
                } else {
                    [invocation setArgument:&valObj atIndex:i];
                }
            }
        }
    }
    
    if (superClassName) _currInvokeSuperClsName[selectorName] = superClassName;
    [invocation invoke];
    if (superClassName) [_currInvokeSuperClsName removeObjectForKey:selectorName];
    if ([_markArray count] > 0) {
        for (EGBoxing *box in _markArray) {
            void *pointer = [box unboxPointer];
            id obj = *((__unsafe_unretained id *)pointer);
            if (obj) {
                @synchronized(_TMPMemoryPool) {
                    [_TMPMemoryPool setObject:obj forKey:[NSNumber numberWithInteger:[(NSObject*)obj hash]]];
                }
            }
        }
    }
    
    char returnType[255];
    strcpy(returnType, [methodSignature methodReturnType]);
    
    // Restore the return type
    if (strcmp(returnType, @encode(EGDouble)) == 0) {
        strcpy(returnType, @encode(double));
    }
    if (strcmp(returnType, @encode(EGFloat)) == 0) {
        strcpy(returnType, @encode(float));
    }
    
    id returnValue;
    if (strncmp(returnType, "v", 1) != 0) {
        if (strncmp(returnType, "@", 1) == 0) {
            void *result;
            [invocation getReturnValue:&result];
            
            //For performance, ignore the other methods prefix with alloc/new/copy/mutableCopy
            if ([selectorName isEqualToString:@"alloc"] || [selectorName isEqualToString:@"new"] ||
                [selectorName isEqualToString:@"copy"] || [selectorName isEqualToString:@"mutableCopy"]) {
                returnValue = (__bridge_transfer id)result;
            } else {
                returnValue = (__bridge id)result;
            }
            return formatOCToJS(returnValue);
            
        } else {
            switch (returnType[0] == 'r' ? returnType[1] : returnType[0]) {
                    
#define EG_CALL_RET_CASE(_typeString, _type) \
case _typeString: {                              \
_type tempResultSet; \
[invocation getReturnValue:&tempResultSet];\
returnValue = @(tempResultSet); \
break; \
}
                    
                    EG_CALL_RET_CASE('c', char)
                    EG_CALL_RET_CASE('C', unsigned char)
                    EG_CALL_RET_CASE('s', short)
                    EG_CALL_RET_CASE('S', unsigned short)
                    EG_CALL_RET_CASE('i', int)
                    EG_CALL_RET_CASE('I', unsigned int)
                    EG_CALL_RET_CASE('l', long)
                    EG_CALL_RET_CASE('L', unsigned long)
                    EG_CALL_RET_CASE('q', long long)
                    EG_CALL_RET_CASE('Q', unsigned long long)
                    EG_CALL_RET_CASE('f', float)
                    EG_CALL_RET_CASE('d', double)
                    EG_CALL_RET_CASE('B', BOOL)
                    
                case '{': {
                    NSString *typeString = extractStructName([NSString stringWithUTF8String:returnType]);
#define EG_CALL_RET_STRUCT(_type, _methodName) \
if ([typeString rangeOfString:@#_type].location != NSNotFound) {    \
_type result;   \
[invocation getReturnValue:&result];    \
return [JSValue _methodName:result inContext:_context];    \
}
                    EG_CALL_RET_STRUCT(CGRect, valueWithRect)
                    EG_CALL_RET_STRUCT(CGPoint, valueWithPoint)
                    EG_CALL_RET_STRUCT(CGSize, valueWithSize)
                    EG_CALL_RET_STRUCT(NSRange, valueWithRange)
                    @synchronized (_context) {
                        NSDictionary *structDefine = _registeredStruct[typeString];
                        if (structDefine) {
                            size_t size = sizeOfStructTypes(structDefine[@"types"]);
                            void *ret = malloc(size);
                            [invocation getReturnValue:ret];
                            NSDictionary *dict = getDictOfStruct(ret, structDefine);
                            free(ret);
                            return dict;
                        }
                    }
                    break;
                }
                case '*':
                case '^': {
                    void *result;
                    [invocation getReturnValue:&result];
                    returnValue = formatOCToJS([EGBoxing boxPointer:result]);
                    if (strncmp(returnType, "^{CG", 4) == 0) {
                        if (!_pointersToRelease) {
                            _pointersToRelease = [[NSMutableArray alloc] init];
                        }
                        [_pointersToRelease addObject:[NSValue valueWithPointer:result]];
                        CFRetain(result);
                    }
                    break;
                }
                case '#': {
                    Class result;
                    [invocation getReturnValue:&result];
                    returnValue = formatOCToJS([EGBoxing boxClass:result]);
                    break;
                }
            }
            return returnValue;
        }
    }
    return nil;
}


static void EGForwardInvocation(__unsafe_unretained id assignSlf, SEL selector, NSInvocation *invocation)
{
#ifdef DEBUG
    _JSLastCallStack = [NSThread callStackSymbols];
#endif
    BOOL deallocFlag = NO;
    id slf = assignSlf;
    NSMethodSignature *methodSignature = [invocation methodSignature];
    NSInteger numberOfArguments = [methodSignature numberOfArguments];
    
    NSString *selectorName = NSStringFromSelector(invocation.selector);
    NSString *EGSelectorName = [NSString stringWithFormat:@"_EG%@", selectorName];
    JSValue *jsFunc = getJSFunctionInObjectHierachy(slf, EGSelectorName);
    if (!jsFunc) {
        EGExecuteORIGForwardInvocation(slf, selector, invocation);
        return;
    }
    
    NSMutableArray *argList = [[NSMutableArray alloc] init];
    if ([slf class] == slf) {
        [argList addObject:[JSValue valueWithObject:@{@"__clsName": NSStringFromClass([slf class])} inContext:_context]];
    } else if ([selectorName isEqualToString:@"dealloc"]) {
        [argList addObject:[EGBoxing boxAssignObj:slf]];
        deallocFlag = YES;
    } else {
        [argList addObject:[EGBoxing boxWeakObj:slf]];
    }
    
    for (NSUInteger i = 2; i < numberOfArguments; i++) {
        const char *argumentType = [methodSignature getArgumentTypeAtIndex:i];
        switch(argumentType[0] == 'r' ? argumentType[1] : argumentType[0]) {
                
#define EG_FWD_ARG_CASE(_typeChar, _type) \
case _typeChar: {   \
_type arg;  \
[invocation getArgument:&arg atIndex:i];    \
[argList addObject:@(arg)]; \
break;  \
}
                EG_FWD_ARG_CASE('c', char)
                EG_FWD_ARG_CASE('C', unsigned char)
                EG_FWD_ARG_CASE('s', short)
                EG_FWD_ARG_CASE('S', unsigned short)
                EG_FWD_ARG_CASE('i', int)
                EG_FWD_ARG_CASE('I', unsigned int)
                EG_FWD_ARG_CASE('l', long)
                EG_FWD_ARG_CASE('L', unsigned long)
                EG_FWD_ARG_CASE('q', long long)
                EG_FWD_ARG_CASE('Q', unsigned long long)
                EG_FWD_ARG_CASE('f', float)
                EG_FWD_ARG_CASE('d', double)
                EG_FWD_ARG_CASE('B', BOOL)
            case '@': {
                __unsafe_unretained id arg;
                [invocation getArgument:&arg atIndex:i];
                if ([arg isKindOfClass:NSClassFromString(@"NSBlock")]) {
                    [argList addObject:(arg ? [arg copy]: _nilObj)];
                } else {
                    [argList addObject:(arg ? arg: _nilObj)];
                }
                break;
            }
            case '{': {
                NSString *typeString = extractStructName([NSString stringWithUTF8String:argumentType]);
#define EG_FWD_ARG_STRUCT(_type, _transFunc) \
if ([typeString rangeOfString:@#_type].location != NSNotFound) {    \
_type arg; \
[invocation getArgument:&arg atIndex:i];    \
[argList addObject:[JSValue _transFunc:arg inContext:_context]];  \
break; \
}
                EG_FWD_ARG_STRUCT(CGRect, valueWithRect)
                EG_FWD_ARG_STRUCT(CGPoint, valueWithPoint)
                EG_FWD_ARG_STRUCT(CGSize, valueWithSize)
                EG_FWD_ARG_STRUCT(NSRange, valueWithRange)
                
                @synchronized (_context) {
                    NSDictionary *structDefine = _registeredStruct[typeString];
                    if (structDefine) {
                        size_t size = sizeOfStructTypes(structDefine[@"types"]);
                        if (size) {
                            void *ret = malloc(size);
                            [invocation getArgument:ret atIndex:i];
                            NSDictionary *dict = getDictOfStruct(ret, structDefine);
                            [argList addObject:[JSValue valueWithObject:dict inContext:_context]];
                            free(ret);
                            break;
                        }
                    }
                }
                
                break;
            }
            case ':': {
                SEL selector;
                [invocation getArgument:&selector atIndex:i];
                NSString *selectorName = NSStringFromSelector(selector);
                [argList addObject:(selectorName ? selectorName: _nilObj)];
                break;
            }
            case '^':
            case '*': {
                void *arg;
                [invocation getArgument:&arg atIndex:i];
                [argList addObject:[EGBoxing boxPointer:arg]];
                break;
            }
            case '#': {
                Class arg;
                [invocation getArgument:&arg atIndex:i];
                [argList addObject:[EGBoxing boxClass:arg]];
                break;
            }
            default: {
                NSLog(@"error type %s", argumentType);
                break;
            }
        }
    }
    
    if (_currInvokeSuperClsName[selectorName]) {
        Class cls = NSClassFromString(_currInvokeSuperClsName[selectorName]);
        NSString *tmpSelectorName = [[selectorName stringByReplacingOccurrencesOfString:@"_EGSUPER_" withString:@"_EG"] stringByReplacingOccurrencesOfString:@"SUPER_" withString:@"_EG"];
        if (!_JSOverideMethods[cls][tmpSelectorName]) {
            NSString *ORIGSelectorName = [selectorName stringByReplacingOccurrencesOfString:@"SUPER_" withString:@"ORIG"];
            [argList removeObjectAtIndex:0];
            id retObj = callSelector(_currInvokeSuperClsName[selectorName], ORIGSelectorName, [JSValue valueWithObject:argList inContext:_context], [JSValue valueWithObject:@{@"__obj": slf, @"__realClsName": @""} inContext:_context], NO);
            id __autoreleasing ret = formatJSToOC([JSValue valueWithObject:retObj inContext:_context]);
            [invocation setReturnValue:&ret];
            return;
        }
    }
    
    NSArray *params = _formatOCToJSList(argList);
    char returnType[255];
    strcpy(returnType, [methodSignature methodReturnType]);
    
    // Restore the return type
    if (strcmp(returnType, @encode(EGDouble)) == 0) {
        strcpy(returnType, @encode(double));
    }
    if (strcmp(returnType, @encode(EGFloat)) == 0) {
        strcpy(returnType, @encode(float));
    }
    
    switch (returnType[0] == 'r' ? returnType[1] : returnType[0]) {
#define EG_FWD_RET_CALL_JS \
JSValue *jsval; \
[_JSMethodForwardCallLock lock];   \
jsval = [jsFunc callWithArguments:params]; \
[_JSMethodForwardCallLock unlock]; \
while (![jsval isNull] && ![jsval isUndefined] && [jsval hasProperty:@"__isPerformInOC"]) { \
NSArray *args = nil;  \
JSValue *cb = jsval[@"cb"]; \
if ([jsval hasProperty:@"sel"]) {   \
id callRet = callSelector(![jsval[@"clsName"] isUndefined] ? [jsval[@"clsName"] toString] : nil, [jsval[@"sel"] toString], jsval[@"args"], ![jsval[@"obj"] isUndefined] ? jsval[@"obj"] : nil, NO);  \
args = @[[_context[@"_formatOCToJS"] callWithArguments:callRet ? @[callRet] : _formatOCToJSList(@[_nilObj])]];  \
}   \
[_JSMethodForwardCallLock lock];    \
jsval = [cb callWithArguments:args];  \
[_JSMethodForwardCallLock unlock];  \
}
            
#define EG_FWD_RET_CASE_RET(_typeChar, _type, _retCode)   \
case _typeChar : { \
EG_FWD_RET_CALL_JS \
_retCode \
[invocation setReturnValue:&ret];\
break;  \
}
            
#define EG_FWD_RET_CASE(_typeChar, _type, _typeSelector)   \
EG_FWD_RET_CASE_RET(_typeChar, _type, _type ret = [[jsval toObject] _typeSelector];)   \

#define EG_FWD_RET_CODE_ID \
id __autoreleasing ret = formatJSToOC(jsval); \
if (ret == _nilObj ||   \
([ret isKindOfClass:[NSNumber class]] && strcmp([ret objCType], "c") == 0 && ![ret boolValue])) ret = nil;  \

#define EG_FWD_RET_CODE_POINTER    \
void *ret; \
id obj = formatJSToOC(jsval); \
if ([obj isKindOfClass:[EGBoxing class]]) { \
ret = [((EGBoxing *)obj) unboxPointer]; \
}
            
#define EG_FWD_RET_CODE_CLASS    \
Class ret;   \
ret = formatJSToOC(jsval);
            
            
#define EG_FWD_RET_CODE_SEL    \
SEL ret;   \
id obj = formatJSToOC(jsval); \
if ([obj isKindOfClass:[NSString class]]) { \
ret = NSSelectorFromString(obj); \
}
            
            EG_FWD_RET_CASE_RET('@', id, EG_FWD_RET_CODE_ID)
            EG_FWD_RET_CASE_RET('^', void*, EG_FWD_RET_CODE_POINTER)
            EG_FWD_RET_CASE_RET('*', void*, EG_FWD_RET_CODE_POINTER)
            EG_FWD_RET_CASE_RET('#', Class, EG_FWD_RET_CODE_CLASS)
            EG_FWD_RET_CASE_RET(':', SEL, EG_FWD_RET_CODE_SEL)
            
            EG_FWD_RET_CASE('c', char, charValue)
            EG_FWD_RET_CASE('C', unsigned char, unsignedCharValue)
            EG_FWD_RET_CASE('s', short, shortValue)
            EG_FWD_RET_CASE('S', unsigned short, unsignedShortValue)
            EG_FWD_RET_CASE('i', int, intValue)
            EG_FWD_RET_CASE('I', unsigned int, unsignedIntValue)
            EG_FWD_RET_CASE('l', long, longValue)
            EG_FWD_RET_CASE('L', unsigned long, unsignedLongValue)
            EG_FWD_RET_CASE('q', long long, longLongValue)
            EG_FWD_RET_CASE('Q', unsigned long long, unsignedLongLongValue)
            EG_FWD_RET_CASE('f', float, floatValue)
            EG_FWD_RET_CASE('d', double, doubleValue)
            EG_FWD_RET_CASE('B', BOOL, boolValue)
            
        case 'v': {
            EG_FWD_RET_CALL_JS
            break;
        }
            
        case '{': {
            NSString *typeString = extractStructName([NSString stringWithUTF8String:returnType]);
#define EG_FWD_RET_STRUCT(_type, _funcSuffix) \
if ([typeString rangeOfString:@#_type].location != NSNotFound) {    \
EG_FWD_RET_CALL_JS \
_type ret = [jsval _funcSuffix]; \
[invocation setReturnValue:&ret];\
break;  \
}
            EG_FWD_RET_STRUCT(CGRect, toRect)
            EG_FWD_RET_STRUCT(CGPoint, toPoint)
            EG_FWD_RET_STRUCT(CGSize, toSize)
            EG_FWD_RET_STRUCT(NSRange, toRange)
            
            @synchronized (_context) {
                NSDictionary *structDefine = _registeredStruct[typeString];
                if (structDefine) {
                    size_t size = sizeOfStructTypes(structDefine[@"types"]);
                    EG_FWD_RET_CALL_JS
                    void *ret = malloc(size);
                    NSDictionary *dict = formatJSToOC(jsval);
                    getStructDataWithDict(ret, dict, structDefine);
                    [invocation setReturnValue:ret];
                    free(ret);
                }
            }
            break;
        }
        default: {
            break;
        }
    }
    
    if (_pointersToRelease) {
        for (NSValue *val in _pointersToRelease) {
            void *pointer = NULL;
            [val getValue:&pointer];
            CFRelease(pointer);
        }
        _pointersToRelease = nil;
    }
    
    if (deallocFlag) {
        slf = nil;
        Class instClass = object_getClass(assignSlf);
        Method deallocMethod = class_getInstanceMethod(instClass, NSSelectorFromString(@"ORIGdealloc"));
        void (*originalDealloc)(__unsafe_unretained id, SEL) = (__typeof__(originalDealloc))method_getImplementation(deallocMethod);
        originalDealloc(assignSlf, NSSelectorFromString(@"dealloc"));
    }
}
/*************************************************************消息转发*************************************************************/

static void _initEGOverideMethods(Class cls) {
    if (!_JSOverideMethods) {
        _JSOverideMethods = [[NSMutableDictionary alloc] init];
    }
    if (!_JSOverideMethods[cls]) {
        _JSOverideMethods[(id<NSCopying>)cls] = [[NSMutableDictionary alloc] init];
    }
}

// 方法替换
static void overrideMethod(Class cls, NSString *selectorName, JSValue *function, BOOL isClassMethod, const char *typeDescription)
{
    SEL selector = NSSelectorFromString(selectorName);
    
    if (!typeDescription) {
        Method method = class_getInstanceMethod(cls, selector);
        typeDescription = (char *)method_getTypeEncoding(method);
    }
    
    IMP originalImp = class_respondsToSelector(cls, selector) ? class_getMethodImplementation(cls, selector) : NULL;
    
    IMP msgForwardIMP = _objc_msgForward;
#if !defined(__arm64__)
    if (typeDescription[0] == '{') {
        //In some cases that returns struct, we should use the '_stret' API:
        //http://sealiesoftware.com/blog/archive/2008/10/30/objc_explain_objc_msgSend_stret.html
        //NSMethodSignature knows the detail but has no API to return, we can only get the info from debugDescription.
        NSMethodSignature *methodSignature = [NSMethodSignature signatureWithObjCTypes:typeDescription];
        if ([methodSignature.debugDescription rangeOfString:@"is special struct return? YES"].location != NSNotFound) {
            msgForwardIMP = (IMP)_objc_msgForward_stret;
        }
    }
#endif
    
    if (class_getMethodImplementation(cls, @selector(forwardInvocation:)) != (IMP)EGForwardInvocation) {
        IMP originalForwardImp = class_replaceMethod(cls, @selector(forwardInvocation:), (IMP)EGForwardInvocation, "v@:@");
        if (originalForwardImp) {
            class_addMethod(cls, @selector(ORIGforwardInvocation:), originalForwardImp, "v@:@");
        }
    }
    
    [cls eg_fixMethodSignature];
    if (class_respondsToSelector(cls, selector)) {
        NSString *originalSelectorName = [NSString stringWithFormat:@"ORIG%@", selectorName];
        SEL originalSelector = NSSelectorFromString(originalSelectorName);
        if(!class_respondsToSelector(cls, originalSelector)) {
            class_addMethod(cls, originalSelector, originalImp, typeDescription);
        }
    }
    
    NSString *EGSelectorName = [NSString stringWithFormat:@"_EG%@", selectorName];
    
    _initEGOverideMethods(cls);
    _JSOverideMethods[cls][EGSelectorName] = function;
    
    // Replace the original selector at last, preventing threading issus when
    // the selector get called during the execution of `overrideMethod`
    class_replaceMethod(cls, selector, msgForwardIMP, typeDescription);
}

static id formatJSToOC(JSValue *jsval)
{
    id obj = [jsval toObject];
    if (!obj || [obj isKindOfClass:[NSNull class]]) return _nilObj;
    
    if ([obj isKindOfClass:[EGBoxing class]]) return [obj unbox];
    if ([obj isKindOfClass:[NSArray class]]) {
        NSMutableArray *newArr = [[NSMutableArray alloc] init];
        for (int i = 0; i < [(NSArray*)obj count]; i ++) {
            [newArr addObject:formatJSToOC(jsval[i])];
        }
        return newArr;
    }
    if ([obj isKindOfClass:[NSDictionary class]]) {
        if (obj[@"__obj"]) {
            id ocObj = [obj objectForKey:@"__obj"];
            if ([ocObj isKindOfClass:[EGBoxing class]]) return [ocObj unbox];
            return ocObj;
        } else if (obj[@"__clsName"]) {
            return NSClassFromString(obj[@"__clsName"]);
        }
        if (obj[@"__isBlock"]) {
            Class EGBlockClass = NSClassFromString(@"EGBlock");
            if (EGBlockClass && ![jsval[@"blockObj"] isUndefined]) {
                return [EGBlockClass performSelector:@selector(blockWithBlockObj:) withObject:[jsval[@"blockObj"] toObject]];
            } else {
                return genCallbackBlock(jsval);
            }
        }
        NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
        for (NSString *key in [obj allKeys]) {
            [newDict setObject:formatJSToOC(jsval[key]) forKey:key];
        }
        return newDict;
    }
    return obj;
}

#pragma mark -- 解析JS的defineClass

static NSDictionary *defineClass(NSString *classDeclaration, JSValue *instanceMethods, JSValue *classMethods)
{
    NSScanner *scanner = [NSScanner scannerWithString:classDeclaration];
    
    NSString *className;
    NSString *superClassName;
    NSString *protocolNames;
    [scanner scanUpToString:@":" intoString:&className];
    if (!scanner.isAtEnd) {
        scanner.scanLocation = scanner.scanLocation + 1;
        [scanner scanUpToString:@"<" intoString:&superClassName];
        if (!scanner.isAtEnd) {
            scanner.scanLocation = scanner.scanLocation + 1;
            [scanner scanUpToString:@">" intoString:&protocolNames];
        }
    }
    
    if (!superClassName) superClassName = @"NSObject";
    className = trim(className);
    superClassName = trim(superClassName);
    
    NSArray *protocols = [protocolNames length] ? [protocolNames componentsSeparatedByString:@","] : nil;
    
    Class cls = NSClassFromString(className);
    if (!cls) {
        Class superCls = NSClassFromString(superClassName);
        if (!superCls) {
            _exceptionBlock([NSString stringWithFormat:@"can't find the super class %@", superClassName]);
            return @{@"cls": className};
        }
        cls = objc_allocateClassPair(superCls, className.UTF8String, 0);
        objc_registerClassPair(cls);
    }
    
    if (protocols.count > 0) {
        for (NSString* protocolName in protocols) {
            Protocol *protocol = objc_getProtocol([trim(protocolName) cStringUsingEncoding:NSUTF8StringEncoding]);
            class_addProtocol (cls, protocol);
        }
    }
    
    for (int i = 0; i < 2; i ++) {
        BOOL isInstance = i == 0;
        JSValue *jsMethods = isInstance ? instanceMethods: classMethods;
        
        Class currCls = isInstance ? cls: objc_getMetaClass(className.UTF8String);
        NSDictionary *methodDict = [jsMethods toDictionary];
        for (NSString *jsMethodName in methodDict.allKeys) {
            JSValue *jsMethodArr = [jsMethods valueForProperty:jsMethodName];
            int numberOfArg = [jsMethodArr[0] toInt32];
            NSString *selectorName = convertEGSelectorString(jsMethodName);
            
            if ([selectorName componentsSeparatedByString:@":"].count - 1 < numberOfArg) {
                selectorName = [selectorName stringByAppendingString:@":"];
            }
            
            JSValue *jsMethod = jsMethodArr[1];
            if (class_respondsToSelector(currCls, NSSelectorFromString(selectorName))) {
                overrideMethod(currCls, selectorName, jsMethod, !isInstance, NULL);
            } else {
                BOOL overrided = NO;
                for (NSString *protocolName in protocols) {
                    char *types = methodTypesInProtocol(protocolName, selectorName, isInstance, YES);
                    if (!types) types = methodTypesInProtocol(protocolName, selectorName, isInstance, NO);
                    if (types) {
                        overrideMethod(currCls, selectorName, jsMethod, !isInstance, types);
                        free(types);
                        overrided = YES;
                        break;
                    }
                }
                if (!overrided) {
                    if (![[jsMethodName substringToIndex:1] isEqualToString:@"_"]) {
                        NSMutableString *typeDescStr = [@"@@:" mutableCopy];
                        for (int i = 0; i < numberOfArg; i ++) {
                            [typeDescStr appendString:@"@"];
                        }
                        overrideMethod(currCls, selectorName, jsMethod, !isInstance, [typeDescStr cStringUsingEncoding:NSUTF8StringEncoding]);
                    }
                }
            }
        }
    }
    
    class_addMethod(cls, @selector(getProp:), (IMP)getPropIMP, "@@:@");
    class_addMethod(cls, @selector(setProp:forKey:), (IMP)setPropIMP, "v@:@@");
    
    return @{@"cls": className, @"superCls": superClassName};
}

#pragma clang diagnostic pop
@end

#pragma mark -- EGExtension

@implementation EGExtension

+ (void)main:(JSContext *)context{}

+ (void *)formatPointerJSToOC:(JSValue *)val
{
    id obj = [val toObject];
    if ([obj isKindOfClass:[NSDictionary class]]) {
        if (obj[@"__obj"] && [obj[@"__obj"] isKindOfClass:[EGBoxing class]]) {
            return [(EGBoxing *)(obj[@"__obj"]) unboxPointer];
        } else {
            return NULL;
        }
    } else if (![val toBool]) {
        return NULL;
    } else{
        return [((EGBoxing *)[val toObject]) unboxPointer];
    }
}

+ (id)formatRetainedCFTypeOCToJS:(CFTypeRef)CF_CONSUMED type
{
    return formatOCToJS([EGBoxing boxPointer:(void *)type]);
}

+ (id)formatPointerOCToJS:(void *)pointer
{
    return formatOCToJS([EGBoxing boxPointer:pointer]);
}

+ (id)formatJSToOC:(JSValue *)val
{
    if (![val toBool]) {
        return nil;
    }
    return formatJSToOC(val);
}

+ (id)formatOCToJS:(id)obj
{
    JSContext *context = [JSContext currentContext] ? [JSContext currentContext]: _context;
    return [context[@"_formatOCToJS"] callWithArguments:@[formatOCToJS(obj)]];
}

+ (int)sizeOfStructTypes:(NSString *)structTypes
{
    return sizeOfStructTypes(structTypes);
}

+ (void)getStructDataWidthDict:(void *)structData dict:(NSDictionary *)dict structDefine:(NSDictionary *)structDefine
{
    return getStructDataWithDict(structData, dict, structDefine);
}

+ (NSDictionary *)getDictOfStruct:(void *)structData structDefine:(NSDictionary *)structDefine
{
    return getDictOfStruct(structData, structDefine);
}

+ (NSMutableDictionary *)registeredStruct
{
    return _registeredStruct;
}

+ (NSDictionary *)overideMethods
{
    return _JSOverideMethods;
}

//+ (NSMutableSet *)includedScriptPaths
//{
//    return _runnedScript;
//}

@end
