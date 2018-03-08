//
//  UITableViewCell+LZTableViewCell.m
//  试一下ReactiveViewModel
//
//  Created by 潘涛 on 2017/3/9.
//  Copyright © 2017年 潘涛. All rights reserved.
//

#import "UITableViewCell+EGTableViewCell.h"
#import <ReactiveObjC/ReactiveObjC.h>

@implementation UITableViewCell (EGTableViewCell)

- (void)EGTableViewCellWithBlock:(void (^)(id x))EGTableViewCellBlock{
    [[self rac_prepareForReuseSignal] subscribeNext:^(id x) {
        EGTableViewCellBlock(x);
    }];
}

@end
