    //
    //  EGLocationManager.m
    //  Pods
    //
    //  Created by 顾新生 on 2018/1/9.
    //

#import "EGLocationManager.h"

@interface EGLocationManager()<CLLocationManagerDelegate>
@property(nonatomic,strong)CLLocationManager *locationManager;
@property(nonatomic,strong)CLGeocoder *geocoder;

@property (nonatomic, strong)NSArray<EGMLocationRequest *> *locationRequests;
@property (nonatomic, strong)NSArray<EGMHeadingRequest *> *headingRequests;

@property (nonatomic, strong) CLLocation *currentLocation;
@property(nonatomic,strong)CLHeading *currentHeading;

@property(nonatomic,assign)BOOL isUpdatingLocation;
@property(nonatomic,assign)BOOL isUpdatingHeading;

@property (nonatomic, assign) BOOL updateFailed;

@property(nonatomic,copy)void (^locationCompletion)(CLLocation *location,NSError *error);
@end
@implementation EGLocationManager
static EGLocationManager *manager;
static dispatch_once_t onceToken;
+(instancetype)manager{
    dispatch_once(&onceToken, ^{
        manager=[[self alloc]init];
    });
    return manager;
}

-(CLGeocoder *)geocoder{
    if (_geocoder==nil) {
        _geocoder=[[CLGeocoder alloc]init];
    }
    return _geocoder;
}

+(void)releaseManager{
    onceToken=0;
    manager=nil;
}

-(instancetype)init{
    if (self=[super init]) {
        NSArray *backgroundModes = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"UIBackgroundModes"];
        if ([backgroundModes containsObject:@"location"]) {
            if (@available(iOS 9, *)) {
                [self.locationManager setAllowsBackgroundLocationUpdates:YES];
            }
        }
        self.locationRequests = @[];
    }
    return self;
}

-(void)dealloc{
    NSLog(@"%s",__func__);
}
#pragma mark ---------------open api---------------

#pragma mark geo
-(void)geocodeAddress:(NSString *)address{
    [self.geocoder geocodeAddressString:address completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@",error);
        }
        NSLog(@"%@",placemarks);
    }];
}

-(void)geocodeLocation:(CLLocation *)location forAnnotation:(id<MKAnnotation>)annotation{
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@",error);
        }
        NSLog(@"%@",placemarks);
        CLPlacemark *placemark=[placemarks firstObject];
    }];
}


#pragma mark location request
-(EGMLocationRequestID)requestLocationWithDesiredAccuracy:(EGMLocationAccuracy)desiredAccuracy timeout:(NSTimeInterval)timeout block:(EGMLocationRequestBlock)block{
    return [self requestLocationWithDesiredAccuracy:desiredAccuracy timeout:timeout delayUntilAuthorized:NO block:block];
}

-(EGMLocationRequestID)requestLocationWithDesiredAccuracy:(EGMLocationAccuracy)desiredAccuracy timeout:(NSTimeInterval)timeout delayUntilAuthorized:(BOOL)delayUntilAuthorized block:(EGMLocationRequestBlock)block{
    NSAssert([NSThread isMainThread], @"EGLocationManager should only be called from the main thread.");
    
    if (desiredAccuracy == EGMLocationAccuracyNone) {
        NSAssert(desiredAccuracy != EGMLocationAccuracyNone, @"EGMLocationAccuracyNone is not a valid desired accuracy.");
        desiredAccuracy = EGMLocationAccuracyCity; // default to the lowest valid desired accuracy
    }
    
    EGMLocationRequest *locationRequest = [[EGMLocationRequest alloc] initWithTarget:self type:EGMLocationRequestTypeSingle];
    locationRequest.desiredAccuracy = desiredAccuracy;
    locationRequest.timeout = timeout;
    locationRequest.block = block;
    
    BOOL deferTimeout = delayUntilAuthorized && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined);
    if (!deferTimeout) {
        [locationRequest startTimeoutTimerIfNeeded];
    }
    
    [self addLocationRequest:locationRequest];
    
    return locationRequest.requestID;
}


-(EGMLocationRequestID)subscribeToLocationUpdatesWithBlock:(EGMLocationRequestBlock)block{
    return [self subscribeToLocationUpdatesWithDesiredAccuracy:EGMLocationAccuracyRoom block:block];
}

