//
//  EGViewController.m
//  EagleSDK
//
//  Created by guxs1129@163.com on 11/10/2017.
//  Copyright (c) 2017 guxs1129@163.com. All rights reserved.
//

#import "EGViewController.h"
#import "EGHomeViewController.h"
@interface EGViewController ()

@end

@implementation EGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
        // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor=[UIColor redColor];
    [self subscribe:@"hello" withBlock:^(id msg) {
        NSLog(@"%@",msg);
    }];
     
    [self post:@"hello" withOptions:@"hello world"];
                               
}
- (IBAction)toMap:(id)sender {
//    EGMapViewController *vc=[[EGMapViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
