//
//  Component2.m
//  EagleSDK_Example
//
//  Created by pantao on 2017/11/13.
//  Copyright © 2017年 guxs1129@163.com. All rights reserved.
//

#import "Component2.h"
#import "ViewModel2.h"
#import "Model2.h"

@implementation Component2

- (void)dealloc
{
    EGLog(@"component2's dealloc");
}

- (void)addOnSuperviewComponent
{
    [super addOnSuperviewComponent];
    self.backgroundColor = [UIColor purpleColor];
    
    UITextField *textField = [UITextField new];
    [self addSubview:textField];
    textField.layer.borderColor = [UIColor blackColor].CGColor;
    textField.layer.borderWidth = 1;
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.container);
        make.left.equalTo(self.container).offset(15);
        make.right.equalTo(self.container).offset(-15);
        make.height.equalTo(@30);
    }];
    
    ViewModel2 *viewModel = [ViewModel2 new];
    Model2 *model = [Model2 new];
    [viewModel EGViewModelDealUIKit:textField model:model];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

@end
