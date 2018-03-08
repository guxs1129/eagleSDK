//
//  NSObject+EventBus.m
//  EGEventBus
//
//  Created by 顾新生 on 2017/10/13.
//  Copyright © 2017年 guxinsheng. All rights reserved.
//

#import "NSObject+EventBus.h"
#import "EGEventBus.h"
@implementation NSObject (EventBus)


-(void)subscribe:(NSString *)topic withHandler:(SEL)handler{
    
    [[EGEventBus shared]registManyToOneWithTarget:self withAction:handler onTopic:topic];
}


-(void)subscribe:(NSString *)topic withBlock:(TopicBlock)topicBlock{
    NSLog(@"%s",__func__);

    [[EGEventBus shared]registManyToOneWithTarget:self withBlock:topicBlock onTopic:topic];
}

-(void)subscribe:(NSString *)topic withResultBlock:(TopicResultBlock)topicResultBlock{
    [[EGEventBus shared]registManyToOneWithTarget:self withResultBlock:topicResultBlock onTopic:topic];
}

-(void)subscribe:(NSString *)topic withAsyncResultBlock:(AsyncCallbackBlock)asyncCallbackBlock{
    [[EGEventBus shared]registManyToOneWithTarget:self withAsyncResultBlock:asyncCallbackBlock onTopic:topic];
}

-(void)post:(NSString *)topic withOptions:(id)options{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[EGEventBus shared]publishTopic:topic withOptions:options];
    });
}

-(void)post:(NSString *)topic options:(id)options withResultHandler:(SEL)resultHandler{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[EGEventBus shared]publishTopic:topic from:self options:options withResultHandler:resultHandler];
    });
}

-(void)post:(NSString *)topic options:(id)options withResultBlock:(void (^)(id))resultBlock{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[EGEventBus shared]publishTopic:topic from:self options:options withResultBlock:resultBlock];
    });
}

-(void)unsubscribeForTopic:(NSString *)topic{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[EGEventBus shared]unmount:self onTopic:topic];
    });
}

-(void)unsubscribeAll{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[EGEventBus shared]unmount:self];
    });
}

-(void)getService:(NSString *)serviceName withOptions:(id)options{
    NSLog(@"%s",__func__);

}


-(void)getService:(NSString *)serviceName options:(id)options callback:(CallResult)callback{
    NSLog(@"%s",__func__);

}

-(void)setEventBusDebug:(BOOL)enable{
    [[EGEventBus shared]setDebug:enable];
}

-(void)debugTopic:(NSString *)topic{
    [[EGEventBus shared]printTopic:topic];
}
@end
