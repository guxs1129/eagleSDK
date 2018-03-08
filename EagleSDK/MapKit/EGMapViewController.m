//
//  EGMapViewController.m
//  EagleSDK
//
//  Created by 顾新生 on 2018/1/9.
//

#import "EGMapViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "EGMAnnotation.h"
@interface EGMapViewController ()

@end

@implementation EGMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"EGMapViewController";
    self.view.backgroundColor=[UIColor whiteColor];
    UIButton *rightBtn=[UIButton buttonWithType:UIButtonTypeContactAdd];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    @weakify(self)
    [[rightBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self post:EGMapComponent_AddAnnotation_Channel withOptions:[[EGMAnnotation alloc]initWithCoordinate:CLLocationCoordinate2DMake(31.5681,120.2991) title:@"Add" subtitle:@"This ia add"]];
    }];
    
    self.addComponent(@"EGMapComponent",FlexCloum,EGSizeMake(NO, 0, 0, kScreenWidth, kScreenHeight-64),nil);
}
-(void)dealloc{
    NSLog(@"%s",__func__);

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
