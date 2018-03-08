//
//  EaglekitManager.h
//  Eagle
//
//  Created by pantao on 2017/11/6.
//  Copyright © 2017年 pantao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EGKit.h"
typedef NSString EagleName;

SEL _Nullable getSelectorWithPattern(const char * _Nullable prefix, const char * _Nullable key, const char * _Nullable suffix);

typedef NS_ENUM(NSInteger, EagleType) {
    EagleTypeMainBundle,
    EagleTypeSandbox
};

@interface EGKitManager : NSObject

+ (BOOL)shiftEagleWithName:(EagleName *_Nullable)name type:(EagleType)type;
+ (EagleType)getEagleCurrentType;

+ (EagleName *_Nullable)getEagleCurrentName;
#pragma mark - Manual Eagle
+ (NSArray<EagleName *> *_Nullable)getLocalEagleNames;
+ (void)registerLocalEagleWithNames:(NSArray<EagleName *> *_Nullable)names;

@end

#pragma mark -- EagleDownload

@interface EGKitManager(EagleDownload)

+ (NSString *_Nullable)eagle_getEagleConfigsFileBundlePathWithName:(NSString *_Nullable)eagleName;
+ (NSString *_Nullable)eagle_getEagleResourceSandboxPathWithName:(NSString *_Nullable)eagleName;
+ (NSString *_Nullable)eagle_tryGetEagleConfigsFileSandboxPathWithName:(NSString *_Nullable)eagleName;
+ (NSArray<EagleName *> *_Nullable)eagle_getEaglesList;

@end

#pragma mark - TXSerialization

@interface EGKitManager(Eaglekitlization)

+ (NSDictionary *_Nullable)eagle_getObjVectorOperationKV;
+ (NSDictionary *_Nullable)eagle_getIntVectorOperationKV;
+ (NSDictionary *_Nullable)eagle_getFloatVectorOperationKV;

+ (CGFloat)eagle_floatWithPath:(NSString  *_Nullable)path owner:(id _Nullable )owner;
+ (UIColor *_Nullable)eagle_colorWithPath:(NSString *_Nullable)path owner:(id _Nullable )owner;
+ (CGColorRef _Nullable )eagle_cgColorWithPath:(NSString *_Nullable)path owner:(id _Nullable )owner;
+ (NSString *_Nullable)eagle_stringWithPath:(NSString *_Nullable)path owner:(id _Nullable )owner;
+ (UIFont *_Nullable)eagle_fontWithPath:(NSString *_Nullable)path owner:(id _Nullable )owner;
+ (UIKeyboardAppearance)eagle_keyboardAppearanceWithPath:(NSString *_Nullable)path owner:(id _Nullable )owner;
+ (NSDictionary *_Nullable)eagle_titleTextAttributesDictionaryWithPath:(NSString *_Nullable)path owner:(id _Nullable )owner;
+ (BOOL)eagle_boolWithPath:(NSString *_Nullable)path owner:(id _Nullable )owner;
+ (UIImage *_Nullable)eagle_imageWithPath:(NSString *_Nullable)path owner:(id _Nullable )owner;
+ (UIActivityIndicatorViewStyle)eagle_activityIndicatorStyleWithPath:(NSString *_Nullable)path owner:(id _Nullable )owner;
+ (UIBarStyle)eagle_barStyleWithPath:(NSString *_Nullable)path owner:(id _Nullable )owner;
+ (UIStatusBarStyle)eagle_statusBarStyleWithPath:(NSString *_Nullable)path owner:(id _Nullable )owner;

@end

#pragma mark - TXTool

@interface EGKitManager(EaglekitTool)
/** Inspired by DKNightVersion */
+ (UIColor *_Nullable)eagle_colorFromString:(NSString *_Nullable)hexStr;

@end

