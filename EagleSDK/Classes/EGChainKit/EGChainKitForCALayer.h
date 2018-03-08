//
//  EGChainKitForCALayer.h
//  ChainFunction
//
//  Created by TengShuQiang on 2017/12/28.
//  Copyright © 2017年 TTeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface EGChainKitForCALayer : NSObject

- (EGChainKitForCALayer *(^)(CGRect)) bounds;
- (EGChainKitForCALayer *(^)(CGPoint)) position;
- (EGChainKitForCALayer *(^)(CGFloat)) zPosition;
- (EGChainKitForCALayer *(^)(CGPoint)) anchorPoint;
- (EGChainKitForCALayer *(^)(CGFloat)) anchorPointZ;
- (EGChainKitForCALayer *(^)(CATransform3D)) transform;
- (EGChainKitForCALayer *(^)(CGAffineTransform)) affineTransform;
- (EGChainKitForCALayer *(^)(CGRect)) frame;
- (EGChainKitForCALayer *(^)(BOOL)) hidden;
- (EGChainKitForCALayer *(^)(BOOL)) doubleSided;
- (EGChainKitForCALayer *(^)(BOOL)) geometryFlipped;
- (EGChainKitForCALayer *(^)(CATransform3D)) sublayerTransform;
- (EGChainKitForCALayer *(^)(CALayer *)) mask;
- (EGChainKitForCALayer *(^)(BOOL)) masksToBounds;
- (EGChainKitForCALayer *(^)(id)) contents;
- (EGChainKitForCALayer *(^)(CGRect)) contentsRect;
- (EGChainKitForCALayer *(^)(NSString *)) contentsGravity;
- (EGChainKitForCALayer *(^)(CGFloat)) contentsScale;
- (EGChainKitForCALayer *(^)(CGRect)) contentsCenter;
- (EGChainKitForCALayer *(^)(NSString *)) contentsFormat;
- (EGChainKitForCALayer *(^)(NSString *)) minificationFilter;
- (EGChainKitForCALayer *(^)(NSString *)) magnificationFilter;
- (EGChainKitForCALayer *(^)(float)) minificationFilterBias;
- (EGChainKitForCALayer *(^)(BOOL)) opaque;
- (EGChainKitForCALayer *(^)(BOOL)) needsDisplayOnBoundsChange;
- (EGChainKitForCALayer *(^)(BOOL)) drawsAsynchronously;
- (EGChainKitForCALayer *(^)(CGContextRef)) renderInContext;
- (EGChainKitForCALayer *(^)(CAEdgeAntialiasingMask)) edgeAntialiasingMask;
- (EGChainKitForCALayer *(^)(BOOL)) allowsEdgeAntialiasing;
- (EGChainKitForCALayer *(^)(CGColorRef)) backgroundColor;
- (EGChainKitForCALayer *(^)(CGFloat)) cornerRadius;
- (EGChainKitForCALayer *(^)(CACornerMask)) maskedCorners CA_AVAILABLE_STARTING (10.13, 11.0, 11.0, 4.0);
- (EGChainKitForCALayer *(^)(CGFloat)) borderWidth;
- (EGChainKitForCALayer *(^)(CGColorRef)) borderColor;
- (EGChainKitForCALayer *(^)(float)) opacity;
- (EGChainKitForCALayer *(^)(BOOL)) allowsGroupOpacity;
- (EGChainKitForCALayer *(^)(id)) compositingFilter;
- (EGChainKitForCALayer *(^)(NSArray *)) filters;
- (EGChainKitForCALayer *(^)(NSArray *)) backgroundFilters;
- (EGChainKitForCALayer *(^)(BOOL)) shouldRasterize;
- (EGChainKitForCALayer *(^)(CGFloat)) rasterizationScale;
- (EGChainKitForCALayer *(^)(CGColorRef)) shadowColor;
- (EGChainKitForCALayer *(^)(float)) shadowOpacity;
- (EGChainKitForCALayer *(^)(CGSize)) shadowOffset;
- (EGChainKitForCALayer *(^)(CGFloat)) shadowRadius;
- (EGChainKitForCALayer *(^)(CGPathRef)) shadowPath;
- (EGChainKitForCALayer *(^)(NSDictionary<NSString *, id<CAAction>> *)) actions;
- (EGChainKitForCALayer *(^)(NSString *)) name;
- (EGChainKitForCALayer *(^)(id <CALayerDelegate>)) delegate;
- (EGChainKitForCALayer *(^)(NSDictionary *)) style;

- (EGChainKitForCALayer *(^)(CALayer *)) addSublayer;
- (EGChainKitForCALayer *(^)(CALayer *)) addToSuperLayer;
- (EGChainKitForCALayer *(^)(CAAnimation *,NSString *)) addAnimationForKey;
- (EGChainKitForCALayer *(^)(NSString *)) removeAnimationForKey;

@end

@interface CALayer (ChainFunction)

@property (nonatomic, strong, readonly) EGChainKitForCALayer *chainMaker;

@end
