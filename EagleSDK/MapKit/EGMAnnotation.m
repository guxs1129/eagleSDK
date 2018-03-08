//
//  EGMAnnotation.m
//  EagleSDK
//
//  Created by 顾新生 on 2018/1/18.
//

#import "EGMAnnotation.h"

@implementation EGMAnnotation
-(instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title subtitle:(NSString *)subtitle{
    if (self=[super init]) {
        self.coordinate=coordinate;
        self.animatedDrop=NO;
        [self setValue:title forKey:@"title"];
        [self setValue:subtitle forKey:@"subtitle"];
    }
    return self;
}
-(void)setCoordinate:(CLLocationCoordinate2D)newCoordinate{
    _coordinate=newCoordinate;
}
@end
