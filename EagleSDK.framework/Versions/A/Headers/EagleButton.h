//
//  EagleButton.h
//  Eagle
//
//  Created by pantao on 2017/11/7.
//  Copyright © 2017年 pantao. All rights reserved.
//

#import "EagleView.h"

EagleBlockDeclare(EagleButton)
Eagle2DStateBlockDeclare(EagleButton)

@interface EagleButton : EagleView

// UIView
- (EagleButtonBlock)backgroundColor;
- (EagleButtonBlock)alpha;
- (EagleButtonBlock)tintColor;

// UIButton
- (EagleButton2DStateBlock)titleColor;//setTitleColor:forState:
- (EagleButton2DStateBlock)image;//setImage:forState:
- (EagleButton2DStateBlock)backgroundImage;//setBackgroundImage:forState:

@end

EagleCategoryDeclare(UIButton, EagleButton)
