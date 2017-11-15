//
//  EagleTableView.h
//  Eagle
//
//  Created by pantao on 2017/11/7.
//  Copyright © 2017年 pantao. All rights reserved.
//

#import "EagleView.h"

EagleBlockDeclare(EagleTableView)

@interface EagleTableView : EagleView

// UIView
- (EagleTableViewBlock)backgroundColor;
- (EagleTableViewBlock)alpha;
- (EagleTableViewBlock)tintColor;

// UITableView
- (EagleTableViewBlock)separatorColor;

@end

EagleCategoryDeclare(UITableView, EagleTableView)
