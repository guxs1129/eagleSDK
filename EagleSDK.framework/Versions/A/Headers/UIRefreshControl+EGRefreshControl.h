//
//  UIRefreshControl+LZRefreshControl.h
//  试一下ReactiveViewModel
//
//  Created by 潘涛 on 2017/3/9.
//  Copyright © 2017年 潘涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIRefreshControl (EGRefreshControl)

- (void)EGRefreshControlForControlEvents:(UIControlEvents)controlEvents block:(void (^)(id x))EGRefreshControlBlock;

@end
