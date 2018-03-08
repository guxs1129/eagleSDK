//
//  UITextField+LZTextField.m
//  试一下ReactiveViewModel
//
//  Created by 潘涛 on 2017/3/8.
//  Copyright © 2017年 潘涛. All rights reserved.
//

#import "UITextField+EGTextField.h"
#import <ReactiveObjC/ReactiveObjC.h>

@implementation UITextField (EGTextField)

- (void)EGTextFieldWithBlock:(void (^)(id x))EGTextFieldBlock{
    //    @weakify(self);
    [self.rac_textSignal subscribeNext:^(id x) {
        //        @strongify(self);
        EGTextFieldBlock(x);
    }];
}

@end
