    //
    //  EagleEventBus.m
    //  EagleEventBus
    //
    //  Created by 顾新生 on 2017/10/13.
    //  Copyright © 2017年 guxinsheng. All rights reserved.
    //

#import "EagleEventBus.h"
//#import "EagleEvent.h"
#import "EagleEventExcuter.h"
@interface EagleEventBus()
/**
 事件响应对象的响应入口索引Map
 */
@property(nonatomic,strong)NSMutableDictionary *methodDict;


/**
 事件响应对象的响应Block索引Map
 */
@property(nonatomic,strong)NSMutableDictionary *blkDict;

/**
 事件的响应对象索引Map
 对象的集合使用NSPointerArray，所以维护不是必须的
 */
@property(nonatomic,strong)NSMapTable *busMap;

@property(nonatomic,strong)NSMutableDictionary *invertBusMap;



@end

@implementation EagleEventBus

+(instancetype)shared{
    static EagleEventBus *bus;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bus=[[EagleEventBus alloc]init];
    });
    return bus;
}

-(void)registManyToOneWithTarget:(id)target withAction:(SEL)action onTopic:(NSString *)topic{
    NSAssert(topic!=nil && ![topic isEqualToString:@""], @"<EventBus Error>:topic required");
    NSAssert(target!=nil, @"<EventBus Error>:regist target required");
    [self saveTarget:target forKey:topic];
    [self saveMethod:action target:target onTopic:topic];
}

-(void)registManyToOneWithTarget:(id)target withBlock:(TopicBlock)blk onTopic:(NSString *)topic{
    NSAssert(topic!=nil && ![topic isEqualToString:@""], @"<EventBus Error>:topic required");
    NSAssert(target!=nil, @"<EventBus Error>:regist target required");
    [self saveTarget:target forKey:topic];
    [self saveBlock:blk forTarget:target onTopic:topic];
}

-(void)registManyToOneWithTarget:(id)target withResultBlock:(TopicResultBlock)blk onTopic:(NSString *)topic{
    NSAssert(topic!=nil && ![topic isEqualToString:@""], @"<EventBus Error>:topic required");
    NSAssert(target!=nil, @"<EventBus Error>:regist target required");
    [self saveTarget:target forKey:topic];
    [self saveBlock:blk forTarget:target onTopic:topic];
}


-(void)publishTopic:(NSString *)topic withOptions:(id)options{
    EagleEvent *event=[self publishTopic:topic withOptions:options needResult:NO];
    [self dispatchEvent:event];
}


-(void)publishTopic:(NSString *)topic from:(id)eventSource options:(id)options withResultHandler:(SEL)resultHandler{
    [self publishTopic:topic from:eventSource options:options withResultHandler:resultHandler withResultBlock:nil];
}

-(void)publishTopic:(NSString *)topic from:(id)eventSource options:(id)options withResultBlock:(void (^)(id))resultBlock{
    [self publishTopic:topic from:eventSource options:options withResultHandler:nil withResultBlock:resultBlock];
}

-(void)unmount:(id)target onTopic:(NSString *)topic{
    [self compactBusMap];
        //清理方法和block索引Map
    NSString *methodKey=[NSString stringWithFormat:@"%@@%lu",topic,(unsigned long)[target hash]];
    [self.methodDict removeObjectForKey:methodKey];

    NSMutableDictionary *subDict=[self.blkDict objectForKey:topic];
    if (subDict) {
        [subDict removeObjectForKey:@([target hash])];
        if (subDict.allValues.count==0) {
            [self.blkDict removeObjectForKey:topic];
        } else {
            [self.blkDict setObject:subDict forKey:topic];
        }
    }
        //对象没有相关主题时清空该对象
    NSArray *topicList=[self topicListForTarget:target];
    if (!topicList || topicList.count==0) {
        [self.invertBusMap removeObjectForKey:@([target hash])];
    }
    
    [self clearInvertBusMap:target];

}



-(void)unmount:(id)target{
    [self compactBusMap];
    
    NSArray *topicList=[self topicListForTarget:target];
    if (topicList) {
        for (NSString *topic in topicList) {
            
                //清理方法和block索引Map
            NSString *methodKey=[NSString stringWithFormat:@"%@@%lu",topic,(unsigned long)[target hash]];
            [self.methodDict removeObjectForKey:methodKey];
            
            NSMutableDictionary *subDict=[self.blkDict objectForKey:topic];
            if (subDict) {
                [subDict removeObjectForKey:@([target hash])];
                if (subDict.allValues.count==0) {
                    [self.blkDict removeObjectForKey:topic];
                } else {
                    [self.blkDict setObject:subDict forKey:topic];
                }
            }
        }
    }
    [self clearInvertBusMap:target];
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
    id key=@([target hash]);
    [self.invertBusMap removeObjectForKey:key];
}
#pragma mark ---------------lazy property---------------

