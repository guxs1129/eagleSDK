    //
    //  EGEventBus.m
    //  EGEventBus
    //
    //  Created by 顾新生 on 2017/10/13.
    //  Copyright © 2017年 guxinsheng. All rights reserved.
    //

#import "EGEventBus.h"
//#import "EGEvent.h"
#import "EGEventExcuter.h"
#import "EGEventDispatcher.h"
@interface EGEventBus()

/**
 事件的响应对象索引Map
 对象的集合使用NSPointerArray，所以维护不是必须的
 */
@property(nonatomic,strong)NSMapTable *busMap;



/**
 事件响应对象的响应Block索引Map
 */
@property(nonatomic,strong)NSMapTable *blkMap;

/**
 事件响应对象的响应入口索引Map
 */
@property(nonatomic,strong)NSMapTable *methodMap;


/**
 事件响应对象的反向索引Map
 */
@property(nonatomic,strong)NSMapTable *invertBusMap;

@property(nonatomic,assign)BOOL enableDebug;


/**
 消息总线的执行队列
 */
@property(nonatomic,strong)NSOperationQueue *eventQueue;

@end

@implementation EGEventBus

+(instancetype)shared{
    static EGEventBus *bus;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bus=[[EGEventBus alloc]init];
        bus.eventQueue=[[NSOperationQueue alloc]init];
        bus.eventQueue.name=@"com.stee.EagleSDK.eventbus";
    });
    return bus;
}

-(void)registManyToOneWithTarget:(id)target withAction:(SEL)action onTopic:(NSString *)topic{
    NSAssert(topic!=nil && ![topic isEqualToString:@""], @"<EventBus Error>:topic required");
    NSAssert(target!=nil, @"<EventBus Error>:regist target required");
    NSOperation *saveTargetOp=[self saveTarget:target forKey:topic];
    NSOperation *saveMethodOp=[self saveMethod:action target:target onTopic:topic];
    [self.eventQueue addOperations:@[saveTargetOp,saveMethodOp] waitUntilFinished:YES];
}

-(void)registManyToOneWithTarget:(id)target withBlock:(TopicBlock)blk onTopic:(NSString *)topic{
    NSAssert(topic!=nil && ![topic isEqualToString:@""], @"<EventBus Error>:topic required");
    NSAssert(target!=nil, @"<EventBus Error>:regist target required");
    NSOperation *saveTargetOp=[self saveTarget:target forKey:topic];
    NSOperation *saveBlkOp=[self saveBlock:blk forTarget:target onTopic:topic async:NO];
    [self.eventQueue addOperations:@[saveTargetOp,saveBlkOp] waitUntilFinished:YES];
}

-(void)registManyToOneWithTarget:(id)target withResultBlock:(TopicResultBlock)blk onTopic:(NSString *)topic{
    NSAssert(topic!=nil && ![topic isEqualToString:@""], @"<EventBus Error>:topic required");
    NSAssert(target!=nil, @"<EventBus Error>:regist target required");
    NSOperation *saveTargetOp=[self saveTarget:target forKey:topic];
    NSOperation *saveBlkOp=[self saveBlock:blk forTarget:target onTopic:topic async:NO];
    [self.eventQueue addOperations:@[saveTargetOp,saveBlkOp] waitUntilFinished:YES];
}

-(void)registManyToOneWithTarget:(id)target withAsyncResultBlock:(AsyncCallbackBlock)blk onTopic:(NSString *)topic{
        //TODO:add async callback
    NSAssert(topic!=nil && ![topic isEqualToString:@""], @"<EventBus Error>:topic required");
    NSAssert(target!=nil, @"<EventBus Error>:regist target required");
    NSOperation *saveTargetOp=[self saveTarget:target forKey:topic];
    NSOperation *saveBlkOp=[self saveBlock:blk forTarget:target onTopic:topic async:YES];
    [self.eventQueue addOperations:@[saveTargetOp,saveBlkOp] waitUntilFinished:YES];

}

-(void)publishTopic:(NSString *)topic withOptions:(id)options{
    [self.eventQueue addOperation:[NSBlockOperation blockOperationWithBlock:^{
        EGEvent *event=[self publishTopic:topic withOptions:options needResult:NO];
        if (event) {
            [[EGEventDispatcher shareInstance] dispatchEvent:event];
        }
    }]];
}


