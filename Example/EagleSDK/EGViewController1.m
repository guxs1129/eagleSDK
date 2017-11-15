//
//  EGViewController1.m
//  EagleSDK_Example
//
//  Created by pantao on 2017/11/13.
//  Copyright © 2017年 guxs1129@163.com. All rights reserved.
//

#import "EGViewController1.h"

#define defaultURL @"http://192.168.200.193:9001/test2.html"

@interface EGViewController1 ()<UITextFieldDelegate>
{
    UILabel *l;
    UILabel *l_last;
    UITextField *tf;
    NSString *urlStr;
}

@end

@implementation EGViewController1

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat kScreenWidth = [UIScreen mainScreen].bounds.size.width;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"toWeb" style:UIBarButtonItemStylePlain target:self action:@selector(click)];
    self.selfView.backgroundColor = randomColor;
    tf = [UITextField new];
    tf.frame = CGRectMake(0, 50, kScreenWidth, 45);
    [self.selfView addSubview:tf];
    tf.font = [UIFont boldSystemFontOfSize:17];
    tf.layer.borderColor = [UIColor whiteColor].CGColor;
    tf.layer.borderWidth = 2.;
    tf.layer.cornerRadius = 3.;
    tf.placeholder = defaultURL;
    tf.adjustsFontSizeToFitWidth = YES;
    tf.delegate = self;
    
    l_last = [UILabel new];
    l_last.frame = CGRectMake(10, tf.frame.origin.y + tf.frame.size.height + 20, (kScreenWidth - 30) /2, 45);
    l_last.font = [UIFont boldSystemFontOfSize:15.];
    l_last.layer.borderColor = [UIColor whiteColor].CGColor;
    l_last.layer.borderWidth = 2.;
    l_last.layer.cornerRadius = 3.;
    [self.selfView addSubview:l_last];
    l_last.backgroundColor = [UIColor orangeColor];
    l_last.textColor = [UIColor whiteColor];
    l_last.text = @"历史缓存:--";
    l_last.textAlignment = NSTextAlignmentCenter;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.selfView addGestureRecognizer:tap];
    
    l = [UILabel new];
    l.frame = CGRectMake(10, l_last.frame.origin.y + l_last.frame.size.height + 20, (kScreenWidth - 30) /2, 45);
    l.font = [UIFont boldSystemFontOfSize:15.];
    l.layer.borderColor = [UIColor whiteColor].CGColor;
    l.layer.borderWidth = 2.;
    l.layer.cornerRadius = 3.;
    [self.selfView addSubview:l];
    l.backgroundColor = [UIColor orangeColor];
    l.textColor = [UIColor whiteColor];
    l.text = @"--";
    l.textAlignment = NSTextAlignmentCenter;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(l.frame.origin.x + l.frame.size.width + 5, l.frame.origin.y, l.frame.size.width, 45);
    btn.backgroundColor = [UIColor brownColor];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"点击获取随机码" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:15.];
    btn.layer.borderWidth = 2.f;
    btn.layer.borderColor = [UIColor whiteColor].CGColor;
    btn.layer.cornerRadius = 3.;
    [self.selfView addSubview:btn];
    [btn addTarget:self action:@selector(getRand) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"refresh" object:nil];
}

- (void)refresh
{
    tf.text = defaultURL;
    l.text = @"--";
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.text = textField.placeholder;
}

- (void)hideKeyboard
{
    [self.selfView endEditing:YES];
}

- (void)getRand
{
    int a = arc4random() % 100000;
    NSString *str = [NSString stringWithFormat:@"%06d", a];
    l.text = str;
    l_last.text = [NSString stringWithFormat:@"历史缓存:%@",str];
    urlStr = defaultURL;
    if ([urlStr rangeOfString:@"?"].location != NSNotFound) {// 有问号
        urlStr = [NSString stringWithFormat:@"%@&code=%@",defaultURL,l.text];
    }else {
        urlStr = [NSString stringWithFormat:@"%@?code=%@",defaultURL,l.text];
    }
    tf.text = urlStr;
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlStr]];
}

- (void)click
{
    [RouterManager navigateTo:[NSString stringWithFormat:@"eagle://A/B?rand=%@",l.text]];
//    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlStr]];
}

@end
