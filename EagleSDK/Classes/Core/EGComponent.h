//
//  Component.h
//  OC's component
//
//  Created by 潘涛 on 2017/3/10.
//  Copyright © 2017年 潘涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGNode.h"
#import "EGMacros.h"
#import <Masonry/Masonry.h>
#import "EGComponentDefine.h"

#define egSkinFomat(keypath) [NSString stringWithFormat:@"components.%s.%@",class_getName([self class]),keypath]
@protocol EGViewModel<NSObject>

@end


@interface EGComponent : UIScrollView
/**
 VC对象的弱引用
 */
@property (nonatomic, weak)                  UIViewController *presentVC;
@property (nonatomic, strong)                UIView *container;

@property (nonatomic, strong)                EGNode *node;
@property (nonatomic, strong)                NSDictionary *params;
@property (nonatomic, weak)                  id<EGComponentProtocol>protocol;

@property (nonatomic, strong)                UIBarButtonItem *rightBarButtonItem;
@property (nonatomic, strong)                UIBarButtonItem *leftBarButtonItem;

#pragma mark -- Component的生命周期
- (void)componentInit;
- (instancetype)initWithPresentVC:(UIViewController *)presentVC;
- (void)addOnSuperviewComponent __attribute__((objc_requires_super));
- (void)viewWillAppear:(BOOL)animated __attribute__((objc_requires_super));
- (void)viewDidAppear:(BOOL)animated __attribute__((objc_requires_super));
- (void)viewWillDisappear:(BOOL)animated __attribute__((objc_requires_super));
- (void)viewDidDisappear:(BOOL)animated __attribute__((objc_requires_super));
- (void)removeFromSuperviewComponent __attribute__((objc_requires_super));

#pragma mark -- 链式调用

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

#pragma mark -- Public's methods

/**
 处理node

 @param component       component
 */
- (void)registerNode:(EGComponent *)component;


@end
