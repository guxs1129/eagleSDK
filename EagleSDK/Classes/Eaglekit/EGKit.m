//
//  Eaglekit.m
//  Eagle
//
//  Created by pantao on 2017/11/6.
//  Copyright © 2017年 pantao. All rights reserved.
//

#import "EGKit.h"
#import "EGTrash.h"
#import "EGKitManager.h"
#import <objc/message.h>

#pragma mark -- FORMAT OF SEL

char *const kEagleSELHeader = "set";
char *const kEagleSELCon = ":";
NSString *const kEagle2DStateSELTail = @"forState:";
NSString *const kEagle2DAnimatedSELTail = @"animated:";

#pragma mark - Config TYPE OF ARG

NSString *const kEagleArgCustomInt = @"com.linkage.eagle.arg.custom.int";

#pragma mark -- Config TYPE OF ARG

NSString *const kEagleArgBool = @"com.linkage.eagle.arg.bool";
NSString *const kEagleArgFloat = @"com.linkage.eagle.arg.float";
NSString *const kEagleArgColor = @"com.linkage.eagle.arg.color";
NSString *const kEagleArgCGColor = @"com.linkage.eagle.arg.cgColor";
NSString *const kEagleArgTitle = @"com.linkage.eagle.arg.title";
NSString *const kEagleArgFont = @"com.linkage.eagle.arg.font";
NSString *const kEagleArgKeyboardAppearance = @"com.linkage.eagle.arg.keyboardAppearance";
NSString *const kEagleArgTextAttributes = @"com.linkage.eagle.arg.textAttributes";
NSString *const kEagleArgImage = @"com.linkage.eagle.arg.image";
NSString *const kEagleActivityIndicatorViewStyle = @"com.linkage.eagle.arg.activityIndicatorViewStyle";
NSString *const kEagleArgBarStyle = @"com.linkage.eagle.arg.barStyle";
NSString *const kEagleArgStatusBarStyle = @"com.linkage.eagle.arg.statusBarStyle";

#pragma mark -- FUNC VAR

NSString *const EagleSkinChangeNotification = @"com.linkage.eagle.notification.skinChange";
NSTimeInterval const EagleSkinChangeDuration = 0.25;

@interface EGKit ()

@property (assign, nonatomic) UIImageRenderingMode imageRenderingMode;
// single arg
@property (strong, nonatomic) NSDictionary *innerSkins1D;
// double args
@property (strong, nonatomic) NSDictionary *innerSkins2D;

@end

@implementation EGKit

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EagleSkinChangeNotification object:nil];
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Please use +initWithOwner: method instead." userInfo:nil];
}

- (NSDictionary *)innerSkins1D
{
    if (_innerSkins1D) return _innerSkins1D;
    return _innerSkins1D = [NSMutableDictionary dictionary];
}

- (NSDictionary *)innerSkins2D
{
    if (_innerSkins2D) return _innerSkins2D;
    return _innerSkins2D = [NSMutableDictionary dictionary];
}

- (NSMutableDictionary *)getSkins1D
{
    return (NSMutableDictionary *)self.innerSkins1D;
}

- (NSMutableDictionary *)getSkins2D
{
    return (NSMutableDictionary *)self.innerSkins2D;
}

- (NSDictionary *)skins1D
{
    return [NSDictionary dictionaryWithDictionary:self.innerSkins1D];
}

- (NSDictionary *)skins2D
{
    return [NSDictionary dictionaryWithDictionary:self.innerSkins2D];
}

- (instancetype)initWithOwner:(id)owner
{
    if (self = [super init]) {
        _owner = owner;
        _imageRenderingMode = UIImageRenderingModeAlwaysOriginal;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateEagleSkins) name:EagleSkinChangeNotification object:nil];
    }
    return self;
}

+ (instancetype)eagleWithOwner:(id)owner
{
    return [[self alloc] initWithOwner:owner];
}

- (void)updateEagleSkins
{
    // 一维参数
    [self updateEagleWith1DSkins:self.skins1D];
}

#pragma mark - Test Refactor

- (id)getObjVectorWithSakuraArgType:(NSString *)argType path:(NSString *)path exist:(BOOL *)flag
{
    NSString *selStr = [[EGKitManager eagle_getObjVectorOperationKV] objectForKey:argType];
    if (selStr.length && path.length) {
        *flag = YES;
        SEL sel = NSSelectorFromString(selStr);
        id(*msg)(id, SEL, id) = (id(*)(id, SEL, id))objc_msgSend;
        id vector = msg(EGKitManager.class, sel, path);
        if ([vector isKindOfClass:[UIImage class]]) {
            vector = [(UIImage *)vector imageWithRenderingMode:_imageRenderingMode];
        }
        return vector;
    }
    *flag = NO;
    return nil;
}

