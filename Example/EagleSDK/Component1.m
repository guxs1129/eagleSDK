//
//  Component1.m
//  EagleSDK_Example
//
//  Created by pantao on 2017/11/13.
//  Copyright © 2017年 guxs1129@163.com. All rights reserved.
//

#import "Component1.h"
#import "ViewModel1.h"
#import "Model1.h"

@implementation Component1

- (void)dealloc
{
    EGLog(@"component1's dealloc");
}

- (void)addOnSuperviewComponent
{
    [super addOnSuperviewComponent];
    self.backgroundColor = [UIColor brownColor];
    
    self.size(EGSizeMake(NO, 0, 0, 200, 400));
    
    UITextField *textField = [UITextField new];
    [self addSubview:textField];
    textField.layer.borderColor = [UIColor blackColor].CGColor;
    textField.layer.borderWidth = 1;
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.container);
//        make.left.equalTo(self.container).offset(15);
//        make.right.equalTo(self.container).offset(-15);
        make.width.equalTo(@120);
        make.height.equalTo(@30);
    }];
    
    ViewModel1 *viewModel = [ViewModel1 new];
    Model1 *model = [Model1 new];
    [viewModel EGViewModelDealUIKit:textField model:model];
    
//    self.addComponent(@"Component2", FlexCloum, EGSizeMake(YES, 0.5, 0.3, 200, 150), nil)
//    .addComponent(@"Component2", FlexCloum, EGSizeMake(YES, 0.5, 0.3, 200, 150), nil)
//    .addComponent(@"Component2", FlexCloum, EGSizeMake(YES, 0.5, 0.3, 200, 150), nil)
//    .addComponent(@"Component2", FlexCloum, EGSizeMake(YES, 0.5, 0.3, 200, 150), nil)
//    .addComponent(@"Component2", FlexCloum, EGSizeMake(YES, 0.5, 0.3, 200, 150), nil)
//    .addComponent(@"Component2", FlexCloum, EGSizeMake(YES, 0.5, 0.3, 200, 150), nil)
//    .addComponent(@"Component2", FlexCloum, EGSizeMake(YES, 0.5, 0.3, 200, 150), nil).done();
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

@end
