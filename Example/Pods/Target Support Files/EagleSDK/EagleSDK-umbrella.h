#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "EGIconFont+JSON.h"
#import "NSObject+EGMediator.h"
#import "NSString+EGUtil.h"
#import "UIButton+Radius.h"
#import "UIImage+Color.h"
#import "UIImageView+Radius.h"
#import "UILabel+Radius.h"
#import "EGComponent.h"
#import "EGComponentDefine.h"
#import "EGDom.h"
#import "EGMacros.h"
#import "EGModuleManager.h"
#import "EGNode.h"
#import "EGRouterManager+Module.h"
#import "NSObject+Service.h"
#import "UIViewController+EGComponent.h"
#import "EGKit.h"
#import "EGKitManager.h"
#import "EGButton.h"
#import "EGController.h"
#import "EGImageView.h"
#import "EGLabel.h"
#import "EGTableView.h"
#import "EGTextComponent.h"
#import "EGTrash.h"
#import "EGView.h"
#import "EagleSDK.h"
#import "EGViewModel.h"
#import "NSObject+EGBind.h"
#import "UIBarButtonItem+EGBarButtonItem.h"
#import "UIButton+EGButton.h"
#import "UIDatePicker+EGDatePicker.h"
#import "UIGestureRecognizer+EGGestureRecognizer.h"
#import "UIRefreshControl+EGRefreshControl.h"
#import "UISegmentedControl+EGSegmentedControl.h"
#import "UISlider+EGSlider.h"
#import "UIStepper+EGStepper.h"
#import "UISwitch+EGSwitch.h"
#import "UITableViewCell+EGTableViewCell.h"
#import "UITextField+EGTextField.h"
#import "UITextView+EGTextView.h"
#import "UIColor+EGHex.h"
#import "EGEngine.h"
#import "EGTabBar.h"
#import "EGTabBarBadge.h"
#import "EGTabBarCONST.h"
#import "EGTabBarController.h"
#import "EGTabBarItem.h"
#import "EGTabBarManager.h"
#import "EGEvent.h"
#import "EGEventBus.h"
#import "EGEventContext.h"
#import "EGEventDispatcher.h"
#import "EGEventExcuter.h"
#import "NSObject+EventBus.h"
#import "EGComponent+JSONInject.h"
#import "EGComponentJsonParser.h"
#import "EGVCJsonBuilderManager.h"
#import "UIViewController+ViewModel.h"
#import "EGNavigationBarManager.h"
#import "EGNaviSlideApp.h"
#import "EGNaviSlideAppRouteParser.h"
#import "EGNaviSlideApp_macros.h"
#import "UIApplication+NaviSlideApp.h"
#import "EGBaseRequest.h"
#import "EGBatchRequest.h"
#import "EGBatchRequestAgent.h"
#import "EGChainRequest.h"
#import "EGChainRequestAgent.h"
#import "EGNetwork.h"
#import "EGNetworkAgent.h"
#import "EGNetworkConfig.h"
#import "EGNetworkPrivate.h"
#import "EGRequest.h"
#import "EGPopView.h"
#import "EGRootNavigationController.h"
#import "UIViewController+EGRootNavigationController.h"
#import "EGRouter.h"
#import "EGRouterManager+Blocks.h"
#import "EGRouterManager.h"
#import "EGFileDefines.h"
#import "EGFileManager.h"
#import "EGFileWrapper.h"
#import "EGSanboxFile.h"
#import "EGSearchHeaderDefault.h"
#import "EGSearchHeaderProtocol.h"
#import "EGSearchViewController.h"
#import "EGURL.h"
#import "EGURLProtocol.h"
#import "EGWebComponentBaseViewModel.h"
#import "EGWebViewController.h"
#import "NSObject+WebComponent.h"
#import "NSURLProtocol+WKWebVIew.h"
#import "WebComponent.h"
#import "WebViewJavascriptBridge.h"
#import "WebViewJavascriptBridgeBase.h"
#import "WKWebViewJavascriptBridge.h"

FOUNDATION_EXPORT double EagleSDKVersionNumber;
FOUNDATION_EXPORT const unsigned char EagleSDKVersionString[];
