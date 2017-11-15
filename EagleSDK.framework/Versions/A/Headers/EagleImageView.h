//
//  EagleImageView.h
//  Eagle
//
//  Created by pantao on 2017/11/7.
//  Copyright © 2017年 pantao. All rights reserved.
//

#import "EagleView.h"

EagleBlockDeclare(EagleImageView)

@interface EagleImageView : EagleView

//UIView
- (EagleImageViewBlock)backgroundColor;
- (EagleImageViewBlock)alpha;
- (EagleImageViewBlock)tintColor;

// UIImageView
- (EagleImageViewBlock)highlighted;
- (EagleImageViewBlock)image;
- (EagleImageViewBlock)highlightedImage;

@end

EagleCategoryDeclare(UIImageView, EagleImageView)
