//
//  EGChainKitForUIView.m
//  ChainProperty
//
//  Created by TengShuQiang on 2017/12/25.
//  Copyright © 2017年 TTeng. All rights reserved.
//

#import "EGChainKitForUIView.h"

@interface EGChainKitForUIView ()

@property (nonatomic, strong) UIView *view;

@end

@implementation EGChainKitForUIView

- (EGChainKitForUIView *(^)(NSInteger)) tag {
    return ^(NSInteger tag){
        self.view.tag = tag;
        return self;
    };
}

//UIViewGeometry
- (EGChainKitForUIView *(^)(CGRect)) frame {
    return ^(CGRect frame) {
        self.view.frame = frame;
        return self;
    };
}
- (EGChainKitForUIView *(^)(CGRect)) bounds {
    return ^(CGRect bounds) {
        self.view.bounds = bounds;
        return self;
    };
}
- (EGChainKitForUIView *(^)(CGPoint)) center {
    return ^(CGPoint center) {
        self.view.center = center;
        return self;
    };
}
- (EGChainKitForUIView *(^)(CGAffineTransform)) transform {
    return ^(CGAffineTransform transform) {
        self.view.transform = transform;
        return self;
    };
}

- (EGChainKitForUIView *(^)(CGFloat)) contentScaleFactor {
    return ^(CGFloat contentScaleFactor) {
        self.view.contentScaleFactor = contentScaleFactor;
        return self;
    };
}
- (EGChainKitForUIView *(^)(BOOL)) multipleTouchEnabled {
    return ^(BOOL multipleTouchEnabled) {
        self.view.multipleTouchEnabled = multipleTouchEnabled;
        return self;
    };
}
- (EGChainKitForUIView *(^)(BOOL)) exclusiveTouch {
    return ^(BOOL exclusiveTouch) {
        self.view.exclusiveTouch = exclusiveTouch;
        return self;
    };
}
- (EGChainKitForUIView *(^)(BOOL)) autoresizesSubviews {
    return ^(BOOL autoresizesSubviews) {
        self.view.autoresizesSubviews = autoresizesSubviews;
        return self;
    };
}
- (EGChainKitForUIView *(^)(UIViewAutoresizing)) autoresizingMask {
    return ^(UIViewAutoresizing autoresizingMask) {
        self.view.autoresizingMask = autoresizingMask;
        return self;
    };
}

//UIViewHierarchy
- (EGChainKitForUIView *(^)(UIEdgeInsets)) layoutMargins {
    return ^(UIEdgeInsets layoutMargins) {
        self.view.layoutMargins = layoutMargins;
        return self;
    };
}
- (EGChainKitForUIView *(^)(NSDirectionalEdgeInsets)) directionalLayoutMargins {
    return ^(NSDirectionalEdgeInsets directionalLayoutMargins) {
        self.view.directionalLayoutMargins = directionalLayoutMargins;
        return self;
    };
}
- (EGChainKitForUIView *(^)(BOOL)) preservesSuperviewLayoutMargins {
    return ^(BOOL preservesSuperviewLayoutMargins) {
        self.view.preservesSuperviewLayoutMargins = preservesSuperviewLayoutMargins;
        return self;
    };
}
- (EGChainKitForUIView *(^)(BOOL)) insetsLayoutMarginsFromSafeArea {
    return ^(BOOL insetsLayoutMarginsFromSafeArea) {
        self.view.insetsLayoutMarginsFromSafeArea = insetsLayoutMarginsFromSafeArea;
        return self;
    };
}

//UIViewRendering
- (EGChainKitForUIView *(^)(BOOL)) clipsToBounds {
    return ^(BOOL clipsToBounds) {
        self.view.clipsToBounds = clipsToBounds;
        return self;
    };
}
- (EGChainKitForUIView *(^)(UIColor *)) backgroundColor {
    return ^(UIColor * backgroundColor) {
        self.view.backgroundColor = backgroundColor;
        return self;
    };
}
- (EGChainKitForUIView *(^)(CGFloat)) alpha {
    return ^(CGFloat alpha) {
        self.view.alpha = alpha;
        return self;
    };
}
- (EGChainKitForUIView *(^)(BOOL)) opaque {
    return ^(BOOL opaque) {
        self.view.opaque = opaque;
        return self;
    };
}
- (EGChainKitForUIView *(^)(BOOL)) clearsContextBeforeDrawing {
    return ^(BOOL clearsContextBeforeDrawing) {
        self.view.clearsContextBeforeDrawing = clearsContextBeforeDrawing;
        return self;
    };
}

