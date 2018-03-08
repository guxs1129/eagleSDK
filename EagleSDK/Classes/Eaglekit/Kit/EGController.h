//
//  EagleController.h
//  Eagle
//
//  Created by pantao on 2017/11/7.
//  Copyright © 2017年 pantao. All rights reserved.
//

#import "EGView.h"

EagleBlockDeclare(EGController)

@interface EGController : EGView

- (EGControllerBlock)title;

@end

EagleCategoryDeclare(UIViewController, EGController)
