//
//  EGComponent+JSONInject.m
//  EagleSDK
//
//  Created by 顾新生 on 26/12/2017.
//

#import "EGComponent+JSONInject.h"

@implementation EGComponent (JSONInject)
-(BOOL)isJSONInject{
    return objc_getAssociatedObject(self, @selector(isJSONInject));
}
-(void)setIsJSONInject:(BOOL)isJSONInject{
    objc_setAssociatedObject(self, @selector(isJSONInject), @(isJSONInject), OBJC_ASSOCIATION_ASSIGN);
}
@end