-(void)publishTopic:(NSString *)topic from:(id)eventSource options:(id)options withResultHandler:(SEL)resultHandler{
    NSOperation *op=[self publishTopic:topic from:eventSource options:options withResultHandler:resultHandler withResultBlock:nil];
    [self.eventQueue addOperation:op];
}

-(void)publishTopic:(NSString *)topic from:(id)eventSource options:(id)options withResultBlock:(void (^)(id))resultBlock{
    NSOperation *op=[self publishTopic:topic from:eventSource options:options withResultHandler:nil withResultBlock:resultBlock];
    [self.eventQueue addOperation:op];
}

-(void)unmount:(id)target onTopic:(NSString *)topic{
    
        //清理方法和block索引Map
    id key=target;
    NSMutableDictionary *topicMethodDict=[self.methodMap objectForKey:key];
    if (topicMethodDict) {
        [topicMethodDict removeObjectForKey:topic];
        [self.methodMap setObject:topicMethodDict forKey:key];
    }
    NSMutableDictionary *topicBlkDict=[self.blkMap objectForKey:key];
    if (topicBlkDict) {
        [topicBlkDict removeObjectForKey:topic];
        [self.blkMap setObject:topicMethodDict forKey:key];
    }
        //    清理反向索引
    NSMutableArray *topicList=[self.invertBusMap objectForKey:key];
    if (topicList) {
        [topicList removeObject:topic];
        [self.invertBusMap setObject:topicList forKey:key];
    }
    
    [self compactBusMap];

}

-(void)unmount:(id)target{
    
    NSArray *topicList=[self topicListForTarget:target];
    if (topicList) {
            //清理方法和block索引Map
        [self.methodMap removeObjectForKey:target];
        [self.blkMap removeObjectForKey:target];
    }
    [self clearInvertBusMap:target];
    [self compactBusMap];

}

- (void)compactBusMap {
    NSEnumerator<NSString *> *enumerator=self.busMap.objectEnumerator;
    NSString *key=nil;
    while ((key=enumerator.nextObject)!=nil) {
        NSPointerArray *arr=[self.busMap objectForKey:key];
        [arr compact];
        [self.busMap setObject:arr forKey:key];
    }
}
-(void)clearInvertBusMap:(id)target{
    id key=target;
    [self.invertBusMap removeObjectForKey:key];
}

#pragma mark ---------------lazy property---------------

-(NSMapTable *)busMap{
    if (_busMap==nil) {
        _busMap=[NSMapTable weakToStrongObjectsMapTable];
    }
    return _busMap;
}

-(NSMapTable *)blkMap{
    if (_blkMap==nil) {
        _blkMap=[NSMapTable weakToStrongObjectsMapTable];
    }
    return _blkMap;
}
-(NSMapTable *)methodMap{
    if (_methodMap==nil) {
        _methodMap=[NSMapTable weakToStrongObjectsMapTable];
    }
    return _methodMap;
}

-(NSMapTable *)invertBusMap{
    if (_invertBusMap==nil) {
        _invertBusMap=[NSMapTable weakToStrongObjectsMapTable];
    }
    return _invertBusMap;
}

#pragma mark ----------------private-----------------
#pragma mark ----------------event flow-----------------
-(EGEvent *)publishTopic:(NSString *)topic withOptions:(id)options needResult:(BOOL)needResult{
    NSAssert(topic!=nil && ![topic isEqualToString:@""], @"<EventBus Error>:topic required");
    if (self.enableDebug) {
        [self test];
    }
    NSPointerArray *targetList=[self.busMap objectForKey:topic];
    if (targetList==nil) {
        return nil;
    }
    NSDictionary *selectorDict=[self getMethodListWithTopic:topic targetList:targetList.allObjects];
    NSDictionary *topicBlkDict=[self getBlkWithTopic:topic targetList:targetList.allObjects];// all excuters with itself blocks
    if (selectorDict.allValues.count==0 && topicBlkDict.allValues.count==0) {
//        @throw [NSError errorWithDomain:@"<EventBus Error>" code:999 userInfo:@{@"topic":topic,@"info":@"no actions for topic"}];
        NSLog(@"<EventBus Info>:No actions for topic [%@]",topic);
        return nil;
    }
    if (needResult && (selectorDict.allValues.count+topicBlkDict.allValues.count)>1) {
        NSString *reason=[NSString stringWithFormat:@"Too much actions for topic<%@>,only one is allowed for result callback.",topic];
        @throw [NSException exceptionWithName:@"<Event Bus Exception>" reason:reason userInfo:@{@"topic":topic}];
    }
    
    EGEvent *event=[[EGEvent alloc]initWithTopic:topic selectorMap:selectorDict blkMap:topicBlkDict options:options];
    event.subscribeList=targetList.allObjects;
    event.isResultNeed=needResult;
    return event;
}

