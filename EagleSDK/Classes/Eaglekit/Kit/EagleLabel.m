//
//  EagleLabel.m
//  Eagle
//
//  Created by pantao on 2017/11/7.
//  Copyright © 2017年 pantao. All rights reserved.
//

#import "EagleLabel.h"

@implementation EagleLabel

- (EagleLabelBlock)backgroundColor {
    return (EagleLabelBlock)[super backgroundColor];
}

- (EagleLabelBlock)alpha {
    return (EagleLabelBlock)[super alpha];
}

- (EagleLabelBlock)tintColor {
    return (EagleLabelBlock)[super tintColor];
}

#pragma mark - UILabel

- (EagleLabelBlock)highlighted {
    return (EagleLabelBlock)[super eagle_boolBlockWithName:NSStringFromSelector(_cmd)];
}

- (EagleLabelBlock)highlightedTextColor {
    return (EagleLabelBlock)[super eagle_colorBlockWithName:NSStringFromSelector(_cmd)];
}

- (EagleLabelBlock)shadowColor {
    return (EagleLabelBlock)[super eagle_colorBlockWithName:NSStringFromSelector(_cmd)];
}

- (EagleLabelBlock)textColor {
    return (EagleLabelBlock)[super eagle_colorBlockWithName:NSStringFromSelector(_cmd)];
}

- (EagleLabelBlock)font {
    return (EagleLabelBlock)[super eagle_fontBlockWithName:NSStringFromSelector(_cmd)];
}

@end

EagleCategoryImplementation(UILabel, EagleLabel)
