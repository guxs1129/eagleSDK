//
//  EGAppDelegate.m
//  EagleSDK
//
//  Created by guxs1129@163.com on 11/10/2017.
//  Copyright (c) 2017 guxs1129@163.com. All rights reserved.
//

#import "EGAppDelegate.h"

@interface EGAppDelegate()
@property(nonatomic,strong)MMDrawerController *drawerController;
@end
@implementation EGAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [NSURLProtocol registerClass:[EGURLProtocol class]];
    NSURLCache *cache=[[NSURLCache alloc]initWithMemoryCapacity:1024*1024*4 diskCapacity:1024*1024*20 diskPath:nil];
    [NSURLCache setSharedURLCache:cache];
    
//    [EGRouterManager analyzeRoute:@[@"eagle://vc?_title=首页&_image=U&_selectedImage=S"] type:RouterTab];

//    [EGRouterManager analyzeRoute:@[@"eagle://vc?home_vc=EGHomeViewController&home_title=首页&left_vc=UIViewController&left_title=个人&left_img=photo&left_selectedImg=photo&right_vc=UIViewController&right_title=设置&right_img=search&right_selectedImg=search"] type:RouterNaviSlide];

    NSArray *arr=@[[NSString stringWithFormat:@"eagle://vc?_title=首页&_image=%@&_color=#666666&_selectedImage=%@&_selectedColor=#2097f4",[NSString stringWithFormat:@"%C", (unichar)0xe699], [NSString stringWithFormat:@"%C", (unichar)0xe699]],
                   [NSString stringWithFormat:@"eagle://vc?_title=通讯录&_image=%@&_color=#666666&_selectedImage=%@&_selectedColor=#2097f4&_autoAlertNotReachable=YES", [NSString stringWithFormat:@"%C", (unichar)0xe6a2], [NSString stringWithFormat:@"%C", (unichar)0xe6a2]],
                   [NSString stringWithFormat:@"eagle://vc?_title=发现&_image=%@&_color=#666666&_selectedImage=%@&_selectedColor=#2097f4", [NSString stringWithFormat:@"%C", (unichar)0xe6ac], [NSString stringWithFormat:@"%C", (unichar)0xe6ac]],
                   [NSString stringWithFormat:@"eagle://vc?_title=我&_image=%@&_color=#666666&_selectedImage=%@&_selectedColor=#2097f4", [NSString stringWithFormat:@"%C", (unichar)0xe6b8], [NSString stringWithFormat:@"%C", (unichar)0xe6b8]]];
    
    [EGRouterManager analyzeRoute:arr
                              type:RouterTab];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh" object:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
