//
//  UIButton+LZButton.h
//  试一下ReactiveViewModel
//
//  Created by 潘涛 on 2017/3/8.
//  Copyright © 2017年 潘涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (EGButton)

- (void)EGButtonForControlEvents:(UIControlEvents)controlEvents block:(void (^)(id x))EGButtonBlock;

@end
