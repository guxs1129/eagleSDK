//  Created by Jason Morrissey

#import <UIKit/UIKit.h>

@interface UIColor (EGHex)
/**
 *  色值转换成UIColor
 *  @param hexColor  16进制色值
 *  @return UIColor类型
 */
+ (UIColor *)eg_colorWithHex:(long)hexColor;
+ (UIColor *)colorWithHex:(long)hexColor;

/**
 *  色值转换成UIColor
 *  @param hexColor  16进制色值
 *  @param opacity  颜色的透明度0~1
 *  @return UIColor类型
 */
+ (UIColor *)eg_colorWithHex:(long)hexColor alpha:(CGFloat)opacity;

+ (UIColor *)eg_getColorWithQulityLevel:(int)qulityLevel;

+ (UIImage *)eg_imageWithColor:(UIColor *)color andSize:(CGSize)size;

+ (UIColor *)eg_colorWithHexString:(NSString *)str;
+ (UIColor *)colorWithHexString:(NSString *)str;

@end
