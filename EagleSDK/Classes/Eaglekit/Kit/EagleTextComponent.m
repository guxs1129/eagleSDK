//
//  EagleTextComponent.m
//  Eagle
//
//  Created by pantao on 2017/11/7.
//  Copyright © 2017年 pantao. All rights reserved.
//

#import "EagleTextComponent.h"

@implementation EagleTextComponent

#pragma mark - UIView

- (EagleTextComponentBlock)backgroundColor {
    return (EagleTextComponentBlock)[super backgroundColor];
}

- (EagleTextComponentBlock)alpha {
    return (EagleTextComponentBlock)[super alpha];
}

- (EagleTextComponentBlock)tintColor {
    return (EagleTextComponentBlock)[super tintColor];
}

#pragma mark - UITextField + UITextView

- (EagleTextComponentBlock)font {
    return (EagleTextComponentBlock)[super eagle_fontBlockWithName:NSStringFromSelector(_cmd)];
}

- (EagleTextComponentBlock)keyboardAppearance {
    return (EagleTextComponentBlock)[super eagle_keyboardAppearanceBlockWithName:NSStringFromSelector(_cmd)];
}

- (EagleTextComponentBlock)textColor {
    return (EagleTextComponentBlock)[super eagle_colorBlockWithName:NSStringFromSelector(_cmd)];
}

@end

EagleCategoryImplementation(UITextField, EagleTextComponent)
EagleCategoryImplementation(UITextView, EagleTextComponent)
