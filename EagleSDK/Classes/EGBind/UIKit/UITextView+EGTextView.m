//
//  UITextView+LZTextView.m
//  试一下ReactiveViewModel
//
//  Created by 潘涛 on 2017/3/8.
//  Copyright © 2017年 潘涛. All rights reserved.
//

#import "UITextView+EGTextView.h"
#import <ReactiveObjC/ReactiveObjC.h>

@implementation UITextView (EGTextView)

- (void)EGTextViewWithBlock:(void (^)(id x))EGTextViewBlock{
    [self.rac_textSignal subscribeNext:^(id x) {
        //        @strongify(self);
        EGTextViewBlock(x);
    }];
}

@end
