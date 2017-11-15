//
//  EagleController.h
//  Eagle
//
//  Created by pantao on 2017/11/7.
//  Copyright © 2017年 pantao. All rights reserved.
//

#import "EagleView.h"

EagleBlockDeclare(EagleController)

@interface EagleController : EagleView

- (EagleControllerBlock)title;

@end

EagleCategoryDeclare(UIViewController, EagleController)
