//
//  UITableViewCell+LZTableViewCell.h
//  试一下ReactiveViewModel
//
//  Created by 潘涛 on 2017/3/9.
//  Copyright © 2017年 潘涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (EGTableViewCell)

- (void)EGTableViewCellWithBlock:(void (^)(id x))EGTableViewCellBlock;

@end
