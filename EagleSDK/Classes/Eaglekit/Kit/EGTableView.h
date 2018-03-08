//
//  EagleTableView.h
//  Eagle
//
//  Created by pantao on 2017/11/7.
//  Copyright © 2017年 pantao. All rights reserved.
//

#import "EGView.h"

EagleBlockDeclare(EGTableView)

@interface EGTableView : EGView

// UIView
- (EGTableViewBlock)backgroundColor;
- (EGTableViewBlock)alpha;
- (EGTableViewBlock)tintColor;

// UITableView
- (EGTableViewBlock)separatorColor;

@end

EagleCategoryDeclare(UITableView, EGTableView)
