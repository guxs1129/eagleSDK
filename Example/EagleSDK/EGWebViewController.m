//
//  EGWebViewController.m
//  EagleSDK_Example
//
//  Created by 顾新生 on 2017/11/14.
//  Copyright © 2017年 guxs1129@163.com. All rights reserved.
//

#import "EGWebViewController.h"
#import <AFNetworking/AFNetworking.h>
@interface EGWebViewController ()<WebComponentDelegate>
@property(nonatomic,strong)NSArray *components;

@end

@implementation EGWebViewController

mapRoute(@"eagle://A/D?c=d&r=f")

-(void)dealloc{
    NSLog(@"%s",__func__);
}
- (void)viewDidLoad {
    [super viewDidLoad];
        // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor greenColor];
    self.title=@"Web Component Test";

    
    self.components=self.registerComponents(@[@"WebComponent"],FlexCloum).done();
    WebComponent *part=(WebComponent *)self.getComponent(self.components[0]);
    part.size(EGSizeMake(YES, 1.0, 1.0, 0, 0));
    [part setFullScreen:YES];
        //    part.backgroundColor=[UIColor redColor];
        //    part.loadURL=[NSURL URLWithString:@"http://122.193.26.154:8204/ibf/m/login.html"];
//    NSString *path=[[NSBundle mainBundle]pathForResource:@"ExampleApp" ofType:@"html"];
//    NSURL *url=[NSURL fileURLWithPath:path];
    NSURL *url=[NSURL URLWithString:@"https://tyxx.sxzq.com/htqf/?userId=90001818&userType=2&appid=UPushHTQF&apikey=ab123&apisecret=cd456&topicType=1"];
//    NSURL *url=[NSURL URLWithString:@"http://baike.baidu.com/api/openapi/BaikeLemmaCardApi?scope=103&format=json&appid=379020&bk_key=银魂&bk_length=600"];

//    NSURL *url=[NSURL URLWithString:@"https://mp.weixin.qq.com/s/0LxGFMqAokMzDu2P6_dxRQ"];

//    NSURL *url=[NSURL URLWithString:@"https://www.baidu.com"];

    part.loadURL=url;
    part.identifier=@"web01";
    [part addHandlers:@[@"rightBarButtonItems",@"btn1Action"] withTarget:self];
    
    
    
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithTitle:@"Call JS" style:UIBarButtonItemStylePlain target:self action:@selector(callJS)];
    UIBarButtonItem *menuItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showMenu)];
    self.navigationItem.rightBarButtonItems=@[menuItem,rightItem];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}

-(void)showMenu{
    WebComponent *part=(WebComponent *)self.getComponent(self.components[0]);
    [part goBack];
    
}

-(void)navtiveCall:(NSString *)handler data:(id)data callBack:(TopicResultBlock)callback{
    if ([handler isEqualToString:@"btn1Action"]) {
        NSLog(@"%@",data);
        NSString *url=(NSString *)data;
        NSString *aurl=[url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:aurl]];
        AFURLSessionManager *manager=[[AFURLSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        [[manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            if(error){
                NSLog(@"%@",error);
            }
            NSLog(@"%@",response);
            callback(responseObject);
        }]resume];
            //        [[AFHTTPSessionManager manager]GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            NSLog(@"%@",responseObject);
//            callback(@"this is from btn1");
//
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            NSLog(@"%@",error);
//            callback(@"this is from btn1");
//
//        }];
        return;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        callback(@"hello world asyn callback");
    });
    if ([handler isEqualToString:@"rightBarButtonItems"]) {
        if ([data isKindOfClass:[NSArray class]]) {
            NSArray *items=(NSArray *)data;
            NSLog(@"%@",items);
        }
    }
    
}

-(void)callJS{
    
    
        //    [self jsCall:@"registerAction" options:@"this is jscall"];
    
    [self jsCall:@"registerAction" options:@{@"name":@"zhangsan"} withIdentifier:@"web01"];
}

-(void)jsCallback:(NSString *)handler response:(id)responseData{
    NSLog(@"[%@]:%@",handler,responseData);
}

-(void)urlCall:(NSString *)handler params:(NSArray *)params msg:(id)msg{
    NSDictionary *dict=nil;
    if ([msg isKindOfClass:[NSDictionary class]]) {
        dict=(NSDictionary *)msg;
    }
    
    if ([handler containsString:NSStringFromSelector(@selector(setActionBarStyle:))]) {
        [self setActionBarStyle:[params firstObject]];
        self.title=[dict objectForKey:@"titleName"];
    }
    self.title=@"Hello";
}

-(void)setActionBarStyle:(NSString *)color{
    
    NSLog(@"%s",__func__);

}
@end
