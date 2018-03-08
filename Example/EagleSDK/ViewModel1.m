//
//  ViewModel1.m
//  EagleSDK_Example
//
//  Created by pantao on 2017/11/27.
//  Copyright © 2017年 guxs1129@163.com. All rights reserved.
//

#import "ViewModel1.h"

@implementation ViewModel1

- (void)EGViewModelDealUIKit:(id)kit model:(NSObject *)model
{
    [super EGViewModelDealUIKit:kit model:model];
    [kit EGBindUIKit:kit keyPath:@"text" model:model property:@"test1"];
    if ([kit isKindOfClass:[UITextField class]]) {
        [kit EGTextFieldWithBlock:^(id x) {
            NSLog(@"ViewModel1 -- textField.text: %@",x);
        }];
    }
}


@end
