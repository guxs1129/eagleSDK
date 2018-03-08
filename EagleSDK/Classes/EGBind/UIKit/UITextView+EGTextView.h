//
//  UITextView+LZTextView.h
//  试一下ReactiveViewModel
//
//  Created by 潘涛 on 2017/3/8.
//  Copyright © 2017年 潘涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (EGTextView)

- (void)EGTextViewWithBlock:(void (^)(id x))EGTextViewBlock;

@end
