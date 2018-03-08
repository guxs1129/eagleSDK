//
//  EGMLocationRequest.m
//  EagleSDK
//
//  Created by 顾新生 on 2018/1/10.
//

#import "EGMLocationRequest.h"

@interface EGMLocationRequest()

@property(nonatomic,strong)NSTimer *timeoutTimer;
@end
@implementation EGMLocationRequest

-(instancetype)init{
    @throw [NSException exceptionWithName:@"<EGMapKit Error>" reason:@"Use initWithType: to create an LocationRequest" userInfo:nil];
    return [self initWithTarget:[EGLocationManager manager] type:EGMLocationRequestTypeSingle];
}

- (instancetype)initWithTarget:(id<EGMLocationRequestDelegate>) target type:(EGMLocationRequestType)type{
    if(self=[super init]){
        self.requestID=[EGMRequestIDGenerator getUniqueRequestID];
        self.type=type;
        self.hasTimeout=NO;
        self.delegate=target;
    }
    return self;
}
/**
 Forces the location request to consider itself timed out.
 */
- (void)forceTimeout{
    if (self.isRecurring == NO) {
        self.hasTimeout = YES;
    } else {
        NSAssert(self.isRecurring == NO, @"Only single location requests (not recurring requests) should ever be considered timed out.");
    }
}
-(void)complete{
    [self.timeoutTimer invalidate];
    self.timeoutTimer = nil;
    self.requestStartTime = nil;
}
-(void)cancel{
    [self.timeoutTimer invalidate];
    self.timeoutTimer = nil;
    self.requestStartTime = nil;
}

-(NSTimeInterval)updateTimeStaleThreshold{
    switch (self.desiredAccuracy) {
        case EGMLocationAccuracyCity:
            return kEGMUpdateTimeStaleThresholdCity;
            break;
        case EGMLocationAccuracyNeighborhood:
            return kEGMUpdateTimeStaleThresholdNeighborhood;
            break;
        case EGMLocationAccuracyBlock:
            return kEGMUpdateTimeStaleThresholdBlock;
            break;
        case EGMLocationAccuracyHouse:
            return kEGMUpdateTimeStaleThresholdHouse;
            break;
        case EGMLocationAccuracyRoom:
            return kEGMUpdateTimeStaleThresholdRoom;
            break;
        default:
            NSAssert(NO, @"<EGMLocation Request>Unknow accuracy.");
            return 0;
            break;
    }
}
-(CLLocationAccuracy)horizontalAccuracyThreshold{
    switch (self.desiredAccuracy) {
        case EGMLocationAccuracyCity:
            return kEGMUpdateTimeStaleThresholdCity;
            break;
        case EGMLocationAccuracyNeighborhood:
            return kEGMUpdateTimeStaleThresholdNeighborhood;
            break;
        case EGMLocationAccuracyBlock:
            return kEGMUpdateTimeStaleThresholdBlock;
            break;
        case EGMLocationAccuracyHouse:
            return kEGMUpdateTimeStaleThresholdHouse;
            break;
        case EGMLocationAccuracyRoom:
            return kEGMUpdateTimeStaleThresholdRoom;
            break;
        default:
            NSAssert(NO, @"<EGMLocation Request>Unknow accuracy.");
            return 0;
            break;
    }
}

-(void)startTimeoutTimerIfNeeded{
    if (self.timeout>0 && self.timeoutTimer==nil) {
        self.requestStartTime=[NSDate date];
//        self.timeoutTimer=[NSTimer scheduledTimerWithTimeInterval:self.timeout target:self selector:@selector(timeoutFired) userInfo:nil repeats:NO];
        self.timeoutTimer=[NSTimer timerWithTimeInterval:self.timeout target:self selector:@selector(timeoutFired) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop]addTimer:self.timeoutTimer forMode:NSRunLoopCommonModes];
    }
}

- (NSTimeInterval)timeAlive{
    if (self.requestStartTime == nil) {
        return 0.0;
    }
    return fabs([self.requestStartTime timeIntervalSinceNow]);
}

/**
 Computed property that returns whether this is a subscription request.
 */
- (BOOL)isRecurring{
    return (self.type == EGMLocationRequestTypeSubscription) || (self.type == EGMLocationRequestTypeSignificantChanges);
}

-(void)dealloc{
    [self.timeoutTimer invalidate];
    self.timeoutTimer=nil;
}

-(NSString *)description{
    return [NSString stringWithFormat:@"<Location Request> :[ID:%ld]-[type:%ld]",(long)self.requestID,(long)self.type];
}

-(void)timeoutFired{

    if(self.delegate && [self.delegate respondsToSelector:@selector(locationRequestDidTimeout:)]){
        [self.delegate locationRequestDidTimeout:self];
    }
}

/**
 Two location requests are considered equal if their request IDs match.
 */
- (BOOL)isEqual:(id)object{
    if (object == self) {
        return YES;
    }
    if (!object || ![object isKindOfClass:[self class]]) {
        return NO;
    }
    if (((EGMLocationRequest *)object).requestID == self.requestID) {
        return YES;
    }
    return NO;
}

-(NSUInteger)hash{
    return [[NSString stringWithFormat:@"%ld",(long)self.requestID]hash];
}

@end


@implementation EGMRequestIDGenerator

static EGMLocationRequestID _nextRequestID = 0;

+(EGMLocationRequestID)getUniqueRequestID{
    return ++_nextRequestID;
}

@end
