//
//  WebViewJavascriptBridge.h
//  ExampleApp-iOS
//
//  Created by Marcus Westin on 6/14/13.
//  Copyright (c) 2013 Marcus Westin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebViewJavascriptBridgeBase.h"

#if (__MAC_OS_X_VERSION_MAX_ALLOWED > __MAC_10_9 || __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_1)
#define supportsWKWebView
#endif

#if defined supportsWKWebView
#import <WebKit/WebKit.h>
#endif

#if defined __MAC_OS_X_VERSION_MAX_ALLOWED
    #define _PLATFORM_OSX
    #define _WEBVIEW_TYPE WebView
    #define _WEBVIEW_DELEGATE_TYPE NSObject<WebViewJavascriptBridgeBaseDelegate>
    #define _WEBVIEW_DELEGATE_INTERFACE NSObject<WebViewJavascriptBridgeBaseDelegate, WebPolicyDelegate>
#elif defined __IPHONE_OS_VERSION_MAX_ALLOWED
    #import <UIKit/UIWebView.h>
    #define _PLATFORM_IOS
    #define _WEBVIEW_TYPE UIWebView
    #define _WEBVIEW_DELEGATE_TYPE NSObject<UIWebViewDelegate>
    #define _WEBVIEW_DELEGATE_INTERFACE NSObject<UIWebViewDelegate, WebViewJavascriptBridgeBaseDelegate>
#endif

@interface WebViewJavascriptBridge : _WEBVIEW_DELEGATE_INTERFACE


+ (instancetype)bridgeForWebView:(id)webView;
+ (instancetype)bridge:(id)webView;

+ (void)enableLogging;
+ (void)setLogMaxLength:(int)length;

- (void)registerHandler:(NSString*)handlerName handler:(Handler)handler;
- (void)removeHandler:(NSString*)handlerName;
- (void)callHandler:(NSString*)handlerName;
- (void)callHandler:(NSString*)handlerName data:(id)data;
- (void)callHandler:(NSString*)handlerName data:(id)data responseCallback:(ResponseCallback)responseCallback;
- (void)setWebViewDelegate:(id)webViewDelegate;
- (void)disableJavscriptAlertBoxSafetyTimeout;

@end
