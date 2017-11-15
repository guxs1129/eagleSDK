//
//  EagleTableView.m
//  Eagle
//
//  Created by pantao on 2017/11/7.
//  Copyright © 2017年 pantao. All rights reserved.
//

#import "EagleTableView.h"

@implementation EagleTableView

#pragma mark - UIView

- (EagleTableViewBlock)backgroundColor {
    return (EagleTableViewBlock)[super backgroundColor];
}

- (EagleTableViewBlock)alpha {
    return (EagleTableViewBlock)[super alpha];
}

- (EagleTableViewBlock)tintColor {
    return (EagleTableViewBlock)[super tintColor];
}

#pragma mark - UITableView

- (EagleTableViewBlock)separatorColor {
    return (EagleTableViewBlock)[super eagle_colorBlockWithName:NSStringFromSelector(_cmd)];
}

@end

EagleCategoryImplementation(UITableView, EagleTableView)
