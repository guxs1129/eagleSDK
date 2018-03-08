//
//  EGMapComponent.h
//  EGMapKit
//
//  Created by 顾新生 on 2018/1/9.
//

#import <EagleSDK/EagleSDK.h>
EAGL_EXTERN NSString * const EGMapComponent_AddAnnotation_Channel;

@protocol EGMapComponent<EGViewModel>



@end

@class EGMAnnotation;
@interface EGMapComponent : EGComponent<EGComponentJSONDataSourceInjectable>

@property(nonatomic,assign)BOOL showUserLocation;

/** Map zoom level (1 - 19) */
@property(nonatomic,assign)int  zoomLevel;


- (void)requestSearch:(NSString *)keyword withResultHandler:(EGMSearchResultHandler)resultHandler;


@end