-(EGMLocationRequestID)subscribeToLocationUpdatesWithDesiredAccuracy:(EGMLocationAccuracy)desiredAccuracy block:(EGMLocationRequestBlock)block{
    NSAssert([NSThread isMainThread], @"EGLocationManager should only be called from the main thread.");

    EGMLocationRequest *request=[[EGMLocationRequest alloc]initWithTarget:self type:EGMLocationRequestTypeSubscription];
    request.block = block;
    request.desiredAccuracy=desiredAccuracy;
    [self addLocationRequest:request];
    return request.requestID;
}

-(EGMLocationRequestID)subscribeToSignificantLocationChangesWithBlock:(EGMLocationRequestBlock)block{
    NSAssert([NSThread isMainThread], @"EGLocationManager should only be called from the main thread.");

    EGMLocationRequest *request=[[EGMLocationRequest alloc]initWithTarget:self type:EGMLocationRequestTypeSignificantChanges];
    request.block = block;
    [self addLocationRequest:request];
    return request.requestID;
}

-(void)forceCompleteLocationRequest:(EGMLocationRequestID)requestID{
    NSAssert([NSThread isMainThread], @"EGLocationManager should only be called from the main thread.");
    
    for (EGMLocationRequest *locationRequest in self.locationRequests) {
        if (locationRequest.requestID == requestID) {
            if (locationRequest.isRecurring) {
                    // Recurring requests can only be canceled
                [self cancelLocationRequest:requestID];
            } else {
                [locationRequest forceTimeout];
                [self completeLocationRequest:locationRequest];
            }
            break;
        }
    }
}

-(void)cancelLocationRequest:(EGMLocationRequestID)requestID{
    NSAssert([NSThread isMainThread], @"EGLocationManager should only be called from the main thread.");
    
    for (EGMLocationRequest *locationRequest in self.locationRequests) {
        if (locationRequest.requestID == requestID) {
            [locationRequest cancel];
            NSLog(@"Location Request canceled with ID: %ld", (long)locationRequest.requestID);
            [self removeLocationRequest:locationRequest];
            break;
        }
    }
}

-(EGMHeadingRequestID)subscribeToHeadingUpdatesWithBlock:(EGMHeadingRequestBlock)block{
    EGMHeadingRequest *request=[[EGMHeadingRequest alloc]init];
    request.block = block;
    [self addHeadingRequest:request];
    return request.requestID;
}

/**
 Immediately cancels the heading request with the given requestID (if it exists), without executing the original request block.
 */
-(void)cancelHeadingRequest:(EGMHeadingRequestID)requestID{
    for (EGMHeadingRequest *headingRequest in self.headingRequests) {
        if (headingRequest.requestID == requestID) {
            [self removeHeadingRequest:headingRequest];
            NSLog(@"Heading Request canceled with ID: %ld", (long)headingRequest.requestID);
            break;
        }
    }
}
#pragma mark ---------------private---------------
#pragma mark Location
/**
 Adds the given location request to the array of requests, updates the maximum desired accuracy, and starts location updates if needed.
 */
- (void)addLocationRequest:(EGMLocationRequest *)locationRequest{
    EGMLocationServicesState locationServicesState = [EGLocationManager locationServicesState];
    if (locationServicesState == EGMLocationServicesStateDisabled ||
        locationServicesState == EGMLocationServicesStateDenied ||
        locationServicesState == EGMLocationServicesStateRestricted) {
            // No need to add this location request, because location services are turned off device-wide, or the user has denied this app permissions to use them
        [self completeLocationRequest:locationRequest];
        return;
    }
    
    switch (locationRequest.type) {
        case EGMLocationRequestTypeSingle:
        case EGMLocationRequestTypeSubscription:{
            EGMLocationAccuracy maximumDesiredAccuracy = EGMLocationAccuracyNone;
                // Determine the maximum desired accuracy for all existing location requests (does not include the new request we're currently adding)
            for (EGMLocationRequest *locationRequest in [self activeLocationRequestsExcludingType:EGMLocationRequestTypeSignificantChanges]) {
                if (locationRequest.desiredAccuracy > maximumDesiredAccuracy) {
                    maximumDesiredAccuracy = locationRequest.desiredAccuracy;
                }
            }
                // Take the max of the maximum desired accuracy for all existing location requests and the desired accuracy of the new request we're currently adding
            maximumDesiredAccuracy = MAX(locationRequest.desiredAccuracy, maximumDesiredAccuracy);
            [self updateWithMaximumDesiredAccuracy:maximumDesiredAccuracy];
            
            [self startUpdatingLocationIfNeeded];
        }
            break;
        case EGMLocationRequestTypeSignificantChanges:
                //            [self startMonitoringSignificantLocationChangesIfNeeded];
            break;
    }
    NSMutableArray<EGMLocationRequest *> *newLocationRequests = [NSMutableArray arrayWithArray:self.locationRequests];
    [newLocationRequests addObject:locationRequest];
    self.locationRequests = newLocationRequests;
    
        // Process all location requests now, as we may be able to immediately complete the request just added above
        // if a location update was recently received (stored in self.currentLocation) that satisfies its criteria.
    [self processLocationRequests];
}