- (EGChainKitForUIView *(^)(BOOL)) hidden {
    return ^(BOOL hidden) {
        self.view.hidden = hidden;
        return self;
    };
}
- (EGChainKitForUIView *(^)(UIViewContentMode)) contentMode {
    return ^(UIViewContentMode contentMode) {
        self.view.contentMode = contentMode;
        return self;
    };
}
- (EGChainKitForUIView *(^)(UIView *)) maskView {
    return ^(UIView * maskView) {
        self.view.maskView = maskView;
        return self;
    };
}
- (EGChainKitForUIView *(^)(UIColor *)) tintColor {
    return ^(UIColor * tintColor) {
        self.view.tintColor = tintColor;
        return self;
    };
}
- (EGChainKitForUIView *(^)(UIViewTintAdjustmentMode)) tintAdjustmentMode {
    return ^(UIViewTintAdjustmentMode  tintAdjustmentMode) {
        self.view.tintAdjustmentMode = tintAdjustmentMode;
        return self;
    };
}

//UIConstraintBasedCompatibility
- (EGChainKitForUIView *(^)(BOOL)) translatesAutoresizingMaskIntoConstraints {
    return ^(BOOL  translatesAutoresizingMaskIntoConstraints) {
        self.view.translatesAutoresizingMaskIntoConstraints = translatesAutoresizingMaskIntoConstraints;
        return self;
    };
}

//
- (EGChainKitForUIView *(^)(UIView *)) addSubview {
    return ^(UIView *subview) {
        [self.view addSubview:subview];
        return self;
    };
}
- (EGChainKitForUIView *(^)(UIView *)) addToSuperView {
    return ^(UIView *superView) {
        [superView addSubview:self.view];
        return self;
    };
}
#pragma mark layer
- (EGChainKitForCALayer *(^)(void)) layerMaker {
    return ^(void) {
        return self.view.layer.chainMaker;
    };
}

#pragma mark - subviews
- (EGChainKitForUILabel *(^)(void))labelMaker {
    return ^(void) {
        NSAssert([self.view isKindOfClass:[UILabel class]], @"labelChain's target must be UILabel class");
        return ((UILabel *)self.view).labelChain;
    };
}
- (EGChainKitForUIButton *(^)(void))buttonMaker {
    return ^(void) {
        NSAssert([self.view isKindOfClass:[UIButton class]], @"buttonChain's target must be UIButton class");
        return ((UIButton *)self.view).buttonChain;
    };
}
- (EGChainKitForUIImageView *(^)(void))imageViewMaker {
    return ^(void) {
        NSAssert([self.view isKindOfClass:[UIImageView class]], @"imageViewChain's target must be UIImageView class");
        return ((UIImageView *)self.view).imageViewChain;
    };
}
- (EGChainKitForUITextField *(^)(void))textFieldMaker {
    return ^(void) {
        NSAssert([self.view isKindOfClass:[UITextField class]], @"textFieldChain's target must be UITextField class");
        return ((UITextField *)self.view).textFieldChain;
    };
}
- (EGChainKitForUITextView *(^)(void))textViewMaker {
    return ^(void) {
        NSAssert([self.view isKindOfClass:[UITextView class]], @"textViewChain's target must be UITextView class");
        return ((UITextView *)self.view).textViewChain;
    };
}
- (EGChainKitForUIScrollView *(^)(void))scrollViewMaker {
    return ^(void) {
        NSAssert([self.view isKindOfClass:[UIScrollView class]], @"scrollViewChain's target must be UIScrollView class");
        return ((UIScrollView *)self.view).scrollChain;
    };
}
- (EGChainKitForUITableView *(^)(void))tableViewMaker {
    return ^(void) {
        NSAssert([self.view isKindOfClass:[UITableView class]], @"tableViewChain's target must be UITableView class");
        return ((UITableView *)self.view).tableViewChain;
    };
}

- (EGChainKitForUIControl *(^)(void))controlMaker {
    return ^(void) {
        NSAssert([self.view isKindOfClass:[UIControl class]], @"controlChain's target must be UIControl class");
        return ((UIControl *)self.view).controlChain;
    };
}

- (EGChainKitForUICollectionView *(^)(void))collectionViewMaker {
    return ^(void) {
        NSAssert([self.view isKindOfClass:[UICollectionView class]], @"collectionViewChain's target must be UICollectionView class");
        return ((UICollectionView *)self.view).collectionViewChain;
    };
}

@end

#import <objc/runtime.h>

@implementation UIView (EGChainKit)

- (EGChainKitForUIView *)viewChain {
    EGChainKitForUIView *chain = objc_getAssociatedObject(self, _cmd);
    if (!chain) {
        chain = [EGChainKitForUIView new];
        chain.view = self;
        objc_setAssociatedObject(self, _cmd, chain, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return chain;
}


@end
