//
//  EGEventDispatcher.m
//  AFNetworking
//
//  Created by 顾新生 on 14/12/2017.
//

#import "EGEventDispatcher.h"
#import "EGEventExcuter.h"
@interface EGEventDispatcher()
@property(nonatomic,strong)dispatch_queue_t excuteQueue;
@end
@implementation EGEventDispatcher
static const char* queueID="com.stee.EagleSDK.excuteQueue";
+(instancetype)shareInstance{
    static EGEventDispatcher *shareInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance=[[self alloc]init];
        shareInstance.excuteQueue=dispatch_queue_create(queueID, DISPATCH_QUEUE_CONCURRENT);
    });
    return shareInstance;
}

-(void)dispatchEvent:(EGEvent *)event{
    EGEventExcuter *excuter=[[EGEventExcuter alloc]initWithEvent:event withQueue:self.excuteQueue];
    [excuter excute];
}

@end
