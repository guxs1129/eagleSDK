//
//  EagleUIWebView.m
//  Eagle
//
//  Created by pantao on 2017/10/25.
//  Copyright © 2017年 pantao. All rights reserved.
//

#import "EagleUIWebView.h"

@implementation EagleUIWebView

- (UIViewController*)viewController {
    for (UIView* nextVC = [self superview]; nextVC; nextVC = nextVC.superview) {
        UIResponder* nextResponder = [nextVC nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

- (UINavigationController *)navigationController
{
    return [self viewController].navigationController;
}

@end
