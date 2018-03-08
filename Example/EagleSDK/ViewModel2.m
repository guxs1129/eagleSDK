//
//  ViewModel2.m
//  EagleSDK_Example
//
//  Created by pantao on 2017/11/27.
//  Copyright © 2017年 guxs1129@163.com. All rights reserved.
//

#import "ViewModel2.h"

@implementation ViewModel2

- (void)EGViewModelDealUIKit:(id)kit model:(NSObject *)model
{
    [super EGViewModelDealUIKit:kit model:model];
    [kit EGBindUIKit:kit keyPath:@"text" model:model property:@"test2"];
    if ([kit isKindOfClass:[UITextField class]]) {
        [kit EGTextFieldWithBlock:^(id x) {
            NSLog(@"ViewModel2 -- textField.text: %@",x);
        }];
    }
}

@end
