//
//  EagleEvent.m
//  EagleEventBus
//
//  Created by 顾新生 on 2017/10/17.
//  Copyright © 2017年 guxinsheng. All rights reserved.
//

#import "EagleEvent.h"

@class EagleEventContext;
@interface EagleEvent()
@end
@implementation EagleEvent
-(instancetype)initWithTopic:(NSString *)topic selectorMap:(NSDictionary *)selectorMap blkMap:(NSDictionary *)blkMap options:(id)options{
    if (self=[super init]) {
        self.topic=topic;
        self.selectorMap=selectorMap;
        self.blkMap=blkMap;
        self.isResultNeed=NO;
        [self setValue:options forKey:@"options"];
    }
    return self;
}


-(NSString *)description{
    return [NSString stringWithFormat:@"topic:%@\nselectors:%@\noptions:%@\nblocks:%@",self.topic,self.selectorMap,self.options,self.blkMap];
}
@end
