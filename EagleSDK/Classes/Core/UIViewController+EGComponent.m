//
//  UIViewController+Component.m
//  LKG-SDK
//
//  Created by 潘涛 on 2017/3/13.
//  Copyright © 2017年 潘涛. All rights reserved.
//

#import "UIViewController+EGComponent.h"
#import "EGNode.h"

#import "Masonry.h"

// 正序遍历dom数组
#define componentPerformSelector_clockwise( domArray )                                                  \
for (NSMutableArray *set in domArray) {                                                                 \
    for (EGComponent *component in set) {                                                                 \
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
            for (EGComponent *component in set) {                                                         \
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


@implementation UIViewController (EGComponent)

- (EGComponent *)selfView
{
    return objc_getAssociatedObject(self, @selector(selfView));
    
}

- (void)setSelfView:(EGComponent *)selfView
{
    objc_setAssociatedObject(self, @selector(selfView), selfView, OBJC_ASSOCIATION_RETAIN);
}

- (EGDom *)dom
{
    return objc_getAssociatedObject(self, @selector(dom));
}

- (void)setDom:(EGDom *)dom
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

- (NSMutableDictionary *)map_id
{
    return objc_getAssociatedObject(self, @selector(map_id));
}

- (void)setMap_id:(NSMutableDictionary *)map_id
{
    objc_setAssociatedObject(self, @selector(map_id), map_id, OBJC_ASSOCIATION_RETAIN);
}

- (NSMutableDictionary *)map_tag
{
    return objc_getAssociatedObject(self, @selector(map_tag));
}

- (void)setMap_tag:(NSMutableDictionary *)map_tag
{
    objc_setAssociatedObject(self, @selector(map_tag), map_tag, OBJC_ASSOCIATION_RETAIN);
}

- (NSMutableDictionary *)map_classname
{
    return objc_getAssociatedObject(self, @selector(map_classname));
}

- (void)setMap_classname:(NSMutableDictionary *)map_classname
{
    objc_setAssociatedObject(self, @selector(map_classname), map_classname, OBJC_ASSOCIATION_RETAIN);
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
    [[EGRouterManager shared].eagleMap setObject:NSStringFromClass([self class]) forKey:[EGRouterManager filterRoute:@"eagle://vc?"]];
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
    [self unsubscribeAll];
    if (self.dom.domArray.count > 0) {
        for (int i = [[NSNumber numberWithInteger:self.dom.domArray.count] intValue] - 1; i > -1; i--) {
            NSArray *set = (NSArray *)self.dom.domArray[i];
            for (int i = 0; i < set.count; i++) {
                EGComponent *component = set[i];
                [component removeFromSuperview];
            }
        }
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    
}

- (void)componentLoadView
{
    self.view = [UIView new];
    self.selfView = [[EGComponent alloc] init];
    self.selfView.protocol = self;
    self.selfView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.selfView];
    [self.selfView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.width.height.equalTo(self.view);
    }];
    
    self.selfView.container = [UIView new];
    [self.selfView addSubview:self.selfView.container];
    [self.selfView.container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.selfView);
        make.width.height.equalTo(self.selfView);
    }];
    [self.selfView sendSubviewToBack:self.selfView.container];
    
    self.dom = [EGDom new];
    self.dom.domArray = [NSMutableArray array];
    self.map = [NSMutableDictionary dictionary];
    self.map_id = [NSMutableDictionary dictionary];
    self.map_tag = [NSMutableDictionary dictionary];
    self.map_classname = [NSMutableDictionary dictionary];
    [self.selfView registerNode:self.selfView];
    self.selfView.node.componentId_super = nil;
    [self addSubcomponent:self.selfView superComponent:nil];
}

- (void)componentViewDidLoad
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doRotateAction:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    [[EGVCJsonBuilderManager manager]build:self];
    
    
    if ([self bindViewModel]) {
        NSLog(@"Viewmodel [%@] has bind to controller [%@].",self.viewModel,self);
        @eg_weakify(self)
        [self subscribe:EGViewModel_UIAction_Channel withBlock:^(id msg) {
            @eg_strongify(self)
            NSDictionary *msgDict=(NSDictionary *)msg;
            EGViewModel *vm=[msgDict objectForKey:@"viewmodel"];
            if (vm!=self.viewModel) {
                return ;
            }
            EGUIActionBlock blk=[msgDict objectForKey:@"action"];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (blk) {
                    blk(self);
                }
            });
        }];
    } else {
        NSLog(@"Failed to bind viewmodel to controller [%@].",self);
    }
}

