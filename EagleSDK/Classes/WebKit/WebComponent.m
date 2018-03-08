//
//  WebComponent.m
//  EG
//
//  Created by 顾新生 on 2017/11/2.
//  Copyright © 2017年 pantao. All rights reserved.
//

#import "WebComponent.h"
@interface WebComponent()<WKUIDelegate,WKNavigationDelegate,NSURLSessionDelegate>
@property(nonatomic,strong)WKWebView *_webView;
@property(nonatomic,strong)WKWebViewJavascriptBridge *_jsBridge;
@property(nonatomic,strong)NSDate *start;

@property(nonatomic,copy)NSString *_jsCallTopicWithIdentifier;//带识别id的通信通道
@property(nonatomic,copy)NSString *_jsCallTopicWithoutIdentifier;//默认通信通道
@property(nonatomic,strong)NSArray *_internalHandlers;
@property(nonatomic,strong)NSMutableSet *handlersSet;

@end
@implementation WebComponent
//-(instancetype)init{
//    if (self=[super init]) {
//        [self addSubview:self._webView];
//        [self._jsBridge setWebViewDelegate:self];
//
//        // if need intercept by NSURLProtocol
////        [NSURLProtocol wk_registerScheme:@"http"];
////        [NSURLProtocol wk_registerScheme:@"https"];
//
//
//    }
//    return self;
//}

- (void)componentInit
{
    [super componentInit];
    [self addSubview:self._webView];
    id<WebComponent> viewModel=(id<WebComponent>)self.presentVC.viewModel;
    self.webDelegate=viewModel;
    [self._jsBridge setWebViewDelegate:self.presentVC.viewModel];
    [self._webView addObserver:self.presentVC forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    if ([self.presentVC.viewModel conformsToProtocol:@protocol(WebComponent)]) {
        id<WebComponent> viewModel=(id<WebComponent>)self.presentVC.viewModel;
        self.loadURL=viewModel.loadURL;
        [self addHandlers:self._internalHandlers withTarget:viewModel];
        [self addHandlers:viewModel.handlers withTarget:viewModel];
        
        [self bindEvents];
    }else{
        NSLog(@"<WebComponent Error>:Check ViewModel [ %@ ] is nil or doesn't confirm to protocol<WebComponent>",self.presentVC.viewModel);
    }
}


- (void)dealloc{
    [self._webView removeObserver:self.presentVC forKeyPath:@"estimatedProgress"];
    [self._webView removeFromSuperview];
    self._webView=nil;
    self._jsBridge=nil;
    NSLog(@"web componentDealloc");
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self._webView.frame=self.frame;
}
-(void)bindEvents{
    @eg_weakify(self)
    [self subscribe:EGW_OpenURL_Channel withBlock:^(id msg) {
        @eg_strongify(self)
        NSURL *url=nil;
        if([msg isKindOfClass:[NSString class]]){
            url=[NSURL URLWithString:msg];
        }else if ([msg isKindOfClass:[NSURL class]]){
            url=(NSURL *)msg;
        }else{
            return ;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self._webView loadRequest:[NSURLRequest requestWithURL:url]];
        });
    }];
}
-(void)setLoadURL:(NSURL *)loadURL{
    _loadURL=loadURL;
    NSString *scheme=loadURL.scheme;
    if ([scheme containsString:@"file"]){
        [self loadLocalFile:loadURL];
    }else{
        NSURLRequest * urlReuqest = [[NSURLRequest alloc]initWithURL:loadURL cachePolicy:1 timeoutInterval:30.0f];
        [self._webView loadRequest:urlReuqest];
    }
}

