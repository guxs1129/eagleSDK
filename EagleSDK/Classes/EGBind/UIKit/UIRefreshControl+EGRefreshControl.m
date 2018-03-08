//
//  UIRefreshControl+LZRefreshControl.m
//  试一下ReactiveViewModel
//
//  Created by 潘涛 on 2017/3/9.
//  Copyright © 2017年 潘涛. All rights reserved.
//

#import "UIRefreshControl+EGRefreshControl.h"
#import <ReactiveObjC/ReactiveObjC.h>

@implementation UIRefreshControl (EGRefreshControl)

- (void)EGRefreshControlWithInput:(id)input Block:(void (^)(id x))EGRefreshControlBlock{
    [[self.rac_command execute:input] subscribeNext:^(id x) {
        EGRefreshControlBlock(x);
    }];
}

- (void)EGRefreshControlForControlEvents:(UIControlEvents)controlEvents block:(void (^)(id x))EGRefreshControlBlock{
    [[self rac_signalForControlEvents:controlEvents]
     subscribeNext:^(id x) {
         EGRefreshControlBlock(x);
     }];
}

@end
