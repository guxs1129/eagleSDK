//
//  UIButton+Radius.m
//  AFNetworking
//
//  Created by 顾新生 on 2017/11/29.
//

#import "UIButton+Radius.h"

@implementation UIButton (Radius)
-(void)eg_setRadius:(CGFloat)radius{
    CAShapeLayer *mask=[CAShapeLayer layer];
    mask.path=[UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:radius].CGPath;
    mask.fillColor=[UIColor whiteColor].CGColor;
    self.layer.mask=mask;
}
@end