/**
 Iterates over the array of active location requests to check and see if the most recent current location
 successfully satisfies any of their criteria.
 */
- (void)processLocationRequests{
    
    CLLocation *mostRecentLocation = self.currentLocation;
    for (EGMLocationRequest *locationRequest in self.locationRequests) {
        if (locationRequest.hasTimeout) {
                // Non-recurring request has timed out, complete it
            [self completeLocationRequest:locationRequest];
            continue;
        }
        
        if (mostRecentLocation != nil) {
            if (locationRequest.isRecurring) {
                    // This is a subscription request, which lives indefinitely (unless manually canceled) and receives every location update we get
                [self processRecurringRequest:locationRequest];
                continue;
            } else {
                    // This is a regular one-time location request
                NSTimeInterval currentLocationTimeSinceUpdate = fabs([mostRecentLocation.timestamp timeIntervalSinceNow]);
                CLLocationAccuracy currentLocationHorizontalAccuracy = mostRecentLocation.horizontalAccuracy;
                NSTimeInterval staleThreshold = [locationRequest updateTimeStaleThreshold];
                CLLocationAccuracy horizontalAccuracyThreshold = [locationRequest horizontalAccuracyThreshold];
                if (currentLocationTimeSinceUpdate <= staleThreshold &&
                    currentLocationHorizontalAccuracy <= horizontalAccuracyThreshold) {
                        // The request's desired accuracy has been reached, complete it
                    [self completeLocationRequest:locationRequest];
                    continue;
                }
            }
        }
    }
}

/**
 Handles calling a recurring location request's block with the current location.
 */
- (void)processRecurringRequest:(EGMLocationRequest *)locationRequest{
    NSAssert(locationRequest.isRecurring, @"This method should only be called for recurring location requests.");
    
    EGMLocationStatus status = [self statusForLocationRequest:locationRequest];
    EGMLocationAccuracy achievedAccuracy = [self achievedAccuracyForLocation:self.currentLocation];
    
    @eg_weakify(self)
    dispatch_async(dispatch_get_main_queue(), ^{
        @eg_strongify(self)
        if (locationRequest.block) {
            locationRequest.block(self.currentLocation, achievedAccuracy, status);
        }
    });
}

/**
 Completes the given location request by removing it from the array of locationRequests and executing its completion block.
 */
- (void)completeLocationRequest:(EGMLocationRequest *)locationRequest{
    if (locationRequest == nil) {
        return;
    }
    
    [locationRequest complete];
    [self removeLocationRequest:locationRequest];
    
    EGMLocationStatus status = [self statusForLocationRequest:locationRequest];
    CLLocation *currentLocation = self.currentLocation;
    EGMLocationAccuracy achievedAccuracy = [self achievedAccuracyForLocation:self.currentLocation];
    
        // EGLocationManager is not thread safe and should only be called from the main thread, so we should already be executing on the main thread now.
        // dispatch_async is used to ensure that the completion block for a request is not executed before the request ID is returned, for example in the
        // case where the user has denied permission to access location services and the request is immediately completed with the appropriate error.
    @eg_weakify(self)
    dispatch_async(dispatch_get_main_queue(), ^{
        @eg_strongify(self)
        if (locationRequest.block) {
            locationRequest.block(self.currentLocation, achievedAccuracy, status);
        }
    });
    
    NSLog(@"Location Request completed with ID: %ld, currentLocation: %@, achievedAccuracy: %lu, status: %lu", (long)locationRequest.requestID, currentLocation, (unsigned long) achievedAccuracy, (unsigned long)status);
}