- (NSInteger)getIntVectorWithSakuraArgType:(NSString *)argType path:(NSString *)path exist:(BOOL *)flag
{
    NSString *selStr = [[EGKitManager eagle_getIntVectorOperationKV] objectForKey:argType];
    if (selStr.length && path.length) {
        *flag = YES;
        SEL sel = NSSelectorFromString(selStr);
        NSInteger(*msg)(id, SEL, id) = (NSInteger(*)(id, SEL, id))objc_msgSend;
        NSInteger vector = msg(EGKitManager.class, sel, path);
        return vector;
    }
    *flag = NO;
    return 0;
}

- (CGFloat)getFloatVectorWithSakuraArgType:(NSString *)argType path:(NSString *)path exist:(BOOL *)flag {
    
    NSString *selStr = [[EGKitManager eagle_getFloatVectorOperationKV] objectForKey:argType];
    if (selStr.length && path.length) {
        *flag = YES;
        SEL sel = NSSelectorFromString(selStr);
        CGFloat(*msg)(id, SEL, id) = (CGFloat(*)(id, SEL, id))objc_msgSend;
        CGFloat vector = msg(EGKitManager.class, sel, path);
        return vector;
    }
    *flag = NO;
    return 0;
}

#pragma mark - 1D Update Methods

- (void)updateEagleWith1DSkins:(NSDictionary *)sakuraSkins1D {
    
    [sakuraSkins1D enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop)
     {
         
         SEL sel = NSSelectorFromString((NSString *)key);
         if (![obj isKindOfClass:[NSDictionary class]]) return;
         NSDictionary *valueDict = (NSDictionary *)obj;
         NSArray *allKeys = valueDict.allKeys;
         
         NSString *skinKey = allKeys.firstObject;
         NSString *skinValue = valueDict[skinKey];
         
         BOOL flag = false;
         
         id firstObject = [self getObjVectorWithSakuraArgType:skinKey path:skinValue exist:&flag];
         
         if (flag) {
             [self send1DMsgWithSEL:sel objValue:firstObject];
             return;
         }
         
         NSInteger intValue = [self getIntVectorWithSakuraArgType:skinKey path:skinValue exist:&flag];
         if (flag) {
             [self send1DMsgWithSEL:sel intValue:intValue];
             return;
         }
         
         CGFloat floatValue = [self getFloatVectorWithSakuraArgType:skinKey path:skinValue exist:&flag];
         if (flag) {
             [self send1DMsgWithSEL:sel floatValue:floatValue];
             return;
         }
     }];
}

#pragma mark - Message Methods

#pragma mark - 1D

- (instancetype)send1DMsgIntWithName:(NSString *)name
                             keyPath:(NSString *)keyPath
                                 arg:(NSString *)arg
                          valueBlock:(NSInteger (^)(NSString *))valueBlock {
    // Cache
    SEL sel = [self prepareForSkin1DWithName:name keyPath:keyPath argKey:arg];
    
    // MsgSend
    if (!valueBlock) return [EGTrash eagleWithOwner:self];
    NSInteger value = valueBlock(keyPath);
    //    valueBlock = nil;
    [self send1DMsgWithSEL:sel intValue:value];
    return self;
}

// Object
- (instancetype)send1DMsgObjectWithName:(NSString *)name
                                keyPath:(NSString *)keyPath
                                    arg:(NSString *)arg
                             valueBlock:(id(^)(NSString *))valueBlock {
    // Cache
    SEL sel = [self prepareForSkin1DWithName:name keyPath:keyPath argKey:arg];
    
    // MsgSend
    if (!valueBlock) return [EGTrash eagleWithOwner:self];
    NSObject *obj = valueBlock(keyPath);
    //    valueBlock = nil;
    [self send1DMsgWithSEL:sel objValue:obj];
    return self;
}

// Float
- (instancetype)send1DMsgFloatWithName:(NSString *)name
                               keyPath:(NSString *)keyPath
                                   arg:(NSString *)arg
                            valueBlock:(CGFloat (^)(NSString *))valueBlock
{// Cache
    SEL sel = [self prepareForSkin1DWithName:name keyPath:keyPath argKey:arg];
    
    // MsgSend
    if (!valueBlock) return [EGTrash eagleWithOwner:self];
    CGFloat value = valueBlock(keyPath);
    //    valueBlock = nil;
    [self send1DMsgWithSEL:sel floatValue:value];
    return self;
}

