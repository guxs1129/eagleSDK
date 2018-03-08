//
//  EGViewModelController.m
//  EagleSDK_Example
//
//  Created by pantao on 2017/11/27.
//  Copyright © 2017年 guxs1129@163.com. All rights reserved.
//

#import "EGViewModelController.h"

@interface EGViewModelController ()
{
    NSArray *arr;
}

@end

@implementation EGViewModelController

mapRoute(@"eagle://vc?");

- (void)viewDidLoad {
    [super viewDidLoad];

    // 搭建组件
    [self buildComponents];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(click)];
}

- (void)click
{
//    EGComponent *cp = (EGComponent *)self.getComponent(arr[0]);
//    cp.size(EGSizeMake(NO, 0.5, 0.3, 200, 100));
}

- (void)buildComponents
{
    arr = self.addComponent(@"Component1", FlexCloum, EGSizeMake(YES, 0.5, 0.3, 200, 150), nil)
        .addComponent(@"Component2", FlexCloum, EGSizeMake(NO, 0.3, 0.2, 150, 150), nil)
        .addComponent(@"Component2", FlexCloum, EGSizeMake(NO, 0.3, 0.2, 150, 150), nil)
        .addComponent(@"Component2", FlexCloum, EGSizeMake(NO, 0.3, 0.2, 150, 150), nil)
        .addComponent(@"Component2", FlexCloum, EGSizeMake(NO, 0.3, 0.2, 150, 150), nil)
        .addComponent(@"Component2", FlexCloum, EGSizeMake(NO, 0.3, 0.2, 150, 150), nil)
        .addComponent(@"Component2", FlexCloum, EGSizeMake(NO, 0.3, 0.2, 150, 150), nil)
        .addComponent(@"Component2", FlexCloum, EGSizeMake(NO, 0.3, 0.2, 150, 150), nil)
        .addComponent(@"Component2", FlexCloum, EGSizeMake(NO, 0.3, 0.2, 150, 150), nil)
        .done();
}



@end
