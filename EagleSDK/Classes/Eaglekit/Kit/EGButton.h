//
//  EagleButton.h
//  Eagle
//
//  Created by pantao on 2017/11/7.
//  Copyright © 2017年 pantao. All rights reserved.
//

#import "EGView.h"

EagleBlockDeclare(EGButton)
Eagle2DStateBlockDeclare(EGButton)

@interface EGButton : EGView

// UIView
- (EGButtonBlock)backgroundColor;
- (EGButtonBlock)alpha;
- (EGButtonBlock)tintColor;

// UIButton
- (EGButton2DStateBlock)titleColor;//setTitleColor:forState:
- (EGButton2DStateBlock)image;//setImage:forState:
- (EGButton2DStateBlock)backgroundImage;//setBackgroundImage:forState:

@end

EagleCategoryDeclare(UIButton, EGButton)
