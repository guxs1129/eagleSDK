//
//  EGViewController2.m
//  EagleSDK_Example
//
//  Created by pantao on 2017/11/13.
//  Copyright © 2017年 guxs1129@163.com. All rights reserved.
//

#import "EGViewController2.h"

@interface EGViewController2 ()

@end

@implementation EGViewController2

mapRoute(@"eagle://vc?");

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [EGTabBarManager shared].selectedIndex(3);
    [EGTabBarManager shared].resetItem(@"试一哈", [UIColor redColor], nil, 3, nil, nil);
}

@end

