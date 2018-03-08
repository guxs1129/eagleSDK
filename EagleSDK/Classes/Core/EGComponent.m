//
//  Component.m
//  OC's component
//
//  Created by 潘涛 on 2017/3/10.
//  Copyright © 2017年 潘涛. All rights reserved.
//

#import "EGComponent.h"
#import <objc/runtime.h>
#import "EGPopView.h"

#define kPopViewBGColor                        [UIColor colorWithRed:0.28 green:0.28 blue:0.29 alpha:1.00]
#define kCellheight                            45.f
#define kContentVWidth                         120.f

@interface EGComponent ()

//NSArray <NSString *>* components, Flex flex, CGSize size, NSDictionary *params
@property (nonatomic, strong)                  NSArray <NSString *>* _components;
@property (nonatomic, strong)                  NSString *_broComponentId;
@property (nonatomic, getter=setDefaultFlex)   Flex _flex;
@property (nonatomic)                          EGSize _size;
@property (nonatomic)                          Type _type;
@property (nonatomic, strong)                  NSMutableArray <NSString *>*_addresses_init;
@property (nonatomic, strong)                  NSMutableArray <NSString *>*_addresses_register;
@property (nonatomic, strong)                  NSMutableArray <NSString *>*_addresses_add;
@property (nonatomic, strong)                  NSMutableArray <NSString *>*_addresses_insert;

@property (nonatomic, strong)                  NSString *_eg_id;
@property (nonatomic, strong)                  NSString *_eg_tag;

@end

@implementation EGComponent

- (Flex)setDefaultFlex
{
    if (!self->__flex) {
        return FlexCloum;
    }
    return self->__flex;
}

- (instancetype)init{
    self = [super initWithFrame:CGRectZero];
    if (self) {}
    return self;
}

- (instancetype)initWithPresentVC:(UIViewController *)presentVC
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.presentVC = presentVC;
        self.protocol = presentVC;
        [self componentInit];
    }
    return self;
}

- (id)getSecretary
{
    return nil;
}

#pragma mark -- 注册node节点

- (void)registerNode:(EGComponent *)component
{
    component.node.componentId = [NSString stringWithFormat:@"%p",component];
    component.node.componentId_super = [NSString stringWithFormat:@"%p",self];
    component.node.component_cls_name = [NSString stringWithFormat:@"%s",class_getName([component class])];
    component.node.component_superCls_name = [NSString stringWithFormat:@"%s",class_getName([self class])];
    id superV = component.superview;
    int level = 0;
    while ([superV isKindOfClass:[EGComponent class]]) {
        level++;
        superV = ((EGComponent *)superV).superview;
    }
    component.node.level = level;
}

#pragma mark -- Component的生命周期

-(void)componentInit
{
    //Add code here....
    self.isJSONInject=NO;
}

- (void)dealloc
{
//    EagleLog(@"component's dealloc");
}

- (void)addOnSuperviewComponent
{
//    EagleLog(@"%s",__func__); 
}

- (void)viewWillAppear:(BOOL)animated
{
//    EagleLog(@"%s",__func__);
}

- (void)viewDidAppear:(BOOL)animated
{
//    EagleLog(@"%s",__func__);
}

- (void)viewWillDisappear:(BOOL)animated
{
//    EagleLog(@"%s",__func__);
}

- (void)viewDidDisappear:(BOOL)animated
{
//    EagleLog(@"%s",__func__);
}

- (void)removeFromSuperviewComponent
{
//    EagleLog(@"%s",__func__);
}

- (void)addSubview:(UIView *)view
{
    [super addSubview:view];
    if ([view isKindOfClass:[EGComponent class]]) {
        ((EGComponent *)view).container = [UIView new];
        [(EGComponent *)view addSubview:((EGComponent *)view).container];
        [((EGComponent *)view).container mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo((EGComponent *)view);
        }];
        [(EGComponent *)view sendSubviewToBack:((EGComponent *)view).container];
        [self registerNode:(EGComponent *)view];
        if (self.protocol && [self.protocol respondsToSelector:@selector(addSubcomponent:superComponent:)]) {
            [self.protocol addSubcomponent:(EGComponent *)view superComponent:self];
        }
    }
}

