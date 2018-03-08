//
//  EGRouterManager+Module.h
//  Pods
//
//  Created by 顾新生 on 2018/2/8.
//

#import <EagleSDK/EagleSDK.h>
@class EGURL;
@interface EGRouterManager (Module)
+ (void)navigateToModule:(EGURL *)url options:(id)options;
+ (void)navigateToModule:(EGURL *)url options:(id)options callback:(EGCallback)callback;

+ (void)startAppWithModuleRouter:(NSString *)moduleRouter;
@end
