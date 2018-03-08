//
//  EGNaviSlideAppRouteParser.h
//
//  Created by 顾新生 on 2017/11/20.
//


#import <Foundation/Foundation.h>
#import "EGURL.h"


@interface EGNaviSlideAppRouteParser : NSObject
+(EGURL *)parse:(NSArray *)routes;
@end
