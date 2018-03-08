//
//  EagleButton.m
//  Eagle
//
//  Created by pantao on 2017/11/7.
//  Copyright © 2017年 pantao. All rights reserved.
//

#import "EGButton.h"

@implementation EGButton

#pragma mark - UIView

- (EGButtonBlock)backgroundColor {
    return (EGButtonBlock)[super backgroundColor];
}

- (EGButtonBlock)alpha {
    return (EGButtonBlock)[super alpha];
}

- (EGButtonBlock)tintColor {
    return (EGButtonBlock)[super tintColor];
}

#pragma mark - UIButton

- (EGButton2DStateBlock)titleColor {
    return (EGButton2DStateBlock)[super eagle_titleColorForStateBlockWithName:NSStringFromSelector(_cmd)];
}

- (EGButton2DStateBlock)image {
    return (EGButton2DStateBlock)[super eagle_imageForStateBlockWithName:NSStringFromSelector(_cmd)];
}

- (EGButton2DStateBlock)backgroundImage {
    return (EGButton2DStateBlock)[super eagle_imageForStateBlockWithName:NSStringFromSelector(_cmd)];
}

@end

EagleCategoryImplementation(UIButton, EGButton)
