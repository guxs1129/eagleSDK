//
//  EagleImageView.m
//  Eagle
//
//  Created by pantao on 2017/11/7.
//  Copyright © 2017年 pantao. All rights reserved.
//

#import "EGImageView.h"

@implementation EGImageView

#pragma mark - UIView

- (EGImageViewBlock)backgroundColor {
    return (EGImageViewBlock)[super backgroundColor];
}

- (EGImageViewBlock)alpha {
    return (EGImageViewBlock)[super alpha];
}

- (EGImageViewBlock)tintColor {
    return (EGImageViewBlock)[super tintColor];
}

#pragma mark - UIImageView

- (EGImageViewBlock)highlighted {
    return (EGImageViewBlock)[super eagle_boolBlockWithName:NSStringFromSelector(_cmd)];
}

- (EGImageViewBlock)image {
    return (EGImageViewBlock)[super eagle_imageBlockWithName:NSStringFromSelector(_cmd)];
}
- (EGImageViewBlock)highlightedImage {
    return (EGImageViewBlock)[super eagle_imageBlockWithName:NSStringFromSelector(_cmd)];
}


@end

EagleCategoryImplementation(UIImageView, EGImageView)
