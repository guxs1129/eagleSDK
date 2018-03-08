//
//  EGRouterManager+Module.m
//  Pods
//
//  Created by 顾新生 on 2018/2/8.
//

#import "EGRouterManager+Module.h"
#import "EGModuleManager.h"
@implementation EGRouterManager (Module)
+(void)navigateToModule:(EGURL *)url options:(id)options{
    [self navigateToModule:url options:options callback:nil];
}

+(void)navigateToModule:(EGURL *)url options:(id)options callback:(EGCallback)callback{
    NSString *moduleName=[url moduleName];
    NSString *module=[NSString stringWithFormat:@"%@_Module",moduleName];
    Class moduleClazz=NSClassFromString(module);
    if([moduleClazz respondsToSelector:@selector(exportDefault)]){
        NSArray *exports=[moduleClazz performSelector:@selector(exportDefault)];
        if(exports.count==1){
            [self navigateTo:[exports firstObject] options:options];
        }else{
            if (url.isHashURL) {
                NSString *route=[[EGModuleManager manager]routeInModule:moduleName vc:url.hashPathValue];
                if (route) {
                    [self navigateTo:route options:options callback:callback];
                }
            }else{
                NSLog(@"<EGModuleManager Error>Module [ %@ ] has multi entrances.Check which is need to load.",moduleName);
            }
        }
    }
}

+(void)startAppWithModuleRouter:(NSString *)moduleRouter{
    if(moduleRouter){
        EGURL *url=[[EGURL alloc]initWithString:moduleRouter];
        if([url.host isEqualToString:@"module"]){
            NSString *moduleName=[url moduleName];
            NSString *module=[NSString stringWithFormat:@"%@_Module",moduleName];
            Class moduleClazz=NSClassFromString(module);
            if([moduleClazz respondsToSelector:@selector(exportAppLoader)]){
                UIViewController *rootVC=[moduleClazz performSelector:@selector(exportAppLoader)];
                [EGRouterManager mainWindow].rootViewController=rootVC;
            }
        }
    }else{
        NSLog(@"<EGRouterManager Error>Invalid router to start App.");
    }
}
@end
