//
//  EagleTextComponent.h
//  Eagle
//
//  Created by pantao on 2017/11/7.
//  Copyright © 2017年 pantao. All rights reserved.
//

#import "EGView.h"

EagleBlockDeclare(EGTextComponent)

@interface EGTextComponent : EGView

// UIView
- (EGTextComponentBlock)backgroundColor;
- (EGTextComponentBlock)alpha;
- (EGTextComponentBlock)tintColor;

// UITextField + UITextView
- (EGTextComponentBlock)font;
- (EGTextComponentBlock)keyboardAppearance;
- (EGTextComponentBlock)textColor;

@end

EagleCategoryDeclare(UITextField, EGTextComponent)
EagleCategoryDeclare(UITextView, EGTextComponent)
