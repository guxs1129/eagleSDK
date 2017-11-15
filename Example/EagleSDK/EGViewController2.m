//
//  EGViewController2.m
//  EagleSDK_Example
//
//  Created by pantao on 2017/11/13.
//  Copyright © 2017年 guxs1129@163.com. All rights reserved.
//

#import "EGViewController2.h"

@interface EGViewController2 ()

@end

@implementation EGViewController2

mapRoute(@"eagle://A/B?rand=000000")

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSString *cId = ((NSArray *)self.addComponent(@"Component1",FlexRow,EGSizeMake(YES, 0.5, 0.5, 0, 0),nil).done())[0];
    Component *c = self.getComponent(cId);
    c.backgroundColor = [UIColor blueColor];

    NSString *cId1 = ((NSArray *)self.addComponent(@"WebComponent1",FlexRow,EGSizeMake(YES, 0.5, 0.5, 0, 0),nil).done())[1];
    WebComponent *c1 = (WebComponent *)self.getComponent(cId1);
    c1.backgroundColor = [UIColor brownColor];
    
//    NSString *cId = ((NSArray *)self.addComponent(@"WebComponent",FlexRow,EGSizeMake(YES, 1.0, 1.0, 0, 0),nil).done())[0];
//    WebComponent *c = (WebComponent *)self.getComponent(cId);
//    c.backgroundColor = randomColor;
//    c.loadURL = [NSURL URLWithString:@"https://tyxx.sxzq.com/htqf/?userId=90001818&userType=2&appid=UPushHTQF&apikey=ab123&apisecret=cd456&topicType=1"];
//
//    NSString *rand = [self.params valueForKey:@"rand"];
}

@end