// Struct
- (instancetype)send1DMsgStructWithName:(NSString *)name
                                keyPath:(NSString *)keyPath
                                    arg:(NSString *)arg
                             valueBlock:(id (^)(NSString *))valueBlock {
    // Cache
    SEL sel = [self prepareForSkin1DWithName:name keyPath:keyPath argKey:arg];
    
    // MsgSend
    if (!valueBlock) return [EGTrash eagleWithOwner:self];
    id obj = valueBlock(keyPath);
    //    valueBlock = nil;
    [self send1DMsgWithSEL:sel structValue:obj];
    return self;
}

// 枚举
- (instancetype)send1DMsgEnumWithName:(NSString *)name
                              keyPath:(NSString *)keyPath
                                  arg:(NSString *)arg
                           valueBlock:(NSInteger (^)(NSString *))valueBlock {
    return [self send1DMsgIntWithName:name keyPath:keyPath arg:arg valueBlock:valueBlock];
}

- (SEL)prepareForSkin1DWithName:(NSString *)name
                        keyPath:(NSString *)keyPath
                         argKey:(NSString *)argKey
{
    const char *charName = name.UTF8String;
    SEL sel = getSelectorWithPattern(kEagleSELHeader, charName, kEagleSELCon);
    
    NSMutableDictionary *attrDict = [NSMutableDictionary dictionary];
    [attrDict setObject:keyPath forKey:argKey];
    [[self getSkins1D] setObject:attrDict forKey:NSStringFromSelector(sel)];
    return sel;
}

#pragma mark - 1D MsgSend

// 整型
- (void)send1DMsgWithSEL:(SEL)sel
                intValue:(NSInteger)value {
    if ([self.owner respondsToSelector:sel]) {
        void(*msg)(id, SEL, NSInteger) = (void(*)(id, SEL, NSInteger))objc_msgSend;
        msg(self.owner, sel, value);
    }
}

// 浮点
- (void)send1DMsgWithSEL:(SEL)sel
              floatValue:(CGFloat)value
{
    if ([self.owner respondsToSelector:sel]) {
        void(*msg)(id, SEL, CGFloat) = (void(*)(id, SEL, CGFloat))objc_msgSend;
        msg(self.owner, sel, value);
    }
}

// 对象
- (BOOL)send1DMsgWithSEL:(SEL)sel
                objValue:(id)obj {
    if (!obj ||
        ![self.owner respondsToSelector:sel]) return NO;
    void(*msg)(id, SEL, id) = (void(*)(id, SEL, id))objc_msgSend;
    if ([obj isKindOfClass:[UIColor class]]) {
        [UIView animateWithDuration:EagleSkinChangeDuration animations:^{
            msg(self.owner, sel, obj);
        }];
    }else {
        msg(self.owner, sel, obj);
    }
    return YES;
}

// 结构体
- (BOOL)send1DMsgWithSEL:(SEL)sel
             structValue:(id)obj {
    if (!obj ||
        ![self.owner respondsToSelector:sel]) return NO;
    void(*msg)(id, SEL, id) = (void(*)(id, SEL, id))objc_msgSend;
    if ([obj isKindOfClass:[UIColor class]]) {
        [UIView animateWithDuration:EagleSkinChangeDuration animations:^{
            msg(self.owner, sel, obj);
        }];
    }else {
        msg(self.owner, sel, obj);
    }
    return YES;
}

#pragma mark -- 2D

- (instancetype)send2DMsgObjectAndIntWithName:(NSString *)name
                                      keyPath:(NSString *)keyPath
                                        integ:(NSInteger)integ
                                      selTail:(NSString *)selTail
                                      argType:(NSString *)arg
                                   valueBlock:(NSObject *(^)(NSString *))valueBlock {
    
    SEL sel = [self prepareForSkin2DWithName:name keyPath:keyPath integ:integ argType:arg selTail:selTail];
    // MsgSend
    if (!valueBlock) return [EGTrash eagleWithOwner:self];
    NSObject *obj = valueBlock(keyPath);
    //    valueBlock = nil;
    [self send2DMsgWithSEL:sel object:obj intValue:integ];
    return self;
}

