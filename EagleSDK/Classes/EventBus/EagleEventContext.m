//
//  EagleEventContext.m
//  EagleEventBus
//
//  Created by 顾新生 on 2017/10/17.
//  Copyright © 2017年 guxinsheng. All rights reserved.
//

#import "EagleEventContext.h"
@interface EagleEventContext()

@end
@implementation EagleEventContext
-(instancetype)initWithEvent:(EagleEvent *)event{
    if (self=[super init]) {
        self.event=event;
    }
    return self;
}
@end