-(NSMutableDictionary *)methodDict{
    if (_methodDict==nil) {
        _methodDict=[NSMutableDictionary dictionary];
    }
    return _methodDict;
}
-(NSMutableDictionary *)blkDict{
    if (_blkDict==nil) {
        _blkDict=[NSMutableDictionary dictionary];
    }
    return _blkDict;
}

-(NSMapTable *)busMap{
    if (_busMap==nil) {
        _busMap=[NSMapTable weakToStrongObjectsMapTable];
    }
    return _busMap;
}

-(NSMutableDictionary *)invertBusMap{
    if (_invertBusMap==nil) {
        _invertBusMap=[NSMutableDictionary dictionary];
    }
    return _invertBusMap;
}

#pragma mark ----------------private-----------------
-(EagleEvent *)publishTopic:(NSString *)topic withOptions:(id)options needResult:(BOOL)needResult{
    NSAssert(topic!=nil && ![topic isEqualToString:@""], @"<EventBus Error>:topic required");
    
    NSPointerArray *targetList=[self.busMap objectForKey:topic];
    if (targetList==nil) {
        return nil;
    }
    NSDictionary *selectorDict=[self getMethodListWithTopic:topic targetList:targetList.allObjects];
    NSDictionary *topicBlkDict=[self getBlkWithTopic:topic];// all excuters with itself blocks
    if (selectorDict.allValues.count==0 && topicBlkDict.allValues.count==0) {
        @throw [NSError errorWithDomain:@"<EventBus Error>" code:999 userInfo:@{@"topic":topic,@"info":@"no actions for topic"}];
    }
    if (needResult && selectorDict.allValues.count>0 && topicBlkDict.allValues.count>0) {
        NSString *reason=[NSString stringWithFormat:@"Too much actions for topic<%@>,only one is allowed for result callback.",topic];
        @throw [NSException exceptionWithName:@"<Event Bus Exception>" reason:reason userInfo:@{@"topic":topic}];
    }
    
    EagleEvent *event=[[EagleEvent alloc]initWithTopic:topic selectorMap:selectorDict blkMap:topicBlkDict options:options];
    event.subscribeList=targetList.allObjects;
    event.isResultNeed=needResult;
    return event;
}

-(void)publishTopic:(NSString *)topic from:(id)eventSource options:(id)options withResultHandler:(SEL)resultHandler withResultBlock:(void (^)(id))resultBlock{
    NSAssert(topic!=nil && ![topic isEqualToString:@""], @"<EventBus Error>:topic required");
    NSPointerArray *targetList=[self.busMap objectForKey:topic];
    if (targetList==nil) {
        NSLog(@"<Event Bus Info>:No subscriber for topic %@",topic);
        return;
    }else if (targetList.allObjects.count>1){
        NSString *reason=[NSString stringWithFormat:@"Too many subscribers for topic<%@>,only one is allowed.",topic];
        @throw [NSException exceptionWithName:@"<Event Bus Exception>" reason:reason userInfo:@{@"topic":topic,@"from":eventSource}];
    }else{
        EagleEvent *event=[self publishTopic:topic withOptions:options needResult:YES];
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
        [self dispatchEvent:event];
    }
}

-(void)dispatchEvent:(EagleEvent *)event{
        //    NSLog(@"%@",event);
    EagleEventExcuter *excuter=[[EagleEventExcuter alloc]initWithEvent:event];
    [excuter excute];
}

-(void)saveTarget:(id)target forKey:(NSString *)key{
    
    NSPointerArray *targetList=[self.busMap objectForKey:key];
    if (targetList==nil) {
        targetList=[NSPointerArray weakObjectsPointerArray];
    }
    if (![targetList.allObjects containsObject:target]) {
        [targetList addPointer:(__bridge void *)target];
    }
    [self.busMap setObject:targetList forKey:key];
    [self updateInvertIndexWithTarget:target topic:key flag:YES];
}

#pragma mark ---------------method index---------------