/**
 Immediately completes all active location requests.
 Used in cases such as when the location services authorization status changes to Denied or Restricted.
 */
- (void)completeAllLocationRequests{
        // Iterate through a copy of the locationRequests array to avoid modifying the same array we are removing elements from
    NSArray<EGMLocationRequest *> *locationRequests = [NSMutableArray arrayWithArray:self.locationRequests];
    for (EGMLocationRequest *locationRequest in locationRequests) {
        [self completeLocationRequest:locationRequest];
    }
    NSLog(@"Finished completing all location requests.");
}


/**
 Removes a given location request from the array of requests, updates the maximum desired accuracy, and stops location updates if needed.
 */
- (void)removeLocationRequest:(EGMLocationRequest *)locationRequest{
    NSMutableArray<EGMLocationRequest *> *newLocationRequests = [NSMutableArray arrayWithArray:self.locationRequests];
    [newLocationRequests removeObject:locationRequest];
    self.locationRequests = newLocationRequests;
    
    switch (locationRequest.type) {
        case EGMLocationRequestTypeSingle:
        case EGMLocationRequestTypeSubscription:{
                // Determine the maximum desired accuracy for all remaining location requests
            EGMLocationAccuracy maximumDesiredAccuracy = EGMLocationAccuracyNone;
            for (EGMLocationRequest *locationRequest in [self activeLocationRequestsExcludingType:EGMLocationRequestTypeSignificantChanges]) {
                if (locationRequest.desiredAccuracy > maximumDesiredAccuracy) {
                    maximumDesiredAccuracy = locationRequest.desiredAccuracy;
                }
            }
            [self updateWithMaximumDesiredAccuracy:maximumDesiredAccuracy];
            
            [self stopUpdatingLocationIfPossible];
        }
            break;
        case EGMLocationRequestTypeSignificantChanges:
                //            [self stopMonitoringSignificantLocationChangesIfPossible];
            break;
    }
}

/**
 Sets the CLLocationManager desiredAccuracy based on the given maximum desired accuracy (which should be the maximum desired accuracy of all active location requests).
 */
- (void)updateWithMaximumDesiredAccuracy:(EGMLocationAccuracy)maximumDesiredAccuracy{
    switch (maximumDesiredAccuracy) {
        case EGMLocationAccuracyNone:
            break;
        case EGMLocationAccuracyCity:
            if (self.locationManager.desiredAccuracy != kCLLocationAccuracyThreeKilometers) {
                self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
                NSLog(@"Changing location services accuracy level to: low (minimum).");
            }
            break;
        case EGMLocationAccuracyNeighborhood:
            if (self.locationManager.desiredAccuracy != kCLLocationAccuracyKilometer) {
                self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
                NSLog(@"Changing location services accuracy level to: medium low.");
            }
            break;
        case EGMLocationAccuracyBlock:
            if (self.locationManager.desiredAccuracy != kCLLocationAccuracyHundredMeters) {
                self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
                NSLog(@"Changing location services accuracy level to: medium.");
            }
            break;
        case EGMLocationAccuracyHouse:
            if (self.locationManager.desiredAccuracy != kCLLocationAccuracyNearestTenMeters) {
                self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
                NSLog(@"Changing location services accuracy level to: medium high.");
            }
            break;
        case EGMLocationAccuracyRoom:
            if (self.locationManager.desiredAccuracy != kCLLocationAccuracyBest) {
                self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
                NSLog(@"Changing location services accuracy level to: high (maximum).");
            }
            break;
        default:
            NSAssert(nil, @"Invalid maximum desired accuracy!");
            break;
    }
}

/**
 Inform CLLocationManager to start sending us updates to our location.
 */
- (void)startUpdatingLocationIfNeeded{
    
    [self requestAuthorizationIfNeeded];
    
    NSArray *locationRequests = [self activeLocationRequestsExcludingType:EGMLocationRequestTypeSignificantChanges];
    if (locationRequests.count == 0) {
        [self.locationManager startUpdatingLocation];
        if (self.isUpdatingLocation == NO) {
            NSLog(@"Location services updates have started.");
        }
        self.isUpdatingLocation = YES;
    }
}

/**
 Checks to see if there are any outstanding locationRequests, and if there are none, informs CLLocationManager to stop sending
 location updates. This is done as soon as location updates are no longer needed in order to conserve the device's battery.
 */
