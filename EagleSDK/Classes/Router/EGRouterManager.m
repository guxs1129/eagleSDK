    //
    //  RouterManager.m
    //  Eagle
    //
    //  Created by pantao on 2017/10/30.
    //  Copyright © 2017年 pantao. All rights reserved.
    //

#import "EGRouterManager.h"
#import "EGRouterManager+Blocks.h"
#import "EGRootNavigationController.h"
#import "EGTabBarManager.h"
#import "EGKitManager.h"
#import "EGIconFont+JSON.h"

@interface UIViewController (KV)
@end

@implementation UIViewController (KV)

- (void)setEGValue:(NSString *)value forKey:(NSString *)key type:(RouterType)type
{
    switch (type) {
        case RouterTab:// tabBar
        {
        if ([key isEqualToString:@"_title"]) {
            self.tabBarItem.title = value;
        }
        else {
            [self setValue:value forKey:key];
        }
        }
            break;
            
        default:
            break;
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{ }

- (id)valueForUndefinedKey:(NSString *)key{
    return nil;
}

@end

@implementation EGRouterManager

+ (instancetype)shared
{
    static dispatch_once_t once;
    static id shared;
    dispatch_once(&once, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (NSMutableDictionary *)eagleMap
{
    if (!_eagleMap) {
        _eagleMap = [NSMutableDictionary dictionary];
    }
    return _eagleMap;
}

+(void)navigateTo:(NSString *)router{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self navigateTo:router options:nil callback:nil];
    });
}

+ (void)navigateTo:(NSString *)router options:(id)options
{
    [self navigateTo:router options:options callback:nil];
}

+ (void)navigateTo:(NSString *)router callback:(EGCallback)callback
{
    [self navigateTo:router options:nil callback:callback];
}

+ (void)navigateTo:(NSString *)route options:(id)options callback:(EGCallback)callback
{
    RouterType type = RouterUnkown;
    if ([route hasPrefix:@"eagle:"]) {                                     //   eagle://a/b?c=d&r=f eagle内部native跳转
        type = RouterEagle;
        if (options) {
            [[EGRouter shared] map:route
                           toBlock:[[EGRouterManager shared] openEagleWithOptions:options callback:callback]];
        }else{
            [[EGRouter shared] map:route
                           toBlock:[[EGRouterManager shared] openEagleWithCallback:callback]];
        }
    }else if ([route hasPrefix:@"http:"] || [route hasPrefix:@"https:"]) {//   http://a/b?c=d&r=f、https://a/b?c=d&r=f H5跳转
        if ([route hasSuffix:@".pdf"] || [route hasSuffix:@".doc"]) {     //   http://a/b.pdf、http://a/b.doc 在线pdf、doc等预览
            type = RouterOnlineFile;
            [[EGRouter shared] map:route
                           toBlock:[[EGRouterManager shared] openOnlineFile]];
        }else {
            type = RouterHtml;
            [[EGRouter shared] map:route
                           toBlock:[[EGRouterManager shared] openHtmlWithCallback:callback]];
        }
    }else if ([route hasPrefix:@"rn:"]) {                                  //   rn://a/b?c=d&r=f react-native跳转
        type = RouterRN;
        [[EGRouter shared] map:route
                       toBlock:[[EGRouterManager shared] openRN]];
    }else if ([route hasPrefix:@"file:"]) {                                //   file://xxx.html 打开本地文件
        type = RouterLocalFile;
        [[EGRouter shared] map:route
                       toBlock:[[EGRouterManager shared] openLocalFile]];
    }else if ([route hasPrefix:@"tel:"]) {                                 //   tel://10086 打电话
        type = RouterTel;
        [[EGRouter shared] map:route
                       toBlock:[[EGRouterManager shared] openTel]];
    }else {
        NSArray *temp = [route componentsSeparatedByString:@"?"];
        if (temp.count > 0) {
            
        }
    }
    [EGRouterManager shared].routerType = type;
        //        /a/b?c=d&r=f
    [[EGRouter shared] callBlock:route];
}

+ (UIWindow *)mainWindow
{
    UIApplication *app = [UIApplication sharedApplication];
    if ([app.delegate respondsToSelector:@selector(window)]) {
        return [app.delegate window];
    }
    return [app keyWindow];
}

+ (void)analyzeRoute:(NSArray <NSString *>*)routes type:(RouterType)type
{
    switch (type) {
        case RouterTab:     // EAGLE://vc?vc=vc1&title=a&titleColor=b&badgeValue=c&image=d&selImage=e&viewBgColor=f
        case RouterNav:
        {
        [EGRouterManager dealRoutes:routes type:type];
        }
            break;
        case RouterNaviSlide:{
            EGNaviSlideApp.parseRoutes(routes).engineStart();
        }
            break;
        default:
            break;
    }
}

+ (void)dealRoutes:(NSArray <NSString *>*)routes type:(RouterType)type
{
    [EGTabBarManager shared].tabBarVC = [[EGTabBarController alloc] init];
    UINavigationController *navC = nil;
    if ([EGRouterManager shared].navClz) {
        Class cls = NSClassFromString([EGRouterManager shared].navClz);
        navC = [[cls alloc] initWithRootViewController:[UIViewController new]];
    }else {
        navC = (EGRootNavigationController *)[[EGRootNavigationController alloc] initWithRootViewController:[UIViewController new]];
    }
    if (!navC) {
        return;
    }
    for (NSString *route in routes) {
        if ([route rangeOfString:@"eagle"].location == NSNotFound) {
            continue;
        }
        NSString *clsName = [[EGRouterManager shared].eagleMap objectForKey:[EGRouterManager filterRoute:route]];
        if (clsName) {
            Class cls = NSClassFromString(clsName);
            UIViewController *vc = [[cls alloc] init];
            if ([route componentsSeparatedByString:@"?"].count == 2) {
                NSString *paramsStr = (NSString *)[route componentsSeparatedByString:@"?"][1];
                UIColor *imageColor = [UIColor blackColor];
                UIColor *selectedImageColor = [UIColor blackColor];
                if ([paramsStr rangeOfString:@"_color"].location != NSNotFound) {
                    imageColor = [UIColor eg_colorWithHexString:[[paramsStr componentsSeparatedByString:@"_color="][1] componentsSeparatedByString:@"&"][0]];
                }
                if ([paramsStr rangeOfString:@"_selectedColor"].location != NSNotFound) {
                    selectedImageColor = [UIColor eg_colorWithHexString:[[paramsStr componentsSeparatedByString:@"_selectedColor="][1] componentsSeparatedByString:@"&"][0]];
                }
                [[EGTabBarManager shared].tabBarVC setItemTitleColor:imageColor];
                [[EGTabBarManager shared].tabBarVC setSelectedItemTitleColor:selectedImageColor];
                for (NSString *param in [paramsStr componentsSeparatedByString:@"&"]) {
                    NSArray *paramArray = [param componentsSeparatedByString:@"="];
                    if (paramArray.count != 2) {
                        continue;
                    }
                    NSString *key = paramArray[0];
                    NSString *value = paramArray[1];
                    if ([key isEqualToString:@"_image"]) {
                        NSString *fontName=[EGIconFont replaceUnicodeString:[value stringByReplacingOccurrencesOfString:@"0x" withString:@"\\U"]];

                        vc.tabBarItem.image = [UIImage iconWithInfo:EGIconInfoMake(fontName, 25, imageColor)];
                        
                    }else if ([paramArray[0] isEqualToString:@"_selectedImage"]) {
                        NSString *fontName=[EGIconFont replaceUnicodeString:[value stringByReplacingOccurrencesOfString:@"0x" withString:@"\\U"]];

                        vc.tabBarItem.selectedImage = [UIImage iconWithInfo:EGIconInfoMake(fontName, 25, selectedImageColor)];
                    }else {
                        [vc setEGValue:paramArray[1] forKey:paramArray[0] type:type];
                    }
                }
            }
            navC = [[EGRootNavigationController alloc] initWithRootViewController:vc];
            if (type == RouterTab) {
                [[EGTabBarManager shared].tabBarVC addChildViewController:navC];
            }else if (type == RouterNav && routes.count == 1) {
                if ([[EGRouterManager mainWindow].rootViewController isKindOfClass:UINavigationController.class]) {
                    [(UINavigationController *)[EGRouterManager mainWindow].rootViewController pushViewController:navC animated:YES];
                }else {
                    [EGRouterManager mainWindow].rootViewController = navC;
                }
            }
        }else {
            EGLog(@"404 not found page");
        }
    }
    if (type == RouterTab) {
        [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [EGRouterManager mainWindow].rootViewController = [EGTabBarManager shared].tabBarVC;
        } completion:nil];
    }
}

