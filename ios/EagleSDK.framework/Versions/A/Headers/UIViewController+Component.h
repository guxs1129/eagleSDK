//
//  UIViewController+Component.h
//  LKG-SDK
//
//  Created by 潘涛 on 2017/3/13.
//  Copyright © 2017年 潘涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "Component.h"
#import "Dom.h"
#import "EagleUIWebView.h"
#import "Router.h"
#import "RouterManager.h"

#define mapRoute(route)\
+(void)load{\
     [[RouterManager shared].eagleMap setObject:NSStringFromClass([self class]) forKey:[RouterManager filterRoute:route]]; \
}\

typedef NS_ENUM(NSUInteger, DomOperation) {
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

@interface UIViewController (Component)<ComponentProtocol>

@property (nonatomic, assign) DeviceOrientation deviceOrientation;
@property (nonatomic, strong) Component *selfView;
@property (nonatomic, strong) Dom *dom;
@property (nonatomic, strong, readonly) NSMutableDictionary *map;
@property (nonatomic, strong) EagleUIWebView *eagleUIWebView;
@property (nonatomic, strong) NSString *route;

- (Component *(^)(NSArray <NSString *>*components, Flex flex))registerComponents;
- (Component *(^)(NSString *component, Flex flex, EGSize size, NSDictionary *params))addComponent;
- (Component *(^)(NSString *component, NSString *broComponentId, Flex flex, EGSize size, NSDictionary *params))insertComponent;
- (Component *(^)(NSArray <NSString *>*components))removeComponents;
- (Component *(^)(NSString *component))removeComponent;
- (Component *(^)(NSString *broComponentId))broComponentId;
- (Component *(^)(Flex flex))flex;
- (Component *(^)(EGSize))size;
- (NSArray *(^)(void))done;
- (Component *(^)(NSString *componentId))getComponent;

- (void)componentDealloc;

@end
