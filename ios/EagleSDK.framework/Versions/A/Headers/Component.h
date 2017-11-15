//
//  Component.h
//  OC's component
//
//  Created by 潘涛 on 2017/3/10.
//  Copyright © 2017年 潘涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Node.h"
#import "Eagle_macros.h"
#import "WebViewJavascriptBridge.h"
#import "EagleUIWebView.h"
@class Component;

typedef NS_ENUM(NSUInteger, Type) {
    // 注册组件
    TypeRegister,
    // 增加组件
    TypeAdd,
    // 插入组件
    TypeInsert,
    // 删除组件
    TypeRemove
};

@protocol ComponentProtocol <NSObject>

- (void)addSubcomponent:(Component *)component
         superComponent:(Component *)superComponent;
- (void)removeFromSuperviewComponent:(Component *)component;

- (void)vcRegisterComponents:(NSArray <NSString *>*)components
                componentIds:(NSArray <NSString *>*)componentIds
                      params:(NSDictionary *)params
                   addresses:(void(^)(NSArray *addresses))returnAddresses;
- (void)vcAddComponent:(NSArray <NSString *>*)component
          componentIds:(NSArray <NSString *>*)componentIds
                  flex:(Flex)flex
                  size:(EGSize)size
                params:(NSDictionary *)params
             addresses:(void(^)(NSArray *addresses))returnAddresses;
- (void)vcInsertComponent:(NSArray <NSString *>*)component
          componentIds:(NSArray <NSString *>*)componentIds
        broComponentId:(NSString *)broComponentId
                  flex:(Flex)flex
                  size:(EGSize)size
                params:(NSDictionary *)params
             addresses:(void(^)(NSArray *addresses))returnAddresses;
- (void)vcRemoveComponents:(NSArray <NSString *>*)components;
- (Component *)vcGetComponentById:(NSString *)componentId;
- (void)refreshContentSize:(Component *)component;
- (void)vcLayoutSubviews:(Component *)component;
- (void)vcResetSize:(EGSize)size component:(Component *)component;

@end

@interface Component : UIScrollView
/**
 VC对象的弱引用
 */
@property (nonatomic, weak)                  UIViewController *presentVC;

@property (nonatomic, strong)                Node *node;
@property (nonatomic, strong)                NSDictionary *params;
@property (nonatomic, weak)                  id<ComponentProtocol>protocol;

@property WebViewJavascriptBridge* bridge;
@property (nonatomic, strong)                EagleUIWebView *webView;
@property (nonatomic, strong)                NSString *url;

#pragma mark -- Component的生命周期

- (void)addOnSuperviewComponent __attribute__((objc_requires_super));
- (void)viewWillAppear:(BOOL)animated __attribute__((objc_requires_super));
- (void)viewDidAppear:(BOOL)animated __attribute__((objc_requires_super));
- (void)viewWillDisappear:(BOOL)animated __attribute__((objc_requires_super));
- (void)viewDidDisappear:(BOOL)animated __attribute__((objc_requires_super));
- (void)removeFromSuperviewComponent __attribute__((objc_requires_super));

#pragma mark -- 链式调用

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

#pragma mark -- 组件API

/**
 注册组件

 @param components      组件字符串数组@[@"类名"](在一个vc作用域内实例名称字符串唯一) e.g.@[@[@"testComponent"]
 @param componentIds    当同一类实例化多个对象时，实例名称数组，可传nil(传nil即该类所有实例化对象的实例名称)
 @param flex            布局方向(row--横向，cloum--纵向,应用于本身组件)
 @param size            尺寸(应用于本身组件)
 @param params          参数(尚未实现)
 */
- (void)registerComponents:(NSArray <NSString *>*)components
              componentIds:(NSArray <NSString *>*)componentIds
                      flex:(Flex)flex
                      size:(EGSize)size
                    params:(NSDictionary *)params
                 addresses:(void(^)(NSArray *addresses))returnAddresses;

/**
 添加组件

 @param component       组件字符串数组@[@"类名"](在一个vc作用域内实例名称字符串唯一) e.g.@[@[@"testComponent"]
 @param componentIds    当同一类实例化多个对象时，实例名称数组，可传nil(传nil即该类所有实例化对象的实例名称)
 @param flex            flex 布局方向(row--横向，cloum--纵向,应用于目标组件)
 @param size            尺寸(应用于目标组件)
 @param params          参数(尚未实现)
 @param returnAddresses 添加成功的组件内存地址字符串数组
 */
- (void)addComponent:(NSArray <NSString *>*)component
        componentIds:(NSArray <NSString *>*)componentIds
                flex:(Flex)flex
                size:(EGSize)size
              params:(NSDictionary *)params
           addresses:(void(^)(NSArray *addresses))returnAddresses;

/**
 插入组件到指定位置

 @param component       组件字符串数组@[@"类名"](在一个vc作用域内实例名称字符串唯一) e.g.@[@[@"testComponent"]
 @param componentIds    当同一类实例化多个对象时，实例名称数组，可传nil(传nil即该类所有实例化对象的实例名称)
 @param broComponentId  兄弟组件ComponentId(即插入到哪个组件之后)
 @param flex            flex 布局方向(row--横向，cloum--纵向,应用于目标组件)
 @param size            尺寸(应用于目标组件)
 @param params          参数(尚未实现)
 @param returnAddresses 添加成功的组件内存地址字符串数组
 */
- (void)insertComponent:(NSArray <NSString *>*)component
        componentIds:(NSArray <NSString *>*)componentIds
      broComponentId:(NSString *)broComponentId
                flex:(Flex)flex
                size:(EGSize)size
              params:(NSDictionary *)params
           addresses:(void(^)(NSArray *addresses))returnAddresses;

/**
 删除组件
 
 @param components      要删除的组件ComponentId数组
 */
- (void)removeComponents:(NSArray <NSString *>*)components;

/**
 通过componentId找到对应组件

 @param componentId     Component的内存地址字符串
 @return                Component
 */
- (Component *)getComponentById:(NSString *)componentId;

#pragma mark -- Public's methods

/**
 处理node

 @param component       component
 */
- (void)registerNode:(Component *)component;

@end