- (void)stopUpdatingLocationIfPossible{
    NSArray *locationRequests = [self activeLocationRequestsExcludingType:EGMLocationRequestTypeSignificantChanges];
    if (locationRequests.count == 0) {
        [self.locationManager stopUpdatingLocation];
        if (self.isUpdatingLocation) {
            NSLog(@"Location services updates have stopped.");
        }
        self.isUpdatingLocation = NO;
    }
}

/**
 Returns all active location requests excluding requests with the given type.
 */
- (NSArray *)activeLocationRequestsExcludingType:(EGMLocationRequestType)locationRequestType{
    return [self.locationRequests filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(EGMLocationRequest *evaluatedObject, NSDictionary *bindings) {
        return evaluatedObject.type != locationRequestType;
    }]];
}

#pragma mark Heading

- (void)addHeadingRequest:(EGMHeadingRequest *)headingRequest{
    NSAssert(headingRequest, @"Must pass in a non-nil heading request.");
    
        // If heading services are not available, just return
    if ([EGLocationManager headingServicesState] == EGMHeadingServicesStateUnavailable) {
            // dispatch_async is used to ensure that the completion block for a request is not executed before the request ID is returned.
        dispatch_async(dispatch_get_main_queue(), ^{
            if (headingRequest.block) {
                headingRequest.block(nil, EGMHeadingStatusUnavailable);
            }
        });
        NSLog(@"Heading Request (ID %ld) NOT added since device heading is unavailable.", (long)headingRequest.requestID);
        return;
    }
    
    NSMutableArray<EGMHeadingRequest *> *newHeadingRequests = [NSMutableArray arrayWithArray:self.headingRequests];
    [newHeadingRequests addObject:headingRequest];
    self.headingRequests = newHeadingRequests;
    NSLog(@"Heading Request added with ID: %ld", (long)headingRequest.requestID);
    
    [self startUpdatingHeadingIfNeeded];
}

-(void)startUpdatingHeadingIfNeeded{
    if (self.headingRequests.count != 0) {
        [self.locationManager startUpdatingHeading];
        if (self.isUpdatingHeading == NO) {
            NSLog(@"Heading services updates have started.");
        }
        self.isUpdatingHeading = YES;
    }
}

-(void)processRecurringHeadingRequests{
    for (EGMHeadingRequest *headingRequest in self.headingRequests) {
        [self processRecurringHeadingRequest:headingRequest];
    }
}


/**
 Handles calling a recurring heading request's block with the current heading.
 */
- (void)processRecurringHeadingRequest:(EGMHeadingRequest *)headingRequest{
    NSAssert(headingRequest.isRecurring, @"This method should only be called for recurring heading requests.");
    
    EGMHeadingStatus status = [self statusForHeadingRequest:headingRequest];
    
        // Check if the request had a fatal error and should be canceled
    if (status == EGMHeadingStatusUnavailable) {
            // dispatch_async is used to ensure that the completion block for a request is not executed before the request ID is returned.
        dispatch_async(dispatch_get_main_queue(), ^{
            if (headingRequest.block) {
                headingRequest.block(nil, status);
            }
        });
        
        [self cancelHeadingRequest:headingRequest.requestID];
        return;
    }
        // dispatch_async is used to ensure that the completion block for a request is not executed before the request ID is returned.
    dispatch_async(dispatch_get_main_queue(), ^{
        if (headingRequest.block) {
            headingRequest.block(self.currentHeading, status);
        }
    });
}

/**
 Returns the status for the given heading request.
 */
- (EGMHeadingStatus)statusForHeadingRequest:(EGMHeadingRequest *)headingRequest{
    if ([EGLocationManager headingServicesState] == EGMHeadingServicesStateUnavailable) {
        return EGMHeadingStatusUnavailable;
    }
        // The accessor will return nil for an invalid heading results
    if (!self.currentHeading) {
        return EGMHeadingStatusInvalid;
    }
    return EGMHeadingStatusSuccess;
}

/**
 Removes a given heading request from the array of requests and stops heading updates if needed.
 */
- (void)removeHeadingRequest:(EGMHeadingRequest *)headingRequest{
    NSMutableArray<EGMHeadingRequest *> *newHeadingRequests = [NSMutableArray arrayWithArray:self.headingRequests];
    [newHeadingRequests removeObject:headingRequest];
    self.headingRequests = newHeadingRequests;
    
    [self stopUpdatingHeadingIfPossible];
}

