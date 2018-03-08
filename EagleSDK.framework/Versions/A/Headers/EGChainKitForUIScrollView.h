//
//  EGChainKitForUIScrollView.h
//  ChainProperty
//
//  Created by TengShuQiang on 2017/12/25.
//  Copyright © 2017年 TTeng. All rights reserved.
//

#import "EGChainKitHeader.h"

@class EGChainKitForCALayer;
@class EGChainKitForUITextView,EGChainKitForUITableView,EGChainKitForUICollectionView;

@interface EGChainKitForUIScrollView : NSObject

- (EGChainKitForUIView *(^)(void))viewMaker;

#pragma mark - scrollView
- (EGChainKitForUIScrollView *(^)(CGPoint)) contentOffset;
- (EGChainKitForUIScrollView *(^)(CGSize)) contentSize;
- (EGChainKitForUIScrollView *(^)(UIEdgeInsets)) contentInset;
- (EGChainKitForUIScrollView *(^)(UIScrollViewContentInsetAdjustmentBehavior)) contentInsetAdjustmentBehavior API_AVAILABLE(ios(11.0),tvos(11.0));

- (EGChainKitForUIScrollView *(^)(id<UIScrollViewDelegate>)) delegate;
- (EGChainKitForUIScrollView *(^)(BOOL)) directionalLockEnabled;
- (EGChainKitForUIScrollView *(^)(BOOL)) bounces;
- (EGChainKitForUIScrollView *(^)(BOOL)) alwaysBounceVertical;
- (EGChainKitForUIScrollView *(^)(BOOL)) alwaysBounceHorizontal;
- (EGChainKitForUIScrollView *(^)(BOOL)) pagingEnabled;
- (EGChainKitForUIScrollView *(^)(BOOL)) scrollEnabled;
- (EGChainKitForUIScrollView *(^)(BOOL)) showsHorizontalScrollIndicator;
- (EGChainKitForUIScrollView *(^)(BOOL)) showsVerticalScrollIndicator;
- (EGChainKitForUIScrollView *(^)(UIEdgeInsets)) scrollIndicatorInsets;
- (EGChainKitForUIScrollView *(^)(UIScrollViewIndicatorStyle)) indicatorStyle;
- (EGChainKitForUIScrollView *(^)(CGFloat)) decelerationRate;
- (EGChainKitForUIScrollView *(^)(BOOL)) delaysContentTouches;
- (EGChainKitForUIScrollView *(^)(BOOL)) canCancelContentTouches;
- (EGChainKitForUIScrollView *(^)(CGFloat)) minimumZoomScale;
- (EGChainKitForUIScrollView *(^)(CGFloat)) maximumZoomScale;
- (EGChainKitForUIScrollView *(^)(CGFloat)) zoomScale;
- (EGChainKitForUIScrollView *(^)(BOOL)) bouncesZoom;
- (EGChainKitForUIScrollView *(^)(BOOL)) scrollsToTop;
- (EGChainKitForUIScrollView *(^)(UIScrollViewKeyboardDismissMode)) keyboardDismissMode NS_AVAILABLE_IOS(7_0);
- (EGChainKitForUIScrollView *(^)(UIRefreshControl *)) refreshControl NS_AVAILABLE_IOS(10_0);

#pragma mark - subviews
- (EGChainKitForUITextView *(^)(void))textViewMaker;
- (EGChainKitForUITableView *(^)(void))tableViewMaker;
- (EGChainKitForUICollectionView *(^)(void))collevtionViewMaker;

#pragma mark layer
- (EGChainKitForCALayer *(^)(void)) layerMaker;

@end

@interface UIScrollView (EGChainKit)

@property (nonatomic, strong, readonly) EGChainKitForUIScrollView *scrollChain;

@end
