//
//  UIImage+Color.m
//  iSmartOffice
//
//  Created by 顾新生 on 16/3/25.
//  Copyright © 2016年 dumplingproject. All rights reserved.
//
#define W   15
#define R   7
#import "UIImage+Color.h"

@implementation UIImage (Color)
+(instancetype)imageWithColor:(UIColor *)color{
    
    CGRect rect=CGRectMake(0, 0, 1, 1);
    return [self imageWithColor:color andSize:rect.size];
}
+(instancetype)imageWithColor:(UIColor *)color andSize:(CGSize)size{
    CGRect rect=CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    CGContextRestoreGState(context);
    UIGraphicsEndImageContext();
    return img;
}

+ (UIImage*) imageWithColo:(UIColor*)color andHeight:(CGFloat)height{
    CGRect r= CGRectMake(0.0f, 0.0f, W, height);
    UIGraphicsBeginImageContext(r.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0.8 alpha:0.8].CGColor);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGFloat startA=-M_PI*0.5;
    UIBezierPath *path=[UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(R, 0)];
    [path addLineToPoint:CGPointMake(W-R, 0)];
    
    [path addArcWithCenter:CGPointMake(W-R, R) radius:R startAngle:startA endAngle:startA+M_PI*0.5 clockwise:YES];
    [path addLineToPoint:CGPointMake(W, height-R)];
    
    [path addArcWithCenter:CGPointMake(W-R, height-R) radius:R startAngle:startA+M_PI*0.5 endAngle:startA+M_PI clockwise:YES];
    [path addLineToPoint:CGPointMake(R, height)];
    
    [path addArcWithCenter:CGPointMake(R, height-R) radius:R startAngle:startA+M_PI endAngle:startA+M_PI*1.5 clockwise:YES];
    [path addLineToPoint:CGPointMake(0, R)];
    
    [path addArcWithCenter:CGPointMake(R, R) radius:R startAngle:startA+M_PI*1.5 endAngle:startA+M_PI*2 clockwise:YES];
    CGContextAddPath(context, path.CGPath);
//    CGContextFillPath(context);
//    CGContextStrokePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}
@end
