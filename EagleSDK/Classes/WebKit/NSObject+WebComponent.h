//
//  NSObject+WebComponent.h
//  Eagle
//
//  Created by 顾新生 on 2017/11/8.
//  Copyright © 2017年 pantao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EagleEventBus.h"
#import "NSObject+EventBus.h"
#import "WebComponent.h"
@interface NSObject (WebComponent)

/**
 调用web中js handler，当只有一个webcomponent的时候快捷方法

 @param handler handler名称
 @param options 传递参数
 */
-(void)jsCall:(NSString *)handler options:(id)options;


/**
 调用web中js handler

 @param handler handler名称
 @param options 传递参数
 @param identifier 响应webcomponent的识别id
 */
-(void)jsCall:(NSString *)handler options:(id)options withIdentifier:(NSString *)identifier;
@end
