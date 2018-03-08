//
//  EGModuleManager.h
//  EagleSDK
//
//  Created by 顾新生 on 2018/2/7.
//
#define RegistModule() +(void)load{\
[super load];\
}

#define RegistService(module,service) +(void)load{\
[super load];\
[[EGModuleManager manager]registService:self name:(service) inModule:(module)];\
}


#define EGModuleRouter(module)     ([[EGModuleManager manager]moduleRouter:(module)])
#define EGModuleHashRouter(module,vcRoute)         ([[EGModuleManager manager]hashRoute:(module) hashValue:(vcRoute)])


#import <Foundation/Foundation.h>
#import "NSObject+EventBus.h"
#import "NSObject+Service.h"
#pragma mark ----------------EGModuleService Protocol-----------------
@protocol EGService<NSObject>

@required

/**
 Service must implement this method.
 When call a service, all requests related with instance with call this method.

 @param params Input params.
 @param resultHandler Result callback.
 */
-(void)onCallWithParams:(id)params resultHandler:(ServiceCallback)resultHandler;


@end


#pragma mark ----------------EGModuleExport Protocol-----------------
@protocol EGModuleExport<NSObject>

@optional


/**
 Set Moduel default entrance

 @return An array contains all route export.
 */
+(NSArray *)exportDefault;

@optional
/**
 Set Module export services
 
 @return An array contains all public services.
 */
+(NSArray *)exportService;

@optional

/**
 If want to enable to start app from a module router,implement this method.

 @return An instance that let keywindow load as rootviewcontroller.
 */
+(UIViewController *)exportAppLoader;

@end

#pragma mark ----------------EGModule-----------------
/**
 Module define.
 */
@interface EGModule:NSObject
@end


#pragma mark ----------------EGModuleManager-----------------
/**
 Manager all modules that add to app.
 */
@interface EGModuleManager : NSObject


+(instancetype)manager;


-(void)registModule:(Class)moduleClass;


-(NSString *)moduleRouter:(NSString *)module;


/**
 Make a hash url.
 Like: eagle://module/IBCustomer/#!/IBCustomerDetailViewController

 @param module ModuleName
 @param vcRoute Controller to add route
 @return Hash URL
 */
-(NSString *)hashRoute:(NSString *)module hashValue:(NSString *)vcRoute;


/**
 ViewController regist router in module.

 @param module Module
 @param vcClazz ViewController class.
 @param router ViewController defined route.
 */
-(void)regitstModuleRouter:(NSString *)module vc:(Class)vcClazz router:(NSString *)router;

-(NSString *)routeInModule:(NSString *)module vc:(NSString *)vcClassName;


/**
 Find module that viewcontroller in.

 @param vcClassName ViewController className.
 @return Module name.
 */
-(NSString *)moduleForVC:(NSString *)vcClassName;


-(void)bindViewModel:(Class)vmClazz forVC:(NSString *)vcClazz inModule:(NSString *)module;

-(Class)viewModelClassForVC:(NSString *)vcClazz;
-(NSArray<Class> *)viewModelArrayForVC:(NSString *)vcClazz;

#pragma mark -- service
-(void)registService:(Class)clazz name:(NSString *)serviceName inModule:(NSString *)module;
-(NSString *)getService:(NSString *)serviceName inModule:(NSString *)module;
-(void)connect:(NSString *)moduleService params:(NSDictionary *)params resultHandler:(ServiceCallback)resultHandler;
@end
