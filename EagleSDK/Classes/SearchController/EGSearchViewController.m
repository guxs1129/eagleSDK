//
//  EGSearchViewController.m
//  EagleSDK-iOS9.3
//
//  Created by 顾新生 on 2017/11/24.
//

#define _kScreenWidth [UIScreen mainScreen].bounds.size.width
#define _kScreenHeight [UIScreen mainScreen].bounds.size.height

#import "EGSearchViewController.h"
#import <Masonry/Masonry.h>
@interface EGSearchViewController ()

@end

@implementation EGSearchViewController
mapRoute(@"eagle://search_vc")
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationController.navigationBarHidden=YES;
    self.view.backgroundColor=[UIColor clearColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.headerView==nil) {
        self.headerView=[[EGSearchHeaderDefault alloc]initWithFrame:CGRectMake(0, 20, _kScreenWidth, 44)];
    }
}

#pragma mark ---------------textfield delegate---------------

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self.headerView inputShouldBeginEditingAnimation];
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [self.headerView inputShouldEndEditingAnimation];
    return YES;
}

#pragma mark ---------------lazy var---------------
-(void)setHeaderView:(UIView<EGSearchHeaderView> *)headerView{
    _headerView=headerView;
    _headerView.searchVC=self;
    _headerView.placeholder=@"Search...";
    [self.view addSubview:self.headerView];

}

@end
