//
//  UIImageView+Radius.m
//  AFNetworking
//
//  Created by 顾新生 on 2017/11/29.
//

#import "UIImageView+Radius.h"

@implementation UIImageView (Radius)
-(void)eg_setRadius:(CGFloat)radius{
    CAShapeLayer *mask=[CAShapeLayer layer];
    mask.path=[UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:radius].CGPath;
    mask.fillColor=[UIColor whiteColor].CGColor;
    self.layer.mask=mask;
}
-(void)eg_setRoundCorner{
    [self eg_setRadius:self.bounds.size.width*0.5];
}
@end