-(void)loadLocalFile:(NSURL *)url{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURLRequest *request=[NSURLRequest requestWithURL:url];
        NSCachedURLResponse *cachedResponse=[[NSURLCache sharedURLCache]cachedResponseForRequest:request];
        if (!cachedResponse || cachedResponse.data==nil) {
            NSData *data=[NSData dataWithContentsOfFile:url.relativePath];
            NSHTTPURLResponse *response=[[NSHTTPURLResponse alloc]initWithURL:url MIMEType:self.mimeType expectedContentLength:data.length textEncodingName:@"utf8"];
            [[NSURLCache sharedURLCache]storeCachedResponse:[[NSCachedURLResponse alloc]initWithResponse:response data:data userInfo:nil storagePolicy:NSURLCacheStorageAllowed] forRequest:request];
            cachedResponse=[[NSURLCache sharedURLCache]cachedResponseForRequest:request];
        }
        NSLog(@"%@",cachedResponse);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self._webView loadData:cachedResponse.data MIMEType:self.mimeType characterEncodingName:@"utf-8" baseURL:url];
        });
    });
}

-(void)goBack{
    if ([self._webView canGoBack]) {
        [self._webView goBack];
    }else{
        if ([[self.presentVC.params objectForKey:@"_modal"] boolValue]) {
            [self.presentVC dismissViewControllerAnimated:YES completion:nil];
        }else {
            [self.presentVC.navigationController popViewControllerAnimated:YES];
        }
    }
}
-(void)setFullScreen:(BOOL)flag{
    if(flag){
        self.presentVC.view=self._webView;
        if(!self.presentVC.navigationController.navigationBarHidden){
            self.presentVC.navigationController.navigationBar.translucent = NO;
            [self.presentVC.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        }
    }
}

-(BOOL)isEqualWebView:(id)object{
    return object==self._webView;
}



#pragma mark ---------------wkwebview---------------
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"%s",__func__);
}
-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    NSLog(@"%@",[navigationAction.request.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
//    NSString *baseURL=@"https://tyxx.sxzq.com/htqf/";
//    NSString *path=[navigationAction.request.URL.absoluteString stringByReplacingOccurrencesOfString:baseURL withString:@""];
//    if ([path hasPrefix:@"KDS_Native://"]) {
//        NSLog(@"[url filter]:%@",path);
//        NSDictionary *parseResult=[self parseURLCall:path forScheme:@"KDS_Native://"];
//        [self excuteURLCall:parseResult];
//        decisionHandler(WKNavigationActionPolicyCancel);
//    }else{
    NSLog(@"%@",navigationAction.request.allHTTPHeaderFields);
        self.start=[NSDate date];
        decisionHandler(WKNavigationActionPolicyAllow);
//    }
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{

    [webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        if ([result isKindOfClass:[NSString class]]) {
//            self.presentVC.title=result;
        }
    }];
    
    NSLog(@"%s",__func__);
    NSDate *end=[NSDate date];
    NSTimeInterval time=[end timeIntervalSinceDate:self.start];
    NSLog(@"=====>%f",time);
}


-(void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    NSLog(@"--->%s",__func__);
    NSLog(@"%@",navigationResponse.response);
    decisionHandler(WKNavigationResponsePolicyAllow);
}


- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self.presentVC presentViewController:alertController animated:YES completion:nil];
    
}


- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self.presentVC presentViewController:alertController animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];
    
    
    [self.presentVC presentViewController:alertController animated:YES completion:nil];
}

#pragma mark ---------------setter & getter---------------
-(WKWebView *)_webView{
    if (__webView==nil) {
        __webView=[[WKWebView alloc]init];
        __webView.UIDelegate=self;
        __webView.navigationDelegate=self;
        __webView.allowsBackForwardNavigationGestures=YES;
    }
    return __webView;
}
-(WKWebViewJavascriptBridge *)_jsBridge{
    if (__jsBridge==nil) {
        __jsBridge=[WKWebViewJavascriptBridge bridgeForWebView:self._webView];
    }
    return __jsBridge;
}
-(NSString *)mimeType{
    return _mimeType==nil?@"text/html":_mimeType;
}

