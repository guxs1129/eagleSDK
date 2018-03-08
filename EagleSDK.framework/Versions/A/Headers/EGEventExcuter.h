//
//  EGEventExcuter.h
//  EGEventBus
//
//  Created by 顾新生 on 2017/10/17.
//  Copyright © 2017年 guxinsheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EGEvent.h"
#import "EGEventContext.h"
#import "NSObject+EventBus.h"
@interface EGEventExcuter : NSObject
@property(nonatomic,strong)EGEvent *event;
@property(nonatomic,strong)NSArray *targetList;
@property(nonatomic,copy)CallResult callback;
-(instancetype)initWithEvent:(EGEvent *)event withQueue:(dispatch_queue_t)excuteQueue;
-(void)excute;
@end