#pragma mark -- ViewModel

/**
If not build from json,viewmodel will bind in this way.

 @return BOOL flag
 */
-(BOOL)bindViewModel{
    EGViewModel *viewmodel=nil;
    BOOL flag=NO;
    if (self.viewModel) {
        flag = YES;
    } else {
        NSString *vcName=NSStringFromClass([self class]);
        Class vmClazz=[[EGModuleManager manager]viewModelClassForVC:vcName];
        if (!vmClazz) {
            NSArray *vmArr=[[EGModuleManager manager]viewModelArrayForVC:vcName];
            if (vmArr) {
                if (vmArr.count==1) {
                    vmClazz=[vmArr firstObject];
                }else if(vmArr.count>1) {
                    @throw [NSException exceptionWithName:@"<ViewModel Error>" reason:[NSString stringWithFormat:@"Controller [ %@ ] has multi viewmodels binds. Bind the target in bindMap.plist.",vcName] userInfo:@{NSUnderlyingErrorKey:vmArr}];
                }
            }
        }
        if (vmClazz) {
            viewmodel=[[vmClazz alloc]init];
        }
    }
    if (viewmodel && [self viewmodelIsValid:viewmodel]) {
        self.viewModel=viewmodel;
        flag = YES;
    }
    return flag;
}

