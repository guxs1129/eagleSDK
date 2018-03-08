//
//  EGChainKitForCALayer.m
//  ChainFunction
//
//  Created by TengShuQiang on 2017/12/28.
//  Copyright © 2017年 TTeng. All rights reserved.
//

#import "EGChainKitForCALayer.h"

@interface EGChainKitForCALayer ()

@property (nonatomic, strong) CALayer *layer;

@end

@implementation EGChainKitForCALayer

- (EGChainKitForCALayer *(^)(CGRect)) bounds {
    return ^(CGRect bounds) {
        self.layer.bounds = bounds;
        return self;
    };
}
- (EGChainKitForCALayer *(^)(CGPoint)) position {
    return ^(CGPoint position) {
        self.layer.position = position;
        return self;
    };
}
- (EGChainKitForCALayer *(^)(CGFloat)) zPosition {
    return ^(CGFloat zPosition) {
        self.layer.zPosition = zPosition;
        return self;
    };
}
- (EGChainKitForCALayer *(^)(CGPoint)) anchorPoint {
    return ^(CGPoint anchorPoint) {
        self.layer.anchorPoint = anchorPoint;
        return self;
    };
}
- (EGChainKitForCALayer *(^)(CGFloat)) anchorPointZ {
    return ^(CGFloat anchorPointZ) {
        self.layer.anchorPointZ = anchorPointZ;
        return self;
    };
}
- (EGChainKitForCALayer *(^)(CATransform3D)) transform {
    return ^(CATransform3D transform) {
        self.layer.transform = transform;
        return self;
    };
}
- (EGChainKitForCALayer *(^)(CGAffineTransform)) affineTransform {
    return ^(CGAffineTransform affineTransform) {
        self.layer.affineTransform = affineTransform;
        return self;
    };
}
- (EGChainKitForCALayer *(^)(CGRect)) frame {
    return ^(CGRect frame) {
        self.layer.frame = frame;
        return self;
    };
}
- (EGChainKitForCALayer *(^)(BOOL)) hidden {
    return ^(BOOL hidden) {
        self.layer.hidden = hidden;
        return self;
    };
}
- (EGChainKitForCALayer *(^)(BOOL)) doubleSided {
    return ^(BOOL doubleSided) {
        self.layer.doubleSided = doubleSided;
        return self;
    };
}
- (EGChainKitForCALayer *(^)(BOOL)) geometryFlipped {
    return ^(BOOL geometryFlipped) {
        self.layer.geometryFlipped = geometryFlipped;
        return self;
    };
}
- (EGChainKitForCALayer *(^)(CATransform3D)) sublayerTransform {
    return ^(CATransform3D sublayerTransform) {
        self.layer.sublayerTransform = sublayerTransform;
        return self;
    };
}
- (EGChainKitForCALayer *(^)(CALayer *)) mask {
    return ^(CALayer * mask) {
        self.layer.mask = mask;
        return self;
    };
}
- (EGChainKitForCALayer *(^)(BOOL)) masksToBounds {
    return ^(BOOL masksToBounds) {
        self.layer.masksToBounds = masksToBounds;
        return self;
    };
}
- (EGChainKitForCALayer *(^)(id)) contents {
    return ^(id contents) {
        self.layer.contents = contents;
        return self;
    };
}
- (EGChainKitForCALayer *(^)(CGRect)) contentsRect {
    return ^(CGRect contentsRect) {
        self.layer.contentsRect = contentsRect;
        return self;
    };
}
- (EGChainKitForCALayer *(^)(NSString *)) contentsGravity {
    return ^(NSString * contentsGravity) {
        self.layer.contentsGravity = contentsGravity;
        return self;
    };
}
- (EGChainKitForCALayer *(^)(CGFloat)) contentsScale {
    return ^(CGFloat contentsScale) {
        self.layer.contentsScale = contentsScale;
        return self;
    };
}
- (EGChainKitForCALayer *(^)(CGRect)) contentsCenter {
    return ^(CGRect contentsCenter) {
        self.layer.contentsCenter = contentsCenter;
        return self;
    };
}
- (EGChainKitForCALayer *(^)(NSString *)) contentsFormat {
    return ^(NSString * contentsFormat) {
        self.layer.contentsFormat = contentsFormat;
        return self;
    };
}
- (EGChainKitForCALayer *(^)(NSString *)) minificationFilter {
    return ^(NSString * minificationFilter) {
        self.layer.minificationFilter = minificationFilter;
        return self;
    };
}
- (EGChainKitForCALayer *(^)(NSString *)) magnificationFilter {
    return ^(NSString * magnificationFilter) {
        self.layer.magnificationFilter = magnificationFilter;
        return self;
    };
}
- (EGChainKitForCALayer *(^)(float)) minificationFilterBias {
    return ^(float minificationFilterBias) {
        self.layer.minificationFilterBias = minificationFilterBias;
        return self;
    };
}
- (EGChainKitForCALayer *(^)(BOOL)) opaque {
    return ^(BOOL opaque) {
        self.layer.opaque = opaque;
        return self;
    };
}
- (EGChainKitForCALayer *(^)(BOOL)) needsDisplayOnBoundsChange {
    return ^(BOOL needsDisplayOnBoundsChange) {
        self.layer.needsDisplayOnBoundsChange = needsDisplayOnBoundsChange;
        return self;
    };
}
- (EGChainKitForCALayer *(^)(BOOL)) drawsAsynchronously {
    return ^(BOOL drawsAsynchronously) {
        self.layer.drawsAsynchronously = drawsAsynchronously;
        return self;
    };
}
- (EGChainKitForCALayer *(^)(CGContextRef)) renderInContext {
    return ^(CGContextRef renderInContext) {
        [self.layer renderInContext:renderInContext];
        return self;
    };
}
- (EGChainKitForCALayer *(^)(CAEdgeAntialiasingMask)) edgeAntialiasingMask {
    return ^(CAEdgeAntialiasingMask edgeAntialiasingMask) {
        self.layer.edgeAntialiasingMask = edgeAntialiasingMask;
        return self;
    };
}
- (EGChainKitForCALayer *(^)(BOOL)) allowsEdgeAntialiasing {
    return ^(BOOL allowsEdgeAntialiasing) {
        self.layer.allowsEdgeAntialiasing = allowsEdgeAntialiasing;
        return self;
    };
}
- (EGChainKitForCALayer *(^)(CGColorRef)) backgroundColor {
    return ^(CGColorRef backgroundColor) {
        self.layer.backgroundColor = backgroundColor;
        return self;
    };
}
- (EGChainKitForCALayer *(^)(CGFloat)) cornerRadius {
    return ^(CGFloat cornerRadius) {
        self.layer.cornerRadius = cornerRadius;
        return self;
    };
}
- (EGChainKitForCALayer *(^)(CACornerMask)) maskedCorners {
    return ^(CACornerMask maskedCorners) {
        self.layer.maskedCorners = maskedCorners;
        return self;
    };
}
- (EGChainKitForCALayer *(^)(CGFloat)) borderWidth {
    return ^(CGFloat borderWidth) {
        self.layer.borderWidth = borderWidth;
        return self;
    };
}
- (EGChainKitForCALayer *(^)(CGColorRef)) borderColor {
    return ^(CGColorRef borderColor) {
        self.layer.borderColor = borderColor;
        return self;
    };
}
- (EGChainKitForCALayer *(^)(float)) opacity {
    return ^(float opacity) {
        self.layer.opacity = opacity;
        return self;
    };
}
- (EGChainKitForCALayer *(^)(BOOL)) allowsGroupOpacity {
    return ^(BOOL allowsGroupOpacity) {
        self.layer.allowsGroupOpacity = allowsGroupOpacity;
        return self;
    };
}
- (EGChainKitForCALayer *(^)(id)) compositingFilter {
    return ^(id compositingFilter) {
        self.layer.compositingFilter = compositingFilter;
        return self;
    };
}
- (EGChainKitForCALayer *(^)(NSArray *)) filters {
    return ^(NSArray * filters) {
        self.layer.filters = filters;
        return self;
    };
}
- (EGChainKitForCALayer *(^)(NSArray *)) backgroundFilters {
    return ^(NSArray * backgroundFilters) {
        self.layer.backgroundFilters = backgroundFilters;
        return self;
    };
}
- (EGChainKitForCALayer *(^)(BOOL)) shouldRasterize {
    return ^(BOOL shouldRasterize) {
        self.layer.shouldRasterize = shouldRasterize;
        return self;
    };
}
- (EGChainKitForCALayer *(^)(CGFloat)) rasterizationScale {
    return ^(CGFloat rasterizationScale) {
        self.layer.rasterizationScale = rasterizationScale;
        return self;
    };
}
- (EGChainKitForCALayer *(^)(CGColorRef)) shadowColor {
    return ^(CGColorRef shadowColor) {
        self.layer.shadowColor = shadowColor;
        return self;
    };
}
- (EGChainKitForCALayer *(^)(float)) shadowOpacity {
    return ^(float shadowOpacity) {
        self.layer.shadowOpacity = shadowOpacity;
        return self;
    };
}
- (EGChainKitForCALayer *(^)(CGSize)) shadowOffset {
    return ^(CGSize shadowOffset) {
        self.layer.shadowOffset = shadowOffset;
        return self;
    };
}
- (EGChainKitForCALayer *(^)(CGFloat)) shadowRadius {
    return ^(CGFloat shadowRadius) {
        self.layer.shadowRadius = shadowRadius;
        return self;
    };
}

