//
//  EagleController.m
//  Eagle
//
//  Created by pantao on 2017/11/7.
//  Copyright © 2017年 pantao. All rights reserved.
//

#import "EGController.h"

@implementation EGController

- (EGControllerBlock)title {
    return (EGControllerBlock)[super eagle_titleBlockWithName:NSStringFromSelector(_cmd)];
}

@end

EagleCategoryImplementation(UIViewController, EGController)
