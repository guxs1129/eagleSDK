//
//  UISlider+LZSlider.m
//  试一下ReactiveViewModel
//
//  Created by 潘涛 on 2017/3/9.
//  Copyright © 2017年 潘涛. All rights reserved.
//

#import "UISlider+EGSlider.h"
#import <ReactiveObjC/ReactiveObjC.h>

@implementation UISlider (EGSlider)

- (void)EGSliderWithNilValue:(NSNumber *)nilValue Block:(void (^)(id x))EGSliderBlock{
    [[self rac_newValueChannelWithNilValue:nilValue] subscribeNext:^(id x) {
        EGSliderBlock(x);
    }];
}

@end
