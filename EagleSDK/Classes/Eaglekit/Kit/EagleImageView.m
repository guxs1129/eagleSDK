//
//  EagleImageView.m
//  Eagle
//
//  Created by pantao on 2017/11/7.
//  Copyright © 2017年 pantao. All rights reserved.
//

#import "EagleImageView.h"

@implementation EagleImageView

#pragma mark - UIView

- (EagleImageViewBlock)backgroundColor {
    return (EagleImageViewBlock)[super backgroundColor];
}

- (EagleImageViewBlock)alpha {
    return (EagleImageViewBlock)[super alpha];
}

- (EagleImageViewBlock)tintColor {
    return (EagleImageViewBlock)[super tintColor];
}

#pragma mark - UIImageView

- (EagleImageViewBlock)highlighted {
    return (EagleImageViewBlock)[super eagle_boolBlockWithName:NSStringFromSelector(_cmd)];
}

- (EagleImageViewBlock)image {
    return (EagleImageViewBlock)[super eagle_imageBlockWithName:NSStringFromSelector(_cmd)];
}
- (EagleImageViewBlock)highlightedImage {
    return (EagleImageViewBlock)[super eagle_imageBlockWithName:NSStringFromSelector(_cmd)];
}


@end

EagleCategoryImplementation(UIImageView, EagleImageView)
