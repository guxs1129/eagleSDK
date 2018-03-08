//
//  NSObject+EGMediator.m
//  AFNetworking
//
//  Created by pantao on 2017/12/1.
//

#import "NSObject+EGMediator.h"

@implementation NSObject (EGMediator)

/**
 触发target的方法
 
 @param actionStr 方法字符串
 */
- (BOOL)eg_performSelector:(id)target actionStr:(NSString *)actionStr withObject:(id)object
{
    SEL action = NSSelectorFromString(actionStr);
    if ([target respondsToSelector:action]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [target performSelector:action withObject:object];
#pragma clang diagnostic pop
        return YES;
    }
    return NO;
}


@end
