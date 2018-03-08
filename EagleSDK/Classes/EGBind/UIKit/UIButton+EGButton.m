//
//  UIButton+LZButton.m
//  试一下ReactiveViewModel
//
//  Created by 潘涛 on 2017/3/8.
//  Copyright © 2017年 潘涛. All rights reserved.
//

#import "UIButton+EGButton.h"
#import <objc/runtime.h>
#import <ReactiveObjC/ReactiveObjC.h>

@implementation UIButton (EGButton)

- (void)EGButtonForControlEvents:(UIControlEvents)controlEvents block:(void (^)(id x))EGButtonBlock{
    [[self rac_signalForControlEvents:controlEvents]
     subscribeNext:^(id x) {
         EGButtonBlock(x);
     }];
}


@end
