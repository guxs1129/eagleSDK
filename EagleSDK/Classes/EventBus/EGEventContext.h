//
//  EGEventContext.h
//  EGEventBus
//
//  Created by 顾新生 on 2017/10/17.
//  Copyright © 2017年 guxinsheng. All rights reserved.
//
//  Context是对事件订阅者的单体封装

#import <Foundation/Foundation.h>
@class EGEvent;
@interface EGEventContext : NSObject
@property(nonatomic,copy)NSString *topic;
@property(nonatomic,weak)id target;
@property(nonatomic,assign)NSArray *actions;
@property(nonatomic,strong)NSArray *blkList;

@property(nonatomic,weak)EGEvent *event;
-(instancetype)initWithEvent:(EGEvent *)event;

@end
