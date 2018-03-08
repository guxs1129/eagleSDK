//
//  EGChainKitForUIScrollView.m
//  ChainProperty
//
//  Created by TengShuQiang on 2017/12/25.
//  Copyright © 2017年 TTeng. All rights reserved.
//

#import "EGChainKitForUIScrollView.h"

@interface EGChainKitForUIScrollView ()

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation EGChainKitForUIScrollView

- (EGChainKitForUIView *(^)(void))viewMaker {
    return ^(void) {
        return ((UIView *)self.scrollView).viewChain;
    };
}

#pragma mark - scrollView
- (EGChainKitForUIScrollView *(^)(CGPoint)) contentOffset {
    return ^(CGPoint  contentOffset) {
        self.scrollView.contentOffset = contentOffset;
        return self;
    };
}
- (EGChainKitForUIScrollView *(^)(CGSize)) contentSize {
    return ^(CGSize  contentSize) {
        self.scrollView.contentSize = contentSize;
        return self;
    };
}
- (EGChainKitForUIScrollView *(^)(UIEdgeInsets)) contentInset {
    return ^(UIEdgeInsets  contentInset) {
        self.scrollView.contentInset = contentInset;
        return self;
    };
}
- (EGChainKitForUIScrollView *(^)(UIScrollViewContentInsetAdjustmentBehavior)) contentInsetAdjustmentBehavior {
    return ^(UIScrollViewContentInsetAdjustmentBehavior  contentInsetAdjustmentBehavior) {
        self.scrollView.contentInsetAdjustmentBehavior = contentInsetAdjustmentBehavior;
        return self;
    };
}

- (EGChainKitForUIScrollView *(^)(id<UIScrollViewDelegate>)) delegate {
    return ^(id<UIScrollViewDelegate>  delegate) {
        self.scrollView.delegate = delegate;
        return self;
    };
}
- (EGChainKitForUIScrollView *(^)(BOOL)) directionalLockEnabled {
    return ^(BOOL  directionalLockEnabled) {
        self.scrollView.directionalLockEnabled = directionalLockEnabled;
        return self;
    };
}
- (EGChainKitForUIScrollView *(^)(BOOL)) bounces {
    return ^(BOOL  bounces) {
        self.scrollView.bounces = bounces;
        return self;
    };
}
- (EGChainKitForUIScrollView *(^)(BOOL)) alwaysBounceVertical {
    return ^(BOOL  alwaysBounceVertical) {
        self.scrollView.alwaysBounceVertical = alwaysBounceVertical;
        return self;
    };
}
- (EGChainKitForUIScrollView *(^)(BOOL)) alwaysBounceHorizontal {
    return ^(BOOL  alwaysBounceHorizontal) {
        self.scrollView.alwaysBounceHorizontal = alwaysBounceHorizontal;
        return self;
    };
}
- (EGChainKitForUIScrollView *(^)(BOOL)) pagingEnabled {
    return ^(BOOL  pagingEnabled) {
        self.scrollView.pagingEnabled = pagingEnabled;
        return self;
    };
}
- (EGChainKitForUIScrollView *(^)(BOOL)) scrollEnabled {
    return ^(BOOL  scrollEnabled) {
        self.scrollView.scrollEnabled = scrollEnabled;
        return self;
    };
}
- (EGChainKitForUIScrollView *(^)(BOOL)) showsHorizontalScrollIndicator {
    return ^(BOOL  showsHorizontalScrollIndicator) {
        self.scrollView.showsHorizontalScrollIndicator = showsHorizontalScrollIndicator;
        return self;
    };
}
- (EGChainKitForUIScrollView *(^)(BOOL)) showsVerticalScrollIndicator {
    return ^(BOOL  showsVerticalScrollIndicator) {
        self.scrollView.showsVerticalScrollIndicator = showsVerticalScrollIndicator;
        return self;
    };
}
- (EGChainKitForUIScrollView *(^)(UIEdgeInsets)) scrollIndicatorInsets {
    return ^(UIEdgeInsets  scrollIndicatorInsets) {
        self.scrollView.scrollIndicatorInsets = scrollIndicatorInsets;
        return self;
    };
}
- (EGChainKitForUIScrollView *(^)(UIScrollViewIndicatorStyle)) indicatorStyle {
    return ^(UIScrollViewIndicatorStyle  indicatorStyle) {
        self.scrollView.indicatorStyle = indicatorStyle;
        return self;
    };
}
- (EGChainKitForUIScrollView *(^)(CGFloat)) decelerationRate {
    return ^(CGFloat  decelerationRate) {
        self.scrollView.decelerationRate = decelerationRate;
        return self;
    };
}
- (EGChainKitForUIScrollView *(^)(BOOL)) delaysContentTouches {
    return ^(BOOL  delaysContentTouches) {
        self.scrollView.delaysContentTouches = delaysContentTouches;
        return self;
    };
}
- (EGChainKitForUIScrollView *(^)(BOOL)) canCancelContentTouches {
    return ^(BOOL  canCancelContentTouches) {
        self.scrollView.canCancelContentTouches = canCancelContentTouches;
        return self;
    };
}
- (EGChainKitForUIScrollView *(^)(CGFloat)) minimumZoomScale {
    return ^(CGFloat  minimumZoomScale) {
        self.scrollView.minimumZoomScale = minimumZoomScale;
        return self;
    };
}
- (EGChainKitForUIScrollView *(^)(CGFloat)) maximumZoomScale {
    return ^(CGFloat  maximumZoomScale) {
        self.scrollView.maximumZoomScale = maximumZoomScale;
        return self;
    };
}
- (EGChainKitForUIScrollView *(^)(CGFloat)) zoomScale {
    return ^(CGFloat  zoomScale) {
        self.scrollView.zoomScale = zoomScale;
        return self;
    };
}
- (EGChainKitForUIScrollView *(^)(BOOL)) bouncesZoom {
    return ^(BOOL  bouncesZoom) {
        self.scrollView.bouncesZoom = bouncesZoom;
        return self;
    };
}

