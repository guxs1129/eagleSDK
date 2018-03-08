//
//  NSString+EGUtil.h
//  EagleSDK-IBCustomer
//
//  Created by pantao on 2017/11/29.
//

#import <Foundation/Foundation.h>

@interface NSString (EGUtil)

/**
 计算字符串宽度(指定高度)
 
 @param str        传入的字符串
 @param height     传入的高度
 @param font       字体
 @param fontSize   fontSize
 @return           字符串宽度
 */
+ (CGFloat)eg_getStrWidth:(NSString *)str height:(CGFloat)height font:(UIFont *)font fontSize:(CGFloat)fontSize;

/**
 计算字符串高度(指定宽度)
 
 @param str         传入的字符串
 @param width       传入的宽度
 @param font        字体
 @param fontSize    fontSize
 @return            字符串高度
 */
+ (CGFloat)eg_getStrHeight:(NSString *)str width:(CGFloat)width font:(UIFont *)font fontSize:(CGFloat)fontSize;

/**
 计算字符串尺寸

 @param str         传入的字符串
 @param font        字体
 @param fontSize    fontSize
 @return            字符串尺寸
 */
+ (CGSize)eg_getStrSize:(NSString *)str font:(UIFont *)font fontSize:(CGFloat)fontSize;

@end
