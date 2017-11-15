//
//  UIViewController+Component.m
//  LKG-SDK
//
//  Created by 潘涛 on 2017/3/13.
//  Copyright © 2017年 潘涛. All rights reserved.
//

#import "UIViewController+Component.h"
#import "Node.h"
#import "Eagle.h"

// 正序遍历dom数组
#define componentPerformSelector_clockwise( domArray )                                                  \
for (NSMutableArray *set in domArray) {                                                                 \
    for (Component *component in set) {                                                                 \
        component.protocol = self;                                                                      \
        SEL action = NSSelectorFromString(NSStringFromSelector(_cmd));                                  \
        if ([component respondsToSelector:action]) {                                                    \
            _Pragma("clang diagnostic push")                                                            \
            _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")                         \
            [component performSelector:action withObject:nil];                                          \
            _Pragma("clang diagnostic pop")                                                             \
        }                                                                                               \
    }                                                                                                   \
} 

// 逆向遍历dom数组
#define componentPerformSelector_counterclockwise( domArray )                                           \
if (domArray.count > 0) {                                                                               \
    for (int i = [[NSNumber numberWithInteger:domArray.count] intValue] - 1; i > -1; i--) {             \
        NSArray *set = (NSArray *)domArray[i];                                                              \
            for (Component *component in set) {                                                         \
                SEL action = NSSelectorFromString(NSStringFromSelector(_cmd));                          \
                if ([component respondsToSelector:action]) {                                            \
                    _Pragma("clang diagnostic push")                                                    \
                    _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")                 \
                    [component performSelector:action withObject:nil];                                  \
                    _Pragma("clang diagnostic pop")                                                     \
            }                                                                                           \
        }                                                                                               \
    }                                                                                                   \
}                                                                                                       \

#define EAGLEAssert(condition, description, ...) NSAssert(condition, description, ##__VA_ARGS__)
#define EAGLECAssert(condition, description, ...) NSCAssert(condition, description, ##__VA_ARGS__)


@implementation UIViewController (Component)

- (Component *)selfView
{
    return objc_getAssociatedObject(self, @selector(selfView));
    
}

- (void)setSelfView:(Component *)selfView
{
    objc_setAssociatedObject(self, @selector(selfView), selfView, OBJC_ASSOCIATION_RETAIN);
}

- (Dom *)dom
{
    return objc_getAssociatedObject(self, @selector(dom));
}

- (void)setDom:(Dom *)dom
{
    objc_setAssociatedObject(self, @selector(dom), dom, OBJC_ASSOCIATION_RETAIN);
}

- (NSString *)route
{
    return objc_getAssociatedObject(self, @selector(route));
}

- (void)setRoute:(NSString *)route
{
    objc_setAssociatedObject(self, @selector(route), route, OBJC_ASSOCIATION_RETAIN);
}

- (NSMutableDictionary *)map
{
    return objc_getAssociatedObject(self, @selector(map));
}

- (void)setMap:(NSMutableDictionary *)map
{
    objc_setAssociatedObject(self, @selector(map), map, OBJC_ASSOCIATION_RETAIN);
}

- (EagleUIWebView *)eagleUIWebView
{
    return objc_getAssociatedObject(self, @selector(eagleUIWebView));
}

- (void)setEagleUIWebView:(EagleUIWebView *)eagleUIWebView
{
    objc_setAssociatedObject(self, @selector(eagleUIWebView), eagleUIWebView, OBJC_ASSOCIATION_RETAIN);
}

- (DeviceOrientation)deviceOrientation
{
    NSNumber *number = objc_getAssociatedObject(self, @selector(deviceOrientation));
    return number ? [number integerValue] : DeviceOrientationVertical;
}

- (void)setDeviceOrientation:(DeviceOrientation)deviceOrientation
{
    objc_setAssociatedObject(self, @selector(deviceOrientation), @(deviceOrientation), OBJC_ASSOCIATION_RETAIN);
}

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        method_exchangeImplementations(class_getInstanceMethod(self, NSSelectorFromString(@"dealloc")), class_getInstanceMethod(self, @selector(componentDealloc)));
        method_exchangeImplementations(class_getInstanceMethod(self, @selector(loadView)), class_getInstanceMethod(self, @selector(componentLoadView)));
        method_exchangeImplementations(class_getInstanceMethod(self, @selector(viewDidLoad)), class_getInstanceMethod(self, @selector(componentViewDidLoad)));
        method_exchangeImplementations(class_getInstanceMethod(self, @selector(viewWillAppear:)), class_getInstanceMethod(self, @selector(componentViewWillAppear:)));
        method_exchangeImplementations(class_getInstanceMethod(self, @selector(viewDidAppear:)), class_getInstanceMethod(self, @selector(componentViewDidAppear:)));
        method_exchangeImplementations(class_getInstanceMethod(self, @selector(viewWillDisappear:)), class_getInstanceMethod(self, @selector(componentViewWillDisappear:)));
        method_exchangeImplementations(class_getInstanceMethod(self, @selector(viewDidDisappear:)), class_getInstanceMethod(self, @selector(componentViewDidDisappear:)));
    });
}

//+ (void)initialize
//{
////    EagleLog(@"---: %@",self);
//    if ([self conformsToProtocol:@protocol(RouterProtocol)]) {
////        EagleLog(@"===: %@",self);
//    }
//}

- (void)componentDealloc
{
    if (self.dom.domArray.count > 0) {
        for (int i = [[NSNumber numberWithInteger:self.dom.domArray.count] intValue] - 1; i > -1; i--) {
            NSArray *set = (NSArray *)self.dom.domArray[i];
            for (int i = 0; i < set.count; i++) {
                Component *component = set[i];
                [component removeFromSuperview];
            }
        }
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [self unsubscribeAll];
}

- (void)componentLoadView
{
//    self.view = [UIView new];
    self.selfView = [[Component alloc] init];
    self.selfView.protocol = self;
    self.selfView.backgroundColor = [UIColor clearColor];
    self.view = self.selfView;
    self.dom = [Dom new];
    self.dom.domArray = [NSMutableArray array];
    self.map = [NSMutableDictionary dictionary];
    [self.selfView registerNode:self.selfView];
    self.selfView.node.componentId_super = nil;
    [self addSubcomponent:self.selfView superComponent:nil];
}

- (void)componentViewDidLoad
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doRotateAction:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)doRotateAction:(NSNotification *)notification {
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait || [[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown) {
//        EagleLog(@"竖屏");
        self.deviceOrientation = DeviceOrientationVertical;
    } else if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight) {
//        EagleLog(@"横屏");
        self.deviceOrientation = DeviceOrientationHorizontal;
    }
}

#pragma mark -- 链式调用

- (Component *(^)(NSArray <NSString *>*components, Flex flex))registerComponents
{
    return ^Component *(NSArray <NSString *>*components, Flex flex) {
        return self.selfView.registerComponents(components, flex);
    };
}

- (Component *(^)(NSString *component, Flex flex, EGSize size, NSDictionary *params))addComponent
{
    return ^Component *(NSString *component, Flex flex, EGSize size, NSDictionary *params) {
        return self.selfView.addComponent(component, flex, size, params);
    };
}

- (Component *(^)(NSString *component, NSString *broComponentId, Flex flex, EGSize size, NSDictionary *params))insertComponent
{
    return ^Component *(NSString *component, NSString *broComponentId, Flex flex, EGSize size, NSDictionary *params) {
        return self.selfView.insertComponent(component, broComponentId, flex, size, params);
    };
}

- (Component *(^)(NSArray <NSString *>*components))removeComponents
{
    return ^Component *(NSArray <NSString *>*components) {
        return self.selfView.removeComponents(components);
    };
}

- (Component *(^)(NSString *component))removeComponent
{
    return ^Component *(NSString *component) {
        return self.selfView.removeComponent(component);
    };
}

- (Component *(^)(NSString *broComponentId))broComponentId
{
    return ^Component *(NSString * broComponentId) {
        return self.selfView.broComponentId(broComponentId);
    };
}

- (Component *(^)(Flex flex))flex
{
    return ^Component *(Flex flex) {
        return self.selfView.flex(flex);
    };
}

- (Component *(^)(EGSize))size
{
    return ^Component *(EGSize size) {
        return self.selfView.size(size);
    };
}

- (NSArray *(^)(void))done
{
    return ^NSArray *() {
        return self.selfView.done();
    };
}

- (Component *(^)(NSString *componentId))getComponent
{
    return ^Component *(NSString *componentId) {
        return self.selfView.getComponent(componentId);
    };
}

#pragma mark -- 处理Dom

- (BOOL)checkComponentExist:(Component *)component
{
    NSArray *domArray = [NSArray arrayWithArray:self.dom.domArray];
    for (NSMutableArray *set in domArray) {
        for (Component *componnet_temp in set) {
            NSString *assert = [NSString stringWithFormat:@"%@已存在",component.node.componentId];
            EAGLECAssert(![componnet_temp.node.componentId isEqualToString:component.node.componentId], assert, nil);
        }
    }
    return YES;
}

- (void)vcDealComponnetDomWithComponents:(NSArray <NSString *>*)components broComponentId:(NSString *)broComponentId componentIds:(NSArray <NSString *>*)componentIds flex:(Flex)flex size:(EGSize)size params:(NSDictionary *)params domOperation:(DomOperation)domOperation addresses:(void(^)(NSArray *addresses))returnAddresses
{
    NSMutableArray *addresses = [NSMutableArray array];
    for (NSString *component in components) {
        NSString *cptCls = component;// component类名
        Class cls = NSClassFromString(cptCls);
        NSString *assert = [NSString stringWithFormat:@"%@类不存在",cptCls];
        EAGLECAssert(cls, assert, nil);
        NSObject *target = [[cls alloc] init];
        if (![self checkComponentExist:(Component *)target]) {// 已存在
            return;
        }
        
        if (domOperation == DomOperationAdd || domOperation == DomOperationInsert) {
            ((Component *)target).node.frame = CGRectMake(0, 0, size.width, size.height);
            ((Component *)target).node.size = size;
            ((Component *)target).node.flex = flex;
        }
        NSArray *domArray = [NSArray arrayWithArray:self.dom.domArray];
        for (NSArray *set in domArray) {
            BOOL added = NO;// 若该实例对象被addSubview到父Component上需跳出domArray循环
            for (Component *cptSet in set) {
//                    if ([cptSet.node.component_instance_name isEqualToString:superCpt]) {
                    BOOL canAddSubview = NO;
                    if (componentIds) {
                        for (NSString *componentId in componentIds) {
                            if ([componentId isEqualToString:cptSet.node.componentId]) {
                                canAddSubview = YES;
                                break;
                            }
                        }
                    }else {
                        canAddSubview = YES;
                    }
                    if (canAddSubview) {
                        [cptSet addSubview:(Component *)target];
                        added = YES;
                        cptSet.node.idx = [set indexOfObject:cptSet];
                        
                        if (domOperation == DomOperationRegister) {
                            [(Component *)target addOnSuperviewComponent];
// *** frame ***************************************
                        }else if (domOperation == DomOperationAdd) {
                            [self setComponentFrame:(Component *)target];
                        }else if (domOperation == DomOperationInsert) {
                            [self insertComponentFrame:(Component *)target broComponentId:broComponentId];
                        }
// *** frame ***************************************
                    }
//                        break;
//                    }
            }
            if (added) {
                break;
            }
        }
        
        if (domOperation == DomOperationRegister || domOperation == DomOperationAdd) {
            for (NSMutableArray *set in self.dom.domArray) {
                for (Component *component in set) {
                    if ([component isEqual:((Component *)target)]) {
                        [addresses addObject:component.node.componentId];
                    }
                }
            }
        }else if (domOperation == DomOperationInsert) {// 修正dom
            if ([broComponentId hasPrefix:@"super"]) {
                broComponentId = [broComponentId substringWithRange:NSMakeRange(5, broComponentId.length - 5)];
                for (int i = 0; i < self.dom.domArray.count; i++) {
                    NSMutableArray *set = self.dom.domArray[i];
                    for (int j = 0; j < set.count; j++) {
                        Component *temp_component = set[j];
                        if ([temp_component.node.componentId_super isEqualToString:broComponentId]) {
                            Component *last_component = set[set.count - 1];
                            [set insertObject:last_component atIndex:0];
                            [set removeObjectAtIndex:set.count - 1];
                            [addresses addObject:last_component.node.componentId];
                            break;
                        }
                    }
                }
            }else {
                for (int i = 0; i < self.dom.domArray.count; i++) {
                    NSMutableArray *set = self.dom.domArray[i];
                    for (int j = 0; j < set.count; j++) {
                        Component *temp_component = set[j];
                        if ([temp_component.node.componentId isEqualToString:broComponentId]) {
                            Component *last_component = set[set.count - 1];
                            [set insertObject:last_component atIndex:j+1];
                            [set removeObjectAtIndex:set.count - 1];
                            [addresses addObject:last_component.node.componentId];
                            break;
                        }
                    }
                }
            }
        }
    }
    if (returnAddresses) {
       returnAddresses(addresses);
    }
}

// 重置Component's node.frame
- (void)resetNodeFrame:(Component *)component superComponet:(Component *)superComponet
{
    if (component.node.size.usePercent) {// 使用百分比布局
        CGRect frame = component.node.frame;
        frame.size.width = superComponet.frame.size.width *component.node.size.horizontal;
        frame.size.height = superComponet.frame.size.height *component.node.size.vertical;
        component.node.frame = frame;
    }
}

// 设置组件frame -- 增加组件
- (void)setComponentFrame:(Component *)component
{
    NSArray *set = nil;
    for (NSMutableArray *temp_set in self.dom.domArray) {
        for (Component *temp_component in temp_set) {
            if ([temp_component isEqual:component]) {
                set = [temp_set copy];
                break;
            }
        }
    }
    if (component.superview && [component.superview isKindOfClass:[Component class]] && set) {
        Component *superComponet = (Component *)component.superview;
        [self resetNodeFrame:component superComponet:superComponet];
        CGFloat X = 0;
        CGFloat Y = 0;
        if (set.count > 0) {
            Y = ((Component *)set[0]).frame.origin.y + ((Component *)set[0]).frame.size.height;
            X = ((Component *)set[0]).frame.origin.x + ((Component *)set[0]).frame.size.width;
        }
        // 遍历同级Component，计算X、Y
        for (Component *component_set in set) {
            if ([set indexOfObject:component_set] < set.count - 1 && [set indexOfObject:component_set] > 0) {
                Y = Y + component_set.node.frame.size.height;
                X = X + component_set.node.frame.size.width;
            }
        }
        if (superComponet.node.flex == FlexCloum && component.node.frame.size.height > 0) {// 竖向排列
            component.frame = CGRectMake(0, Y, component.node.frame.size.width, component.node.frame.size.height);
        }else if (superComponet.node.flex == FlexRow && component.node.frame.size.width > 0) {// 横向排列
            component.frame = CGRectMake(X, 0, component.node.frame.size.width, component.node.frame.size.height);
        }
        superComponet.showsVerticalScrollIndicator = NO;
        superComponet.showsHorizontalScrollIndicator = NO;
    }
}

// 设置组件frame -- 移除组件
- (void)removeComponentFrame:(Component *)component set:(NSArray *)set
{
    if (component.superview && [component.superview isKindOfClass:[Component class]]) {
        Component *superComponet = (Component *)component.superview;
        [self resetNodeFrame:component superComponet:superComponet];
        CGFloat X = component.node.frame.size.width;
        CGFloat Y = component.node.frame.size.height;
        // 拿出要移除组件的下标
        int idx = [[NSNumber numberWithInteger:[set indexOfObject:component]] intValue];
        // 遍历同级组件改变其frame
        for (int i = idx + 1; i < set.count; i++) {
            Component *component_set = set[i];
            if (superComponet.node.flex == FlexCloum) {// 竖向排列
                [component_set setFrame:CGRectMake(component_set.frame.origin.x, component_set.frame.origin.y - Y, component_set.frame.size.width, component_set.frame.size.height)];
            }else if (superComponet.node.flex == FlexRow) {// 横向排列
                [component_set setFrame:CGRectMake(component_set.frame.origin.x - X, component_set.frame.origin.y, component_set.frame.size.width, component_set.frame.size.height)];
            }
        }
        [component removeFromSuperview];
        component = nil;
        superComponet.showsVerticalScrollIndicator = NO;
        superComponet.showsHorizontalScrollIndicator = NO;
    }
}

// 插入组件frame -- 插入组件
- (void)insertComponentFrame:(Component *)component broComponentId:(NSString *)broComponentId
{
    Component *broComponent = nil;
    NSArray *set = nil;
    // 遍历dom，找出broComponent
    if ([broComponentId hasPrefix:@"super"]) {// 插在父组件的第一个位置，上面没有兄弟组件
        broComponentId = [broComponentId substringWithRange:NSMakeRange(5, broComponentId.length - 5)];
        for (NSMutableArray *temp_set in self.dom.domArray) {
            BOOL isFound = NO;
            for (Component *component_set in temp_set) {
                if ([component_set.node.componentId_super isEqualToString:broComponentId]) {
                    set = [temp_set copy];
                    isFound = YES;
                    break;
                }
            }
            if (isFound) {
                break;
            }
        }
        
        if (set && set.count > 0) {
            broComponent = component;
        }
    }else {
        for (NSMutableArray *temp_set in self.dom.domArray) {
            BOOL isFound = NO;
            for (Component *component_set in temp_set) {
                if ([component_set.node.componentId isEqualToString:broComponentId]) {
                    broComponent = component_set;
                    isFound = YES;
                    break;
                }
            }
            if (isFound) {
                break;
            }
        }
        
        for (NSMutableArray *temp_set in self.dom.domArray) {
            for (Component *temp_component in temp_set) {
                if ([temp_component isEqual:broComponent]) {
                    set = [temp_set copy];
                    break;
                }
            }
        }
    }
    
    if (broComponent) {// 有兄弟组件
        if (broComponent.superview && [broComponent.superview isKindOfClass:[Component class]] && set) {
            Component *superComponet = (Component *)broComponent.superview;
            [self resetNodeFrame:component superComponet:superComponet];
            CGFloat X = component.node.frame.size.width;
            CGFloat Y = component.node.frame.size.height;
            
            if (superComponet.node.flex == FlexCloum) {// 竖向排列
                [component setFrame:CGRectMake(0, broComponent.frame.origin.y + broComponent.frame.size.height, X, Y)];
            }else if (superComponet.node.flex == FlexRow) {// 横向排列
                [component setFrame:CGRectMake(broComponent.frame.origin.x + broComponent.frame.size.width, 0, X, Y)];
            }
            broComponent.backgroundColor = [UIColor whiteColor];
            
            // 拿出兄弟组件的下标
            int broIdx = [[NSNumber numberWithInteger:[set indexOfObject:broComponent]] intValue];
            if ([broComponent isEqual:component]) {// 插入到第一位
                broIdx = -1;
            }
            // 遍历同级组件改变其frame
            for (int i = broIdx + 1; i < set.count - 1; i++) {
                Component *component_set = set[i];
                if (superComponet.node.flex == FlexCloum) {// 竖向排列
                    [component_set setFrame:CGRectMake(component_set.frame.origin.x, component_set.frame.origin.y + Y, component_set.frame.size.width, component_set.frame.size.height)];
                }else if (superComponet.node.flex == FlexRow) {// 横向排列
                    [component_set setFrame:CGRectMake(component_set.frame.origin.x + X, component_set.frame.origin.y, component_set.frame.size.width, component_set.frame.size.height)];
                }
            }
            superComponet.showsVerticalScrollIndicator = NO;
            superComponet.showsHorizontalScrollIndicator = NO;
        }
    }
}

#pragma mark -- ComponentProtocol

- (void)vcRegisterComponents:(NSArray <NSString *>*)components componentIds:(NSArray <NSString *>*)componentIds params:(NSDictionary *)params addresses:(void(^)(NSArray *addresses))returnAddresses
{
    [self vcDealComponnetDomWithComponents:components broComponentId:nil componentIds:componentIds flex:FlexCloum size:EGSizeMake(NO, 0, 0, 0, 0) params:params domOperation:DomOperationRegister addresses:returnAddresses];
}

- (void)vcAddComponent:(NSArray<NSString *> *)component componentIds:(NSArray<NSString *> *)componentIds flex:(Flex)flex size:(EGSize)size params:(NSDictionary *)params addresses:(void(^)(NSArray *addresses))returnAddresses
{
    [self vcDealComponnetDomWithComponents:component broComponentId:nil componentIds:componentIds flex:flex size:size params:params domOperation:DomOperationAdd addresses:returnAddresses];
}

- (void)vcInsertComponent:(NSArray<NSString *> *)component componentIds:(NSArray<NSString *> *)componentIds broComponentId:(NSString *)broComponentId flex:(Flex)flex size:(EGSize)size params:(NSDictionary *)params addresses:(void (^)(NSArray *))returnAddresses
{
    // 先将要插入的组件初始实例化，并addsubview到父级组件
    [self vcDealComponnetDomWithComponents:component broComponentId:broComponentId componentIds:componentIds flex:FlexCloum size:size params:params domOperation:DomOperationInsert addresses:returnAddresses];
}

- (void)vcRemoveComponents:(NSArray <NSString *>*)components
{
    for (NSString *removeComponentId in components) {
        for (NSMutableArray *set in self.dom.domArray) {
            BOOL isFound = NO;
            for (int i = 0; i < set.count; i++) {
                Component *component = (Component *)set[i];
                if ([component.node.componentId isEqualToString:removeComponentId]) {
                    [self removeComponentFrame:component set:set];
                    [set removeObject:component];
                    isFound = YES;
                    break;
                }
            }
            if (isFound) {
                break;
            }
        }
    }
}

- (Component *)vcGetComponentById:(NSString *)componentId
{
    return (Component *)self.map[componentId];
}

// 更新ContentSize
- (void)refreshContentSize:(Component *)component
{
    NSArray *set = nil;
    for (NSMutableArray *temp_set in self.dom.domArray) {
        for (Component *temp_component in temp_set) {
            if ([temp_component.node.componentId isEqualToString:component.node.componentId]) {
                set = [temp_set copy];
                break;
            }
        }
    }
    if ([component.superview isKindOfClass:[Component class]]) {
        Component *superComponent = (Component *)component.superview;
        if (set) {
            CGFloat Height = 0;
            CGFloat Width = 0;
            for (Component *temp_component in set) {
                if (superComponent.node.flex == FlexCloum) {// 纵向布局
                    Width = MAX(superComponent.node.component_contentSize.width, temp_component.frame.size.width);
                    Height = MAX(Height, temp_component.frame.origin.y + temp_component.frame.size.height);
                }else if (superComponent.node.flex == FlexRow) {// 横向布局
                    Width = MAX(Width, temp_component.frame.origin.x + temp_component.frame.size.width);
                    Height = MAX(superComponent.node.component_contentSize.height, temp_component.frame.size.height);
                }
            }
            superComponent.node.component_contentSize = CGSizeMake(Width, Height);
            [superComponent setContentSize:superComponent.node.component_contentSize];
        }
    }
}

// layoutSubviews
- (void)vcLayoutSubviews:(Component *)component
{
    NSArray *subComponentSet = nil;
    for (NSMutableArray *set in self.dom.domArray) {
        BOOL isFound = NO;
        for (Component *component_set in set) {
            if ([component_set.node.componentId_super isEqualToString:component.node.componentId]) {
                subComponentSet = [NSArray arrayWithArray:set];
                isFound = YES;
                break;
            }
        }
        if (isFound) {
            break;
        }
    }
    
    if (subComponentSet) {
        for (int i = 0; i < subComponentSet.count; i++) {
            Component *subComponent = (Component *)subComponentSet[i];
            [self resetNodeFrame:subComponent superComponet:component];
            CGFloat X = subComponent.frame.origin.x;
            CGFloat Y = subComponent.frame.origin.y;
            if (i > 0) {
                if (component.node.flex == FlexCloum) {// 父组件是纵向布局，则y坐标需变
                    Component *lastComponent = (Component *)subComponentSet[i - 1];
                    Y = lastComponent.frame.origin.y + lastComponent.frame.size.height;
                }else if (component.node.flex == FlexRow) {// 父组件是横向布局，则x坐标需变
                    Component *lastComponent = (Component *)subComponentSet[i - 1];
                    X = lastComponent.frame.origin.x + lastComponent.frame.size.width;
                }
            }
            CGRect frame = subComponent.node.frame;
            frame.origin.x = X;
            frame.origin.y = Y;
            subComponent.node.frame = frame;
            [subComponent setFrame:subComponent.node.frame];
        }
    }
}

- (void)vcResetSize:(EGSize)size component:(Component *)component
{
    if (size.usePercent && [component.superview isKindOfClass:[Component class]]) {// 使用百分比布局
        Component *superComponet = (Component *)component.superview;
        if ([superComponet isEqual:self.selfView]) {
            CGRect superFrame = superComponet.node.frame;
            superFrame.size.width = [UIScreen mainScreen].bounds.size.width;
            superFrame.size.height = [UIScreen mainScreen].bounds.size.height;
            superComponet.node.frame = superFrame;
        }
        CGRect frame = component.node.frame;
        frame.size.width = superComponet.node.frame.size.width *size.horizontal;
        frame.size.height = superComponet.node.frame.size.height *size.vertical;
        component.node.frame = frame;
        [component setFrame:frame];
    }
}

#pragma mark -- Component生命周期

// 组件将要展示
- (void)componentViewWillAppear:(BOOL)animated
{
    componentPerformSelector_clockwise(self.dom.domArray);
}

// 组件已经展示
- (void)componentViewDidAppear:(BOOL)animated
{
    componentPerformSelector_clockwise(self.dom.domArray);
}

// 组件将要消失
- (void)componentViewWillDisappear:(BOOL)animated
{
    componentPerformSelector_counterclockwise(self.dom.domArray);
}

// 组件已经消失
- (void)componentViewDidDisappear:(BOOL)animated
{
    componentPerformSelector_counterclockwise(self.dom.domArray);
}

- (void)addSubcomponent:(Component *)component superComponent:(Component *)superComponent
{
    Node *node = component.node;
    [self.map setObject:component forKey:component.node.componentId];
    int level = node.level;
    if (level < self.dom.domArray.count) {// 已有层级
        NSMutableArray *set = (NSMutableArray *)self.dom.domArray[level];
        [set addObject:component];
    }else {// 新增层级
        NSMutableArray *set = [NSMutableArray array];
        [set addObject:component];
        [self.dom.domArray addObject:set];
    }
    component.protocol = self;
}

- (void)removeFromSuperviewComponent:(Component *)component
{
    for (NSMutableArray *set in self.dom.domArray) {
        for (int i = 0; i < set.count; i++) {
            Component *componentSet = set[i];
            if ([componentSet.node.componentId_super isEqualToString:component.node.componentId]) {// 父组件是被移除组件
                [component unsubscribeAll];
                [componentSet removeFromSuperviewComponent];
                componentSet = nil;
                componentSet.protocol = nil;
            }
        }
    }
    component = nil;
    component.protocol = nil;
}

@end
