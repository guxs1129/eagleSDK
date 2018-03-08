//
//  EGMapTestViewController.m
//  EagleSDK_Example
//
//  Created by 顾新生 on 2018/1/9.
//  Copyright © 2018年 guxs1129@163.com. All rights reserved.
//

#import "EGMapTestViewController.h"

@interface EGMapTestViewController ()

@end

@implementation EGMapTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"MapKit";
    self.view.backgroundColor=[UIColor whiteColor];
    
    
    self.addComponent(@"EGMapComponent",FlexCloum,EGSizeMake(NO, 0, 0, 200, 200),nil);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
