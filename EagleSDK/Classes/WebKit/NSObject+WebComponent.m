//
//  NSObject+WebComponent.m
//  Eagle
//
//  Created by 顾新生 on 2017/11/8.
//  Copyright © 2017年 pantao. All rights reserved.
//

#import "NSObject+WebComponent.h"

@implementation NSObject (WebComponent)
-(void)jsCall:(NSString *)handler options:(id)options{
    [self jsCall:handler options:options withIdentifier:nil];
}

-(void)jsCall:(NSString *)handler options:(id)options withIdentifier:(NSString *)identifier{
    if ([self conformsToProtocol:@protocol(WebComponentDelegate)]) {
        NSString *topic=nil;
        if (identifier) {
            topic=[NSString stringWithFormat:@"%lu_JSCALL_%@",(unsigned long)[self hash],identifier];
        }else{
            topic=[NSString stringWithFormat:@"%lu_JSCALL",(unsigned long)[self hash]];
        }
        NSMutableDictionary *params=[NSMutableDictionary dictionary];
        [params setObject:handler forKey:@"handler"];
        if (options!=nil) {
            [params setObject:options forKey:@"data"];
        }
        [self post:topic withOptions:params];
    }else{
        @throw [NSException exceptionWithName:@"WebComponent" reason:@"Object which is not conforms to  WebComponentDelegate is not allowed to call js action" userInfo:@{@"Target":self}];
    }
    
}


@end