- (EGChainKitForCALayer *(^)(CGPathRef)) shadowPath {
    return ^(CGPathRef shadowPath) {
        self.layer.shadowPath = shadowPath;
        return self;
    };
}
- (EGChainKitForCALayer *(^)(NSDictionary<NSString *, id<CAAction>> *)) actions {
    return ^(NSDictionary<NSString *, id<CAAction>> *actions) {
        self.layer.actions = actions;
        return self;
    };
}

- (EGChainKitForCALayer *(^)(NSString *)) name {
    return ^(NSString *name) {
        self.layer.name = name;
        return self;
    };
}
- (EGChainKitForCALayer *(^)(id <CALayerDelegate>)) delegate {
    return ^(id <CALayerDelegate> delegate) {
        self.layer.delegate = delegate;
        return self;
    };
}

- (EGChainKitForCALayer *(^)(NSDictionary *)) style {
    return ^(NSDictionary *style) {
        self.layer.style = style;
        return self;
    };
}

- (EGChainKitForCALayer *(^)(CALayer *)) addSublayer {
    return ^(CALayer *layer) {
        [self.layer addSublayer:layer];
        return self;
    };
}

- (EGChainKitForCALayer *(^)(CALayer *)) addToSuperLayer {
    return ^(CALayer *layer) {
        [layer addSublayer:self.layer];
        return self;
    };
}

- (EGChainKitForCALayer *(^)(CAAnimation *,NSString *)) addAnimationForKey {
    return ^(CAAnimation *ani,NSString *key) {
        [self.layer addAnimation:ani forKey:key];
        return self;
    };
}

- (EGChainKitForCALayer *(^)(NSString *)) removeAnimationForKey {
    return ^(NSString *key) {
        [self.layer removeAnimationForKey:key];
        return self;
    };
}

@end

#import <objc/runtime.h>

@implementation CALayer (ChainFunction)

- (EGChainKitForCALayer *)chainMaker {
    EGChainKitForCALayer *chain = objc_getAssociatedObject(self, _cmd);
    if (!chain) {
        chain = [EGChainKitForCALayer new];
        chain.layer = self;
        objc_setAssociatedObject(self, _cmd, chain, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return chain;
}

@end
