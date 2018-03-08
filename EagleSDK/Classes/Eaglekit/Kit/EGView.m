//
//  EagleView.m
//  Eagle
//
//  Created by pantao on 2017/11/6.
//  Copyright © 2017年 pantao. All rights reserved.
//

#import "EGView.h"

@interface EGView()

@end

@implementation EGView

- (EGViewBlock)backgroundColor {
    return (EGViewBlock)[super eagle_colorBlockWithName:NSStringFromSelector(_cmd)];
}

- (EGViewBlock)alpha {
    return (EGViewBlock)[super eagle_floatBlockWithName:NSStringFromSelector(_cmd)];
}

- (EGViewBlock)tintColor {
    return (EGViewBlock)[super eagle_colorBlockWithName:NSStringFromSelector(_cmd)];
}

@end

EagleCategoryImplementation(UIView, EGView)
