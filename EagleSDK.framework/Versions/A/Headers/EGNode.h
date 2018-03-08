//
//  Node.h
//  eagle
//
//  Created by 潘涛 on 2017/10/12.
//  Copyright © 2017年 pantao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EGMacros.h"

typedef NS_ENUM(NSUInteger, Flex) {
    // 纵向排列
    FlexCloum  = 0,
    // 横向排列
    FlexRow
};

@interface EGNode : NSObject

@property (nonatomic, strong) NSString *componentId;// 内存地址字符串
@property (nonatomic, strong) NSString *componentId_super;// 父级组件内存地址字符串

@property (nonatomic, strong) NSString *component_instance_address;// 实例对象内存地址
@property (nonatomic, strong) NSString *component_cls_name;// 组件类名
@property (nonatomic, strong) NSString *component_superCls_name;// 父组件类名

@property (nonatomic, assign) int       level;// 节点层级
@property (nonatomic) CGRect frame;// default CGRectZero
@property (nonatomic) EGSize size;
@property (nonatomic) NSInteger idx;// 所在父级的下标
@property (nonatomic) Flex flex;// 布局方向
@property (nonatomic) CGPoint component_contentOffset; // default CGPointZero
@property (nonatomic) CGSize component_contentSize; // default CGSizeZero

@property (nonatomic, assign) NSString *eg_id;
@property (nonatomic, assign) NSString *eg_tag;

@end
