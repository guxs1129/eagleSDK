//
//  EGComponentJsonParser.h
//  EagleSDK
//
//  Created by 顾新生 on 21/12/2017.
//
typedef struct{
    __unsafe_unretained NSString *eg_id;
    struct EGSize size;
    Flex flex;
    __unsafe_unretained NSString *className;
    __unsafe_unretained id dataSource;
}EGComponentDesc;

#import <Foundation/Foundation.h>

@protocol EGComponentJSONDataSourceInjectable<NSObject>

/**
 需要支持json注入数据源的component需要实现该方法
 
 @param jsonDataSource json数据
 */
-(void)injectJSONDataSource:(id)jsonDataSource;

@end

@interface EGComponentJsonParser : NSObject
+(EGComponentDesc)parseWithDict:(NSDictionary *)dict;
@end

