//
//  EagleView.m
//  Eagle
//
//  Created by pantao on 2017/11/6.
//  Copyright © 2017年 pantao. All rights reserved.
//

#import "EagleView.h"

@interface EagleView()

@end

@implementation EagleView

- (EagleViewBlock)backgroundColor {
    return (EagleViewBlock)[super eagle_colorBlockWithName:NSStringFromSelector(_cmd)];
}

- (EagleViewBlock)alpha {
    return (EagleViewBlock)[super eagle_floatBlockWithName:NSStringFromSelector(_cmd)];
}

- (EagleViewBlock)tintColor {
    return (EagleViewBlock)[super eagle_colorBlockWithName:NSStringFromSelector(_cmd)];
}

@end

EagleCategoryImplementation(UIView, EagleView)
