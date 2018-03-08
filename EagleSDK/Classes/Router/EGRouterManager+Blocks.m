    //
    //  RouterManager+Blocks.m
    //  Eagle
    //
    //  Created by pantao on 2017/10/31.
    //  Copyright © 2017年 pantao. All rights reserved.
    //

#import "EGRouterManager+Blocks.h"
#import "EGRouter.h"
#import "EGWebViewController.h"

@implementation EGRouterManager (Blocks)

- (void)routeOperate:(NSDictionary *)params callback:(EGCallback)callback
{
    dispatch_async(dispatch_get_main_queue(), ^{
        BOOL _hidesBottomBarWhenPushed = [[params valueForKey:@"_hidesBottomBarWhenPushed"] boolValue];
        BOOL _modal = [[params valueForKey:@"_modal"] boolValue];
        if (params && [params objectForKey:@"route"]) {
            NSString *route = [params objectForKey:@"route"];
            NSString *clsName = [[EGRouterManager shared].eagleMap objectForKey:[EGRouterManager filterRoute:route]];
            if (clsName) {
                Class cls = NSClassFromString(clsName);
                UIViewController *nextVC = [[cls alloc] init];
                nextVC.params = params;
                nextVC.eg_callback = callback;
                UIViewController *topmostVC = [self topViewController];
                if ([topmostVC conformsToProtocol:@protocol(RouterProtocol)] && [topmostVC respondsToSelector:@selector(prepareNavigationTo:options:)]) {
                    id<RouterProtocol> fromVC=(id<RouterProtocol>)topmostVC;
                    [fromVC prepareNavigationTo:nextVC options:nil];
                }
                if (_modal) {
                    UINavigationController *navC = nil;
                    if ([EGRouterManager shared].navClz) {
                        Class cls = NSClassFromString([EGRouterManager shared].navClz);
                        navC = [[cls alloc] initWithRootViewController:nextVC];
                    }else {
                        navC = (EGRootNavigationController *)[[EGRootNavigationController alloc] initWithRootViewController:nextVC];
                    }
                    if (!navC) {
                        [topmostVC presentViewController:nextVC animated:YES completion:nil];
                    }else {
                        [topmostVC presentViewController:navC animated:YES completion:nil];
                    }
                }else {
                    if (_hidesBottomBarWhenPushed) {
                        topmostVC.hidesBottomBarWhenPushed = YES;
                        [topmostVC.navigationController pushViewController:nextVC animated:YES];
                        topmostVC.hidesBottomBarWhenPushed = NO;
                    }else{
                        [topmostVC.navigationController pushViewController:nextVC animated:YES];
                    }
                }
            }else {
                if (self.routerType == RouterHtml) {
                        //FIXME:use webmodule if available
                    EGWebViewController *webVC = [[EGWebViewController alloc] initWithUrl:[NSURL URLWithString:[params objectForKey:@"route"]]];
                    if ([EGRouterManager shared].webClz) {
                        Class cls = NSClassFromString([EGRouterManager shared].webClz);
                        if (cls) {
                            webVC = [[cls alloc] initWithUrl:[NSURL URLWithString:[params objectForKey:@"route"]] params:params callback:callback];
                        }
                    }
                    UIViewController *topmostVC = [self topViewController];
                    if (_modal) {
                        UINavigationController *navC = nil;
                        if ([EGRouterManager shared].navClz) {
                            Class cls = NSClassFromString([EGRouterManager shared].navClz);
                            navC = [[cls alloc] initWithRootViewController:webVC];
                        }else {
                            navC = (EGRootNavigationController *)[[EGRootNavigationController alloc] initWithRootViewController:webVC];
                        }
                        if (!navC) {
                            [topmostVC presentViewController:webVC animated:YES completion:nil];
                        }else {
                            [topmostVC presentViewController:navC animated:YES completion:nil];
                        }
                    }else {
                        if (_hidesBottomBarWhenPushed) {
                            topmostVC.hidesBottomBarWhenPushed = YES;
                            [topmostVC.navigationController pushViewController:webVC animated:YES];
                            topmostVC.hidesBottomBarWhenPushed = NO;
                        }else {
                            [topmostVC.navigationController pushViewController:webVC animated:YES];
                        }
                    }
                }else {
                    NSLog(@"404 not found page");
                }
            }
        }
    });
}