/**
 Checks to see if there are any outstanding headingRequests, and if there are none, informs CLLocationManager to stop sending
 heading updates. This is done as soon as heading updates are no longer needed in order to conserve the device's battery.
 */
- (void)stopUpdatingHeadingIfPossible{
    if (self.headingRequests.count == 0) {
        [self.locationManager stopUpdatingHeading];
        if (self.isUpdatingHeading) {
            NSLog(@"Location services heading updates have stopped.");
        }
        self.isUpdatingHeading = NO;
    }
}

#pragma mark ---------------EGMLocationRequest delegate---------------
-(void)locationRequestDidTimeout:(EGMLocationRequest *)locationRequest{
    for (EGMLocationRequest *activeLocationRequest in self.locationRequests) {
        if (activeLocationRequest.requestID == locationRequest.requestID) {
            [self completeLocationRequest:locationRequest];
            break;
        }
    }
}

#pragma mark ---------------Services Status Get---------------
/**
 Returns the associated EGMLocationAccuracy level that has been achieved for a given location,
 based on that location's horizontal accuracy and recency.
 */
- (EGMLocationAccuracy)achievedAccuracyForLocation:(CLLocation *)location{
    if (location==nil) {
        return EGMLocationAccuracyNone;
    }
    
    NSTimeInterval timeSinceUpdate = fabs([location.timestamp timeIntervalSinceNow]);
    CLLocationAccuracy horizontalAccuracy = location.horizontalAccuracy;
    
    if (horizontalAccuracy <= kEGMHorizontalAccuracyThresholdRoom && timeSinceUpdate <= kEGMUpdateTimeStaleThresholdRoom) {
        return EGMLocationAccuracyRoom;
    }else if (horizontalAccuracy <= kEGMHorizontalAccuracyThresholdHouse && timeSinceUpdate <= kEGMUpdateTimeStaleThresholdHouse) {
        return EGMLocationAccuracyHouse;
    }else if (horizontalAccuracy <= kEGMHorizontalAccuracyThresholdBlock && timeSinceUpdate <= kEGMUpdateTimeStaleThresholdBlock) {
        return EGMLocationAccuracyBlock;
    }else if (horizontalAccuracy <= kEGMHorizontalAccuracyThresholdNeighborhood && timeSinceUpdate <= kEGMUpdateTimeStaleThresholdNeighborhood) {
        return EGMLocationAccuracyNeighborhood;
    }else if (horizontalAccuracy <= kEGMHorizontalAccuracyThresholdCity && timeSinceUpdate <= kEGMUpdateTimeStaleThresholdCity) {
        return EGMLocationAccuracyCity;
    }else {
        return EGMLocationAccuracyNone;
    }
}

/**
 Returns the location manager status for the given location request.
 */
- (EGMLocationStatus)statusForLocationRequest:(EGMLocationRequest *)locationRequest{
    
    EGMLocationServicesState locationServicesState = [EGLocationManager locationServicesState];
    switch (locationServicesState) {
        case EGMLocationServicesStateDisabled:
            return EGMLocationStatusServicesDisabled;
            break;
        case EGMLocationServicesStateDenied:
            return EGMLocationStatusServicesDenied;
            break;
        case EGMLocationServicesStateNotDetermined:
            return EGMLocationStatusServicesNotDetermined;
            break;
        case EGMLocationServicesStateRestricted:
            return EGMLocationStatusServicesRestricted;
            break;
        default:{
            if (self.updateFailed) {
                return EGMLocationStatusError;
            }else if (locationRequest.hasTimeout){
                return EGMLocationStatusTimedOut;
            }
            return EGMLocationStatusSuccess;
        }
            break;
    }
}

/**
 Returns the current state of location services for this app, based on the system settings and user authorization status.
 */
+ (EGMLocationServicesState)locationServicesState{
    CLAuthorizationStatus status=[CLLocationManager authorizationStatus];
    if ([CLLocationManager locationServicesEnabled] == NO) {
        return EGMLocationServicesStateDisabled;
    }else{
        switch (status) {
            case kCLAuthorizationStatusNotDetermined:{
                return EGMLocationServicesStateNotDetermined;
            }
                break;
            case kCLAuthorizationStatusDenied:{
                return EGMLocationServicesStateDenied;
            }
                break;
            case kCLAuthorizationStatusRestricted:{
                return EGMLocationServicesStateRestricted;
            }
                break;
            default:
                return EGMLocationServicesStateAvailable;
                break;
        }
    }
}

