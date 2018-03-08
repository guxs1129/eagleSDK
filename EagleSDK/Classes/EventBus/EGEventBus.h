//
//  EGEventBus.h
//  EGEventBus
//
//  Created by 顾新生 on 2017/10/13.
//  Copyright © 2017年 guxinsheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+EventBus.h"
@interface EGEventBus : NSObject

+(instancetype)shared;

-(void)registManyToOneWithTarget:(id)target withAction:(SEL)action onTopic:(NSString *)topic;
-(void)registManyToOneWithTarget:(id)target withBlock:(TopicBlock)blk onTopic:(NSString *)topic;
-(void)registManyToOneWithTarget:(id)target withResultBlock:(TopicResultBlock)blk onTopic:(NSString *)topic;
-(void)registManyToOneWithTarget:(id)target withAsyncResultBlock:(AsyncCallbackBlock)blk onTopic:(NSString *)topic;

-(void)publishTopic:(NSString *)topic withOptions:(id)options;

-(void)publishTopic:(NSString *)topic from:(id)eventSource options:(id)options withResultHandler:(SEL)resultHandler;
-(void)publishTopic:(NSString *)topic from:(id)eventSource options:(id)options withResultBlock:(void(^)(id result))resultBlock;

-(void)unmount:(id)target onTopic:(NSString *)topic;
-(void)unmount:(id)target;

-(void)setDebug:(BOOL)debug;

-(void)printTopic:(NSString *)topic;
@end
