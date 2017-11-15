//
//  EagleButton.m
//  Eagle
//
//  Created by pantao on 2017/11/7.
//  Copyright © 2017年 pantao. All rights reserved.
//

#import "EagleButton.h"

@implementation EagleButton

#pragma mark - UIView

- (EagleButtonBlock)backgroundColor {
    return (EagleButtonBlock)[super backgroundColor];
}

- (EagleButtonBlock)alpha {
    return (EagleButtonBlock)[super alpha];
}

- (EagleButtonBlock)tintColor {
    return (EagleButtonBlock)[super tintColor];
}

#pragma mark - UIButton

- (EagleButton2DStateBlock)titleColor {
    return (EagleButton2DStateBlock)[super eagle_titleColorForStateBlockWithName:NSStringFromSelector(_cmd)];
}

- (EagleButton2DStateBlock)image {
    return (EagleButton2DStateBlock)[super eagle_imageForStateBlockWithName:NSStringFromSelector(_cmd)];
}

- (EagleButton2DStateBlock)backgroundImage {
    return (EagleButton2DStateBlock)[super eagle_imageForStateBlockWithName:NSStringFromSelector(_cmd)];
}

@end

EagleCategoryImplementation(UIButton, EagleButton)
