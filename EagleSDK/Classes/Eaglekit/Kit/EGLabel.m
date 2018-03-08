//
//  EagleLabel.m
//  Eagle
//
//  Created by pantao on 2017/11/7.
//  Copyright © 2017年 pantao. All rights reserved.
//

#import "EGLabel.h"

@implementation EGLabel

- (EGLabelBlock)backgroundColor {
    return (EGLabelBlock)[super backgroundColor];
}

- (EGLabelBlock)alpha {
    return (EGLabelBlock)[super alpha];
}

- (EGLabelBlock)tintColor {
    return (EGLabelBlock)[super tintColor];
}

#pragma mark - UILabel

- (EGLabelBlock)highlighted {
    return (EGLabelBlock)[super eagle_boolBlockWithName:NSStringFromSelector(_cmd)];
}

- (EGLabelBlock)highlightedTextColor {
    return (EGLabelBlock)[super eagle_colorBlockWithName:NSStringFromSelector(_cmd)];
}

- (EGLabelBlock)shadowColor {
    return (EGLabelBlock)[super eagle_colorBlockWithName:NSStringFromSelector(_cmd)];
}

- (EGLabelBlock)textColor {
    return (EGLabelBlock)[super eagle_colorBlockWithName:NSStringFromSelector(_cmd)];
}

- (EGLabelBlock)font {
    return (EGLabelBlock)[super eagle_fontBlockWithName:NSStringFromSelector(_cmd)];
}

@end

EagleCategoryImplementation(UILabel, EGLabel)
