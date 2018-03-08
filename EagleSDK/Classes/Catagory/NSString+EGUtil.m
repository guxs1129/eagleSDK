//
//  NSString+EGUtil.m
//  EagleSDK-IBCustomer
//
//  Created by pantao on 2017/11/29.
//

#import "NSString+EGUtil.h"

@implementation NSString (EGUtil)

+ (CGFloat)eg_getStrWidth:(NSString *)str height:(CGFloat)height font:(UIFont *)font fontSize:(CGFloat)fontSize
{
    CGFloat currentWidth = 0.0;
    if ([str respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSDictionary *attribute = [NSDictionary dictionaryWithObjectsAndKeys:font?font:[UIFont systemFontOfSize:fontSize],NSFontAttributeName, nil];
        currentWidth = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options: (NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:attribute context:nil].size.width;
    }
    return currentWidth + 1;// +1预留个缓冲区
}

+ (CGFloat)eg_getStrHeight:(NSString *)str width:(CGFloat)width font:(UIFont *)font fontSize:(CGFloat)fontSize
{
    CGFloat currentHeight = 0.0;
    if ([str respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSDictionary *attribute = [NSDictionary dictionaryWithObjectsAndKeys:font?font:[UIFont systemFontOfSize:fontSize],NSFontAttributeName, nil];
        currentHeight = [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options: (NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:attribute context:nil].size.width;
    }
    return currentHeight;
}

+ (CGSize)eg_getStrSize:(NSString *)str font:(UIFont *)font fontSize:(CGFloat)fontSize
{
    CGSize size = CGSizeZero;
    if ([str respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSDictionary *attribute = [NSDictionary dictionaryWithObjectsAndKeys:font?font:[UIFont systemFontOfSize:fontSize],NSFontAttributeName, nil];
        size = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options: (NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:attribute context:nil].size;
    }
    return size;
}

@end
