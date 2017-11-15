//
//  EagleEventExcuter.h
//  EagleEventBus
//
//  Created by 顾新生 on 2017/10/17.
//  Copyright © 2017年 guxinsheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EagleEvent.h"
#import "EagleEventContext.h"
#import "NSObject+EventBus.h"
@interface EagleEventExcuter : NSObject
@property(nonatomic,strong)EagleEvent *event;
@property(nonatomic,strong)NSArray *targetList;
@property(nonatomic,copy)CallResult callback;
-(instancetype)initWithEvent:(EagleEvent *)event;
-(void)excute;
@end
