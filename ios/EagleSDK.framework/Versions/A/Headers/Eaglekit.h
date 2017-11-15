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
@property (strong, nonatomic) PropertyClassName *eagle;\
@end

#define EagleCategoryImplementation(ClassName, PropertyClassName)\
extern void *kEagleKey;\
@implementation ClassName(Eagle)\
@dynamic eagle;\
- (PropertyClassName *)eagle {\
PropertyClassName *obj = objc_getAssociatedObject(self, kEagleKey);\
if (!obj) {\
obj = [PropertyClassName eagleWithOwner:self];\
objc_setAssociatedObject(self, kEagleKey, obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);\
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

EagleBlockDeclare(Eaglekit)
Eagle2DUIntBlockDeclare(Eaglekit)
Eagle2DBoolBlockDeclare(Eaglekit)

UIKIT_EXTERN NSString *const EagleSkinChangeNotification;

@interface Eaglekit : NSObject

/** Get ower of current sakura. */
@property (weak, nonatomic, readonly) id owner;

/** Just get all 1D skin objs which under sakura control. */
@property (strong, nonatomic, readonly) NSDictionary *skins1D;

+ (instancetype)eagleWithOwner:(id)owner;
- (instancetype)initWithOwner:(id)owner;

@end

@interface Eaglekit(Blocker)

#pragma mark - 1D Block

/** Change and Cache skin to sakura. */
- (EaglekitBlock)eagle_floatBlockWithName:(NSString *)name;
- (EaglekitBlock)eagle_colorBlockWithName:(NSString *)name;
- (EaglekitBlock)eagle_cgColorBlockWithName:(NSString *)name;
- (EaglekitBlock)eagle_titleBlockWithName:(NSString *)name;
- (EaglekitBlock)eagle_fontBlockWithName:(NSString *)name;
- (EaglekitBlock)eagle_keyboardAppearanceBlockWithName:(NSString *)name;
- (EaglekitBlock)eagle_titleTextAttributesBlockWithName:(NSString *)name;
- (EaglekitBlock)eagle_boolBlockWithName:(NSString *)name;
- (EaglekitBlock)eagle_imageBlockWithName:(NSString *)name;
- (EaglekitBlock)eagle_indicatorViewStyleBlockWithName:(NSString *)name;
- (EaglekitBlock)eagle_barStyleBlockWithName:(NSString *)name;

#pragma mark - 2D Block
- (Eaglekit2DUIntBlock)eagle_titleColorForStateBlockWithName:(NSString *)name;
- (Eaglekit2DUIntBlock)eagle_imageForStateBlockWithName:(NSString *)name;
- (Eaglekit2DUIntBlock)eagle_titleTextAttributesForStateBlockWithName:(NSString *)name;
- (Eaglekit2DBoolBlock)eagle_applicationForStyleBlockWithName:(NSString *)name;
            
@end

EagleCategoryDeclare(NSObject, Eaglekit)
