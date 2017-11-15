//
//  NSObject+EventBus.m
//  EagleEventBus
//
//  Created by 顾新生 on 2017/10/13.
//  Copyright © 2017年 guxinsheng. All rights reserved.
//

#import "NSObject+EventBus.h"
#import "EagleEventBus.h"
@implementation NSObject (EventBus)


-(void)subscribe:(NSString *)topic withHandler:(SEL)handler{
    
    [[EagleEventBus shared]registManyToOneWithTarget:self withAction:handler onTopic:topic];
}


-(void)subscribe:(NSString *)topic withBlock:(TopicBlock)topicBlock{
    NSLog(@"%s",__func__);

    [[EagleEventBus shared]registManyToOneWithTarget:self withBlock:topicBlock onTopic:topic];
}

-(void)subscribe:(NSString *)topic withResultBlock:(TopicResultBlock)topicResultBlock{
    [[EagleEventBus shared]registManyToOneWithTarget:self withResultBlock:topicResultBlock onTopic:topic];
}

-(void)post:(NSString *)topic withOptions:(id)options{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[EagleEventBus shared]publishTopic:topic withOptions:options];
    });
}

-(void)post:(NSString *)topic options:(id)options withResultHandler:(SEL)resultHandler{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[EagleEventBus shared]publishTopic:topic from:self options:options withResultHandler:resultHandler];
    });
}

-(void)post:(NSString *)topic options:(id)options withResultBlock:(void (^)(id))resultBlock{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[EagleEventBus shared]publishTopic:topic from:self options:options withResultBlock:resultBlock];
    });
}

-(void)unsubscribeForTopic:(NSString *)topic{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[EagleEventBus shared]unmount:self onTopic:topic];
    });
}

-(void)unsubscribeAll{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[EagleEventBus shared]unmount:self];
    });
}

-(void)getService:(NSString *)serviceName withOptions:(id)options{
    NSLog(@"%s",__func__);

}


-(void)getService:(NSString *)serviceName options:(id)options callback:(CallResult)callback{
    NSLog(@"%s",__func__);

}


-(void)debug{
    [[EagleEventBus shared]test];
}
-(void)debugTopic:(NSString *)topic{
    [[EagleEventBus shared]printTopic:topic];
}
@end