- (SEL)prepareForSkin2DWithName:(NSString *)name
                        keyPath:(NSString *)keyPath
                          integ:(NSInteger)integ
                        argType:(NSString *)argKey
                        selTail:(NSString *)selTail {
    const char *charName = name.UTF8String;
    SEL sel = getSelectorWithPattern(kEagleSELHeader, charName, kEagleSELCon);
    
    NSString *selStr = [NSStringFromSelector(sel) stringByAppendingString:selTail];
    NSString *selStrAppend = [selStr stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)integ]];
    NSMutableDictionary *attrDict = [NSMutableDictionary dictionary];
    [attrDict setObject:keyPath forKey:argKey];
    [attrDict setObject:@(integ) forKey:kEagleArgCustomInt];
    [[self getSkins2D] setObject:attrDict forKey:selStrAppend];
    return NSSelectorFromString(selStr);
}

- (instancetype)send2DMsgIntAndIntWithName:(NSString *)name
                                   keyPath:(NSString *)keyPath
                                     integ:(NSInteger)integ
                                   selTail:(NSString *)selTail
                                   argType:(NSString *)arg
                                valueBlock:(NSInteger (^)(NSString *))valueBlock {
    
    SEL sel = [self prepareForSkin2DWithName:name keyPath:keyPath integ:integ argType:arg selTail:selTail];
    // MsgSend
    if (!valueBlock) return [EGTrash eagleWithOwner:self];
    NSInteger value = valueBlock(keyPath);
    //    valueBlock = nil;
    [self send2DMsgWithSEL:sel intValue:value intValue:integ];
    return self;
}

#pragma mark - 2 MsgSend

- (void)send2DMsgWithSEL:(SEL)sel
                  object:(NSObject *)obj
                intValue:(NSInteger)value {
    if (obj && [self.owner respondsToSelector:sel]) {
        void(*msg)(id, SEL, id, NSInteger) = (void(*)(id, SEL, id, NSInteger))objc_msgSend;
        msg(self.owner, sel, obj, value);
    }
}

- (void)send2DMsgWithSEL:(SEL)sel
                intValue:(NSInteger)value1
                intValue:(NSInteger)value2 {
    if ([self.owner respondsToSelector:sel]) {
        void(*msg)(id, SEL, NSInteger, NSInteger) = (void(*)(id, SEL, NSInteger, NSInteger))objc_msgSend;
        msg(self.owner, sel, value1, value2);
    }
}


@end

@implementation EGKit(Blocker)

#pragma mark - 1D Block

- (EGKitBlock)eagle_floatBlockWithName:(NSString *)name {
    return ^EGKit *(NSString *path){
        return [self send1DMsgFloatWithName:name keyPath:path arg:kEagleArgFloat valueBlock:^CGFloat(NSString *keyPath) {
            return [EGKitManager eagle_floatWithPath:keyPath owner:self.owner];
        }];
    };
}

- (EGKitBlock)eagle_colorBlockWithName:(NSString *)name {
    return ^EGKit *(NSString *path){
        return [self send1DMsgObjectWithName:name keyPath:path arg:kEagleArgColor valueBlock:^NSObject *(NSString *keyPath) {
            return [EGKitManager eagle_colorWithPath:keyPath owner:self.owner];
        }];
    };
}

- (EGKitBlock)eagle_cgColorBlockWithName:(NSString *)name {
    return ^EGKit *(NSString *path){
        return [self send1DMsgStructWithName:name keyPath:path arg:kEagleArgCGColor valueBlock:^id (NSString *keyPath) {
            return (id)[EGKitManager eagle_cgColorWithPath:keyPath owner:self.owner];
        }];
    };
}

- (EGKitBlock)eagle_titleBlockWithName:(NSString *)name {
    return ^EGKit *(NSString *path){
        return [self send1DMsgObjectWithName:name keyPath:path arg:kEagleArgTitle valueBlock:^NSObject *(NSString *kayPath) {
            return [EGKitManager eagle_stringWithPath:kayPath owner:self.owner];
        }];
    };
}

- (EGKitBlock)eagle_fontBlockWithName:(NSString *)name {
    return ^EGKit *(NSString *path){
        return [self send1DMsgObjectWithName:name keyPath:path arg:kEagleArgFont valueBlock:^NSObject *(NSString *keyPath) {
            return [EGKitManager eagle_fontWithPath:keyPath owner:self.owner];
        }];
    };
}

- (EGKitBlock)eagle_keyboardAppearanceBlockWithName:(NSString *)name {
    return ^EGKit *(NSString *path){
        return [self send1DMsgEnumWithName:name keyPath:path arg:kEagleArgKeyboardAppearance valueBlock:^NSInteger(NSString *keyPath) {
            return [EGKitManager eagle_keyboardAppearanceWithPath:keyPath owner:self.owner];
        }];
    };
}

