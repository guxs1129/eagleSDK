//
//  EagleLabel.h
//  Eagle
//
//  Created by pantao on 2017/11/7.
//  Copyright © 2017年 pantao. All rights reserved.
//

#import "EGView.h"

EagleBlockDeclare(EGLabel)

@interface EGLabel : EGView

// UIView
- (EGLabelBlock)backgroundColor;
- (EGLabelBlock)alpha;
- (EGLabelBlock)tintColor;
// UILabel
- (EGLabelBlock)highlighted;
- (EGLabelBlock)highlightedTextColor;
- (EGLabelBlock)shadowColor;
- (EGLabelBlock)textColor;
- (EGLabelBlock)font;

@end

EagleCategoryDeclare(UILabel, EGLabel)
