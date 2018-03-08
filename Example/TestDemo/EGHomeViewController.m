//
//  EGHomeViewController.m
//  EagleSDK_Example
//
//  Created by 顾新生 on 2017/11/23.
//  Copyright © 2017年 guxs1129@163.com. All rights reserved.
//

#import "EGHomeViewController.h"
#import <Masonry/Masonry.h>

@interface EGHomeViewController ()

@end

@implementation EGHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *btn=[[UIButton alloc]init];
    [btn setTitle:@"test click" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.centerY.equalTo(@0);
    }];
    [btn sizeToFit];
    [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    NSLog(@"%@",self.mm_drawerController);
    
#if defined(EGNaviSlideApp_h)
    NSLog(@"hello");
#else
//    NSLog(@"%s",__func__);
#endif
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)click{
    NSLog(@"%s",__func__);
    NSLog(@"%@",[UIApplication sharedApplication].naviSlideApp.drawerController);

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:[UIColor redColor]];
    [[UIApplication sharedApplication].naviSlideApp.drawerController setShowsShadow:NO];
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
