//
//  EagleTextComponent.h
//  Eagle
//
//  Created by pantao on 2017/11/7.
//  Copyright © 2017年 pantao. All rights reserved.
//

#import "EagleView.h"

EagleBlockDeclare(EagleTextComponent)

@interface EagleTextComponent : EagleView

// UIView
- (EagleTextComponentBlock)backgroundColor;
- (EagleTextComponentBlock)alpha;
- (EagleTextComponentBlock)tintColor;

// UITextField + UITextView
- (EagleTextComponentBlock)font;
- (EagleTextComponentBlock)keyboardAppearance;
- (EagleTextComponentBlock)textColor;

@end

EagleCategoryDeclare(UITextField, EagleTextComponent)
EagleCategoryDeclare(UITextView, EagleTextComponent)
