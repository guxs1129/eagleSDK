//
//  EagleImageView.h
//  Eagle
//
//  Created by pantao on 2017/11/7.
//  Copyright © 2017年 pantao. All rights reserved.
//

#import "EGView.h"

EagleBlockDeclare(EGImageView)

@interface EGImageView : EGView

//UIView
- (EGImageViewBlock)backgroundColor;
- (EGImageViewBlock)alpha;
- (EGImageViewBlock)tintColor;

// UIImageView
- (EGImageViewBlock)highlighted;
- (EGImageViewBlock)image;
- (EGImageViewBlock)highlightedImage;

@end

EagleCategoryDeclare(UIImageView, EGImageView)
