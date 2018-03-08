//
//  UISegmentedControl+LZSegmentedControl.m
//  试一下ReactiveViewModel
//
//  Created by 潘涛 on 2017/3/9.
//  Copyright © 2017年 潘涛. All rights reserved.
//

#import "UISegmentedControl+EGSegmentedControl.h"
#import <ReactiveObjC/ReactiveObjC.h>

@implementation UISegmentedControl (EGSegmentedControl)

- (void)EGSegmentedControlWithNilValue:(NSNumber *)nilValue Block:(void (^)(id x))EGSegmentedControlBlock{
    [[self rac_newSelectedSegmentIndexChannelWithNilValue:nilValue] subscribeNext:^(id x) {
        EGSegmentedControlBlock(x);
    }];
}

@end
