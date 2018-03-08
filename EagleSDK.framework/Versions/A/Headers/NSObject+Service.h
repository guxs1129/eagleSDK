//
//  NSObject+Service.h
//  EagleSDK
//
//  Created by 顾新生 on 2018/3/7.
//
typedef NSString ModuleSerivce;
typedef TopicBlock ServiceCallback;

#define ModuleService(module,service) ([NSString stringWithFormat:@"%@#%@",(module),(service)])

#import <Foundation/Foundation.h>

@interface NSObject (Service)
-(void)callService:(ModuleSerivce *)moduleService params:(id)params resultHandler:(ServiceCallback)resultHandler;
@end
