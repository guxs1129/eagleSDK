//
//  UISwitch+LZSwitch.m
//  试一下ReactiveViewModel
//
//  Created by 潘涛 on 2017/3/9.
//  Copyright © 2017年 潘涛. All rights reserved.
//

#import "UISwitch+EGSwitch.h"
#import <ReactiveObjC/ReactiveObjC.h>

@implementation UISwitch (EGSwitch)

- (void)EGSwitchWithBlock:(void (^)(id x))EGSwitchBlock{
    [[self rac_newOnChannel] subscribeNext:^(id x) {
        EGSwitchBlock(x);
    }];
}

@end
