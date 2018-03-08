//
//  EGEventContext.m
//  EGEventBus
//
//  Created by 顾新生 on 2017/10/17.
//  Copyright © 2017年 guxinsheng. All rights reserved.
//

#import "EGEventContext.h"
@interface EGEventContext()

@end
@implementation EGEventContext
-(instancetype)initWithEvent:(EGEvent *)event{
    if (self=[super init]) {
        self.event=event;
    }
    return self;
}
@end
