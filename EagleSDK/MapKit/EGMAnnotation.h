//
//  EGMAnnotation.h
//  EagleSDK
//
//  Created by 顾新生 on 2018/1/18.
//

#import <Foundation/Foundation.h>
@protocol MKAnnotation;
@interface EGMAnnotation : NSObject<MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@property (nonatomic, readonly, copy, nullable) NSString *title;
@property (nonatomic, readonly, copy, nullable) NSString *subtitle;
@property(nonatomic,assign)BOOL animatedDrop;

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;
-(instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *_Nonnull)title subtitle:(NSString *_Nullable)subtitle;
@end