+ (NSString *)filterRoute:(NSString *)route
{
    NSString *tempRoute = route;
    if ([route rangeOfString:@"://"].location != NSNotFound) {
        if ([route rangeOfString:@"?"].location != NSNotFound) {
            tempRoute = [route substringWithRange:NSMakeRange([route rangeOfString:@"://"].location + 3, [route rangeOfString:@"?"].location - ([route rangeOfString:@"://"].location + 3))];
        }else {
            tempRoute = [route substringWithRange:NSMakeRange([route rangeOfString:@"://"].location + 3, route.length - ([route rangeOfString:@"://"].location + 3))];
        }
    }
    return tempRoute;
}

- (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[EGRouterManager mainWindow] rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    if([resultVC isKindOfClass:[ContainerController class]]){
        return ((ContainerController *)resultVC).contentViewController;
    }
    return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

+ (void)setupCustomNavVC:(NSString *)className
{
    [EGRouterManager shared].navClz = className;
}

+ (void)setupCustomWebVC:(NSString *)className
{
    [EGRouterManager shared].webClz = className;
}

+(void)parseJSON{
    
    NSString *jsonfile=[[NSBundle mainBundle]pathForResource:@"app.json" ofType:nil];
    if (jsonfile) {
        NSData *data=[NSData dataWithContentsOfFile:jsonfile];
        NSError *error;
        NSDictionary *params=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        if (params) {
            NSArray *urls=[params valueForKey:@"urls"];
            NSInteger type=[[params valueForKey:@"type"]integerValue];
            if (urls) {
                [self analyzeRoute:urls type:type];
            }
        }else{
            @throw [NSException exceptionWithName:@"<EGRouterManager Error>" reason:@"The app.json is invalid." userInfo:nil];
        }
    }else{
        NSLog(@"<EGRouterManager Inof>The app.json file is not exist.");
    }
}

@end

