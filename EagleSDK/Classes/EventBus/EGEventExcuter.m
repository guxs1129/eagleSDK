    //
    //  EGEventExcuter.m
    //  EGEventBus
    //
    //  Created by 顾新生 on 2017/10/17.
    //  Copyright © 2017年 guxinsheng. All rights reserved.
    //

#import "EGEventExcuter.h"
#import "NSObject+EventBus.h"
@interface EGEventExcuter()
@property(nonatomic,weak)dispatch_queue_t excuteQueue;
@end
@implementation EGEventExcuter
-(instancetype)initWithEvent:(EGEvent *)event withQueue:(dispatch_queue_t)excuteQueue{
    if (self=[super init]) {
        self.event=event;
        self.excuteQueue=excuteQueue;
        if (event.isResultNeed) {
            self.callback = ^(id result) {
                event.callback(result);
            };
        }
    }
    return self;
}
-(void)setEvent:(EGEvent *)event{
    NSMutableArray *tmpArr=[NSMutableArray array];

    for (id subscriber in event.subscribeList) {
        EGEventContext *context=[[EGEventContext alloc]initWithEvent:event];
        
        context.topic=event.topic;
        context.target=subscriber;
        NSMutableArray *selectorList=[event.selectorMap objectForKey:@([subscriber hash])];
        if (selectorList && selectorList.count>0) {
            context.actions=selectorList;
        }
        NSMutableArray *blkList=[event.blkMap objectForKey:@([subscriber hash])];
        if (blkList && blkList.count>0) {
            context.blkList=blkList;
        }
        if (context.event.isResultNeed) {
            if (context.blkList.count+context.actions.count>1) {
                @throw [NSException exceptionWithName:@"<EventBus Error>" reason:[NSString stringWithFormat:@"Too much results return from subscriber (%@) for topic (%@),only one is needed.",NSStringFromClass([subscriber class]),event.topic] userInfo:nil];
            }
        }
        [tmpArr addObject:context];
    }
    self.targetList=[NSArray arrayWithArray:tmpArr];
}

-(void)excute{
    size_t count=self.targetList.count;
    __weak typeof(self) weakSelf=self;
    dispatch_apply(count, self.excuteQueue, ^(size_t i) {
        __strong typeof(self) sSelf=weakSelf;
        NSString *index=[NSString stringWithFormat:@"%zd",i];
        EGEventContext *context=[sSelf.targetList objectAtIndex:[index integerValue]];
        [sSelf runSelectorWithContext:context];
    });
    dispatch_apply(count, self.excuteQueue, ^(size_t i) {
        __strong typeof(self) sSelf=weakSelf;
        NSString *index=[NSString stringWithFormat:@"%zd",i];
        EGEventContext *context=[sSelf.targetList objectAtIndex:[index integerValue]];
        [sSelf runBlockWithContext:context];
    });
}


-(void)runSelectorWithContext:(EGEventContext *)context{
    id target = context.target;
    __weak typeof(self) weakSelf=self;
    size_t count=0;
    if (context.actions) {
        count=context.actions.count;
    }
    dispatch_apply(count, self.excuteQueue, ^(size_t i) {
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
-(void)runBlockWithContext:(EGEventContext *)context{
    __weak typeof(self) weakSelf=self;
    size_t count=context.blkList.count;
    dispatch_apply(count, self.excuteQueue, ^(size_t i) {
        __strong typeof(self) sSelf=weakSelf;
        NSString *index=[NSString stringWithFormat:@"%zd",i];
        if (context.event.isResultNeed) {
            NSDictionary *blkDict=[context.blkList objectAtIndex:[index integerValue]];
            BOOL isAsync=[[blkDict valueForKey:@"isAsync"]boolValue];
            id blk=[blkDict objectForKey:@"block"];
            if (isAsync) {
                AsyncCallbackBlock asyncBlk=(AsyncCallbackBlock)blk;
                if (sSelf.callback) {
                    asyncBlk(sSelf.callback);
                }
            } else {
                TopicResultBlock syncBlk=(TopicResultBlock)blk;
                id result=syncBlk(context.event.options);
                if (sSelf.callback) {
                    sSelf.callback(result);
                }
            }
        }else{
            NSDictionary *blkDict=[context.blkList objectAtIndex:[index integerValue]];
            id blk=[blkDict objectForKey:@"block"];
            if (blk) {
                TopicBlock syncBlk=(TopicBlock)blk;
                syncBlk(context.event.options);
            }
        }
    });
}
@end
