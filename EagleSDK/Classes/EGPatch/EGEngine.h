//
//  EGEngine.h
//  AFNetworking
//
//  Created by pantao on 2017/12/22.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@interface EGEngine : NSObject

+ (void)startEngine;
+ (JSValue *)evaluateScript:(NSString *)script;

@end

@interface EGExtension : NSObject
+ (void)main:(JSContext *)context;

+ (void *)formatPointerJSToOC:(JSValue *)val;
+ (id)formatRetainedCFTypeOCToJS:(CFTypeRef)CF_CONSUMED type;
+ (id)formatPointerOCToJS:(void *)pointer;
+ (id)formatJSToOC:(JSValue *)val;
+ (id)formatOCToJS:(id)obj;

+ (int)sizeOfStructTypes:(NSString *)structTypes;
+ (void)getStructDataWidthDict:(void *)structData dict:(NSDictionary *)dict structDefine:(NSDictionary *)structDefine;
+ (NSDictionary *)getDictOfStruct:(void *)structData structDefine:(NSDictionary *)structDefine;

/*!
 @method
 @description Return the registered struct definition in JSPatch,
 the key of dictionary is the struct name.
 */
+ (NSMutableDictionary *)registeredStruct;

+ (NSDictionary *)overideMethods;
+ (NSMutableSet *)includedScriptPaths;
@end

@interface EGBoxing : NSObject
@property (nonatomic) id obj;
@property (nonatomic) void *pointer;
@property (nonatomic) Class cls;
@property (nonatomic, weak) id weakObj;
@property (nonatomic, assign) id assignObj;
- (id)unbox;
- (void *)unboxPointer;
- (Class)unboxClass;
@end
