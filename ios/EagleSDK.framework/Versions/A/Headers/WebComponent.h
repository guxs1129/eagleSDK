//
//  WebComponent.h
//  Eagle
//
//  Created by 顾新生 on 2017/11/2.
//  Copyright © 2017年 pantao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKWebViewJavascriptBridge.h"
#import "Component.h"
#import "EagleEventBus.h"
#import "NSURLProtocol+WKWebVIew.h"
@protocol WebComponentDelegate<NSObject>

/**
 js Call native 事件处理

 @param handler handler名称
 @param data 传入数据
 @param callback js回调
 */
@required
-(void)navtiveCall:(NSString *)handler data:(id)data callBack:(TopicResultBlock)callback;



/**
 
 native Call js 结果回调

 @param handler handler名称
 @param responseData 返回数据
 */
@optional
-(void)jsCallback:(NSString *)handler response:(id)responseData;

@optional
/**
 url拦截调用

 @param handler handler名称
 @param msg 信息
 */
-(void)urlCall:(NSString *)handler params:(NSArray *)params msg:(id)msg;


@end

@interface WebComponent : Component
@property(nonatomic,weak)NSObject<WebComponentDelegate> *webDelegate;
@property(nonatomic,strong)NSURL *loadURL;
@property(nonatomic,copy)NSString *mimeType;
@property(nonatomic,strong)NSArray *handlers;

/**
 WebComponent的识别id，唯一，默认是自己的hash值
 */
@property(nonatomic,copy)NSString *identifier;

-(void)addTarget:(NSObject<WebComponentDelegate> *)webDelegate andIdentifier:(NSString *)identifier;
-(void)addHandlers:(NSArray *)handlers withTarget:(id<WebComponentDelegate>)delegate;
-(void)callJSHandler:(NSString *)handler from:(id)target options:(id)options complete:(TopicBlock)completeBlock;
-(void)goBack;

-(void)setFullScreen:(BOOL)flag;
@end