//Check viewmodel
-(BOOL)viewmodelIsValid:(EGViewModel *)viewmodel{
    BOOL flag=YES;
    for (UIView *subView in self.selfView.subviews) {
        if ([subView isKindOfClass:[EGComponent class]]) {
            NSString *componentName=NSStringFromClass([subView class]);
            Protocol *componentProtocol = NSProtocolFromString(componentName);
            if (componentProtocol && ![viewmodel conformsToProtocol:componentProtocol]) {
                flag=NO;
                break;
            }
        }
    }
    return flag;
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

- (EGComponent *(^)(NSString *component))initComponent
{
    return ^EGComponent *(NSString *component) {
        return self.selfView.initComponent(component);
    };
}

- (EGComponent *(^)(NSArray <NSString *>*components, Flex flex))registerComponents
{
    return ^EGComponent *(NSArray <NSString *>*components, Flex flex) {
        return self.selfView.registerComponents(components, flex);
    };
}

- (EGComponent *(^)(NSString *component, Flex flex, EGSize size, NSDictionary *params))addComponent
{
    return ^EGComponent *(NSString *component, Flex flex, EGSize size, NSDictionary *params) {
        return self.selfView.addComponent(component, flex, size, params);
    };
}

- (EGComponent *(^)(NSString *component, NSString *broComponentId, Flex flex, EGSize size, NSDictionary *params))insertComponent
{
    return ^EGComponent *(NSString *component, NSString *broComponentId, Flex flex, EGSize size, NSDictionary *params) {
        return self.selfView.insertComponent(component, broComponentId, flex, size, params);
    };
}

- (EGComponent *(^)(NSArray <NSString *>*components))removeComponents
{
    return ^EGComponent *(NSArray <NSString *>*components) {
        return self.selfView.removeComponents(components);
    };
}

- (EGComponent *(^)(NSString *component))removeComponent
{
    return ^EGComponent *(NSString *component) {
        return self.selfView.removeComponent(component);
    };
}

- (EGComponent *(^)(NSString *broComponentId))broComponentId
{
    return ^EGComponent *(NSString * broComponentId) {
        return self.selfView.broComponentId(broComponentId);
    };
}

- (EGComponent *(^)(Flex flex))flex
{
    return ^EGComponent *(Flex flex) {
        return self.selfView.flex(flex);
    };
}

- (EGComponent *(^)(EGSize))size
{
    return ^EGComponent *(EGSize size) {
        return self.selfView.size(size);
    };
}

- (NSArray *(^)(void))done
{
    return ^NSArray *() {
        return self.selfView.done();
    };
}

- (EGComponent *(^)(NSString *componentId))getComponentByComponentId
{
    return ^EGComponent *(NSString *componentId) {
        return self.selfView.getComponentByComponentId(componentId);
    };
}

- (EGComponent *(^)(NSString *))eg_id
{
    return ^EGComponent *(NSString *eg_id) {
        return self.selfView.eg_id(eg_id);
    };
}

- (EGComponent *(^)(NSString *eg_id))getComponentById
{
    return ^EGComponent *(NSString *eg_id) {
        return self.selfView.getComponentById(eg_id);
    };
}

- (EGComponent *(^)(NSString *))eg_tag
{
    return ^EGComponent *(NSString *eg_tag) {
        return self.selfView.eg_tag(eg_tag);
    };
}

- (NSArray *(^)(NSString *eg_tag))getComponentsByTag
{
    return ^NSArray *(NSString *eg_tag) {
        return self.selfView.getComponentsByTag(eg_tag);
    };
}

- (NSArray *(^)(NSString *className))getComponentsByClassName
{
    return ^NSArray *(NSString *className) {
        return self.selfView.getComponentsByClassName(className);
    };
}

#pragma mark -- 处理Dom

- (BOOL)checkComponentExist:(EGComponent *)component
{
    NSArray *domArray = [NSArray arrayWithArray:self.dom.domArray];
    for (NSMutableArray *set in domArray) {
        for (EGComponent *componnet_temp in set) {
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
        NSObject *target = [[cls alloc] initWithPresentVC:self];
        if (![self checkComponentExist:(EGComponent *)target]) {// 已存在
            return;
        }
        
        if (domOperation == DomOperationAdd || domOperation == DomOperationInsert) {
            ((EGComponent *)target).node.frame = CGRectMake(0, 0, size.width, size.height);
            ((EGComponent *)target).node.size = size;
            ((EGComponent *)target).node.flex = flex;
        }else if (domOperation == DomOperationNone) {
            [((EGComponent *)target) registerNode:((EGComponent *)target)];
            [addresses addObject:((EGComponent *)target)];
            if (returnAddresses) {
                returnAddresses(addresses);
            }
            return;
        }
        NSArray *domArray = [NSArray arrayWithArray:self.dom.domArray];
        for (NSArray *set in domArray) {
            BOOL added = NO;// 若该实例对象被addSubview到父Component上需跳出domArray循环
            for (EGComponent *cptSet in set) {
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
                        [cptSet addSubview:(EGComponent *)target];
                        added = YES;
                        cptSet.node.idx = [set indexOfObject:cptSet];
                        
                        [(EGComponent *)target addOnSuperviewComponent];
                        if (domOperation == DomOperationRegister) {
                            
// *** frame ***************************************
                        }else if (domOperation == DomOperationAdd) {
                            [self setComponentFrame:(EGComponent *)target];
                        }else if (domOperation == DomOperationInsert) {
                            [self insertComponentFrame:(EGComponent *)target broComponentId:broComponentId set:set];
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
                for (EGComponent *component in set) {
                    if ([component isEqual:((EGComponent *)target)]) {
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
                        EGComponent *temp_component = set[j];
                        if ([temp_component.node.componentId_super isEqualToString:broComponentId]) {
                            EGComponent *last_component = set[set.count - 1];
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
                        EGComponent *temp_component = set[j];
                        if ([temp_component.node.componentId isEqualToString:broComponentId]) {
                            EGComponent *last_component = set[set.count - 1];
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
- (void)resetNodeFrame:(EGComponent *)component superComponet:(EGComponent *)superComponet
{
    if (component.node.size.usePercent) {// 使用百分比布局
        CGRect frame = component.node.frame;
        frame.size.width = superComponet.frame.size.width *component.node.size.horizontal;
        frame.size.height = superComponet.frame.size.height *component.node.size.vertical;
        component.node.frame = frame;
    }
}

/**
 masonry remake

 @param component       该component
 @param superComponent  父component
 @param lastComponent   前面一个component
 */
- (void)remakeMasonryLayout:(EGComponent *)component superComponent:(EGComponent *)superComponent lastComponent:(EGComponent *)lastComponent
{
    [component mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (superComponent.node.flex == FlexCloum) {// 竖向排列
            make.left.equalTo(superComponent);
            if (lastComponent) {
                make.top.equalTo(lastComponent.mas_bottom);
            }else {
                make.top.equalTo(superComponent);
            }
        }else if (superComponent.node.flex == FlexRow) {// 横向
            if (lastComponent) {
                make.left.equalTo(lastComponent.mas_right);
            }else {
                make.left.equalTo(superComponent);
            }
            make.top.equalTo(superComponent);
        }
        if (component.node.size.usePercent) {// 使用百分比布局
            make.width.equalTo(superComponent).multipliedBy(component.node.size.horizontal);
            make.height.equalTo(superComponent).multipliedBy(component.node.size.vertical);
        }else {
            make.width.mas_equalTo(component.node.size.width);
            make.height.mas_equalTo(component.node.size.height);
        }
    }];
    [component setNeedsLayout];
    [component layoutIfNeeded];
    [component.container mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(component);
        make.width.height.equalTo(component);
    }];
}

/**
 remake约束的逻辑处理

 @param component       该component
 @param broComponentId  兄弟component
 @param domOperation    操作类型
 @return                结果
 */
- (BOOL)remakeAutoLayout:(EGComponent *)component broComponentId:(NSString *)broComponentId domOperation:(DomOperation)domOperation
{
    NSArray *set = [self getSet:component];
    if (component.superview && [component.superview isKindOfClass:[EGComponent class]] && set) {
        EGComponent *superComponet = (EGComponent *)component.superview;
        EGComponent *lastComponent = nil;
        NSInteger idx = 0;
        EGComponent *tempComponent = component;
        if (domOperation == DomOperationInsert) {
            if ([broComponentId hasPrefix:@"super"]) {// 插在父组件的第一个位置，上面没有兄弟组件
                broComponentId = [broComponentId substringWithRange:NSMakeRange(5, broComponentId.length - 5)];
            }
            lastComponent = [self vcGetComponentById:broComponentId];
            if ([lastComponent isEqual:superComponet]) {
                lastComponent = nil;
            }else {
                idx = [set indexOfObject:lastComponent];
            }
            [self remakeMasonryLayout:tempComponent superComponent:superComponet lastComponent:lastComponent];// 布局要插入的component
            if (idx+1 < set.count) {
                [self remakeMasonryLayout:set[idx + 1] superComponent:superComponet lastComponent:tempComponent];// 修改插入component的后面一个component的布局
            }
        }else {
            idx = [set indexOfObject:component];
            if (idx > 0) {
                lastComponent = set[idx - 1];
            }
            if (domOperation == DomOperationRemove) {
                if (set.count < 2) {// 当同级有且只有这一个component被移除时，无需考虑约束
                    return YES;
                }
                tempComponent = set[idx + 1];
            }
            [self remakeMasonryLayout:tempComponent superComponent:superComponet lastComponent:lastComponent];
        }
        
        superComponet.showsVerticalScrollIndicator = NO;
        superComponet.showsHorizontalScrollIndicator = NO;
        return YES;
    }
    return NO;
}

/**
 获取component所在级数组

 @param component 该component
 @return          所在级数组
 */
- (NSArray *)getSet:(EGComponent *)component
{
    for (NSArray *tempArray in self.dom.domArray) {
        for (EGComponent *tempCp in tempArray) {
            if ([tempCp.node.componentId isEqualToString:component.node.componentId]) {
                return tempArray;
            }
        }
    }
    return nil;
}

// 设置组件frame -- 增加组件
- (void)setComponentFrame:(EGComponent *)component
{
    [self remakeAutoLayout:component broComponentId:nil domOperation:DomOperationAdd];
}

// 设置组件frame -- 移除组件
- (BOOL)removeComponentFrame:(EGComponent *)component set:(NSArray *)set
{
    BOOL removed = [self remakeAutoLayout:component broComponentId:nil domOperation:DomOperationRemove];
    if (removed) {
        [component removeFromSuperview];
        component = nil;
    }
    return removed;
}

// 插入组件frame -- 插入组件
- (void)insertComponentFrame:(EGComponent *)component broComponentId:(NSString *)broComponentId set:(NSArray *)set
{
    [self remakeAutoLayout:component broComponentId:broComponentId domOperation:DomOperationInsert];
}

#pragma mark -- ComponentProtocol

- (void)vcInitComponent:(NSString *)component addresses:(void (^)(NSArray *))returnAddresses
{
    [self vcDealComponnetDomWithComponents:@[component] broComponentId:nil componentIds:nil flex:FlexCloum size:EGSizeMake(NO, 0, 0, 0, 0) params:nil domOperation:DomOperationNone addresses:returnAddresses];
}

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
                EGComponent *component = (EGComponent *)set[i];
                if ([component.node.componentId isEqualToString:removeComponentId]) {
                    if ([self removeComponentFrame:component set:set]) {
                        [set removeObject:component];
                    }
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

- (EGComponent *)vcGetComponentByComponentId:(NSString *)componentId
{
    return (EGComponent *)self.map[componentId];
}

// 更新ContentSize
- (void)refreshContentSize:(EGComponent *)component
{
    NSArray *set = [self getSet:component];
    if ([component.superview isKindOfClass:[EGComponent class]]) {
        EGComponent *superComponent = (EGComponent *)component.superview;
        if (set) {
            CGFloat Height = 0;
            CGFloat Width = 0;
            for (EGComponent *temp_component in set) {
                if (superComponent.node.flex == FlexCloum) {// 纵向布局
                    Width = MAX(Width, temp_component.frame.size.width);
                    Height = MAX(Height, temp_component.frame.origin.y + temp_component.frame.size.height);
                }else if (superComponent.node.flex == FlexRow) {// 横向布局
                    Width = MAX(Width, temp_component.frame.origin.x + temp_component.frame.size.width);
                    Height = MAX(Height, temp_component.frame.size.height);
                }
            }
            superComponent.node.component_contentSize = CGSizeMake(Width, Height);
            dispatch_async(dispatch_get_main_queue(), ^{
                [superComponent.container mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(superComponent);
                    make.width.mas_equalTo(Width);
                    make.height.mas_equalTo(Height);
                }];
            });
        }
    }
}

/**
 reset component's frame

 @param size        new size
 @param component   component
 */
- (void)vcResetSize:(EGSize)size component:(EGComponent *)component
{
    NSArray *set = [self getSet:component];
    if (component.superview && [component.superview isKindOfClass:[EGComponent class]] && set) {
        EGComponent *superComponet = (EGComponent *)component.superview;
        EGComponent *lastComponent = nil;
        NSInteger idx = [set indexOfObject:component];
        if (idx > 0) {
            lastComponent = set[idx - 1];
        }
        [self remakeMasonryLayout:component superComponent:superComponet lastComponent:lastComponent];
    }else if (!set && !size.usePercent) {// 这种情况一般是没有添加到dom树内，而是EGComponent只作为一个组件容器来开发，可能都并没有添加到任何一个视图上，所以只能用setFrame
        [component setFrame:CGRectMake(0, 0, size.width, size.height)];
    }
}

- (void)vcSetId:(NSString *)Id forComponent:(EGComponent *)component
{
    if (!Id) {
        return;
    }
    EAGLECAssert(![self.map_id.allKeys containsObject:Id], ([NSString stringWithFormat:@"该Id(%@)已绑定过component",Id]), nil);
    [self.map_id setObject:component forKey:Id];
}

- (EGComponent *)vcGetComponentById:(NSString *)Id
{
    return (EGComponent *)[self.map_id objectForKey:Id];
}

- (void)vcSetTag:(NSString *)Tag forComponent:(EGComponent *)component
{
    if (!Tag) {
        return;
    }
    NSMutableArray *temp = [self.map_tag objectForKey:Tag];
    if (temp) {
        for (EGComponent *cp in temp) {
            if ([cp isEqual:component]) {
                return;
            }
        }
    }else {
        temp = [NSMutableArray array];
    }
    [temp addObject:component];
    [self.map_tag setObject:temp forKey:Tag];
}

- (NSArray *)vcGetComponentsByTag:(NSString *)Tag
{
    return [(NSMutableArray *)[self.map_tag objectForKey:Tag] copy];
}

- (NSArray *)vcGetComponentsByClassName:(NSString *)className
{
    return [(NSMutableArray *)[self.map_classname objectForKey:className] copy];
}

- (void)setComponentsWithClassName:(EGComponent *)component
{
    NSMutableArray *temp = [self.map_classname objectForKey:component.node.component_cls_name];
    if (temp) {
        for (EGComponent *cp in temp) {
            if ([cp isEqual:component]) {
                return;
            }
        }
    }else {
        temp = [NSMutableArray array];
    }
    [temp addObject:component];
    [self.map_classname setObject:temp forKey:component.node.component_cls_name];
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

#pragma mark -- Component add & remove

- (void)addSubcomponent:(EGComponent *)component superComponent:(EGComponent *)superComponent
{
    EGNode *node = component.node;
    [self.map setObject:component forKey:component.node.componentId];
    [self setComponentsWithClassName:component];
    int level = node.level;
    if (level < self.dom.domArray.count) {// 已有层级
        NSMutableArray *set = (NSMutableArray *)self.dom.domArray[level];
        [set addObject:component];
    }else {// 新增层级
        NSMutableArray *set = [NSMutableArray array];
        [set addObject:component];
        [self.dom.domArray addObject:set];
    }
}

- (void)removeFromSuperviewComponent:(EGComponent *)component
{
    for (NSMutableArray *set in self.dom.domArray) {
        for (int i = 0; i < set.count; i++) {
            EGComponent *componentSet = set[i];
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