- (void)removeFromSuperview
{
    [super removeFromSuperview];
    [self removeFromSuperviewComponent];
    if (self.protocol && [self.protocol respondsToSelector:@selector(removeFromSuperviewComponent:)]) {
        [self.protocol removeFromSuperviewComponent:self];
    }
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.node.frame = frame;
    if (self.protocol && [self.protocol respondsToSelector:@selector(refreshContentSize:)]) {
        [self.protocol refreshContentSize:self];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    CGRect frame = self.node.frame;
//    frame.size.width = self.frame.size.width;
//    frame.size.height = self.frame.size.height;
//    if (self.protocol && [self.protocol respondsToSelector:@selector(vcLayoutSubviews:)]) {
//        [self.protocol vcLayoutSubviews:self];
//    }
    if (self.protocol && [self.protocol respondsToSelector:@selector(refreshContentSize:)]) {
        [self.protocol refreshContentSize:self];
    }
}

#pragma mark -- 链式调用

- (EGComponent *(^)(NSString *component))initComponent
{
    return ^EGComponent *(NSString *component) {
        if (self.protocol && [self.protocol respondsToSelector:@selector(vcInitComponent:addresses:)]) {
            self._type = TypeInit;
            if (!self._addresses_init) {
                self._addresses_init = [NSMutableArray array];
            }
            @eg_weakify(self);
            [self.protocol vcInitComponent:component addresses:^(NSArray *addresses) {
                @eg_strongify(self);
                [self._addresses_init addObjectsFromArray:addresses];
            }];
        }
        return self;
    };
}

- (EGComponent *(^)(NSArray <NSString *>*components, Flex flex))registerComponents
{
    return ^EGComponent *(NSArray <NSString *>*components, Flex flex) {
        self._components = [components copy];
        self._flex = flex;
//        self.params = [params copy];
        self._type = TypeRegister;
        if (!self._addresses_register) {
            self._addresses_register = [NSMutableArray array];
        }
        @eg_weakify(self);
        [self registerComponents:self._components componentIds:@[self.node.componentId] flex:self._flex size:EGSizeMake(NO, 0, 0, 0, 0) params:self.params addresses:^(NSArray *addresses) {
            @eg_strongify(self);
            [self._addresses_register addObjectsFromArray:addresses];
        }];
        return self;
    };
}

- (EGComponent *(^)(NSString *component, Flex flex, EGSize size, NSDictionary *params))addComponent
{
    return ^EGComponent *(NSString *component, Flex flex, EGSize size, NSDictionary *params) {
        self._components = [@[component] copy];
        self._flex = flex;
        self._size = size;
        self.params = [params copy];
        self._type = TypeAdd;
        if (!self._addresses_add) {
            self._addresses_add = [NSMutableArray array];
        }
        @eg_weakify(self);
        [self addComponent:self._components componentIds:@[self.node.componentId] flex:self._flex size:self._size params:self.params addresses:^(NSArray *addresses) {
            @eg_strongify(self);
            [self._addresses_add addObjectsFromArray:addresses];
        }];
        return self;
    };
}

- (EGComponent *(^)(NSString *component, NSString *broComponentId, Flex flex, EGSize size, NSDictionary *params))insertComponent
{
    return ^EGComponent *(NSString *component, NSString *broComponentId, Flex flex, EGSize size, NSDictionary *params) {
        self._components = [@[component] copy];
        self._broComponentId = broComponentId;
        self._flex = flex;
        self._size = size;
        self.params = [params copy];
        self._type = TypeInsert;
        if (!self._addresses_insert) {
            self._addresses_insert = [NSMutableArray array];
        }
        @eg_weakify(self);
        [self insertComponent:self._components componentIds:@[self.node.componentId] broComponentId:nil flex:self._flex size:self._size params:self.params addresses:^(NSArray *addresses) {
            @eg_strongify(self);
            [self._addresses_insert addObjectsFromArray:addresses];
        }];
        return self;
    };
}

- (EGComponent *(^)(NSArray <NSString *>*components))removeComponents
{
    return ^EGComponent *(NSArray <NSString *>*components) {
        if (components && components.count > 0) {
            self._components = [components copy];
            self._type = TypeRemove;
            [self removeComponents:self._components];
        }
        return self;
    };
}

- (EGComponent *(^)(NSString *component))removeComponent
{
    return ^EGComponent *(NSString *component) {
        if (component && component.length > 0) {
            self._components = [@[component] copy];
            self._type = TypeRemove;
            [self removeComponents:self._components];
        }
        return self;
    };
}

- (EGComponent *(^)(NSString *broComponentId))broComponentId
{
    return ^EGComponent *(NSString * broComponentId) {
        self._broComponentId = broComponentId;
        return self;
    };
}

- (EGComponent *(^)(Flex flex))flex
{
    return ^EGComponent *(Flex flex) {
        self._flex = flex;
        return self;
    };
}

- (EGComponent *(^)(EGSize))size
{
    return ^EGComponent *(EGSize size) {
        
        if ((size.usePercent && self.node.size.usePercent && size.horizontal == self.node.size.horizontal && size.vertical == self.node.size.vertical)
            || (!size.usePercent && !self.node.size.usePercent && size.width == self.node.size.width && size.height == self.node.size.height)) {
            // 若size未发生改变则return
            return self;
        }
        self._size = size;// 缓存size
        if (self.protocol && [self.protocol respondsToSelector:@selector(vcResetSize:component:)]) {
            self.node.size = size;
            [self.protocol vcResetSize:size component:self];
        }
        return self;
    };
}

- (NSArray *(^)(void))done
{
    return ^NSArray *() {
        __block NSArray *tempArray = [NSArray array];
        switch (self._type) {
            case TypeInit:
                return self._addresses_init;
                break;
            case TypeRegister:
                return self._addresses_register;
                break;
            case TypeAdd:
                return self._addresses_add;
                break;
            case TypeInsert:
                return self._addresses_insert;
                break;
            case TypeRemove:
                
                break;
            default:
                break;
        }
        return tempArray;
    };
}

- (EGComponent *(^)(NSString *componentId))getComponentByComponentId
{
    return ^EGComponent *(NSString *componentId) {
        return (EGComponent *)[self getComponentByComponentId:componentId];
    };
}

- (EGComponent *(^)(NSString *))eg_id
{
    return ^EGComponent *(NSString *eg_id) {
        self._eg_id = eg_id;
        self.node.eg_id = eg_id;
        if (self.protocol && [self.protocol respondsToSelector:@selector(vcSetId:forComponent:)]) {
            [self.protocol vcSetId:eg_id forComponent:self];
        }
        return self;
    };
}

- (EGComponent *(^)(NSString *eg_id))getComponentById
{
    return ^EGComponent *(NSString *eg_id) {
        return (EGComponent *)[self getComponentById:eg_id];
    };
}

- (EGComponent *(^)(NSString *))eg_tag
{
    return ^EGComponent *(NSString *eg_tag) {
        self._eg_tag = eg_tag;
        self.node.eg_tag = eg_tag;
        if (self.protocol && [self.protocol respondsToSelector:@selector(vcSetTag:forComponent:)]) {
            [self.protocol vcSetTag:eg_tag forComponent:self];
        }
        return self;
    };
}

- (NSArray *(^)(NSString *eg_tag))getComponentsByTag
{
    return ^NSArray *(NSString *eg_tag) {
        if (self.protocol && [self.protocol respondsToSelector:@selector(vcGetComponentsByTag:)]) {
            return [self.protocol vcGetComponentsByTag:eg_tag];
        }
        return nil;
    };
}

- (NSArray *(^)(NSString *className))getComponentsByClassName
{
    return ^NSArray *(NSString *className) {
        if (self.protocol && [self.protocol respondsToSelector:@selector(vcGetComponentsByClassName:)]) {
            return [self.protocol vcGetComponentsByClassName:className];
        }
        return nil;
    };
}

#pragma mark -- Component增删操作

- (void)registerComponents:(NSArray <NSString *>*)components componentIds:(NSArray <NSString *>*)componentIds flex:(Flex)flex size:(EGSize)size params:(NSDictionary *)params addresses:(void(^)(NSArray *addresses))returnAddresses
{
    self.node.frame = CGRectMake(0, 0, size.width, size.height);
    self.node.flex = flex;
    if (!componentIds && self.node.componentId) {
        componentIds = @[self.node.componentId];
    }
    if (self.protocol && [self.protocol respondsToSelector:@selector(vcRegisterComponents:componentIds:params:addresses:)]) {
        [self.protocol vcRegisterComponents:components componentIds:componentIds params:params addresses:returnAddresses];
    }
}

- (void)addComponent:(NSArray <NSString *>*)component componentIds:(NSArray <NSString *>*)componentIds flex:(Flex)flex size:(EGSize)size params:(NSDictionary *)params addresses:(void(^)(NSArray *addresses))returnAddresses
{
    if (!componentIds && self.node.componentId) {
        componentIds = @[self.node.componentId];
    }
    if (self.protocol && [self.protocol respondsToSelector:@selector(vcAddComponent:componentIds:flex:size:params:addresses:)]) {
        [self.protocol vcAddComponent:component componentIds:componentIds flex:flex size:size params:params addresses:returnAddresses];
    }
}

- (void)insertComponent:(NSArray <NSString *>*)component
           componentIds:(NSArray <NSString *>*)componentIds
         broComponentId:(NSString *)broComponentId
                   flex:(Flex)flex
                   size:(EGSize)size
                 params:(NSDictionary *)params
              addresses:(void(^)(NSArray *addresses))returnAddresses
{
    if (!componentIds && self.node.componentId) {
        componentIds = @[self.node.componentId];
    }
    if (!broComponentId && self.node.componentId) {
        broComponentId = [@"super" stringByAppendingString:self.node.componentId];
    }
    if (self.protocol && [self.protocol respondsToSelector:@selector(vcAddComponent:componentIds:flex:size:params:addresses:)]) {
        [self.protocol vcInsertComponent:component componentIds:componentIds broComponentId:broComponentId flex:flex size:size params:params addresses:returnAddresses];
    }
}

- (void)removeComponents:(NSArray <NSString *>*)components
{
    if (self.protocol && [self.protocol respondsToSelector:@selector(vcRemoveComponents:)]) {
        [self.protocol vcRemoveComponents:components];
    }
}

- (EGComponent *)getComponentByComponentId:(NSString *)componentId
{
    if (self.protocol && [self.protocol respondsToSelector:@selector(vcGetComponentByComponentId:)]) {
        return [self.protocol vcGetComponentByComponentId:componentId];
    }
    return nil;
}

- (EGComponent *)getComponentById:(NSString *)Id
{
    if (self.protocol && [self.protocol respondsToSelector:@selector(vcGetComponentById:)]) {
        return [self.protocol vcGetComponentById:Id];
    }
    return nil;
}


#pragma mark -- UIBarButtonItem

- (void)setLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem
{
    _leftBarButtonItem = leftBarButtonItem;
    NSMutableArray *temp = [NSMutableArray arrayWithObject:leftBarButtonItem];
    if (self.presentVC.navigationItem.leftBarButtonItems) {
        [temp addObjectsFromArray:self.presentVC.navigationItem.leftBarButtonItems];
    }
    self.presentVC.navigationItem.leftBarButtonItems = [temp copy];
}

- (void)setRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem
{
    _rightBarButtonItem = rightBarButtonItem;
    NSMutableArray *temp = [NSMutableArray arrayWithObject:rightBarButtonItem];
    if (self.presentVC.navigationItem.rightBarButtonItems) {
        [temp addObjectsFromArray:self.presentVC.navigationItem.rightBarButtonItems];
    }
    self.presentVC.navigationItem.rightBarButtonItems = [temp copy];
}

#pragma mark -- 懒加载

- (UIViewController *)presentVC
{
    if (_presentVC==nil) {
        id target=self;
        while (target) {
            target = ((UIResponder *)target).nextResponder;
            if ([target isKindOfClass:[UIViewController class]]) {
                break;
            }
        }
        _presentVC=target;
    }
    return _presentVC;
}
- (EGNode *)node
{
    if (!_node) {
        _node = [EGNode new];
    }
    return _node;
}

@end
