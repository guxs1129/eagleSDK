//
//  Component.m
//  OC's component
//
//  Created by 潘涛 on 2017/3/10.
//  Copyright © 2017年 潘涛. All rights reserved.
//

#import "Component.h"
#import <objc/runtime.h>
#import "Eagle.h"
#import "PopView.h"

#define kPopViewBGColor                        [UIColor colorWithRed:0.28 green:0.28 blue:0.29 alpha:1.00]
#define kCellheight                            45.f
#define kContentVWidth                         120.f

@interface Component ()<UITableViewDelegate, UITableViewDataSource>

//NSArray <NSString *>* components, Flex flex, CGSize size, NSDictionary *params
@property (nonatomic, strong)                  NSArray <NSString *>* _components;
@property (nonatomic, strong)                  NSString *_broComponentId;
@property (nonatomic, getter=setDefaultFlex)   Flex _flex;
@property (nonatomic)                          EGSize _size;
@property (nonatomic)                          Type _type;
@property (nonatomic, strong)                  NSMutableArray <NSString *>*_addresses_register;
@property (nonatomic, strong)                  NSMutableArray <NSString *>*_addresses_add;
@property (nonatomic, strong)                  NSMutableArray <NSString *>*_addresses_insert;
@property (nonatomic, strong)                  PopView *popView;
@property (nonatomic, strong)                  UIView *contentView;
@property (nonatomic, strong)                  UITableView *contentTableView;
@property (nonatomic, strong)                  NSArray *contentArray;

@end

@implementation Component

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

- (id)getSecretary
{
    return nil;
}

#pragma mark -- 注册node节点

- (void)registerNode:(Component *)component
{
    component.node.componentId = [NSString stringWithFormat:@"%p",component];
    component.node.componentId_super = [NSString stringWithFormat:@"%p",self];
    component.node.component_cls_name = [NSString stringWithFormat:@"%s",class_getName([component class])];
    component.node.component_superCls_name = [NSString stringWithFormat:@"%s",class_getName([self class])];
    id superV = component.superview;
    int level = 0;
    while ([superV isKindOfClass:[Component class]]) {
        level++;
        superV = ((Component *)superV).superview;
    }
    component.node.level = level;
}

#pragma mark -- Component的生命周期

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
    if (self.webView) {
        self.webView.frame = self.frame;
    }
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
    if ([view isKindOfClass:[Component class]]) {
        [self registerNode:(Component *)view];
        if (self.protocol && [self.protocol respondsToSelector:@selector(addSubcomponent:superComponent:)]) {
            [self.protocol addSubcomponent:(Component *)view superComponent:self];
        }
    }else if ([view isKindOfClass:[EagleUIWebView class]] && !self.bridge) {
        self.bridge = [WebViewJavascriptBridge bridgeForWebView:(EagleUIWebView *)view];
        [self.bridge setWebViewDelegate:self];
        [self registerSomeJsMethods];
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
    CGRect frame = self.node.frame;
    frame.size.width = self.frame.size.width;
    frame.size.height = self.frame.size.height;
    if (self.protocol && [self.protocol respondsToSelector:@selector(vcLayoutSubviews:)]) {
        [self.protocol vcLayoutSubviews:self];
    }
}

#pragma mark -- 链式调用

- (Component *(^)(NSArray <NSString *>*components, Flex flex))registerComponents
{
    return ^Component *(NSArray <NSString *>*components, Flex flex) {
        self._components = [components copy];
        self._flex = flex;
//        self.params = [params copy];
        self._type = TypeRegister;
        if (!self._addresses_register) {
            self._addresses_register = [NSMutableArray array];
        }
        @weakify(self);
        [self registerComponents:self._components componentIds:@[self.node.componentId] flex:self._flex size:EGSizeMake(NO, 0, 0, 0, 0) params:self.params addresses:^(NSArray *addresses) {
            @strongify(self);
            [self._addresses_register addObjectsFromArray:addresses];
        }];
        return self;
    };
}

- (Component *(^)(NSString *component, Flex flex, EGSize size, NSDictionary *params))addComponent
{
    return ^Component *(NSString *component, Flex flex, EGSize size, NSDictionary *params) {
        self._components = [@[component] copy];
        self._flex = flex;
        self._size = size;
        self.params = [params copy];
        self._type = TypeAdd;
        if (!self._addresses_add) {
            self._addresses_add = [NSMutableArray array];
        }
        @weakify(self);
        [self addComponent:self._components componentIds:@[self.node.componentId] flex:self._flex size:self._size params:self.params addresses:^(NSArray *addresses) {
            @strongify(self);
            [self._addresses_add addObjectsFromArray:addresses];
        }];
        return self;
    };
}

- (Component *(^)(NSString *component, NSString *broComponentId, Flex flex, EGSize size, NSDictionary *params))insertComponent
{
    return ^Component *(NSString *component, NSString *broComponentId, Flex flex, EGSize size, NSDictionary *params) {
        self._components = [@[component] copy];
        self._broComponentId = broComponentId;
        self._flex = flex;
        self._size = size;
        self.params = [params copy];
        self._type = TypeInsert;
        if (!self._addresses_insert) {
            self._addresses_insert = [NSMutableArray array];
        }
        @weakify(self);
        [self insertComponent:self._components componentIds:@[self.node.componentId] broComponentId:nil flex:self._flex size:self._size params:self.params addresses:^(NSArray *addresses) {
            @strongify(self);
            [self._addresses_insert addObjectsFromArray:addresses];
        }];
        return self;
    };
}

