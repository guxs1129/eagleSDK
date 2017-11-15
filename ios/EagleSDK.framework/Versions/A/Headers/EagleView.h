//
//  EagleView.h
//  Eagle
//
//  Created by pantao on 2017/11/6.
//  Copyright © 2017年 pantao. All rights reserved.
//

#import "Eaglekit.h"

EagleBlockDeclare(EagleView)

@interface EagleView : Eaglekit

- (EagleViewBlock)backgroundColor;
- (EagleViewBlock)alpha;
- (EagleViewBlock)tintColor;

@end

EagleCategoryDeclare(UIView, EagleView)
