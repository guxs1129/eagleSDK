//
//  MKMapView+ZoomLevel.h
//  EagleSDK
//
//  Created by 顾新生 on 2018/1/23.
//

#import <MapKit/MapKit.h>

@interface MKMapView (ZoomLevel)
-(int)getZoomLevel;

- (MKCoordinateSpan)coordinateSpanWithMapView:(MKMapView *)mapView centerCoordinate:(CLLocationCoordinate2D)centerCoordinate andZoomLevel:(NSUInteger)zoomLevel;

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate zoomLevel:(NSUInteger)zoomLevel animated:(BOOL)animated;
@end
