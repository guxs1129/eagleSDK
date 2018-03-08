//
//  EGVCJsonBuilderManager.m
//  EagleSDK
//
//  Created by 顾新生 on 19/12/2017.
//

#import "EGVCJsonBuilderManager.h"
#import "UIViewController+ViewModel.h"
//#import "EGComponentJsonParser.h"
@protocol EGComponentJSONDataSourceInjectable;
@class EGComponentJsonParser;
@interface EGVCJsonBuilderManager()
@property(nonatomic,strong)NSMutableDictionary *jsonDict;
@end
@implementation EGVCJsonBuilderManager
+(instancetype)manager{
    static EGVCJsonBuilderManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager=[[self alloc]init];
    });
    return manager;
}
-(void)build:(UIViewController *)vc{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary *options=[self getOptionsForVC:vc];
        if (options==nil) {
            return;
        }
//        dispatch_async(dispatch_get_main_queue(), ^{
            EGVCJsonBuilder *builder=[[EGVCJsonBuilder alloc]init];
            [builder buildWithVC:vc options:options];
//        });
//    });
}
#pragma mark ---------------read json file---------------
-(NSDictionary *)getOptionsForVC:(UIViewController *)vc{
    NSString *className=NSStringFromClass([vc class]);
    NSDictionary *dict=[self getJSONFromCacheForKey:className];
    if (dict==nil) {
        dict=[self getJSONFromFileForKey:className];
    }
    return dict;
}