-(NSOperation *)publishTopic:(NSString *)topic from:(id)eventSource options:(id)options withResultHandler:(SEL)resultHandler withResultBlock:(void (^)(id))resultBlock{
    @eg_weakify(self)
    return [NSBlockOperation blockOperationWithBlock:^{
        @eg_strongify(self)
        NSAssert(topic!=nil && ![topic isEqualToString:@""], @"<EventBus Error>:topic required");
        NSPointerArray *targetList=[self.busMap objectForKey:topic];
        if (targetList==nil) {
            NSLog(@"<Event Bus Info>:No subscriber for topic %@",topic);
            return;
        }else if (targetList.allObjects.count>1){
            NSString *reason=[NSString stringWithFormat:@"Too many subscribers for topic<%@>,only one is allowed.",topic];
            @throw [NSException exceptionWithName:@"<Event Bus Exception>" reason:reason userInfo:@{@"topic":topic,@"from":eventSource}];
        }else{
            EGEvent *event=[self publishTopic:topic withOptions:options needResult:YES];
            event.callback = ^(id result) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                if (resultHandler) {
                    [eventSource performSelector:resultHandler withObject:result];
                }
#pragma clang diagnostic pop
                if (resultBlock) {
                    resultBlock(result);
                }
            };
            [[EGEventDispatcher shareInstance] dispatchEvent:event];
        }
    }];
}



#pragma mark ----------------target index-----------------
-(NSOperation *)saveTarget:(id)target forKey:(NSString *)key{
    @eg_weakify(self)
    return [NSBlockOperation blockOperationWithBlock:^{
        @eg_strongify(self)
        NSPointerArray *targetList=[self.busMap objectForKey:key];
        if (targetList==nil) {
            targetList=[NSPointerArray weakObjectsPointerArray];
        }
        if (![targetList.allObjects containsObject:target]) {
            [targetList addPointer:(__bridge void *)target];
        }
        [self.busMap setObject:targetList forKey:key];
        [self updateInvertIndexWithTarget:target topic:key flag:YES];
    }];
}

#pragma mark ---------------method index---------------

-(NSOperation *)saveMethod:(SEL)action target:(id)target onTopic:(NSString *)topic{
    @eg_weakify(self)
    return [NSBlockOperation blockOperationWithBlock:^{
        @eg_strongify(self)
        if (![target respondsToSelector:action]) {
            NSString *reason=[NSString stringWithFormat:@"Unrecognized Action[%@] regist to target <%@>",NSStringFromSelector(action),target];
            @throw [NSException exceptionWithName:@"<Event Bus Error>" reason:reason userInfo:@{@"class":[target class]}];
        }
        
        id key=target;
        NSMutableDictionary *topicDict=[self.methodMap objectForKey:key];
        if (topicDict==nil) {
            topicDict=[NSMutableDictionary dictionary];
        }
        NSMutableArray *topicDictMethodArr=[topicDict objectForKey:topic];
        if (topicDictMethodArr==nil) {
            topicDictMethodArr=[NSMutableArray array];
        }
        NSString *selector=NSStringFromSelector(action);
        if (![topicDictMethodArr containsObject:selector]) {
            [topicDictMethodArr addObject:selector];
        }else{
            NSString *reason=[NSString stringWithFormat:@"<%@> regist Action[%@] which is already exist",[target class],NSStringFromSelector(action)];
            @throw [NSException exceptionWithName:@"<Event Bus Error>" reason:reason userInfo:@{@"class":[target class],@"info":@"regist action already exist"}];
        }
        [topicDict setObject:topicDictMethodArr forKey:topic];
        [self.methodMap setObject:topicDict forKey:target];
    }];
    
}