-(void)addHandlers:(NSArray *)handlers withTarget:(id<WebComponentDelegate>)delegate{
    if ([delegate isKindOfClass:[NSObject class]]) {
        self.webDelegate=delegate;
        [self.handlersSet addObjectsFromArray:handlers];
        for (NSString *handler in handlers) {
            [self bindHandler:handler];
        }
        NSLog(@"[WebComponent Handlers]:%@",self.handlersSet.allObjects);
    } else {
        @throw [NSException exceptionWithName:@"<WebComponent>" reason:@"Target must be an object" userInfo:nil];
    }
}

-(void)addTarget:(NSObject<WebComponentDelegate> *)webDelegate andIdentifier:(NSString *)identifier{
    if (identifier && identifier.length>0) {
        self.identifier=identifier;
    }
    if (webDelegate==nil) {
        @throw [NSException exceptionWithName:@"<WebComponent>" reason:@"Target cann't be nil" userInfo:nil];
        return;
    }
    self.webDelegate=webDelegate;
    
}

-(void)setWebDelegate:(NSObject<WebComponentDelegate> *)webDelegate{
    _webDelegate=webDelegate;

    if (self._jsCallTopicWithIdentifier) {
        [self subscribe:self._jsCallTopicWithIdentifier withBlock:^(id msg) {
            [self parseJSCall:msg];
        }];
    }
    [self subscribe:self._jsCallTopicWithoutIdentifier withBlock:^(id msg) {
        [self parseJSCall:msg];
    }];
}