- (Component *(^)(NSArray <NSString *>*components))removeComponents
{
    return ^Component *(NSArray <NSString *>*components) {
        if (components && components.count > 0) {
            self._components = [components copy];
            self._type = TypeRemove;
            [self removeComponents:self._components];
        }
        return self;
    };
}

- (Component *(^)(NSString *component))removeComponent
{
    return ^Component *(NSString *component) {
        if (component && component.length > 0) {
            self._components = [@[component] copy];
            self._type = TypeRemove;
            [self removeComponents:self._components];
        }
        return self;
    };
}

- (Component *(^)(NSString *broComponentId))broComponentId
{
    return ^Component *(NSString * broComponentId) {
        self._broComponentId = broComponentId;
        return self;
    };
}

- (Component *(^)(Flex flex))flex
{
    return ^Component *(Flex flex) {
        self._flex = flex;
        return self;
    };
}

- (Component *(^)(EGSize))size
{
    return ^Component *(EGSize size) {
        self._size = size;
        self.node.size = size;
        if (self.protocol && [self.protocol respondsToSelector:@selector(vcResetSize:component:)]) {
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

- (Component *(^)(NSString *componentId))getComponent
{
    return ^Component *(NSString *componentId) {
        return (Component *)[self getComponentById:componentId];
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

- (Component *)getComponentById:(NSString *)componentId
{
    if (self.protocol && [self.protocol respondsToSelector:@selector(vcGetComponentById:)]) {
        return [self.protocol vcGetComponentById:componentId];
    }
    return nil;
}

#pragma mark -- WebViewJavascriptBridge

/**
 注册一些js调用oc的通用方法
 */
- (void)registerSomeJsMethods
{
    [self registerLeftBarButtonItems];
    [self registerRightBarButtonItems];
}

/**
 注册导航栏左侧按钮数组
 */
- (void)registerLeftBarButtonItems
{
    [self.bridge registerHandler:@"leftBarButtonItems" handler:^(id data, ResponseCallback responseCallback) {
        // data js页面传过来的参数  假设这里是用户名和姓名，字典格式
        // responseCallback 给后台的回复
        responseCallback(@"报告，oc已收到js的请求");
    }];
}

/**
 注册导航栏右侧按钮数组
 */
- (void)registerRightBarButtonItems
{
    @weakify(self);
    [self.bridge registerHandler:@"rightBarButtonItems" handler:^(id data, ResponseCallback responseCallback) {
        @strongify(self);
        NSArray *arr = (NSArray *)data;
        UIViewController *vc = [self.webView viewController];
        if (arr.count == 1) {
            NSDictionary *dict = arr[0];
            NSString *title = [dict valueForKey:@"key"];
            self.url = [dict valueForKey:@"value"];
            vc.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(click)];
        }else {
            vc.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(click)];
        }
        
        self.contentView.frame = CGRectMake(0, 0, kContentVWidth, kCellheight *arr.count);
        self.contentTableView.frame = CGRectMake(0, 0, kContentVWidth, kCellheight *arr.count);
        self.contentArray = arr;
        if (arr.count < 6) {
            self.contentTableView.scrollEnabled = NO;
        }
//        responseCallback(self.responseData(1, @"ok", [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"A",@"2",@"B", nil]));
    }];
}

- (NSString *(^)(NSInteger status, NSString *msg, id values))responseData
{
    return ^NSString*(NSInteger status, NSString *msg, id values) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:[NSNumber numberWithInteger:status] forKey:@"status"];
        [dict setObject:msg forKey:@"msg"];
        [dict setObject:values forKey:@"values"];
        return [self convertToJsonData:dict];;
    };
}

- (NSString *)convertToJsonData:(NSDictionary *)dict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        return @"数据有问题";
    }else {
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
}

- (void)click
{
    EagleLog(@"self.url:  %@",self.url);
    UIViewController *vc = [self.webView viewController];
    CGPoint point = CGPointMake(vc.view.bounds.size.width - 25, 0);
    if (self.contentArray.count < 2) {
        return;
    }
    [self.popView showAtPoint:point
              withContentView:self.contentView
                       inView:vc.view];
}

#pragma mark -- UITableViewDelegate, UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellheight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"popCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.textLabel.text = [self.contentArray[indexPath.row] valueForKey:@"key"];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = cell.contentView.backgroundColor = kPopViewBGColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.popView dismiss];
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
- (Node *)node
{
    if (!_node) {
        _node = [Node new];
    }
    return _node;
}

- (PopView *)popView
{
    if(!_popView){
        _popView = [PopView popover];
        _popView.cornerRadius = 2;
        _popView.applyShadow = NO;
        _popView.animationSpring = NO;
        _popView.animationOut = 0.2;
        _popView.backgroundColor = kPopViewBGColor;
    }
    return _popView;
}

- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.backgroundColor = kPopViewBGColor;
        [_contentView addSubview:self.contentTableView];
    }
    return _contentView;
}

- (UITableView *)contentTableView
{
    if (!_contentTableView) {
        _contentTableView = [UITableView new];
        _contentTableView.backgroundColor =kPopViewBGColor;
        _contentTableView.delegate = self;
        _contentTableView.dataSource = self;
    }
    return _contentTableView;
}

- (NSArray *)contentArray
{
    if (!_contentArray) {
        _contentArray = [NSArray array];
    }
    return _contentArray;
}

@end
