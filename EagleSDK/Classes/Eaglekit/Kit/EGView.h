//
//  EagleView.h
//  Eagle
//
//  Created by pantao on 2017/11/6.
//  Copyright © 2017年 pantao. All rights reserved.
//

#import "EGKit.h"

EagleBlockDeclare(EGView)

@interface EGView : EGKit

- (EGViewBlock)backgroundColor;
- (EGViewBlock)alpha;
- (EGViewBlock)tintColor;

@end

EagleCategoryDeclare(UIView, EGView)
