//
//  EagleTextComponent.m
//  Eagle
//
//  Created by pantao on 2017/11/7.
//  Copyright © 2017年 pantao. All rights reserved.
//

#import "EGTextComponent.h"

@implementation EGTextComponent

#pragma mark - UIView

- (EGTextComponentBlock)backgroundColor {
    return (EGTextComponentBlock)[super backgroundColor];
}

- (EGTextComponentBlock)alpha {
    return (EGTextComponentBlock)[super alpha];
}

- (EGTextComponentBlock)tintColor {
    return (EGTextComponentBlock)[super tintColor];
}

#pragma mark - UITextField + UITextView

- (EGTextComponentBlock)font {
    return (EGTextComponentBlock)[super eagle_fontBlockWithName:NSStringFromSelector(_cmd)];
}

- (EGTextComponentBlock)keyboardAppearance {
    return (EGTextComponentBlock)[super eagle_keyboardAppearanceBlockWithName:NSStringFromSelector(_cmd)];
}

- (EGTextComponentBlock)textColor {
    return (EGTextComponentBlock)[super eagle_colorBlockWithName:NSStringFromSelector(_cmd)];
}

@end

EagleCategoryImplementation(UITextField, EGTextComponent)
EagleCategoryImplementation(UITextView, EGTextComponent)
