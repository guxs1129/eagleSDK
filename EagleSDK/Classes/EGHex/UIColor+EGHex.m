//  Created by Jason Morrissey

#import "UIColor+EGHex.h"

@implementation UIColor (EGHex)

+ (UIColor*)eg_colorWithHex:(long)hexColor;
{
    return [UIColor eg_colorWithHex:hexColor alpha:1.0];
}
+(UIColor *)colorWithHex:(long)hexColor{
    return [self eg_colorWithHex:hexColor];
}
+ (UIColor *)eg_colorWithHex:(long)hexColor alpha:(CGFloat)opacity
{
    CGFloat red = ((CGFloat)((hexColor & 0xFF0000) >> 16))/255.0;
    CGFloat green = ((CGFloat)((hexColor & 0xFF00) >> 8))/255.0;
    CGFloat blue = ((CGFloat)(hexColor & 0xFF))/255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:opacity];  
}

+ (UIColor *)eg_getColorWithQulityLevel:(int)qulityLevel
{
    UIColor *color = [UIColor eg_colorWithHex:0x42badc];
    if(qulityLevel<=50){
        color = [UIColor eg_colorWithHex:0x29a532];
    }else if (qulityLevel > 50 &&  qulityLevel <= 100){
        color = [UIColor eg_colorWithHex:0xc5e801];
    }else if (qulityLevel > 100 && qulityLevel <= 150){
        color = [UIColor eg_colorWithHex:0xf49a0b];
    }else if (qulityLevel > 150 && qulityLevel <= 200){
        color = [UIColor eg_colorWithHex:0xfb1c1c];
    }else if (qulityLevel > 200 && qulityLevel <= 300){
        color = [UIColor eg_colorWithHex:0xaf00bf];
    }else if (qulityLevel > 300){
       color = [UIColor eg_colorWithHex:0x6000b1];
    }
    return color;
}

+ (UIImage *)eg_imageWithColor:(UIColor *)color andSize:(CGSize)size
{
    UIImage *img = nil;
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,
                                   color.CGColor);
    CGContextFillRect(context, rect);
    img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

+ (UIColor *)eg_colorWithHexString:(NSString *)str
{
    const char *cStr = [str cStringUsingEncoding:NSASCIIStringEncoding];
    long x = strtol(cStr+1, NULL, 16);
    return [UIColor eg_colorWithHex:x];
}
+(UIColor *)colorWithHexString:(NSString *)str{
    return [self eg_colorWithHexString:str];
}
@end
