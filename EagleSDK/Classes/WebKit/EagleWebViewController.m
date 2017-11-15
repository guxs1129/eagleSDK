    //
    //  EagleWebViewController.m
    //  Eagle
    //
    //  Created by 顾新生 on 2017/10/31.
    //  Copyright © 2017年 pantao. All rights reserved.
    //

#import "EagleWebViewController.h"
#import <WebKit/WebKit.h>
#import "NSURLProtocol+WKWebVIew.h"
#import <Masonry/Masonry.h>
@interface EagleWebViewController ()
@property(nonatomic,strong)NSDate *start;

@end

@implementation EagleWebViewController
-(instancetype)initWithUrl:(NSURL *)url{
    if (self=[super init]) {
        self.url=url;
        self.webView.UIDelegate=self;
        self.webView.navigationDelegate=self;
        [self.view addSubview:self.webView];
        self.bridge=[WKWebViewJavascriptBridge bridgeForWebView:self.webView];
        [self.bridge setWebViewDelegate:self];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
        // Do any additional setup after loading the view.
    [NSURLProtocol wk_registerScheme:@"http"];
    [NSURLProtocol wk_registerScheme:@"https"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}
- (void)loadRemoteData:(NSURL *)url {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURLRequest *request=[[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
        NSURLSession *session=[NSURLSession sharedSession];
        NSURLSessionDataTask *task=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.webView loadData:data MIMEType:@"text/html" characterEncodingName:@"utf-8" baseURL:url];
            });
        }];
        [task resume];
    });
}
-(void)loadLocalFile:(NSURL *)url{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURLRequest *request=[NSURLRequest requestWithURL:url];
        NSCachedURLResponse *cachedResponse=[[NSURLCache sharedURLCache]cachedResponseForRequest:request];
        
        
        if (!cachedResponse || cachedResponse.data==nil) {
            NSData *data=[NSData dataWithContentsOfFile:url.relativePath];
            NSHTTPURLResponse *response=[[NSHTTPURLResponse alloc]initWithURL:url MIMEType:@"text/html" expectedContentLength:data.length textEncodingName:@"utf8"];
            [[NSURLCache sharedURLCache]storeCachedResponse:[[NSCachedURLResponse alloc]initWithResponse:response data:data userInfo:nil storagePolicy:NSURLCacheStorageAllowed] forRequest:request];
            cachedResponse=[[NSURLCache sharedURLCache]cachedResponseForRequest:request];
        }
        NSLog(@"%@",cachedResponse);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.webView loadData:cachedResponse.data MIMEType:@"text/html" characterEncodingName:@"utf-8" baseURL:url];
        });
    });
}
-(void)setUrl:(NSURL *)url{
    _url=url;
    NSString *scheme=url.scheme;

    if ([scheme containsString:@"file"]){
        [self loadLocalFile:url];
    }else{
        [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
    }
}

-(WKWebView *)webView{
    if (_webView==nil) {
        _webView=[[WKWebView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _webView;
}

-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"%s",__func__);
    
}
-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    self.start=[NSDate date];
    NSLog(@"%s",__func__);
    NSURL *url=navigationAction.request.URL;
    NSSet *types=[WKWebsiteDataStore allWebsiteDataTypes];
    
    decisionHandler(WKNavigationActionPolicyAllow);
}
-(void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    NSLog(@"%s",__func__);
    
    decisionHandler(WKNavigationResponsePolicyAllow);
}
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSLog(@"%s",__func__);
    NSDate *end=[NSDate date];
    NSTimeInterval time=[end timeIntervalSinceDate:self.start];
    NSLog(@"=====>%f",time);
}


-(void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"%s",__func__);
    
}
@end
