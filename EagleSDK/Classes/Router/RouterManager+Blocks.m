//
//  RouterManager+Blocks.m
//  Eagle
//
//  Created by pantao on 2017/10/31.
//  Copyright © 2017年 pantao. All rights reserved.
//

#import "RouterManager+Blocks.h"
#import "Router.h"

@implementation RouterManager (Blocks)

- (void)routeOperate:(NSDictionary *)params
{
    if (params && [params objectForKey:@"route"]) {
        NSString *route = [params objectForKey:@"route"];
        NSString *clsName = [[RouterManager shared].eagleMap objectForKey:[RouterManager filterRoute:route]];
        if (clsName) {
            Class cls = NSClassFromString(clsName);
            UIViewController *nextVC = [[cls alloc] init];
            nextVC.params = params;
            UIViewController *topmostVC = [self topViewController];
            [topmostVC.navigationController pushViewController:nextVC animated:YES];
        }else {
            NSLog(@"404 not found page");
        }
    }
}

- (EagleRouterBlock)openEagle
{
    return ^id(NSDictionary* params) {
        [self routeOperate:params];
        return nil;
    };
}

- (EagleRouterBlock)openHtml
{
    return ^id(NSDictionary* params) {
        [self routeOperate:params];
        return nil;
    };
}

- (EagleRouterBlock)openRN
{
    return ^id(NSDictionary* params) {
        [self routeOperate:params];
        return nil;
    };
}

- (EagleRouterBlock)openOnlineFile
{
    return ^id(NSDictionary* params) {
        [self routeOperate:params];
        return nil;
    };
}

- (EagleRouterBlock)openLocalFile
{
    return ^id(NSDictionary* params) {
        [self routeOperate:params];
        return nil;
    };
}

- (EagleRouterBlock)openTel
{
    return ^id(NSDictionary* params) {
        [self routeOperate:params];
        return nil;
    };
}

@end
