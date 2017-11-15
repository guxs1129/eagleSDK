//
//  Eagle.h
//  eagle
//
//  Created by 潘涛 on 2017/10/12.
//  Copyright © 2017年 pantao. All rights reserved.
//

#ifndef Eagle_h
#define Eagle_h

#import <Availability.h>

#ifndef __IPHONE_8_0
#warning "This project uses features only available in iOS SDK 8.0 and later."
#endif

#ifdef __OBJC__
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#endif

#import "Eagle_macros.h"
#import <objc/runtime.h>
#import <sys/sysctl.h>
#import <mach/mach.h>

#import "Router.h"


#pragma mark -- NavigationVC

#import "UIViewController+RootNavigationController.h"
#import "RootNavigationController.h"

#pragma mark -- Component

#import "Component.h"// 组件
#import "UIViewController+Component.h"

#pragma mark -- EventBus

#import "NSObject+EventBus.h"
#import "EagleEventBus.h"

#pragma mark -- Skin

#import "EaglekitManager.h"
#import "EagleView.h"
#import "EagleButton.h"

#pragma mark -- Networking

#import "EGNetwork.h"

#pragma mark -- ZipArchive

#import "EGSanboxFile.h"

#pragma mark --WebKit
#import "NSURLProtocol+WKWebVIew.h"
#import "WebComponent.h"
#import "EagleURLProtocol.h"
#import "NSObject+WebComponent.h"
#import "EagleWebViewController.h"




#endif /* Eagle_h */
