//
//  EGMHeadingRequest.h
//  EagleSDK
//
//  Created by 顾新生 on 2018/1/15.
//

#import <Foundation/Foundation.h>
@class EGMRequestIDGenerator;
@interface EGMHeadingRequest : NSObject
@property(nonatomic,assign)EGMHeadingRequestID requestID;
@property(nonatomic,assign)BOOL isRecurring;
@property(nonatomic,copy)EGMHeadingRequestBlock block;
@end
