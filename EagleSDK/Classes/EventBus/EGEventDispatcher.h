//
//  EGEventDispatcher.h
//  AFNetworking
//
//  Created by 顾新生 on 14/12/2017.
//

#import <Foundation/Foundation.h>
@class EGEvent;
@interface EGEventDispatcher : NSObject
+(instancetype)shareInstance;
-(void)dispatchEvent:(EGEvent *)event;
@end
