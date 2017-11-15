    //
    //  EagleEventExcuter.m
    //  EagleEventBus
    //
    //  Created by 顾新生 on 2017/10/17.
    //  Copyright © 2017年 guxinsheng. All rights reserved.
    //

#import "EagleEventExcuter.h"
#import "NSObject+EventBus.h"
@interface EagleEventExcuter()

@end
@implementation EagleEventExcuter
-(instancetype)initWithEvent:(EagleEvent *)event{
    if (self=[super init]) {
        self.event=event;
        if (event.isResultNeed) {
            self.callback = ^(id result) {
                event.callback(result);
            };
        }
    }
    return self;
}
-(void)setEvent:(EagleEvent *)event{
    NSMutableArray *tmpArr=[NSMutableArray array];

    for (id subscriber in event.subscribeList) {
        EagleEventContext *context=[[EagleEventContext alloc]initWithEvent:event];
        context.topic=event.topic;
        context.target=subscriber;
        NSDictionary *selectorDict=[event.selectorMap objectForKey:@([subscriber hash])];
        if (selectorDict) {
            NSString *key=selectorDict.allKeys.firstObject;
            NSArray *components=[key componentsSeparatedByString:@"\01"];
            if (components.count>1) {
                context.actions=[components.lastObject componentsSeparatedByString:@","];
            }
        }
        context.blkList=[event.blkMap objectForKey:@([context.target hash])];
        [tmpArr addObject:context];
    }
    
    self.targetList=[NSArray arrayWithArray:tmpArr];
}

-(void)excute{
    dispatch_queue_t queue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    size_t count=self.targetList.count;
    __weak typeof(self) weakSelf=self;
    dispatch_apply(count, queue, ^(size_t i) {
        __strong typeof(self) sSelf=weakSelf;
        NSString *index=[NSString stringWithFormat:@"%zd",i];
        EagleEventContext *context=[sSelf.targetList objectAtIndex:[index integerValue]];
        [sSelf runSelectorWithContext:context];
    });
    dispatch_apply(count, queue, ^(size_t i) {
        __strong typeof(self) sSelf=weakSelf;
        NSString *index=[NSString stringWithFormat:@"%zd",i];
        EagleEventContext *context=[sSelf.targetList objectAtIndex:[index integerValue]];
        [sSelf runBlockWithContext:context];
    });
}


-(void)runSelectorWithContext:(EagleEventContext *)context{
    id target = context.target;
    __weak typeof(self) weakSelf=self;
    dispatch_queue_t queue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    size_t count=context.actions.count;
    dispatch_apply(count, queue, ^(size_t i) {
        __strong typeof(self) sSelf=weakSelf;
        NSString *index=[NSString stringWithFormat:@"%zd",i];
        NSString *action=context.actions[[index integerValue]];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        if (sSelf.callback) {
            sSelf.callback([target performSelector:NSSelectorFromString(action) withObject:context.event.options]);
        }else{
            [target performSelector:NSSelectorFromString(action) withObject:context.event.options];
        }
#pragma clang diagnostic pop
    });
}
-(void)runBlockWithContext:(EagleEventContext *)context{
    id target = context.target;
    __weak typeof(self) weakSelf=self;
    dispatch_queue_t queue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    size_t count=context.blkList.count;
    dispatch_apply(count, queue, ^(size_t i) {
        __strong typeof(self) sSelf=weakSelf;
        NSString *index=[NSString stringWithFormat:@"%zd",i];
        if (context.event.isResultNeed) {
            TopicResultBlock blk=(TopicResultBlock)[context.blkList objectAtIndex:[index integerValue]];
            id result=blk(context.event.options);
            if (sSelf.callback) {
                sSelf.callback(result);
            }
        }else{
            TopicBlock blk=(TopicBlock)[context.blkList objectAtIndex:[index integerValue]];
            blk(context.event.options);
        }
    });
}
@end