-(void)parseJSCall:(id)msg{
    if ([msg isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict=(NSDictionary *)msg;
        NSString *handler=[dict objectForKey:@"handler"];
        id data=[dict objectForKey:@"data"];
        [self._jsBridge callHandler:handler data:data responseCallback:^(id responseData) {
            if(self.webDelegate && [self.webDelegate respondsToSelector:@selector(jsCallback:response:)]){
                [self.webDelegate jsCallback:handler response:responseData];
            }
        }];
    }
}

-(NSString *)_jsCallTopicWithIdentifier{
    if (__jsCallTopicWithIdentifier==nil) {
        if (self.identifier) {
            __jsCallTopicWithIdentifier=[NSString stringWithFormat:@"%lu_JSCALL_%@",(unsigned long)[self.webDelegate hash],self.identifier];
        }else{
            __jsCallTopicWithIdentifier=nil;
        }
    }
    return __jsCallTopicWithIdentifier;
}
-(NSString *)_jsCallTopicWithoutIdentifier{
    if (__jsCallTopicWithoutIdentifier==nil) {
            __jsCallTopicWithoutIdentifier=[NSString stringWithFormat:@"%lu_JSCALL",(unsigned long)[self.webDelegate hash]];
    }
    return __jsCallTopicWithoutIdentifier;
}

#pragma mark ---------------private---------------
-(void)excuteURLCall:(NSDictionary *)parseResult{
    NSLog(@"==========>%@",parseResult);
    NSArray *handlerAndParams=[parseResult objectForKey:@"handler"];
//    NSMethodSignature *signature=[[self.webDelegate class]instanceMethodSignatureForSelector:NSSelectorFromString([handlerAndParams firstObject]))];
//    NSInvocation *invocation=[NSInvocation invocationWithMethodSignature:signature];
//    invocation.target=self.webDelegate;
    NSMutableArray *tmp=[NSMutableArray arrayWithArray:handlerAndParams];
    [tmp removeObjectAtIndex:0];
    NSDictionary *msg=[parseResult objectForKey:@"data"];
    if (self.webDelegate && [self.webDelegate respondsToSelector:@selector(urlCall:params:msg:)]) {
        [self.webDelegate urlCall:[handlerAndParams firstObject] params:tmp msg:msg];
    }
    
    
}

-(NSDictionary *)parseURLCall:(NSString *)url forScheme:(NSString *)scheme{
    NSString *rePath=[[url stringByReplacingOccurrencesOfString:scheme withString:@""]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSArray *parts=[rePath componentsSeparatedByString:@"::"];
    NSError *error;
    NSMutableDictionary *tmp=[NSMutableDictionary dictionary];
    NSMutableArray *strArrM=[NSMutableArray array];
    for (NSString *arg in parts) {
        if ([arg hasPrefix:@"{"]) {
            NSDictionary *data=[NSJSONSerialization JSONObjectWithData:[arg dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
            if (error) {
                NSLog(@"%@",error);
            }else{
                [tmp setObject:data forKey:@"data"];
            }
        }else{
            [strArrM addObject:arg];
        }
    }
    [tmp setObject:strArrM forKey:@"handler"];
    return [NSDictionary dictionaryWithDictionary:tmp];
}

- (void)bindHandler:(NSString *)handler {
    @eg_weakify(self)
    NSString *topic=[self topicForHandler:handler];
    
    NSString *callbackTopic=[self topicCallbackForHandler:handler];
    
    if (self.webDelegate) {
        [self.webDelegate subscribe:topic withResultBlock:^id(id msg) {
            if (self.webDelegate) {
                [self.webDelegate navtiveCall:handler data:msg callBack:^id(id msg) {
                    [self post:callbackTopic withOptions:msg];
                    return nil;
                }];
            }
            return nil;
        }];
    } else {
        @throw [NSException exceptionWithName:@"<WebComponent>" reason:@"No delegate for handlers.Tips:set webDelegate before add handlers" userInfo:nil];
    }
    __block ResponseCallback jsCallback=nil;
    [self._jsBridge registerHandler:handler handler:^(id data, ResponseCallback responseCallback) {
        @eg_strongify(self);
        [self post:topic withOptions:data];
        jsCallback=responseCallback;
    }];
    
    [self subscribe:callbackTopic withBlock:^(id msg) {
        if (jsCallback) {
            jsCallback(msg);
        }
    }];
}

-(void)callJSHandler:(NSString *)handler options:(id)options{
    NSLog(@"%@%@",handler,options);
    [self._jsBridge callHandler:handler data:options responseCallback:^(id responseData) {
        if (self.webDelegate && [self.webDelegate respondsToSelector:@selector(navtiveCall:data:callBack:)]) {
            
        }
    }];
}

-(void)callJSHandler:(NSString *)handler from:(id)target options:(id)options complete:(TopicBlock)completeBlock{
    NSLog(@"%@",target);
    [self._jsBridge callHandler:handler data:options responseCallback:^(id responseData) {
        if (completeBlock) {
            completeBlock(responseData);
        }
    }];
}
-(NSString *)topicForHandler:(NSString *)handler{
    return [NSString stringWithFormat:@"nativeCall:%@@%lu",handler,(unsigned long)[self hash]];
}
-(NSString *)topicCallbackForHandler:(NSString *)handler{
    return [NSString stringWithFormat:@"%@@callback@%lu",handler,(unsigned long)[self hash]];
}
#pragma mark ---------------lazy var---------------
-(NSMutableSet *)handlersSet{
    if (_handlersSet==nil) {
        _handlersSet=[NSMutableSet set];
    }
    return _handlersSet;
}

-(NSArray *)_internalHandlers{
    if (__internalHandlers==nil) {
        __internalHandlers=@[
                             EGWGetSystemInfoHandler,
                             EGWGetNetworkTypeHandler,
                             EGWGetAppVersionHandler,
                             EGWGenerateQRCodeHandler,
                             EGWOpenQRCodeHandler,
                             EGWOpenAlbumHandler,
                             EGWOpenCameraHandler,
                             EGWGetLocationInfoHandler,
                             EGWCloseWindowHandler,
                             EGWOpenWindowHandler,
                             EGWSetNavBarStyleHandler,
                             EGWsetOptionMenuHandler
                             ];
    }
    return __internalHandlers;
}

@end



