//
//  EGChainKitForUIImageView.m
//  ChainProperty
//
//  Created by TengShuQiang on 2017/12/25.
//  Copyright © 2017年 TTeng. All rights reserved.
//

#import "EGChainKitForUIImageView.h"

@interface EGChainKitForUIImageView ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation EGChainKitForUIImageView

- (EGChainKitForUIView *(^)(void)) viewMaker {
    return ^(void) {
        return ((UIView *)self.imageView).viewChain;
    };
}

#pragma mark -

- (EGChainKitForUIImageView *(^)(UIViewTintAdjustmentMode)) tintAdjustmentMode {
    return ^(UIViewTintAdjustmentMode  tintAdjustmentMode) {
        self.imageView.tintAdjustmentMode = tintAdjustmentMode;
        return self;
    };
}

//UIConstraintBasedCompatibility
- (EGChainKitForUIImageView *(^)(BOOL)) translatesAutoresizingMaskIntoConstraints {
    return ^(BOOL  translatesAutoresizingMaskIntoConstraints) {
        self.imageView.translatesAutoresizingMaskIntoConstraints = translatesAutoresizingMaskIntoConstraints;
        return self;
    };
}

- (EGChainKitForUIImageView *(^)(UIImage *)) image {
    return ^(UIImage *image) {
        self.imageView.image = image;
        return self;
    };
}
- (EGChainKitForUIImageView *(^)(UIImage *)) highlightedImage {
    return ^(UIImage *highlightedImage) {
        self.imageView.highlightedImage = highlightedImage;
        return self;
    };
}
- (EGChainKitForUIImageView *(^)(BOOL)) userInteractionEnabled {
    return ^(BOOL userInteractionEnabled) {
        self.imageView.userInteractionEnabled = userInteractionEnabled;
        return self;
    };
}
- (EGChainKitForUIImageView *(^)(BOOL)) highlighted {
    return ^(BOOL highlighted) {
        self.imageView.highlighted = highlighted;
        return self;
    };
}
- (EGChainKitForUIImageView *(^)(NSArray<UIImage *> *)) animationImages {
    return ^(NSArray<UIImage *> * animationImages) {
        self.imageView.animationImages = animationImages;
        return self;
    };
}
- (EGChainKitForUIImageView *(^)( NSArray<UIImage *> *)) highlightedAnimationImages {
    return ^(NSArray<UIImage *> * highlightedAnimationImages) {
        self.imageView.highlightedAnimationImages = highlightedAnimationImages;
        return self;
    };
}
- (EGChainKitForUIImageView *(^)(NSTimeInterval)) animationDuration {
    return ^(NSTimeInterval animationDuration) {
        self.imageView.animationDuration = animationDuration;
        return self;
    };
}
- (EGChainKitForUIImageView *(^)(NSInteger)) animationRepeatCount {
    return ^(NSInteger animationRepeatCount) {
        self.imageView.animationRepeatCount = animationRepeatCount;
        return self;
    };
}
- (EGChainKitForUIImageView *(^)(UIColor *)) tintColor {
    return ^(UIColor *tintColor) {
        self.imageView.tintColor = tintColor;
        return self;
    };
}

#pragma mark layer
- (EGChainKitForCALayer *(^)(void)) layerMaker {
    return ^(void) {
        return self.imageView.layer.chainMaker;
    };
}

@end

#import <objc/runtime.h>

@implementation UIImageView (EGChainKit)

- (EGChainKitForUIImageView *)imageViewChain {
    EGChainKitForUIImageView *chain = objc_getAssociatedObject(self, _cmd);
    if (!chain) {
        chain = [EGChainKitForUIImageView new];
        chain.imageView = self;
        objc_setAssociatedObject(self, _cmd, chain, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return chain;
}

@end
