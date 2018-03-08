//
//  UIDatePicker+LZDatePicker.h
//  试一下ReactiveViewModel
//
//  Created by 潘涛 on 2017/3/9.
//  Copyright © 2017年 潘涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDatePicker (EGDatePicker)

- (void)EGDatePickerWithNilValue:(NSDate *)nilValue Block:(void (^)(id x))EGDatePickerBlock;

@end