-(NSDictionary *)getJSONFromFileForKey:(NSString *)key{
    NSString *fileName=[NSString stringWithFormat:@"%@.json",key];
    NSString *filePath=[[NSBundle mainBundle]pathForResource:fileName ofType:nil];
    if (!filePath) {//If not exist in mainbundle,load from module bundle.
        NSString *module=[[EGModuleManager manager]moduleForVC:key];
        if(module){
            NSString *configurationBundle=[NSString stringWithFormat:@"%@_configurations.bundle",module];
            NSString *moduleBundlePath=[[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:configurationBundle];
            NSBundle *moduleBundle=[NSBundle bundleWithPath:moduleBundlePath];
            if (!moduleBundle) {//If in pod framework,location will change Frameworks/module.framework/xxx.bundle
                NSString *frameworkName=[NSString stringWithFormat:@"%@.framework",module];
                moduleBundlePath=[[[[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:@"Frameworks"]stringByAppendingPathComponent:frameworkName]stringByAppendingPathComponent:configurationBundle];
                moduleBundle=[NSBundle bundleWithPath:moduleBundlePath];
            }
            filePath=[moduleBundle pathForResource:fileName ofType:nil];
            if (!filePath) {
                NSLog(@"<JSONBuilder Info>%@ not found.",fileName);
            }
        }
    }
    NSDictionary *dict=nil;
    if (filePath){
        NSData *data=[NSData dataWithContentsOfFile:filePath];
        NSError *error;
        dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        if (error) {
            @throw [NSException exceptionWithName:@"<JSONBuilder Error>" reason:error.description userInfo:nil];
        }else{
            [self.jsonDict setObject:dict forKey:key];
        }
    }
    return dict;
}

#pragma mark ---------------cache---------------
-(NSDictionary *)getJSONFromCacheForKey:(NSString *)key{
    NSDictionary *dict=[self.jsonDict objectForKey:key];
    return dict;
}


#pragma mark ----------------lazy var-----------------
-(NSMutableDictionary *)jsonDict{
    if (_jsonDict==nil) {
        _jsonDict=[NSMutableDictionary dictionary];
    }
    return _jsonDict;
}
@end


@interface EGVCJsonBuilder()

@property(nonatomic,weak)UIViewController *vc;
@property(nonatomic,weak)NSDictionary *options;
@property(nonatomic,strong)EGViewModel *viewModel;
@end

@implementation EGVCJsonBuilder
-(void)buildWithVC:(UIViewController *)vc options:(NSDictionary *)options{
    self.vc=vc;
    self.options=options;
    if (![self jsonIsValid]) {
        @throw [NSException exceptionWithName:@"<JSONBuilder Error>" reason:@"JSON is invalid with target vc" userInfo:nil];
    }else{
        [self bindViewModel];
        [self parseComponents];
    }
}

-(BOOL)jsonIsValid{
    NSString *viewcontroller=[self.options valueForKey:@"viewcontroller"];
    if (viewcontroller==nil || viewcontroller.length==0) {
        return NO;
    }
    if (self.vc==nil) {
        return NO;
    }
    return [NSStringFromClass([self.vc class]) isEqualToString:viewcontroller];
}

#pragma mark ---------------viewmodel---------------
-(BOOL)viewModelIsValid{
    NSArray *components=[self.options valueForKeyPath:@"components"];
    BOOL flag=YES;
    for (NSDictionary *component in components) {
        Protocol *protocol=NSProtocolFromString(component.allKeys.firstObject);
        if (protocol && ![self.viewModel conformsToProtocol:protocol]) {
            flag=NO;
            NSLog(@"Viewmodel [ %@ ] doesn't confirm to protocol <%@>",NSStringFromClass([self.viewModel class]),NSStringFromProtocol(protocol));
            break;
        }
    }
    return flag;
}

-(void)bindViewModel{
    NSString *className=[self.options valueForKey:@"viewmodel"];
    NSString *vcClazz=NSStringFromClass([self.vc class]);
    //load from plist
    Class vmClazz=[[EGModuleManager manager]viewModelClassForVC:vcClazz];//bindMap priority high
    
    //load from json
    if (!vmClazz) {
        if (className && className.length>0) {
            vmClazz=NSClassFromString(className);
        }
    }
    
    //load from bindmacros
    if (!vmClazz) {
        NSArray *vmArr=[[EGModuleManager manager]viewModelArrayForVC:vcClazz];
        if (vmArr.count==1) {
            vmClazz=[vmArr firstObject];
        }else if (vmArr.count>1){
            @throw [NSException exceptionWithName:@"<EGJSONBuilder Error>" reason:[NSString stringWithFormat:@"Controller [ %@ ] has multi viewmodels binds. Bind the target in bindMap.plist.",vcClazz] userInfo:@{NSUnderlyingErrorKey:vmArr}];
            return;
        }else{
            NSLog(@"No viewmodel bind to controller %@",self.vc);
            return;
        }
    }

    self.viewModel=[[vmClazz alloc]init];
    if ([self viewModelIsValid]) {
        self.vc.viewModel=self.viewModel;
    }
}

#pragma mark ---------------component---------------
-(void)parseComponents{

    NSArray *componentsSource=[self.options valueForKey:@"components"];

    for (int i=0; i<componentsSource.count; i++) {

        NSDictionary *componentDict=componentsSource[i];
        EGComponentDesc component=[EGComponentJsonParser parseWithDict:componentDict];
        
        NSString *className=component.className;
#define keyPathFormat(keypath) [NSString stringWithFormat:@"components.%@.%@",className,keypath]
        NSString *eg_id = component.eg_id;
        NSString *eg_tag = [self.options valueForKeyPath:keyPathFormat(@"eg_tag")][i];
        
        
        NSArray *cpArray = self.vc.addComponent(component.className,component.flex,component.size,nil).done();
        if (cpArray.count  > i) {
            (self.vc.getComponentByComponentId(cpArray[i])).eg_id(eg_id).eg_tag(eg_tag);
        }
        EGComponent *c = self.vc.getComponentById(eg_id);
        
//        EGComponent *c=self.vc.addComponent(component.className,component.flex,component.size,nil).eg_id(eg_id).eg_tag(eg_tag);
        if (c && [c conformsToProtocol:@protocol(EGComponentJSONDataSourceInjectable)] && [c conformsToProtocol:@protocol(EGComponentJSONDataSourceInjectable)] && [c respondsToSelector:@selector(injectJSONDataSource:)]) {
            [c performSelector:@selector(injectJSONDataSource:) withObject:component.dataSource];
        }
        
    }
//    self.vc.done();
}


@end

