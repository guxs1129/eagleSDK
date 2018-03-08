//
//  EGMapDefines.h
//  Pods
//
//  Created by 顾新生 on 2018/1/10.
//

#ifndef EGMapDefines_h
#define EGMapDefines_h
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
typedef NS_ENUM(NSInteger,EGMLocationServicesState) {
    EGMLocationServicesStateAvailable,
    /** User has not yet responded to the dialog that grants this app permission to access location services. */
    EGMLocationServicesStateNotDetermined,
    /** User has explicitly denied this app permission to access location services. (The user can enable permissions again for this app from the system Settings app.) */
    EGMLocationServicesStateDenied,
    /** User does not have ability to enable location services (e.g. parental controls, corporate policy, etc). */
    EGMLocationServicesStateRestricted,
    /** User has turned off location services device-wide (for all apps) from the system Settings app. */
    EGMLocationServicesStateDisabled
};

/** The possible states that heading services can be in. */
typedef NS_ENUM(NSInteger, EGMHeadingServicesState) {
    /** Heading services are available on the device */
    EGMHeadingServicesStateAvailable,
    /** Heading services are available on the device */
    EGMHeadingServicesStateUnavailable,
};

/** The types of location requests. */
typedef NS_ENUM(NSInteger, EGMLocationRequestType) {
    /** A one-time location request with a specific desired accuracy and optional timeout. */
    EGMLocationRequestTypeSingle,
    /** A subscription to location updates. */
    EGMLocationRequestTypeSubscription,
    /** A subscription to significant location changes. */
    EGMLocationRequestTypeSignificantChanges
};

typedef NS_ENUM(NSInteger, EGMLocationAccuracy) {
        // 'None' is not valid as a desired accuracy.
    /** Inaccurate (>5000 meters, and/or received >10 minutes ago). */
    EGMLocationAccuracyNone = 0,
    
        // The below options are valid desired accuracies.
    /** 5000 meters or better, and received within the last 10 minutes. Lowest accuracy. */
    EGMLocationAccuracyCity,
    /** 1000 meters or better, and received within the last 5 minutes. */
    EGMLocationAccuracyNeighborhood,
    /** 100 meters or better, and received within the last 1 minute. */
    EGMLocationAccuracyBlock,
    /** 15 meters or better, and received within the last 15 seconds. */
    EGMLocationAccuracyHouse,
    /** 5 meters or better, and received within the last 5 seconds. Highest accuracy. */
    EGMLocationAccuracyRoom,
};

/** A status that will be passed in to the completion block of a location request. */
typedef NS_ENUM(NSInteger, EGMLocationStatus) {
        // These statuses will accompany a valid location.
    /** Got a location and desired accuracy level was achieved successfully. */
    EGMLocationStatusSuccess = 0,
    /** Got a location, but the desired accuracy level was not reached before timeout. (Not applicable to subscriptions.) */
    EGMLocationStatusTimedOut,
    
        // These statuses indicate some sort of error, and will accompany a nil location.
    /** User has not yet responded to the dialog that grants this app permission to access location services. */
    EGMLocationStatusServicesNotDetermined,
    /** User has explicitly denied this app permission to access location services. */
    EGMLocationStatusServicesDenied,
    /** User does not have ability to enable location services (e.g. parental controls, corporate policy, etc). */
    EGMLocationStatusServicesRestricted,
    /** User has turned off location services device-wide (for all apps) from the system Settings app. */
    EGMLocationStatusServicesDisabled,
    /** An error occurred while using the system location services. */
    EGMLocationStatusError
};

/** A status that will be passed in to the completion block of a heading request. */
typedef NS_ENUM(NSInteger, EGMHeadingStatus) {
        // These statuses will accompany a valid heading.
    /** Got a heading successfully. */
    EGMHeadingStatusSuccess = 0,
    
        // These statuses indicate some sort of error, and will accompany a nil heading.
    /** Heading was invalid. */
    EGMHeadingStatusInvalid,
    
    /** Heading services are not available on the device */
    EGMHeadingStatusUnavailable
};

/** A unique ID that corresponds to one location request. */
typedef NSInteger EGMLocationRequestID;
/** A unique ID that corresponds to one heading request. */
typedef NSInteger EGMHeadingRequestID;

static const NSTimeInterval kEGMUpdateTimeStaleThresholdCity =             600.0;  // in seconds
static const NSTimeInterval kEGMUpdateTimeStaleThresholdNeighborhood =     300.0;  // in seconds
static const NSTimeInterval kEGMUpdateTimeStaleThresholdBlock =             60.0;  // in seconds
static const NSTimeInterval kEGMUpdateTimeStaleThresholdHouse =             15.0;  // in seconds
static const NSTimeInterval kEGMUpdateTimeStaleThresholdRoom =               5.0;  // in seconds

static const CLLocationAccuracy kEGMHorizontalAccuracyThresholdCity =         5000.0;  // in meters
static const CLLocationAccuracy kEGMHorizontalAccuracyThresholdNeighborhood = 1000.0;  // in meters
static const CLLocationAccuracy kEGMHorizontalAccuracyThresholdBlock =         100.0;  // in meters
static const CLLocationAccuracy kEGMHorizontalAccuracyThresholdHouse =          15.0;  // in meters
static const CLLocationAccuracy kEGMHorizontalAccuracyThresholdRoom =            5.0;  // in meters

/**
 A block type for a location request, which is executed when the request succeeds, fails, or times out.
 
 @param currentLocation The most recent & accurate current location available when the block executes, or nil if no valid location is available.
 @param achievedAccuracy The accuracy level that was actually achieved (may be better than, equal to, or worse than the desired accuracy).
 @param status The status of the location request - whether it succeeded, timed out, or failed due to some sort of error. This can be used to
 understand what the outcome of the request was, decide if/how to use the associated currentLocation, and determine whether other
 actions are required (such as displaying an error message to the user, retrying with another request, quietly proceeding, etc).
 */
typedef void(^EGMLocationRequestBlock)(CLLocation *currentLocation, EGMLocationAccuracy achievedAccuracy, EGMLocationStatus status);


/**
 A block type for a heading request, which is executed when the request succeeds.
 
 @param currentHeading  The most recent current heading available when the block executes.
 @param status          The status of the request - whether it succeeded or failed due to some sort of error. This can be used to understand if any further action is needed.
 */
typedef void(^EGMHeadingRequestBlock)(CLHeading *currentHeading, EGMHeadingStatus status);



/**
 A block type for a map search request.

 @param results The search result is a array.
 @param error Error handle.
 */
typedef void(^EGMSearchResultHandler) (MKLocalSearchResponse *results,NSError *error);

/**
 A block type for zoombar action when slides to change mapview's zoomlevel.

 @param level ZoomLevel
 */
typedef void(^EGMapZoomBarActionBlock)(int level);
#endif /* EGMapDefines_h */
