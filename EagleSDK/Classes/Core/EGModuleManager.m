//
//  EGModuleManager.m
//  EagleSDK
//
//  Created by 顾新生 on 2018/2/7.
//

#import "EGModuleManager.h"
#pragma mark ----------------module-----------------
@interface EGModule()
@end
@implementation EGModule

+(void)load{
    [super load];
    [[EGModuleManager manager]registModule:self];
}


@end



#pragma mark ----------------manager-----------------
@interface EGModuleManager()
@property(nonatomic,strong)NSMutableArray *modules;
@property(nonatomic,strong)NSMutableDictionary *moduleRouterMaps;
@property(nonatomic,strong)NSMutableDictionary *vcModuleMaps;
@property(nonatomic,strong)NSMutableDictionary *vcViewModelMaps;
@property(nonatomic,strong)NSMutableDictionary *serviceMaps;
@end

@implementation EGModuleManager

+(instancetype)manager{
    static EGModuleManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager=[[self alloc]init];
    });
    return manager;
}

-(void)registModule:(Class)moduleClass{
    if([NSStringFromClass(moduleClass) isEqualToString:@"EGModule"]){
        return;
    }
    [self.modules addObject:moduleClass];
}

-(void)regitstModuleRouter:(NSString *)module vc:(Class)vcClazz router:(NSString *)router{
    if(!module || !vcClazz || !router){
        return;
    }
    NSMutableArray *routerMaps=[self.moduleRouterMaps objectForKey:module];
    if(routerMaps==nil){
        routerMaps=[NSMutableArray array];
    }
    NSString *vcName=NSStringFromClass(vcClazz);
    [routerMaps addObject:@{vcName:router}];
    [self.moduleRouterMaps setObject:routerMaps forKey:module];
    [self.vcModuleMaps setObject:module forKey:NSStringFromClass(vcClazz)];
//    NSLog(@"%@",self.moduleRouterMaps);
}

-(NSString *)routeInModule:(NSString *)module vc:(NSString *)vcClassName{
    NSString *msg=nil;
    NSString *result=nil;
    if (!module || module.length==0 || !vcClassName || vcClassName.length==0) {
        msg=@"<EGModuleManager Error>Invalid module or hashValue.";
    }
    NSMutableArray *routes=[self.moduleRouterMaps objectForKey:module];
    if (!routes) {
        msg=@"<EGModuleManager Error>Invalid module or hashValue.";
    }
    NSString *route=nil;
    for (NSDictionary *dict in routes) {
        NSString *key=dict.allKeys.firstObject;
        if ([vcClassName isEqualToString:key]) {
            route=dict.allValues.firstObject;
            break;
        }
    }
    if (!route) {
        msg=[NSString stringWithFormat:@"<EGModuleManager Error>Route not found in module.Check viewcontroller [ %@ ] has regist route to module [ %@ ].",vcClassName,module];
    }
    result=route;
    if (msg) {
        NSLog(@"%@",msg);
    }
    return result;
}

-(NSString *)moduleForVC:(NSString *)vcClassName{
    return [self.vcModuleMaps valueForKey:vcClassName];
}

-(NSString *)moduleRouter:(NSString *)module{
    return [self moduleRouter:module vcRoute:nil];
}

-(NSString *)moduleRouter:(NSString *)module vcRoute:(NSString *)vcRoute{
    if([module isKindOfClass:[NSString class]]){
        if([self moduleIsExist:module]){
            if(vcRoute && [module isKindOfClass:[NSString class]]){
                NSString *vc=(NSString *)vcRoute;
                if(vc.length>0){
                    return [NSString stringWithFormat:@"eagle://module/%@/#!/%@",module,vc];
                }
            }
            return [NSString stringWithFormat:@"eagle://module/%@",module];
        }else{
            NSLog(@"<EGModuleManager Error>%@ doesn't loaded.Check module's name.",module);
        }
    }
    return nil;
}

-(NSString *)hashRoute:(NSString *)module hashValue:(NSString *)vcRoute{
    return [self moduleRouter:module vcRoute:vcRoute];
}


-(void)bindViewModel:(Class)vmClazz forVC:(NSString *)vcClazz inModule:(NSString *)module{
    NSMutableDictionary *maps=[self.vcViewModelMaps objectForKey:module];
    if (maps==nil) {
        maps=[NSMutableDictionary dictionary];
    }
    NSMutableArray *vmClsArr=[maps objectForKey:vcClazz];
    if (!vmClsArr) {
        vmClsArr=[NSMutableArray array];
    }
    [vmClsArr addObject:vmClazz];
    [maps setValue:vmClsArr forKey:vcClazz];
    [self.vcViewModelMaps setObject:maps forKey:module];
}

-(Class)viewModelClassForVC:(NSString *)vcClazz{
    NSString *module=[self moduleForVC:vcClazz];
    NSMutableDictionary *maps=[self.vcViewModelMaps objectForKey:module];
    Class result=nil;
    if (maps && maps.count>0) {
        NSMutableArray *vmClsArr=[maps objectForKey:vcClazz];
        if (vmClsArr && vmClsArr.count>0) {
            NSString *filePath = [[NSBundle mainBundle]pathForResource:@"bindMap.plist" ofType:nil];
            NSDictionary *bindMapDict=[NSDictionary dictionaryWithContentsOfFile:filePath];
            NSDictionary *moduleDict=[bindMapDict objectForKey:module];
            NSString *vmClzz=[moduleDict objectForKey:vcClazz];
            if (vmClzz && vmClzz.length>0) {
                Class vmClazz = NSClassFromString(vmClzz);
                NSArray *vmArr=[self viewModelArrayForVC:vcClazz];
                if ([vmArr containsObject:vmClazz]) {
                    result=vmClazz;
                }else{
                    @throw [NSException exceptionWithName:@"<EGModuleManager Error>" reason:[NSString stringWithFormat:@"Viewmodel [ %@ ] needs to bind to controller [ %@ ] by defined macro --BindViewModelToController(module,controller) before use.",vmClzz,vcClazz] userInfo:nil];
                }
            }
        }
    }
    return result;
}

