//
//  EGNaviSlideApp.h
//
//  Created by 顾新生 on 2017/11/17.
//
#define EGNaviSlideApp_h


#import <Foundation/Foundation.h>

#pragma mark --Exception-
extern NSString * const EGURLParseException;
extern NSString * const EGNaviSlideAppException;


#pragma mark ---Center VC mapping-
extern NSString * const HOME_VC;
extern NSString * const HOME_TITLE;

#pragma mark ---Left VC mapping-
extern NSString * const LEFT_VC;
extern NSString * const LEFT_TITLE;
extern NSString * const LEFT_IMAGE;
extern NSString * const LEFT_SELECTED_IMAGE;
extern NSString * const LEFT_IMAGE_COLOR;
extern NSString * const LEFT_IMAGE_SELECTED_COLOR;

#pragma mark --Right VC mapping-
extern NSString * const RIGHT_VC;
extern NSString * const RIGHT_TITLE;
extern NSString * const RIGHT_IMAGE;
extern NSString * const RIGHT_SELECTED_IMAGE;
extern NSString * const RIGHT_IMAGE_COLOR;
extern NSString * const RIGHT_IMAGE_SELECTED_COLOR;

@class MMDrawerController;
@interface EGNaviSlideApp : NSObject

@property(nonatomic,weak)MMDrawerController *drawerController;

+(EGNaviSlideApp *(^)(NSArray *routes))parseRoutes;

-(void(^)(void))engineStart;
@end
