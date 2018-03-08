//
//  EGChainKitForUIView.h
//  ChainProperty
//
//  Created by TengShuQiang on 2017/12/25.
//  Copyright © 2017年 TTeng. All rights reserved.
//

#import "EGChainKitHeader.h"

@class EGChainKitForUICollectionView;
@class EGChainKitForUITableView
    ,EGChainKitForUIScrollView
    ,EGChainKitForUITextView
    ,EGChainKitForUITextField
    ,EGChainKitForUIImageView
    ,EGChainKitForUIButton
    ,EGChainKitForUILabel
    ,EGChainKitForUIControl
    ,EGChainKitForCALayer;
@interface EGChainKitForUIView : NSObject


- (EGChainKitForUIView *(^)(NSInteger)) tag;

//UIViewGeometry
- (EGChainKitForUIView *(^)(CGRect)) frame;
- (EGChainKitForUIView *(^)(CGRect)) bounds;
- (EGChainKitForUIView *(^)(CGPoint)) center;
- (EGChainKitForUIView *(^)(CGAffineTransform)) transform;

- (EGChainKitForUIView *(^)(CGFloat)) contentScaleFactor;
- (EGChainKitForUIView *(^)(BOOL)) multipleTouchEnabled;
- (EGChainKitForUIView *(^)(BOOL)) exclusiveTouch;
- (EGChainKitForUIView *(^)(BOOL)) autoresizesSubviews;
- (EGChainKitForUIView *(^)(UIViewAutoresizing)) autoresizingMask;

//UIViewHierarchy
- (EGChainKitForUIView *(^)(UIEdgeInsets)) layoutMargins NS_AVAILABLE_IOS(8_0);
- (EGChainKitForUIView *(^)(NSDirectionalEdgeInsets)) directionalLayoutMargins API_AVAILABLE(ios(11.0),tvos(11.0));
- (EGChainKitForUIView *(^)(BOOL)) preservesSuperviewLayoutMargins NS_AVAILABLE_IOS(8_0);
- (EGChainKitForUIView *(^)(BOOL)) insetsLayoutMarginsFromSafeArea API_AVAILABLE(ios(11.0),tvos(11.0));

//UIViewRendering
- (EGChainKitForUIView *(^)(BOOL)) clipsToBounds;
- (EGChainKitForUIView *(^)(UIColor *)) backgroundColor;
- (EGChainKitForUIView *(^)(CGFloat)) alpha;
- (EGChainKitForUIView *(^)(BOOL)) opaque;
- (EGChainKitForUIView *(^)(BOOL)) clearsContextBeforeDrawing;

- (EGChainKitForUIView *(^)(BOOL)) hidden;
- (EGChainKitForUIView *(^)(UIViewContentMode)) contentMode;
- (EGChainKitForUIView *(^)(UIView *)) maskView NS_AVAILABLE_IOS(8_0);
- (EGChainKitForUIView *(^)(UIColor *)) tintColor NS_AVAILABLE_IOS(7_0);
- (EGChainKitForUIView *(^)(UIViewTintAdjustmentMode)) tintAdjustmentMode NS_AVAILABLE_IOS(7_0);

//UIConstraintBasedCompatibility
- (EGChainKitForUIView *(^)(BOOL)) translatesAutoresizingMaskIntoConstraints NS_AVAILABLE_IOS(6_0);

//------------------------
- (EGChainKitForUIView *(^)(UIView *)) addSubview;
- (EGChainKitForUIView *(^)(UIView *)) addToSuperView;

#pragma mark layer

- (EGChainKitForCALayer *(^)(void)) layerMaker;

#pragma mark - subviews
- (EGChainKitForUILabel *(^)(void))labelMaker;
- (EGChainKitForUIButton *(^)(void))buttonMaker;
- (EGChainKitForUIImageView *(^)(void))imageViewMaker;
- (EGChainKitForUITextField *(^)(void))textFieldMaker;
- (EGChainKitForUITextView *(^)(void))textViewMaker;
- (EGChainKitForUIScrollView *(^)(void))scrollViewMaker;
- (EGChainKitForUITableView *(^)(void))tableViewMaker;
- (EGChainKitForUIControl *(^)(void))controlMaker;
- (EGChainKitForUICollectionView *(^)(void))collectionViewMaker;

@end

@interface UIView (EGChainKit)

@property (nonatomic, strong, readonly) EGChainKitForUIView *viewChain;

@end
