//
//  UIGestureRecognizer+LZGestureRecognizer.m
//  试一下ReactiveViewModel
//
//  Created by 潘涛 on 2017/3/9.
//  Copyright © 2017年 潘涛. All rights reserved.
//

#import "UIGestureRecognizer+EGGestureRecognizer.h"
#import <ReactiveObjC/ReactiveObjC.h>

@implementation UIGestureRecognizer (EGGestureRecognizer)

- (void)EGGestureRecognizerWithBlock:(void (^)(id x))EGGestureRecognizerBlock{
    [[self rac_gestureSignal] subscribeNext:^(id x) {
        EGGestureRecognizerBlock(x);
    }];
}

@end