-(NSArray<Class> *)viewModelArrayForVC:(NSString *)vcClazz{
    NSString *module=[self moduleForVC:vcClazz];
    NSMutableDictionary *maps=[self.vcViewModelMaps objectForKey:module];
    NSArray *resultArr=nil;
    if (maps && maps.count>0){
        NSMutableArray *vmClsArr=[maps objectForKey:vcClazz];
        if (vmClsArr) {
            resultArr = [NSArray arrayWithArray:vmClsArr];
        }
    }
    return resultArr;
}

-(BOOL)moduleIsExist:(NSString *)moduleName{
    NSString *module=[NSString stringWithFormat:@"%@_Module",moduleName];
    Class clazz=NSClassFromString(module);
    return [self.modules containsObject:clazz];
}

#pragma mark ---------------service---------------
-(void)registService:(Class)clazz name:(NSString *)serviceName inModule:(NSString *)module{
    NSString *clazzName=NSStringFromClass(clazz);
    if (![clazz conformsToProtocol:@protocol(EGService)]) {
        @throw [NSException exceptionWithName:@"<Service Error>" reason:[NSString stringWithFormat:@"Service [ %@ ] need confirm to protocol <EGService>.",clazzName] userInfo:nil];
    }
    NSMutableArray *serviceArrM=[self.serviceMaps objectForKey:module];
    if (serviceArrM==nil) {
        serviceArrM=[NSMutableArray array];
    }else{
        if ([serviceArrM containsObject:serviceName]) {
            @throw [NSException exceptionWithName:@"<Service Error>" reason:[NSString stringWithFormat:@"Duplicate service [ %@ ] regist.",serviceName] userInfo:nil];
        }
    }
    if (!serviceName||serviceName.length==0) {
        @throw [NSException exceptionWithName:@"<Serivce Error>" reason:@"Service must has a name to call." userInfo:nil];
        return;
    }
    [serviceArrM addObject:[NSString stringWithFormat:@"%@.%@",clazzName,serviceName]];
    [self.serviceMaps setObject:serviceArrM forKey:module];
    NSLog(@"======>%@",self.serviceMaps);
}

-(NSString *)getService:(NSString *)serviceName inModule:(NSString *)module{
    NSMutableArray *serviceArrM=[self.serviceMaps objectForKey:module];
    NSString *clazzName=nil;
    if (serviceArrM) {
        for (NSString *service in serviceArrM) {
            if ([service hasSuffix:serviceName]) {
                clazzName=[[service stringByReplacingOccurrencesOfString:serviceName withString:@""]stringByReplacingOccurrencesOfString:@"." withString:@""];
                break;
            }
        }
    }
    if (!clazzName) {
        NSLog(@"No service [ %@ ] in module [ %@ ].",serviceName,module);
    }
    return clazzName;
}

-(void)connect:(NSString *)moduleService params:(NSDictionary *)params resultHandler:(ServiceCallback)resultHandler{
    if (moduleService && moduleService.length>0) {
        NSArray *components=[moduleService componentsSeparatedByString:@"#"];
        if (components.count==2) {
            NSString *module=[components firstObject];
            NSString *serviceName=[components lastObject];
            
            //Check whether export
            NSString *moduleClazzName=[NSString stringWithFormat:@"%@_Module",module];
            Class moduleClazz=NSClassFromString(moduleClazzName);
            NSString *serviceClazzName=[self getService:serviceName inModule:module];
            
            if (serviceClazzName && serviceClazzName.length>0) {
                if (moduleClazz && [moduleClazz respondsToSelector:@selector(exportService)]) {
                    NSArray *exportServices=[moduleClazz performSelector:@selector(exportService)];
                    if ([exportServices containsObject:serviceClazzName]) {
                        Class clazz=NSClassFromString(serviceClazzName);
                        id<EGService> service=[[clazz alloc]init];
                        [service performSelector:@selector(onCallWithParams:resultHandler:) withObject:params withObject:resultHandler];
                    }
                }
            }
        }
    }
}



#pragma mark ---------------lazy var---------------
-(NSMutableArray *)modules{
    if(_modules==nil){
        _modules=[NSMutableArray array];
    }
    return _modules;
}
-(NSMutableDictionary *)moduleRouterMaps{
    if(_moduleRouterMaps==nil){
        _moduleRouterMaps=[NSMutableDictionary dictionary];
    }
    return _moduleRouterMaps;
}
-(NSMutableDictionary *)vcModuleMaps{
    if (_vcModuleMaps==nil) {
        _vcModuleMaps=[NSMutableDictionary dictionary];
    }
    return _vcModuleMaps;
}
-(NSMutableDictionary *)vcViewModelMaps{
    if (_vcViewModelMaps==nil) {
        _vcViewModelMaps=[NSMutableDictionary dictionary];
    }
    return _vcViewModelMaps;
}
-(NSMutableDictionary *)serviceMaps{
    if (_serviceMaps==nil) {
        _serviceMaps=[NSMutableDictionary dictionary];
    }
    return _serviceMaps;
}
@end
