//
//  NSObject+Service.m
//  EagleSDK
//
//  Created by 顾新生 on 2018/3/7.
//

#import "NSObject+Service.h"

@implementation NSObject (Service)
-(void)callService:(ModuleSerivce *)moduleService params:(id)params resultHandler:(ServiceCallback)resultHandler{
    [[EGModuleManager manager]connect:moduleService params:params resultHandler:resultHandler];
}
@end
