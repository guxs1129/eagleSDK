//
//  EGMLocationConverter.h
//  EagleSDK
//
//  Created by 顾新生 on 2018/1/10.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@interface EGMLocationConverter : NSObject
/**
 *  判断是否在中国
 */
+(BOOL)isLocationOutOfChina:(CLLocationCoordinate2D)location;

/**
 *  将WGS-84转为GCJ-02(火星坐标):
 */
+(CLLocationCoordinate2D)convertWGSToGCJ:(CLLocationCoordinate2D)wgsLoc;

/**
 *  将GCJ-02(火星坐标)转为百度坐标:
 */
+(CLLocationCoordinate2D)convertGCJToBaidu:(CLLocationCoordinate2D)p;

/**
 *  将百度坐标转为GCJ-02(火星坐标):
 */
+(CLLocationCoordinate2D)convertBaiduToGCJ:(CLLocationCoordinate2D)p;

/**
 *  将GCJ-02(火星坐标)转为WGS-84:
 */
+(CLLocationCoordinate2D)convertGCJToWGS:(CLLocationCoordinate2D)p;

@end
