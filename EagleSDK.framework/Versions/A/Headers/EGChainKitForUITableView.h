//
//  EGChainKitForUITableView.h
//  ChainProperty
//
//  Created by TengShuQiang on 2017/12/25.
//  Copyright © 2017年 TTeng. All rights reserved.
//

#import "EGChainKitHeader.h"

@class EGChainKitForCALayer;
@interface EGChainKitForUITableView : NSObject


- (EGChainKitForUIView *(^)(void)) viewMaker;

- (EGChainKitForUIScrollView *(^)(void)) scrollMaker;


#pragma mark - tableView

- (EGChainKitForUITableView *(^)(id <UITableViewDataSource>)) dataSource;
- (EGChainKitForUITableView *(^)(id <UITableViewDelegate>)) delegate;
- (EGChainKitForUITableView *(^)(id <UITableViewDataSourcePrefetching>)) prefetchDataSource NS_AVAILABLE_IOS(10_0);
- (EGChainKitForUITableView *(^)(id <UITableViewDragDelegate>)) dragDelegate API_AVAILABLE(ios(11.0)) API_UNAVAILABLE(tvos, watchos);
- (EGChainKitForUITableView *(^)(id <UITableViewDropDelegate>)) dropDelegate API_AVAILABLE(ios(11.0)) API_UNAVAILABLE(tvos, watchos);

- (EGChainKitForUITableView *(^)(CGFloat)) rowHeight;
- (EGChainKitForUITableView *(^)(CGFloat)) sectionHeaderHeight;
- (EGChainKitForUITableView *(^)(CGFloat)) sectionFooterHeight;
- (EGChainKitForUITableView *(^)(CGFloat)) estimatedRowHeight NS_AVAILABLE_IOS(7_0);
- (EGChainKitForUITableView *(^)(CGFloat)) estimatedSectionHeaderHeight NS_AVAILABLE_IOS(7_0);
- (EGChainKitForUITableView *(^)(CGFloat)) estimatedSectionFooterHeight NS_AVAILABLE_IOS(7_0);
- (EGChainKitForUITableView *(^)(UIEdgeInsets)) separatorInset NS_AVAILABLE_IOS(7_0);
- (EGChainKitForUITableView *(^)(UITableViewSeparatorInsetReference)) separatorInsetReference API_AVAILABLE(ios(11.0), tvos(11.0));
- (EGChainKitForUITableView *(^)(UIView *)) backgroundView NS_AVAILABLE_IOS(3_2);

- (EGChainKitForUITableView *(^)(BOOL)) editing;
- (EGChainKitForUITableView *(^)(BOOL)) allowsSelection NS_AVAILABLE_IOS(3_0);
- (EGChainKitForUITableView *(^)(BOOL)) allowsSelectionDuringEditing;
- (EGChainKitForUITableView *(^)(NSInteger)) sectionIndexMinimumDisplayRowCount;
- (EGChainKitForUITableView *(^)(UIColor *)) sectionIndexColor NS_AVAILABLE_IOS(6_0);
- (EGChainKitForUITableView *(^)(UIColor *)) sectionIndexBackgroundColor NS_AVAILABLE_IOS(7_0);
- (EGChainKitForUITableView *(^)(UIColor *)) sectionIndexTrackingBackgroundColor NS_AVAILABLE_IOS(6_0);
- (EGChainKitForUITableView *(^)(UITableViewCellSeparatorStyle)) separatorStyle;
- (EGChainKitForUITableView *(^)(UIColor *)) separatorColor;
- (EGChainKitForUITableView *(^)(UIVisualEffect *)) separatorEffect NS_AVAILABLE_IOS(8_0);
- (EGChainKitForUITableView *(^)(BOOL)) cellLayoutMarginsFollowReadableWidth NS_AVAILABLE_IOS(9_0);
- (EGChainKitForUITableView *(^)(BOOL)) insetsContentViewsToSafeArea API_AVAILABLE(ios(11.0), tvos(11.0));
- (EGChainKitForUITableView *(^)(UIView *)) tableHeaderView;
- (EGChainKitForUITableView *(^)(UIView *)) tableFooterView;

- (EGChainKitForUITableView *(^)(BOOL)) dragInteractionEnabled API_AVAILABLE(ios(11.0)) API_UNAVAILABLE(tvos, watchos);

//register class ..
- (EGChainKitForUITableView *(^)(Class, NSString *)) registerClass;
- (EGChainKitForUITableView *(^)(UINib *, NSString *)) registerNib;
- (EGChainKitForUITableView *(^)(Class, NSString *)) registerHeaderFooterClass;
- (EGChainKitForUITableView *(^)(UINib *, NSString *)) registerHeaderFooterNib;

#pragma mark layer
- (EGChainKitForCALayer *(^)(void)) layerMaker;

@end

@interface UITableView (EGChainKit)

@property (nonatomic, strong, readonly) EGChainKitForUITableView *tableViewChain;

@end

