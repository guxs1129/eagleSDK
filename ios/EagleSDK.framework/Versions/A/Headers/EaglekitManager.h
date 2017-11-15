//
//  EaglekitManager.h
//  Eagle
//
//  Created by pantao on 2017/11/6.
//  Copyright © 2017年 pantao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Eaglekit.h"
typedef NSString EagleName;

SEL _Nullable getSelectorWithPattern(const char * _Nullable prefix, const char * _Nullable key, const char * _Nullable suffix);

typedef NS_ENUM(NSInteger, EagleType) {
    EagleTypeMainBundle,
    EagleTypeSandbox
};

@interface EaglekitManager : NSObject

+ (BOOL)shiftEagleWithName:(EagleName *_Nullable)name type:(EagleType)type;
+ (EagleName *_Nullable)getEagleCurrentName;
+ (EagleType)getEagleCurrentType;

@end

#pragma mark -- EagleDownload

@interface EaglekitManager(EagleDownload)

+ (NSString *_Nullable)eagle_getEagleConfigsFileBundlePathWithName:(NSString *_Nullable)eagleName;
+ (NSString *_Nullable)eagle_getEagleResourceSandboxPathWithName:(NSString *_Nullable)eagleName;
+ (NSString *_Nullable)eagle_tryGetEagleConfigsFileSandboxPathWithName:(NSString *_Nullable)eagleName;

@end

#pragma mark - TXSerialization

@interface EaglekitManager(Eaglekitlization)

+ (NSDictionary *_Nullable)eagle_getObjVectorOperationKV;
+ (NSDictionary *_Nullable)eagle_getIntVectorOperationKV;
+ (NSDictionary *_Nullable)eagle_getFloatVectorOperationKV;

+ (CGFloat)eagle_floatWithPath:(NSString  *_Nullable)path;
+ (UIColor *_Nullable)eagle_colorWithPath:(NSString *_Nullable)path;
+ (CGColorRef _Nullable )eagle_cgColorWithPath:(NSString *_Nullable)path;
+ (NSString *_Nullable)eagle_stringWithPath:(NSString *_Nullable)path;
+ (UIFont *_Nullable)eagle_fontWithPath:(NSString *_Nullable)path;
+ (UIKeyboardAppearance)eagle_keyboardAppearanceWithPath:(NSString *_Nullable)path;
+ (NSDictionary *_Nullable)eagle_titleTextAttributesDictionaryWithPath:(NSString *_Nullable)path;
+ (BOOL)eagle_boolWithPath:(NSString *_Nullable)path;
+ (UIImage *_Nullable)eagle_imageWithPath:(NSString *_Nullable)path;
+ (UIActivityIndicatorViewStyle)eagle_activityIndicatorStyleWithPath:(NSString *_Nullable)path;
+ (UIBarStyle)eagle_barStyleWithPath:(NSString *_Nullable)path;
+ (UIStatusBarStyle)eagle_statusBarStyleWithPath:(NSString *_Nullable)path;

@end

#pragma mark - TXTool

@interface EaglekitManager(EaglekitTool)
/** Inspired by DKNightVersion */
+ (UIColor *_Nullable)eagle_colorFromString:(NSString *_Nullable)hexStr;

@end