- (void)routeOperate:(NSDictionary *)params options:(id)options callback:(EGCallback)callback
{
    dispatch_async(dispatch_get_main_queue(), ^{
        BOOL _hidesBottomBarWhenPushed = [[params valueForKey:@"_hidesBottomBarWhenPushed"] boolValue];
        BOOL _modal = [[params valueForKey:@"_modal"] boolValue];
        if (params && [params objectForKey:@"route"]) {
            NSString *route = [params objectForKey:@"route"];
            NSString *clsName = [[EGRouterManager shared].eagleMap objectForKey:[EGRouterManager filterRoute:route]];
            if (clsName) {
                Class cls = NSClassFromString(clsName);
                UIViewController *nextVC = [[cls alloc] init];
                nextVC.params = params;
                nextVC.eg_callback = callback;
                UIViewController *topmostVC = [self topViewController];
                if ([topmostVC conformsToProtocol:@protocol(RouterProtocol)] && [topmostVC respondsToSelector:@selector(prepareNavigationTo:options:)]) {
                    id<RouterProtocol> fromVC=(id<RouterProtocol>)topmostVC;
                    [fromVC prepareNavigationTo:nextVC options:options];
                }
                if ([nextVC conformsToProtocol:@protocol(RouterProtocol)] && [nextVC respondsToSelector:@selector(getOptionsFromEx:)]) {
                    [(id<RouterProtocol>)nextVC getOptionsFromEx:options];
                }
                if (_modal) {
                    UINavigationController *navC = nil;
                    if ([EGRouterManager shared].navClz) {
                        Class cls = NSClassFromString([EGRouterManager shared].navClz);
                        navC = [[cls alloc] initWithRootViewController:nextVC];
                    }else {
                        navC = (EGRootNavigationController *)[[EGRootNavigationController alloc] initWithRootViewController:nextVC];
                    }
                    if (!navC) {
                        [topmostVC presentViewController:nextVC animated:YES completion:nil];
                    }else {
                        [topmostVC presentViewController:navC animated:YES completion:nil];
                    }
                }else {
                    if (_hidesBottomBarWhenPushed) {
                        topmostVC.hidesBottomBarWhenPushed = YES;
                        [topmostVC.navigationController pushViewController:nextVC animated:YES];
                        topmostVC.hidesBottomBarWhenPushed = NO;
                    }else{
                        [topmostVC.navigationController pushViewController:nextVC animated:YES];
                    }
                }
            }else {
            }
        }
    });
}

- (EGRouterBlock)openEagleWithCallback:(EGCallback)callback
{
    return ^id(NSDictionary* params) {
        [self routeOperate:params callback:callback];
        return nil;
    };
}

-(EGRouterBlock)openEagleWithOptions:(id)options callback:(EGCallback)callback
{
    return ^id(NSDictionary* params) {
        [self routeOperate:params options:options callback:callback];
        return nil;
    };
}

- (EGRouterBlock)openHtml
{
    return ^id(NSDictionary* params) {
        [self routeOperate:params callback:nil];
        return nil;
    };
}

- (EGRouterBlock)openHtmlWithCallback:(EGCallback)callback
{
    return ^id(NSDictionary* params) {
        [self routeOperate:params callback:callback];
        return nil;
    };
}

- (EGRouterBlock)openRN
{
    return ^id(NSDictionary* params) {
        [self routeOperate:params callback:nil];
        return nil;
    };
}

- (EGRouterBlock)openOnlineFile
{
    return ^id(NSDictionary* params) {
        [self routeOperate:params callback:nil];
        return nil;
    };
}

- (EGRouterBlock)openLocalFile
{
    return ^id(NSDictionary* params) {
        [self routeOperate:params callback:nil];
        return nil;
    };
}

- (EGRouterBlock)openTel
{
    return ^id(NSDictionary* params) {
        [self routeOperate:params callback:nil];
        return nil;
    };
}

@end

