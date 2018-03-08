//
//  EGMLocationRequest.h
//  EagleSDK
//
//  Created by 顾新生 on 2018/1/10.
//

#import <Foundation/Foundation.h>
#import "EGMapDefines.h"
@class EGMLocationRequest;

/**
 Protocol for the EGMLocationRequest to notify the its delegate that a request has timed out.
 */
@protocol EGMLocationRequestDelegate<NSObject>

/**
 Notification that a location request has timed out.
 
 @param locationRequest The location request that timed out.
 */
- (void)locationRequestDidTimeout:(EGMLocationRequest *)locationRequest;

@end


/**
 Represents a geolocation request that is created and managed by EGLocationManager.
 */
@interface EGMLocationRequest : NSObject

@property(nonatomic,assign)EGMLocationRequestID requestID;
@property(nonatomic,assign)EGMLocationRequestType type;
@property (nonatomic, assign)NSTimeInterval timeout;
@property(nonatomic,weak)id<EGMLocationRequestDelegate> delegate;
@property (nonatomic, assign)EGMLocationAccuracy desiredAccuracy;
@property(nonatomic,strong)NSDate *requestStartTime;
@property(nonatomic,copy)EGMLocationRequestBlock block;
@property(nonatomic,assign)BOOL hasTimeout;
@property(nonatomic,assign)BOOL isRecurring;

/** Designated initializer. Initializes and returns a newly allocated location request object with the specified type. */
- (instancetype)initWithTarget:(id<EGMLocationRequestDelegate>) target type:(EGMLocationRequestType)type NS_DESIGNATED_INITIALIZER;

/** Completes the location request. */
- (void)complete;

/** Forces the location request to consider itself timed out. */
- (void)forceTimeout;

/** Cancels the location request. */
- (void)cancel;

/** Starts the location request's timeout timer if a nonzero timeout value is set, and the timer has not already been started. */
- (void)startTimeoutTimerIfNeeded;

/** Returns the associated recency threshold (in seconds) for the location request's desired accuracy level. */
- (NSTimeInterval)updateTimeStaleThreshold;

/** Returns the associated horizontal accuracy threshold (in meters) for the location request's desired accuracy level. */
- (CLLocationAccuracy)horizontalAccuracyThreshold;


@end

@interface EGMRequestIDGenerator : NSObject

/** Returns a unique request ID (within the lifetime of the application). */
+(EGMLocationRequestID)getUniqueRequestID;

@end
