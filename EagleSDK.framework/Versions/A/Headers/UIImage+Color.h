//
//  UIImage+Color.h
//  iSmartOffice
//
//  Created by 顾新生 on 16/3/25.
//  Copyright © 2016年 dumplingproject. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Color)
+(instancetype)imageWithColor:(UIColor *)color;
+(instancetype)imageWithColor:(UIColor *)color andSize:(CGSize)size;
+ (UIImage*) imageWithColo:(UIColor*)color andHeight:(CGFloat)height;
@end
