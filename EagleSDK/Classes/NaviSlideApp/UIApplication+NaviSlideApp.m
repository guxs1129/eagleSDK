//
//  UIApplication+NaviSlideApp.m
//  AFNetworking
//
//  Created by 顾新生 on 2017/11/23.
//

#import "UIApplication+NaviSlideApp.h"
#import <objc/runtime.h>
@implementation UIApplication (NaviSlideApp)
-(EGNaviSlideApp *)naviSlideApp{
    return objc_getAssociatedObject(self, @selector(naviSlideApp));
}

-(void)setNaviSlideApp:(EGNaviSlideApp *)app{
    objc_setAssociatedObject(self, @selector(naviSlideApp), app, OBJC_ASSOCIATION_RETAIN);
}
@end
