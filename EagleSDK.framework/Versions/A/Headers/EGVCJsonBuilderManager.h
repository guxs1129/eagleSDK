//
//  EGVCJsonBuilderManager.h
//  EagleSDK
//
//  Created by 顾新生 on 19/12/2017.
//

#import <Foundation/Foundation.h>

@interface EGVCJsonBuilderManager : NSObject
+(instancetype)manager;
-(void)build:(UIViewController *)vc;
@end
@interface EGVCJsonBuilder : NSObject
-(void)buildWithVC:(UIViewController *)vc options:(NSDictionary *)options;

@end
