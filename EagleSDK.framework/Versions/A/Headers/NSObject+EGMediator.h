//
//  NSObject+EGMediator.h
//  AFNetworking
//
//  Created by pantao on 2017/12/1.
//

#import <Foundation/Foundation.h>

@interface NSObject (EGMediator)

/**
 触发target的方法
 
 @param actionStr 方法字符串
 */
- (BOOL)eg_performSelector:(id)target actionStr:(NSString *)actionStr withObject:(id)object;

@end
