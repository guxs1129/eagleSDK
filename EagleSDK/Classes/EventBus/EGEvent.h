//
//  EGEvent.h
//  EGEventBus
//
//  Created by 顾新生 on 2017/10/17.
//  Copyright © 2017年 guxinsheng. All rights reserved.
//
//  Event 是对事件的封装，包括事件主题、事件的订阅者，事件对于的block，事件含有的信息

#import <Foundation/Foundation.h>
#import "NSObject+EventBus.h"
@interface EGEvent : NSObject
@property(nonatomic,copy)NSString *topic;


/**
 事件订阅者
 */
@property(nonatomic,strong)NSArray *subscribeList;


/**
 事件订阅者与方法索引
 */
@property(nonatomic,strong)NSDictionary *selectorMap;


/**
 block索引
 */
@property(nonatomic,strong)NSDictionary *blkMap;

@property(nonatomic,assign)BOOL isResultNeed;

@property(nonatomic,assign)BOOL isAsync;

@property(nonatomic,copy)CallResult callback;

@property(nonatomic,strong,readonly)id options;

-(instancetype)initWithTopic:(NSString *)topic selectorMap:(NSDictionary *)selectorMap blkMap:(NSDictionary *)blkMap options:(id)options;
@end
