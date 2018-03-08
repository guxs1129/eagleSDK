//
//  UIStepper+LZStepper.m
//  试一下ReactiveViewModel
//
//  Created by 潘涛 on 2017/3/9.
//  Copyright © 2017年 潘涛. All rights reserved.
//

#import "UIStepper+EGStepper.h"
#import <ReactiveObjC/ReactiveObjC.h>

@implementation UIStepper (EGStepper)

- (void)EGStepperWithNilValue:(NSNumber *)nilValue Block:(void (^)(id x))EGStepperBlock{
    [[self rac_newValueChannelWithNilValue:nilValue] subscribeNext:^(id x) {
        EGStepperBlock(x);
    }];
}

@end
