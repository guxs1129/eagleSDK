//
//  NSObject+EGBind.h
//  Pods
//
//  Created by pantao on 2017/11/27.
//

#import <Foundation/Foundation.h>

@interface NSObject (EGBind)

/**
 双向绑定
 
 @param kit         e.g UILabel、UIButton、UITextField、UITextView
 @param keyPath     UIKit的属性
 @param model       自定义model
 @param property    model属性
 */
- (void)EGBindUIKit:(id)kit keyPath:(NSString *)keyPath model:(NSObject *)model property:(NSString *)property;

@end
