//
//  UIDatePicker+LZDatePicker.m
//  试一下ReactiveViewModel
//
//  Created by 潘涛 on 2017/3/9.
//  Copyright © 2017年 潘涛. All rights reserved.
//

#import "UIDatePicker+EGDatePicker.h"
#import <ReactiveObjC/ReactiveObjC.h>

@implementation UIDatePicker (EGDatePicker)

- (void)EGDatePickerWithNilValue:(NSDate *)nilValue Block:(void (^)(id x))EGDatePickerBlock{
    [[self rac_newDateChannelWithNilValue:nilValue] subscribeNext:^(id x) {
        EGDatePickerBlock(x);
    }];
}

@end
