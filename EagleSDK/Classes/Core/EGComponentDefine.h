//
//  EGComponentDefine.h
//  Pods
//
//  Created by pantao on 2017/12/21.
//

#ifndef EGComponentDefine_h
#define EGComponentDefine_h

@class EGComponent;

typedef NS_ENUM(NSUInteger, Type) {
    // 初始化组件
    TypeInit,
    // 注册组件
    TypeRegister,
    // 增加组件
    TypeAdd,
    // 插入组件
    TypeInsert,
    // 删除组件
    TypeRemove
};

@protocol EGComponentProtocol <NSObject>

- (void)addSubcomponent:(EGComponent *)component
         superComponent:(EGComponent *)superComponent;
- (void)removeFromSuperviewComponent:(EGComponent *)component;

- (void)vcInitComponent:(NSString *)component
              addresses:(void(^)(NSArray *addresses))returnAddresses;
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
- (void)refreshContentSize:(EGComponent *)component;
- (void)vcResetSize:(EGSize)size component:(EGComponent *)component;

/**
 通过componentId获取component
 
 @param componentId componentId
 @return            component
 */
- (EGComponent *)vcGetComponentByComponentId:(NSString *)componentId;

/**
 将component's Id与VC持有的map_Id进行映射(Id与component只能一一对应)
 
 @param Id          Id
 @param component   component
 */
- (void)vcSetId:(NSString *)Id forComponent:(EGComponent *)component;

/**
 通过Id获取component
 
 @param Id          Id
 @return            component
 */
- (EGComponent *)vcGetComponentById:(NSString *)Id;

/**
  将component's Tag与VC持有的map_Tag进行映射(同一个Tag可以对应多个component)

 @param Tag         Tag
 @param component   component
 */
- (void)vcSetTag:(NSString *)Tag forComponent:(EGComponent *)component;

/**
 通过Tag获取component的数组
 
 @param Tag         Tag
 @return            component's array
 */
- (NSArray *)vcGetComponentsByTag:(NSString *)Tag;

/**
 通过类名获取component的数组

 @param className   类名
 @return            component's array
 */
- (NSArray *)vcGetComponentsByClassName:(NSString *)className;

@optional

- (void)vcLayoutSubviews:(EGComponent *)component;

@end

#endif /* EGComponentDefine_h */
