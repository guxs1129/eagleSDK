//
//  UIViewController+Component.h
//  LKG-SDK
//
//  Created by 潘涛 on 2017/3/13.
//  Copyright © 2017年 潘涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "EGComponent.h"
#import "EGDom.h"
#import "EGRouter.h"
#import "EGRouterManager.h"


#define mapRoute(route)\
+(void)load{\
     [[EGRouterManager shared].eagleMap setObject:NSStringFromClass([self class]) forKey:[EGRouterManager filterRoute:route]]; \
}\

//********** If in a module,use this Macro to map route **********/
#define moduleMapRoute(module,route)\
+(void)load{\
[[EGRouterManager shared].eagleMap setObject:NSStringFromClass([self class]) forKey:[EGRouterManager filterRoute:route]]; \
[[EGModuleManager manager]regitstModuleRouter:(module) vc:self router:(route)];\
}\


typedef NS_ENUM(NSUInteger, DomOperation) {
    // 不参与dom操作
    DomOperationNone,
    // 注册组件到dom中
    DomOperationRegister,
    // 添加组件到dom中
    DomOperationAdd,
    // 插入组件到dom中
    DomOperationInsert,
    // 从dom中移除组件
    DomOperationRemove
};

typedef NS_ENUM(NSInteger, DeviceOrientation) {
    DeviceOrientationVertical,// 竖屏
    DeviceOrientationHorizontal// 横屏
};

@interface UIViewController (EGComponent)<EGComponentProtocol>

@property (nonatomic, assign) DeviceOrientation deviceOrientation;
@property (nonatomic, strong) EGComponent *selfView;
@property (nonatomic, strong) EGDom *dom;
@property (nonatomic, strong, readonly) NSMutableDictionary *map;
@property (nonatomic, strong, readonly) NSMutableDictionary *map_id;
@property (nonatomic, strong, readonly) NSMutableDictionary *map_tag;
@property (nonatomic, strong, readonly) NSMutableDictionary *map_classname;
@property (nonatomic, strong) NSString *route;

- (EGComponent *(^)(NSString *component))initComponent;
- (EGComponent *(^)(NSArray <NSString *>*components, Flex flex))registerComponents;
- (EGComponent *(^)(NSString *component, Flex flex, EGSize size, NSDictionary *params))addComponent;
- (EGComponent *(^)(NSString *component, NSString *broComponentId, Flex flex, EGSize size, NSDictionary *params))insertComponent;
- (EGComponent *(^)(NSArray <NSString *>*components))removeComponents;
- (EGComponent *(^)(NSString *component))removeComponent;
- (EGComponent *(^)(NSString *broComponentId))broComponentId;
- (EGComponent *(^)(Flex flex))flex;
- (EGComponent *(^)(EGSize))size;
- (NSArray *(^)(void))done;
- (EGComponent *(^)(NSString *componentId))getComponentByComponentId;

- (EGComponent *(^)(NSString *))eg_id;
- (EGComponent *(^)(NSString *eg_id))getComponentById;
- (EGComponent *(^)(NSString *))eg_tag;
- (NSArray *(^)(NSString *eg_tag))getComponentsByTag;
- (NSArray *(^)(NSString *className))getComponentsByClassName;

- (void)componentDealloc;

@end
