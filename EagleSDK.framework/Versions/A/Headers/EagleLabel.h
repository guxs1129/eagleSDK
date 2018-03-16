//
//  EagleLabel.h
//  Eagle
//
//  Created by pantao on 2017/11/7.
//  Copyright © 2017年 pantao. All rights reserved.
//

#import "EagleView.h"

EagleBlockDeclare(EagleLabel)

@interface EagleLabel : EagleView

// UIView
- (EagleLabelBlock)backgroundColor;
- (EagleLabelBlock)alpha;
- (EagleLabelBlock)tintColor;
// UILabel
- (EagleLabelBlock)highlighted;
- (EagleLabelBlock)highlightedTextColor;
- (EagleLabelBlock)shadowColor;
- (EagleLabelBlock)textColor;
- (EagleLabelBlock)font;

@end

EagleCategoryDeclare(UILabel, EagleLabel)
