//
//  NSObject+EventBus.h
//  EGEventBus
//
//  Created by 顾新生 on 2017/10/13.
//  Copyright © 2017年 guxinsheng. All rights reserved.
//
typedef void(^TopicBlock)(id msg);
typedef id(^TopicResultBlock)(id msg);
typedef void(^CallResult)(id result);
typedef void(^AsyncCallbackBlock)(CallResult callback);


#import <Foundation/Foundation.h>

@interface NSObject (EventBus)

/**
 事件订阅

 @param topic 事件主题
 @param handler 事件处理方法
 */
-(void)subscribe:(NSString *)topic withHandler:(SEL)handler;


/**
 事件订阅

 @param topic 事件主题
 @param topicBlock 事件处理block
 */
-(void)subscribe:(NSString *)topic withBlock:(TopicBlock)topicBlock;


/**
 事件订阅
 
 @param topic 事件主题
 @param topicResultBlock 事件处理block，带结果回调
 */
-(void)subscribe:(NSString *)topic withResultBlock:(TopicResultBlock)topicResultBlock;

/**
 事件订阅
 
 @param topic 事件主题
 @param asyncCallbackBlock 事件处理block，带异步结果回调
 */
-(void)subscribe:(NSString *)topic withAsyncResultBlock:(AsyncCallbackBlock)asyncCallbackBlock;

/**
 事件广播（一对多）

 @param topic 事件主题
 @param options 事件内容
 */
-(void)post:(NSString *)topic withOptions:(id)options;


/**
 事件广播（一对一），有结果回调

 @param topic 事件主题
 @param options 事件内容
 @param resultHandler 结果回调
 */
-(void)post:(NSString *)topic options:(id)options withResultHandler:(SEL)resultHandler;


/**
 事件广播（一对一），有结果回调

 @param topic 事件主题
 @param options 事件内容
 @param resultBlock 结果回调Block
 */
-(void)post:(NSString *)topic options:(id)options withResultBlock:(void(^)(id result))resultBlock;



/**
 取消事件订阅

 @param topic 事件主题
 */
-(void)unsubscribeForTopic:(NSString *)topic;


/**
 取消全部事件订阅
 */
-(void)unsubscribeAll;

///**
// 服务注册
//
// @param serviceName 服务名
// */
//-(void)registService:(NSString *)className withAction:(SEL)action;


///**
// 服务请求
//
// @param serviceName 服务名
// @param options 传入选项
// */
//-(void)getService:(NSString *)serviceName withOptions:(id)options;


///**
// 服务请求
//
// @param serviceName 服务名
// @param options 传入选项
// @param callback 结果回调
// */
//-(void)getService:(NSString *)serviceName options:(id)options callback:(CallResult)callback;

-(void)setEventBusDebug:(BOOL)enable;

-(void)debug;
-(void)debugTopic:(NSString *)topic;
@end
