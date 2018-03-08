//
//  EagleTableView.m
//  Eagle
//
//  Created by pantao on 2017/11/7.
//  Copyright © 2017年 pantao. All rights reserved.
//

#import "EGTableView.h"

@implementation EGTableView

#pragma mark - UIView

- (EGTableViewBlock)backgroundColor {
    return (EGTableViewBlock)[super backgroundColor];
}

- (EGTableViewBlock)alpha {
    return (EGTableViewBlock)[super alpha];
}

- (EGTableViewBlock)tintColor {
    return (EGTableViewBlock)[super tintColor];
}

#pragma mark - UITableView

- (EGTableViewBlock)separatorColor {
    return (EGTableViewBlock)[super eagle_colorBlockWithName:NSStringFromSelector(_cmd)];
}

@end

EagleCategoryImplementation(UITableView, EGTableView)