/**
 Returns the current state of heading services for this device.
 */
+ (EGMHeadingServicesState)headingServicesState{
    return [CLLocationManager headingAvailable] ? EGMHeadingServicesStateAvailable : EGMHeadingServicesStateUnavailable;
}

#pragma mark ---------------Request Authorization---------------
/**
 Requests permission to use location services.
 */
-(void)requestAuthorizationIfNeeded{
    
    double iOSVersion = floor(NSFoundationVersionNumber);
    BOOL isiOSVersion8to10 = iOSVersion > NSFoundationVersionNumber_iOS_8_1 && iOSVersion <= NSFoundationVersionNumber10_11_Max;
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        
        BOOL hasAlwaysAndInUseKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysAndWhenInUseUsageDescription"] != nil;
        
        if (isiOSVersion8to10) {
            BOOL hasAlwaysKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"] != nil || hasAlwaysAndInUseKey;
            
            BOOL hasWhenInUseKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"] != nil;
            
            if (hasAlwaysKey) {
                [self.locationManager requestAlwaysAuthorization];
            } else if (hasWhenInUseKey) {
                [self.locationManager requestWhenInUseAuthorization];
            } else {
                NSAssert(hasAlwaysKey || hasWhenInUseKey, @"To use location services in iOS 8+, your Info.plist must provide a value for either NSLocationWhenInUseUsageDescription or NSLocationAlwaysUsageDescription.");
            }
        } else {
            if (hasAlwaysAndInUseKey) {
                [self.locationManager requestAlwaysAuthorization];
            } else {
                NSAssert(hasAlwaysAndInUseKey, @"To use location services in iOS 11+, your Info.plist must provide a value for NSLocationAlwaysAndWhenInUseUsageDescription.");
            }
        }
    }
}


#pragma mark ---------------Set BackMode---------------
- (void)setBackgroundLocationUpdate:(BOOL) enabled {
    NSArray *backgroundModes = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"UIBackgroundModes"];
    if (@available(iOS 9.0, *)) {
        if ([backgroundModes containsObject:@"location"]) {
            self.locationManager.allowsBackgroundLocationUpdates = enabled;
        }
    }
}

#pragma mark ---------------CLLocationManagerDelegate---------------
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
        // Received update successfully, so clear any previous errors
    self.updateFailed = NO;
    
    CLLocation *mostRecentLocation = [locations lastObject];
    self.currentLocation = mostRecentLocation;
    
        // Process the location requests using the updated location
    [self processLocationRequests];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"<EGLocationManager Error>%@", [error localizedDescription]);
    self.updateFailed = YES;
    
    for (EGMLocationRequest *locationRequest in self.locationRequests) {
        if (locationRequest.isRecurring) {
                // Keep the recurring request alive
            [self processRecurringRequest:locationRequest];
        } else {
                // Fail any non-recurring requests
            [self completeLocationRequest:locationRequest];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    
    if (status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusRestricted) {
            // Clear out any active location requests (which will execute the blocks with a status that reflects
            // the unavailability of location services) since we now no longer have location services permissions
        [self completeAllLocationRequests];
    }else if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        
            // Start the timeout timer for location requests that were waiting for authorization
        for (EGMLocationRequest *locationRequest in self.locationRequests) {
            [locationRequest startTimeoutTimerIfNeeded];
        }
    }
}
-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
    self.currentHeading=newHeading;
    [self processRecurringHeadingRequests];
}


#pragma mark ---------------lazy var---------------
/**
 Returns the most recent current location, or nil if the current location is unknown, invalid, or stale.
 */
- (CLLocation *)currentLocation{
    if (_currentLocation) {
            // Location isn't nil, so test to see if it is valid
        if (!CLLocationCoordinate2DIsValid(_currentLocation.coordinate) || (_currentLocation.coordinate.latitude == 0.0 && _currentLocation.coordinate.longitude == 0.0)) {
                // The current location is invalid; discard it and return nil
            _currentLocation = nil;
        }
    }
        // Location is either nil or valid at this point, return it
    return _currentLocation;
}

-(CLLocationManager *)locationManager{
    if (_locationManager==nil) {
        _locationManager=[[CLLocationManager alloc]init];
        _locationManager.delegate=self;
    }
    return _locationManager;
}
@end
