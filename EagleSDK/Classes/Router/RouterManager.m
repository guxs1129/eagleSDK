//
//  RouterManager.m
//  Eagle
//
//  Created by pantao on 2017/10/30.
//  Copyright © 2017年 pantao. All rights reserved.
//

#import "RouterManager.h"
#import "Router.h"
#import "RouterManager+Blocks.h"

@implementation RouterManager

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

+ (void)navigateTo:(NSString *)route
{
    RouterType type = RouterUnkown;
    if ([route hasPrefix:@"eagle:"]) {                                     //   eagle://a/b?c=d&r=f eagle内部native跳转
        type = RouterEagle;
        [[Router shared] map:route
                     toBlock:[[RouterManager shared] openEagle]];
    }else if ([route hasPrefix:@"http:"] || [route hasPrefix:@"https:"]) {//   http://a/b?c=d&r=f、https://a/b?c=d&r=f H5跳转
        if ([route hasSuffix:@".pdf"] || [route hasSuffix:@".doc"]) {     //   http://a/b.pdf、http://a/b.doc 在线pdf、doc等预览
            type = RouterOnlineFile;
            [[Router shared] map:route
                         toBlock:[[RouterManager shared] openOnlineFile]];
        }else {
            type = RouterHtml;
            [[Router shared] map:route
                         toBlock:[[RouterManager shared] openHtml]];
        }
    }else if ([route hasPrefix:@"rn:"]) {                                  //   rn://a/b?c=d&r=f react-native跳转
        type = RouterRN;
        [[Router shared] map:route
                     toBlock:[[RouterManager shared] openRN]];
    }else if ([route hasPrefix:@"file:"]) {                                //   file://xxx.html 打开本地文件
        type = RouterLocalFile;
        [[Router shared] map:route
                     toBlock:[[RouterManager shared] openLocalFile]];
    }else if ([route hasPrefix:@"tel:"]) {                                 //   tel://10086 打电话
        type = RouterTel;
        [[Router shared] map:route
                     toBlock:[[RouterManager shared] openTel]];
    }else {
        NSArray *temp = [route componentsSeparatedByString:@"?"];
        if (temp.count > 0) {
            
        }
    }
//        /a/b?c=d&r=f
     [[Router shared] callBlock:route];
}

+ (NSString *)filterRoute:(NSString *)route
{
    NSString *tempRoute = route;
    if ([route rangeOfString:@"://"].location != NSNotFound && [route rangeOfString:@"?"].location != NSNotFound) {
        tempRoute = [route substringWithRange:NSMakeRange([route rangeOfString:@"://"].location + 3, [route rangeOfString:@"?"].location - ([route rangeOfString:@"://"].location + 3))];
    }
    return tempRoute;
}

- (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
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

@end