- (EGKitBlock)eagle_titleTextAttributesBlockWithName:(NSString *)name {
    return ^EGKit *(NSString *path){
        return [self send1DMsgObjectWithName:name keyPath:path arg:kEagleArgTextAttributes valueBlock:^NSObject *(NSString *keyPath) {
            return [EGKitManager eagle_titleTextAttributesDictionaryWithPath:keyPath owner:self.owner];
        }];
    };
}

- (EGKitBlock)eagle_boolBlockWithName:(NSString *)name {
    return ^EGKit *(NSString *path){
        return [self send1DMsgIntWithName:name keyPath:path arg:kEagleArgBool valueBlock:^NSInteger(NSString *keyPath) {
            return [EGKitManager eagle_boolWithPath:keyPath owner:self.owner];
        }];
    };
}

- (EGKitBlock)eagle_imageBlockWithName:(NSString *)name {
    return ^EGKit *(NSString *path){
        return [self send1DMsgObjectWithName:name keyPath:path arg:kEagleArgImage valueBlock:^NSObject *(NSString *keyPath) {
            return [EGKitManager eagle_imageWithPath:keyPath owner:self.owner];
        }];
    };
}

- (EGKitBlock)eagle_indicatorViewStyleBlockWithName:(NSString *)name {
    return ^EGKit *(NSString *path){
        return [self send1DMsgEnumWithName:name keyPath:path arg:kEagleActivityIndicatorViewStyle valueBlock:^NSInteger(NSString *keyPath) {
            return [EGKitManager eagle_activityIndicatorStyleWithPath:keyPath owner:self.owner];
        }];
    };
}

- (EGKitBlock)eagle_barStyleBlockWithName:(NSString *)name {
    return ^EGKit *(NSString *path){
        return [self send1DMsgEnumWithName:name keyPath:path arg:kEagleArgBarStyle valueBlock:^NSInteger(NSString *keyPath) {
            return [EGKitManager eagle_barStyleWithPath:keyPath owner:self.owner];
        }];
    };
}

#pragma mark - 2D Block

- (EGKit2DUIntBlock)eagle_titleColorForStateBlockWithName:(NSString *)name {
    return ^EGKit *(NSString *path, UIControlState state){
        return [self send2DMsgObjectAndIntWithName:name keyPath:path integ:state selTail:kEagle2DStateSELTail argType:kEagleArgColor valueBlock:^NSObject *(NSString *keyPath) {
            return [EGKitManager eagle_colorWithPath:keyPath owner:self.owner];
        }];
    };
}

- (EGKit2DUIntBlock)eagle_imageForStateBlockWithName:(NSString *)name {
    return ^EGKit *(NSString *path, UIControlState state){
        return [self send2DMsgObjectAndIntWithName:name keyPath:path integ:state selTail:kEagle2DStateSELTail argType:kEagleArgImage valueBlock:^NSObject *(NSString *keyPath) {
            return [EGKitManager eagle_imageWithPath:keyPath owner:self.owner];
        }];
    };
}

- (EGKit2DUIntBlock)eagle_titleTextAttributesForStateBlockWithName:(NSString *)name {
    return ^EGKit *(NSString *path, UIControlState state){
        return [self send2DMsgObjectAndIntWithName:name keyPath:path integ:state selTail:kEagle2DStateSELTail argType:kEagleArgTextAttributes valueBlock:^NSObject *(NSString *keyPath) {
            return [EGKitManager eagle_titleTextAttributesDictionaryWithPath:keyPath owner:self.owner];
        }];
    };
}

- (EGKit2DBoolBlock)eagle_applicationForStyleBlockWithName:(NSString *)name {
    return ^EGKit *(NSString *path, BOOL animated){
        return [self send2DMsgIntAndIntWithName:name keyPath:path integ:animated selTail:kEagle2DAnimatedSELTail argType:kEagleArgStatusBarStyle valueBlock:^NSInteger(NSString *keyPath) {
            return [EGKitManager eagle_statusBarStyleWithPath:path owner:self.owner];
        }];
    };
}

@end

#pragma mark - NSObject + eagle

void const *kEGSkinKey = &kEGSkinKey;

@implementation NSObject(Eagle)

@dynamic egSkin;

- (EGKit *)eagle {
    EGKit *obj = objc_getAssociatedObject(self, kEGSkinKey);
    if (!obj) {
        obj = [EGKit eagleWithOwner:self];
        objc_setAssociatedObject(self, kEGSkinKey, obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return obj;
}
@end