-(void)saveMethod:(SEL)action target:(id)target onTopic:(NSString *)topic{
    
    if (![target respondsToSelector:action]) {
        NSString *reason=[NSString stringWithFormat:@"Unrecognized Action[%@] regist to target <%@>",NSStringFromSelector(action),target];
        @throw [NSException exceptionWithName:@"<Event Bus Error>" reason:reason userInfo:@{@"class":[target class]}];
    }
    NSString *key=[NSString stringWithFormat:@"%@@%lu",topic,(unsigned long)[target hash]];
    NSMutableArray *methodArr=[self.methodDict objectForKey:key];
    if (methodArr==nil) {
        methodArr=[NSMutableArray array];
    }
    NSString *selector=NSStringFromSelector(action);
    if (![methodArr containsObject:selector]) {
        [methodArr addObject:selector];
    }else{
        NSString *reason=[NSString stringWithFormat:@"<%@> regist Action[%@] which is already exist",[target class],NSStringFromSelector(action)];
        @throw [NSException exceptionWithName:@"<Event Bus Error>" reason:reason userInfo:@{@"class":[target class],@"info":@"regist action already exist"}];
    }
    [self.methodDict setObject:methodArr forKey:key];
    
}

-(NSDictionary *)getMethodListWithTopic:(NSString *)topic targetList:(NSArray *)targetList{
    NSMutableDictionary *tmpDict=[NSMutableDictionary dictionary];
    for (id target in targetList) {
        NSString *key=[NSString stringWithFormat:@"%@@%lu",topic,(unsigned long)[target hash]];
        NSMutableArray *selectorList=[self.methodDict objectForKey:key];
        if (selectorList) {
            NSString *selectorStr=[selectorList componentsJoinedByString:@","];
            NSString *eventKey=[NSString stringWithFormat:@"%lu\01%@",(unsigned long)[target hash],selectorStr];
            NSDictionary *dict=@{eventKey:target};
            [tmpDict setObject:dict forKey:@([target hash])];
        }
    }
    return [NSDictionary dictionaryWithDictionary:tmpDict];
}
#pragma mark ---------------block index---------------

-(void)saveBlock:(id)blk forTarget:(id)target onTopic:(NSString *)topic{
    
    NSString *key=[NSString stringWithFormat:@"%@",topic];
    NSMutableDictionary *topicSubDict=[self.blkDict objectForKey:key];
    if (topicSubDict==nil) {
        topicSubDict=[NSMutableDictionary dictionary];
    }
    NSMutableArray *targetsubArr=[topicSubDict objectForKey:@([target hash])];
    if (targetsubArr==nil) {
        targetsubArr=[NSMutableArray array];
    }
    if (![targetsubArr containsObject:blk]) {
        [targetsubArr addObject:blk];
    }else{
        NSString *reason=[NSString stringWithFormat:@"<%@> regist Block which is already exist",[target class]];
        @throw [NSException exceptionWithName:@"<Event Bus Error>" reason:reason userInfo:@{@"class":[target class],@"info":@"regist action already exist"}];
    }
    [topicSubDict setObject:targetsubArr forKey:@([target hash])];
    [self.blkDict setObject:topicSubDict forKey:key];
}





-(NSDictionary *)getBlkWithTopic:(NSString *)topic{
    NSMutableDictionary *topicSubDict=[self.blkDict objectForKey:topic];
    return [NSDictionary dictionaryWithDictionary:topicSubDict];
}


#pragma mark ---------------invert index map---------------
/**
 维护反向索引表
 
 @param target 事件响应对象
 @param topic 事件主题
 @param add YES：增加，NO：删除
 */
-(void)updateInvertIndexWithTarget:(id)target topic:(NSString *)topic flag:(BOOL)add{
    id key=@([target hash]);
    NSMutableArray *topicList=[self.invertBusMap objectForKey:key];
    if (topicList==nil) {
        topicList=[NSMutableArray array];
    }
    if (add) {
        [topicList addObject:topic];
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
    id key=@([target hash]);
    NSMutableArray *topicList=[self.invertBusMap objectForKey:key];
    if (topicList==nil) {
        return nil;
    }
    return [NSArray arrayWithArray:topicList];
}

#pragma mark ----------------debug-----------------
-(void)test{
    NSPointerArray *arr=[[self.busMap dictionaryRepresentation]objectForKey:@"test"];
    NSLog(@"event bus test");
    NSLog(@"<Bus Load>:%@",arr.allObjects);
    NSLog(@"<Bus Load Entry>:%@",self.methodDict);
    NSLog(@"<Bus Load Blk>:%@",self.blkDict);
    
}
-(void)printTopic:(NSString *)topic{
    NSPointerArray *arr=[[self.busMap dictionaryRepresentation]objectForKey:topic];
    NSLog(@"event bus test");
    NSLog(@"<Bus Index>:%@",arr.allObjects);
    NSLog(@"<Bus Method Index>:%@",self.methodDict);
    NSLog(@"<Bus Block Index>:%@",self.blkDict);
}
@end
