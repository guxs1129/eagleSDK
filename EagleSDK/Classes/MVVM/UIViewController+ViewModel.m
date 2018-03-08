//
//  UIViewController+ViewModel.m
//  EagleSDK
//
//  Created by 顾新生 on 19/12/2017.
//

#import "UIViewController+ViewModel.h"

@implementation UIViewController (ViewModel)
-(EGViewModel *)viewModel{
    return objc_getAssociatedObject(self, @selector(viewModel));
}

-(void)setViewModel:(EGViewModel *)viewModel{
    objc_setAssociatedObject(self, @selector(viewModel), viewModel, OBJC_ASSOCIATION_RETAIN);
}

-(NSMutableArray *)componentsArr{
    return objc_getAssociatedObject(self, @selector(componentsArr));
}
-(void)setComponentsArr:(NSMutableArray *)componentsArr{
    objc_setAssociatedObject(self, @selector(componentsArr), componentsArr, OBJC_ASSOCIATION_RETAIN);
}
@end
