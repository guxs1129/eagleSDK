//
//  EGTestSearchHeader.m
//  EagleSDK_Example
//
//  Created by 顾新生 on 2017/11/24.
//  Copyright © 2017年 guxs1129@163.com. All rights reserved.
//

#import "EGTestSearchHeader.h"

@implementation EGTestSearchHeader
@synthesize searchInput;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor=[UIColor blueColor];
    }
    return self;
}

@end
