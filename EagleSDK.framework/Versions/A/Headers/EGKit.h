//
//  Eaglekit.h
//  Eagle
//
//  Created by pantao on 2017/11/6.
//  Copyright © 2017年 pantao. All rights reserved.
//

/** Category declare */
#define EagleCategoryDeclare(ClassName, PropertyClassName)\
@interface ClassName (Eagle)\
@property (strong, nonatomic) PropertyClassName *egSkin;\
@end

#define EagleCategoryImplementation(ClassName, PropertyClassName)\
extern void *kEGSkinKey;\
@implementation ClassName(Eagle)\
@dynamic egSkin;\
- (PropertyClassName *)egSkin {\
PropertyClassName *obj = objc_getAssociatedObject(self, kEGSkinKey);\
if (!obj) {\
obj = [PropertyClassName eagleWithOwner:self];\
objc_setAssociatedObject(self, kEGSkinKey, obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);\
}\
return obj;\
}\
@end

/** Sakura Block declare */
#define EagleBlockDeclare(Class)\
@class Class;\
typedef Class *(^Class##Block)(NSString *);

#define Eagle2DStateBlockDeclare(Class)\
typedef Class *(^Class##2DStateBlock)(NSString *, UIControlState);

#define Eagle2DBoolBlockDeclare(Class)\
typedef Class *(^Class##2DBoolBlock)(NSString *, BOOL);

#define Eagle2DUIntBlockDeclare(Class)\
typedef Class *(^Class##2DUIntBlock)(NSString *, NSUInteger);

#define EagleBlockCustomDeclare(Class)\
typedef Class *(^Class##CustomBlock)(NSString *propertyName, NSString *keyPath);

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

EagleBlockDeclare(EGKit)
Eagle2DUIntBlockDeclare(EGKit)
Eagle2DBoolBlockDeclare(EGKit)

UIKIT_EXTERN NSString *const EagleSkinChangeNotification;

@interface EGKit : NSObject

/** Get ower of current sakura. */
@property (weak, nonatomic, readonly) id owner;

/** Just get all 1D skin objs which under sakura control. */
@property (strong, nonatomic, readonly) NSDictionary *skins1D;

+ (instancetype)eagleWithOwner:(id)owner;
- (instancetype)initWithOwner:(id)owner;

@end

@interface EGKit(Blocker)

#pragma mark - 1D Block

/** Change and Cache skin to sakura. */
- (EGKitBlock)eagle_floatBlockWithName:(NSString *)name;
- (EGKitBlock)eagle_colorBlockWithName:(NSString *)name;
- (EGKitBlock)eagle_cgColorBlockWithName:(NSString *)name;
- (EGKitBlock)eagle_titleBlockWithName:(NSString *)name;
- (EGKitBlock)eagle_fontBlockWithName:(NSString *)name;
- (EGKitBlock)eagle_keyboardAppearanceBlockWithName:(NSString *)name;
- (EGKitBlock)eagle_titleTextAttributesBlockWithName:(NSString *)name;
- (EGKitBlock)eagle_boolBlockWithName:(NSString *)name;
- (EGKitBlock)eagle_imageBlockWithName:(NSString *)name;
- (EGKitBlock)eagle_indicatorViewStyleBlockWithName:(NSString *)name;
- (EGKitBlock)eagle_barStyleBlockWithName:(NSString *)name;

#pragma mark - 2D Block
- (EGKit2DUIntBlock)eagle_titleColorForStateBlockWithName:(NSString *)name;
- (EGKit2DUIntBlock)eagle_imageForStateBlockWithName:(NSString *)name;
- (EGKit2DUIntBlock)eagle_titleTextAttributesForStateBlockWithName:(NSString *)name;
- (EGKit2DBoolBlock)eagle_applicationForStyleBlockWithName:(NSString *)name;
            
@end

EagleCategoryDeclare(NSObject, EGKit)