- (EGChainKitForUIScrollView *(^)(BOOL)) scrollsToTop {
    return ^(BOOL  scrollsToTop) {
        self.scrollView.scrollsToTop = scrollsToTop;
        return self;
    };
}
- (EGChainKitForUIScrollView *(^)(UIScrollViewKeyboardDismissMode)) keyboardDismissMode {
    return ^(UIScrollViewKeyboardDismissMode  keyboardDismissMode) {
        self.scrollView.keyboardDismissMode = keyboardDismissMode;
        return self;
    };
}
- (EGChainKitForUIScrollView *(^)(UIRefreshControl *)) refreshControl {
    return ^(UIRefreshControl * refreshControl) {
        self.scrollView.refreshControl = refreshControl;
        return self;
    };
}

#pragma mark - subviews
- (EGChainKitForUITextView *(^)(void))textViewMaker {
    return ^(void) {
        NSAssert([self.scrollView isKindOfClass:[UITextView class]], @"textViewChain's target must be UITextView class");
        return ((UITextView *)self.scrollView).textViewChain;
    };
}
- (EGChainKitForUITableView *(^)(void))tableViewMaker {
    return ^(void) {
        NSAssert([self.scrollView isKindOfClass:[UITableView class]], @"tableViewChain's target must be UITableView class");
        return ((UITableView *)self.scrollView).tableViewChain;
    };
}

- (EGChainKitForUICollectionView *(^)(void))collevtionViewMaker {
    return ^(void) {
        NSAssert([self.scrollView isKindOfClass:[UICollectionView class]], @"tableViewChain's target must be UITableView class");
        return ((UICollectionView *)self.scrollView).collectionViewChain;
    };
}

#pragma mark layer
- (EGChainKitForCALayer *(^)(void)) layerMaker {
    return ^(void) {
        return self.scrollView.layer.chainMaker;
    };
}

@end

#import <objc/runtime.h>

@implementation UIScrollView (EGChainKit)
- (EGChainKitForUIScrollView *)scrollChain {
    EGChainKitForUIScrollView *chain = objc_getAssociatedObject(self, _cmd);
    if (!chain) {
        chain = [EGChainKitForUIScrollView new];
        chain.scrollView = self;
        objc_setAssociatedObject(self, _cmd, chain, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return chain;
}

@end
