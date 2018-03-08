//
//  EGChainKitForUICollectionView.h
//  EGChainKit
//
//  Created by TengShuQiang on 2018/1/2.
//  Copyright © 2018年 TTeng. All rights reserved.
//

#import "EGChainKitHeader.h"

@class EGChainKitForCALayer;
@class EGChainKitForUIView,EGChainKitForUIScrollView;
@interface EGChainKitForUICollectionView : NSObject

- (EGChainKitForUIView *(^)(void)) viewMaker;

- (EGChainKitForUIScrollView *(^)(void)) scrollMaker;

#pragma mark - collectionView

- (EGChainKitForUICollectionView *(^)(UICollectionViewLayout *)) collectionViewLayout;
- (EGChainKitForUICollectionView *(^)(id <UICollectionViewDelegate>)) delegate;
- (EGChainKitForUICollectionView *(^)(id <UICollectionViewDataSource>)) dataSource;
- (EGChainKitForUICollectionView *(^)(id<UICollectionViewDataSourcePrefetching>)) prefetchDataSource NS_AVAILABLE_IOS(10_0);
- (EGChainKitForUICollectionView *(^)(BOOL)) prefetchingEnabled NS_AVAILABLE_IOS(10_0);
- (EGChainKitForUICollectionView *(^)(id <UICollectionViewDragDelegate>)) dragDelegate API_AVAILABLE(ios(11.0)) API_UNAVAILABLE(tvos, watchos);
- (EGChainKitForUICollectionView *(^)(id <UICollectionViewDropDelegate>)) dropDelegate API_AVAILABLE(ios(11.0)) API_UNAVAILABLE(tvos, watchos);;

- (EGChainKitForUICollectionView *(^)(BOOL)) dragInteractionEnabled API_AVAILABLE(ios(11.0)) API_UNAVAILABLE(tvos, watchos);
- (EGChainKitForUICollectionView *(^)(UICollectionViewReorderingCadence)) reorderingCadence API_AVAILABLE(ios(11.0)) API_UNAVAILABLE(tvos, watchos);
- (EGChainKitForUICollectionView *(^)(UIView *)) backgroundView;
- (EGChainKitForUICollectionView *(^)(BOOL)) allowsSelection;
- (EGChainKitForUICollectionView *(^)(BOOL)) allowsMultipleSelection;
- (EGChainKitForUICollectionView *(^)(BOOL)) remembersLastFocusedIndexPath NS_AVAILABLE_IOS(9_0);

// register class
- (EGChainKitForUICollectionView *(^)(Class, NSString *)) registerClass;
- (EGChainKitForUICollectionView *(^)(UINib *, NSString *)) registerNib;
- (EGChainKitForUICollectionView *(^)(Class, NSString *)) registerHeaderClass;
- (EGChainKitForUICollectionView *(^)(UINib *, NSString *)) registerHeaderNib;
- (EGChainKitForUICollectionView *(^)(Class, NSString *)) registerFooterClass;
- (EGChainKitForUICollectionView *(^)(UINib *, NSString *)) registerFooterNib;

#pragma mark layer
- (EGChainKitForCALayer *(^)(void)) layerMaker;

@end

@interface UICollectionView (EGChainKit)

@property (nonatomic, strong, readonly) EGChainKitForUICollectionView *collectionViewChain;

@end
