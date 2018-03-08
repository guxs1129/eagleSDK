//
//  EGURL.m
//  AFNetworking
//
//  Created by 顾新生 on 2017/11/20.
//

#import "EGURL.h"

@implementation EGURL

-(instancetype)initWithScheme:(EGURLScheme)scheme components:(NSArray *)pathComponents query:(NSDictionary *)query{
    if (self=[super init]) {
        self.schemeType=scheme;
        self.scheme=[self schemeTypeToString:scheme];
        self.pathComponents=pathComponents;
        self.path=[NSString stringWithFormat:@"/%@",[pathComponents componentsJoinedByString:@"/"]];
        self.host=[pathComponents firstObject];
        self.query=query;
        self.queryString=[self dictToString:query];
        self.relativePath=[NSString stringWithFormat:@"%@?%@",self.path,self.queryString];
        self.absolutePath=[NSString stringWithFormat:@"%@:/%@",self.scheme,self.relativePath];
    }
    return self;
}
-(instancetype)initWithString:(NSString *)urlString{
    if (self=[super init]) {
        [self parseURL:[urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    return self;
}

-(void)parseURL:(NSString *)urlString{
    //check hash path
    NSRange hashRange=[urlString rangeOfString:@"/#!/"];
    self.isHashURL = hashRange.location!=NSNotFound;
    if (self.isHashURL) {
        self.hashPathValue=[urlString substringFromIndex:hashRange.location+hashRange.length];
    }
    
    //scheme
    NSArray *components=[urlString componentsSeparatedByString:@":/"];
    if (components.count!=2) {
        return;
    }
    NSString *scheme=[components firstObject];
    NSString *pathAndQuery=[components lastObject];
    EGURLScheme schemeType=[self schemeToType:scheme];
    if (schemeType==EGURLSchemeUnknown) {
        return;
    }
    self.scheme=scheme;
    self.schemeType=schemeType;
    
    //path
    NSRange range=[pathAndQuery rangeOfString:@"?"];
    if(range.location==NSNotFound){
        self.path=pathAndQuery;
        self.queryString=nil;
    }else{
        NSArray *pathAndQueryArr=[pathAndQuery componentsSeparatedByString:@"?"];
        if (pathAndQueryArr.count==2) {
            self.path=[pathAndQueryArr firstObject];
            self.queryString=[pathAndQueryArr lastObject];
        }
    }
    
    //query
    NSMutableArray *pathArrM=[[self.path componentsSeparatedByString:@"/"]mutableCopy];
    [pathArrM removeObjectAtIndex:0];
    self.pathComponents=[NSArray arrayWithArray:pathArrM];
    self.host=[self.pathComponents firstObject];
    NSString *queryR1=[self.queryString stringByReplacingOccurrencesOfString:@"=" withString:@"&"];
    NSArray *queryArr=[queryR1 componentsSeparatedByString:@"&"];
    if (queryArr.count%2!=0) {
        @throw [NSException exceptionWithName:@"<EGURL Error>" reason:@"Query string is not key=value format" userInfo:nil];
    }
    NSMutableDictionary *tmp=[NSMutableDictionary dictionary];
    for (int i=0; i<queryArr.count/2; i++) {
        NSString *key=queryArr[2*i];
        NSString *value=queryArr[2*i+1];
        [tmp setObject:value forKey:key];
    }
    self.query=[NSDictionary dictionaryWithDictionary:tmp];
    
    self.relativePath=self.queryString?[NSString stringWithFormat:@"%@?%@",self.path,self.queryString]:self.path;
    
    self.absolutePath=[NSString stringWithFormat:@"%@:/%@",self.scheme,self.relativePath];
}

-(NSString *)queryObj:(NSString *)key{
    return [self.query objectForKey:key];
}

-(NSString *)moduleName{
    if(![self.host isEqualToString:@"module"]){
        NSLog(@"<EGURL Info>It's not a module route.");
        return nil;
    }
    return [self.pathComponents objectAtIndex:1];
}

#pragma mark ----------------scheme convert-----------------

-(EGURLScheme)schemeToType:(NSString *)scheme{
    if ([scheme isEqualToString:@"eagle"]) {
        return EGURLSchemeDefault;
    }else if ([scheme isEqualToString:@"media"]){
        return EGURLSchemeMedia;
    }else{
        return EGURLSchemeUnknown;
    }
}
-(NSString *)schemeTypeToString:(EGURLScheme)scheme{
    switch (scheme) {
        case EGURLSchemeDefault:
            return @"eagle";
            break;
        case EGURLSchemeMedia:
            return @"media";
            break;
        default:
            return nil;
            break;
    }
}

-(NSString *)dictToString:(NSDictionary *)dict{
    NSEnumerator *itor=dict.keyEnumerator;
    NSMutableString *mString=[[NSMutableString alloc]init];
    NSString *key;
    while ((key=itor.nextObject)!=nil) {
        [mString appendString:key];
        [mString appendString:@"="];
        [mString appendString:[dict objectForKey:key]];
        [mString appendString:@"&"];
    }
    [mString deleteCharactersInRange:NSMakeRange(mString.length-1, 1)];
    return [NSString stringWithString:mString];
}

@end
