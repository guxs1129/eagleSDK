//
//  EGWebViewController.h
//  EG
//
//  Created by 顾新生 on 2017/10/31.
//  Copyright © 2017年 pantao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKWebViewJavascriptBridge.h"

@interface EGWebViewController : UIViewController<WKUIDelegate,WKNavigationDelegate>
- (instancetype)initWithUrl:(NSURL *)url;
- (instancetype)initWithUrl:(NSURL *)url params:(NSDictionary *)params callback:(EGCallback)callback;
@property(nonatomic,strong)NSURL *url;
@property(nonatomic,strong)WKWebViewJavascriptBridge *bridge;
@property(nonatomic,strong)WKWebView *webView;

@end
