    //
    //  RouterManager.h
    //  Eagle
    //
    //  Created by pantao on 2017/10/30.
    //  Copyright © 2017年 pantao. All rights reserved.
    //

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EGRouter.h"

typedef NS_ENUM(NSInteger, RouterType)
{
    RouterTab=0,              // tabBar
    RouterNaviSlide,        // 导航加左右抽屉菜单
    RouterUnkown,           // 未知类型
    RouterEagle,            // eagle内部native跳转
    RouterHtml,             // H5跳转
    RouterRN,               // react-native跳转
    RouterOnlineFile,       // 在线pdf、doc等预览
    RouterLocalFile,        // 本地文件
    RouterTel,              // 电话
    RouterNav,              // nav
};

@interface EGRouterManager : NSObject

@property (nonatomic, strong) NSMutableDictionary *eagleMap;

+ (instancetype)shared;
+ (void)navigateTo:(NSString *)router;
+ (void)navigateTo:(NSString *)router options:(id)options;
+ (void)navigateTo:(NSString *)router callback:(EGCallback)callback;
+ (void)navigateTo:(NSString *)route options:(id)options callback:(EGCallback)callback;
+ (NSString *)filterRoute:(NSString *)route;
- (UIViewController *)topViewController;
+ (void)analyzeRoute:(NSArray <NSString *>*)routes type:(RouterType)type;
@property (nonatomic, assign) RouterType routerType;

@property (nonatomic, strong) NSString *navClz;
+ (void)setupCustomNavVC:(NSString *)className;

@property (nonatomic, strong) NSString *webClz;
+ (void)setupCustomWebVC:(NSString *)className;

+ (UIWindow *)mainWindow;

+(void)parseJSON;
@end