-(NSDictionary *)getMethodListWithTopic:(NSString *)topic targetList:(NSArray *)targetList{
    NSMutableDictionary *tmpDict=[NSMutableDictionary dictionary];
    for (id target in targetList) {
        id key=target;
        NSMutableDictionary *topicDict=[self.methodMap objectForKey:key];
        if (topicDict) {
            NSMutableArray *topicDictMethodArr=[topicDict objectForKey:topic];
            if (topicDictMethodArr) {
                [tmpDict setObject:topicDictMethodArr forKey:@([target hash])];
            }
        }
    }
    return [NSDictionary dictionaryWithDictionary:tmpDict];
}
#pragma mark ---------------block index---------------

-(NSOperation *)saveBlock:(id)blk forTarget:(id)target onTopic:(NSString *)topic async:(BOOL)isAsync{
    @eg_weakify(self)
    return [NSBlockOperation blockOperationWithBlock:^{
        @eg_strongify(self)
        
        id key=target;
        NSMutableDictionary *topicDict=[self.blkMap objectForKey:key];
        if (topicDict==nil) {
            topicDict=[NSMutableDictionary dictionary];
        }
        NSMutableArray *topicDictBlkArr=[topicDict objectForKey:topic];
        if (topicDictBlkArr==nil) {
            topicDictBlkArr=[NSMutableArray array];
        }
        NSDictionary *blkDict=@{@"block":blk,@"isAsync":@(isAsync)};
        [topicDictBlkArr addObject:blkDict];
        [topicDict setObject:topicDictBlkArr forKey:topic];
        [self.blkMap setObject:topicDict forKey:target];
    }];
    
}

-(NSDictionary *)getBlkWithTopic:(NSString *)topic targetList:(NSArray *)targetList{
    NSMutableDictionary *tmpDict=[NSMutableDictionary dictionary];
    for (id target in targetList) {
        id key=target;
        NSMutableDictionary *topicDict=[self.blkMap objectForKey:key];
        if (topicDict) {
            NSMutableArray *topicDictBlkArr=[topicDict objectForKey:topic];
            if (topicDictBlkArr) {
                [tmpDict setObject:topicDictBlkArr forKey:@([target hash])];
            }
        }
    }
    return [NSDictionary dictionaryWithDictionary:tmpDict];
}


#pragma mark ---------------invert index map---------------
/**
 维护反向索引表
 
 @param target 事件响应对象
 @param topic 事件主题
 @param add YES：增加，NO：删除
 */
-(void)updateInvertIndexWithTarget:(id)target topic:(NSString *)topic flag:(BOOL)add{
    id key=target;
    NSMutableArray *topicList=[self.invertBusMap objectForKey:key];
    if (topicList==nil) {
        topicList=[NSMutableArray array];
    }
    if (add) {
        if (![topicList containsObject:topic]) {
            [topicList addObject:topic];
        }
    }else{
        if ([topicList containsObject:topic]) {
            [topicList removeObject:topic];
        }
    }
    [self.invertBusMap setObject:topicList forKey:key];
}

/**
 反向索引表查询
 
 @param target 事件响应对象
 @return 对象所支持的所有事件主题
 */
-(NSArray *)topicListForTarget:(id)target{
    id key=target;
    NSMutableArray *topicList=[self.invertBusMap objectForKey:key];
    if (topicList==nil) {
        return nil;
    }
    return [NSArray arrayWithArray:topicList];
}

#pragma mark ----------------debug-----------------
-(void)setDebug:(BOOL)debug{
    self.enableDebug=debug;
}
-(void)test{
    NSLog(@"<Bus Load>:%@",self.invertBusMap);
    NSLog(@"<Bus Load Entry>:%@",self.methodMap);
    NSLog(@"<Bus Load Blk>:%@",self.blkMap);
    
}
-(void)printTopic:(NSString *)topic{
    NSPointerArray *arr=[[self.busMap dictionaryRepresentation]objectForKey:topic];
    NSLog(@"event bus test");
    NSLog(@"<Bus Index>:%@",arr.allObjects);
    NSLog(@"<Bus Method Index>:%@",self.methodMap);
    NSLog(@"<Bus Block Index>:%@",self.blkMap);
}
@end
