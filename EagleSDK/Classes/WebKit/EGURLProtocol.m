//
//  EGURLProtocol.m
//  EG
//
//  Created by 顾新生 on 2017/11/6.
//  Copyright © 2017年 pantao. All rights reserved.
//
#import "EGURLProtocol.h"
static  NSString *const EGURLProtocolHKey=@"EGURLProtocolHKey";


@interface EGURLProtocol()<NSURLSessionDelegate>
@property(nonatomic,strong)NSURLSessionTask *task;

@end

@implementation EGURLProtocol
+(BOOL)canInitWithRequest:(NSURLRequest *)request{
    NSLog(@"request.URL.absoluteString = %@",[request.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
    NSString *scheme = [[request URL] scheme];
//    NSString *baseURL=@"https://tyxx.sxzq.com/htqf/";
//    NSString *path=[request.URL.absoluteString stringByReplacingOccurrencesOfString:baseURL withString:@""];
//    if ([path containsString:@"KDS_Native"]) {
//        NSLog(@"[url filter]:%@",path);
//        return NO;
//    }
    if ([request.URL.absoluteString containsString:@"https://tyxx.sxzq.com/upush/querytopics"]) {
        return NO;
    }
    
    if ( ([scheme caseInsensitiveCompare:@"http"]==NSOrderedSame || [scheme caseInsensitiveCompare:@"https"]==NSOrderedSame )){
            //看看是否已经处理过了，防止无限循环
        
        if ([NSURLProtocol propertyForKey:EGURLProtocolHKey inRequest:request]){
            return NO;
        }
        return YES;
    }

    return NO;
}


+(NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request{
    NSMutableURLRequest *mutableReqeust = [request mutableCopy];
    [mutableReqeust setValue:@"header test" forHTTPHeaderField:@"option"];
    [mutableReqeust addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    return mutableReqeust;
}


-(void)startLoading{
    NSLog(@"%s",__func__);

    NSMutableURLRequest *mutableReqeust = [[self request] mutableCopy];
        //给我们处理过的请求设置一个标识符, 防止无限循环,
    [NSURLProtocol setProperty:@YES forKey:EGURLProtocolHKey inRequest:mutableReqeust];
    //TODO：拦截缓存
//    NSLog(@"%@",self.request.allHTTPHeaderFields);
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    self.task = [session dataTaskWithRequest:self.request];
    [self.task resume];
}


-(void)stopLoading{
    if (self.task != nil){
        [self.task  cancel];
    }
}



-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (error) {
        NSLog(@"%@",error);
        [self.client URLProtocol:self didFailWithError:error];
    } else {
        [self.client URLProtocolDidFinishLoading:self];
    }
}

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {

    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    completionHandler(NSURLSessionResponseAllow);
}

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    [self.client URLProtocol:self didLoadData:data];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask willCacheResponse:(NSCachedURLResponse *)proposedResponse completionHandler:(void (^)(NSCachedURLResponse *cachedResponse))completionHandler{
    completionHandler(proposedResponse);
}


@end
