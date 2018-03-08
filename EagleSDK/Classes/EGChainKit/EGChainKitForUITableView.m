//
//  EGChainKitForUITableView.m
//  ChainProperty
//
//  Created by TengShuQiang on 2017/12/25.
//  Copyright © 2017年 TTeng. All rights reserved.
//

#import "EGChainKitForUITableView.h"

@interface EGChainKitForUITableView ()

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation EGChainKitForUITableView

- (EGChainKitForUIView *(^)(void)) viewMaker {
    return ^(void) {
        return ((UIView *)self.tableView).viewChain;
    };
}

- (EGChainKitForUIScrollView *(^)(void)) scrollMaker {
    return ^(void) {
        return ((UIScrollView *)self.tableView).scrollChain;
    };
}

#pragma mark - tableView

- (EGChainKitForUITableView *(^)(id <UITableViewDataSource>)) dataSource {
    return ^(id <UITableViewDataSource> dataSource) {
        self.tableView.dataSource = dataSource;
        return self;
    };
}
- (EGChainKitForUITableView *(^)(id <UITableViewDelegate>)) delegate {
    return ^(id <UITableViewDelegate> delegate) {
        self.tableView.delegate = delegate;
        return self;
    };
}
- (EGChainKitForUITableView *(^)(id <UITableViewDataSourcePrefetching>)) prefetchDataSource {
    return ^(id <UITableViewDataSourcePrefetching> prefetchDataSource) {
        self.tableView.prefetchDataSource = prefetchDataSource;
        return self;
    };
}
- (EGChainKitForUITableView *(^)(id <UITableViewDragDelegate>)) dragDelegate {
    return ^(id <UITableViewDragDelegate> dragDelegate) {
        self.tableView.dragDelegate = dragDelegate;
        return self;
    };
}
- (EGChainKitForUITableView *(^)(id <UITableViewDropDelegate>)) dropDelegate  {
    return ^(id <UITableViewDropDelegate> dropDelegate) {
        self.tableView.dropDelegate = dropDelegate;
        return self;
    };
}

- (EGChainKitForUITableView *(^)(CGFloat)) rowHeight {
    return ^(CGFloat rowHeight) {
        self.tableView.rowHeight = rowHeight;
        return self;
    };
}
- (EGChainKitForUITableView *(^)(CGFloat)) sectionHeaderHeight {
    return ^(CGFloat sectionHeaderHeight) {
        self.tableView.sectionHeaderHeight = sectionHeaderHeight;
        return self;
    };
}
- (EGChainKitForUITableView *(^)(CGFloat)) sectionFooterHeight {
    return ^(CGFloat sectionFooterHeight) {
        self.tableView.sectionFooterHeight = sectionFooterHeight;
        return self;
    };
}
- (EGChainKitForUITableView *(^)(CGFloat)) estimatedRowHeight {
    return ^(CGFloat estimatedRowHeight) {
        self.tableView.estimatedRowHeight = estimatedRowHeight;
        return self;
    };
}
- (EGChainKitForUITableView *(^)(CGFloat)) estimatedSectionHeaderHeight {
    return ^(CGFloat estimatedSectionHeaderHeight) {
        self.tableView.estimatedSectionHeaderHeight = estimatedSectionHeaderHeight;
        return self;
    };
}
- (EGChainKitForUITableView *(^)(CGFloat)) estimatedSectionFooterHeight {
    return ^(CGFloat estimatedSectionFooterHeight) {
        self.tableView.estimatedSectionFooterHeight = estimatedSectionFooterHeight;
        return self;
    };
}
- (EGChainKitForUITableView *(^)(UIEdgeInsets)) separatorInset {
    return ^(UIEdgeInsets separatorInset) {
        self.tableView.separatorInset = separatorInset;
        return self;
    };
}
- (EGChainKitForUITableView *(^)(UITableViewSeparatorInsetReference)) separatorInsetReference {
    return ^(UITableViewSeparatorInsetReference separatorInsetReference) {
        self.tableView.separatorInsetReference = separatorInsetReference;
        return self;
    };
}
- (EGChainKitForUITableView *(^)(UIView *)) backgroundView {
    return ^(UIView * backgroundView) {
        self.tableView.backgroundView = backgroundView;
        return self;
    };
}

- (EGChainKitForUITableView *(^)(BOOL)) editing {
    return ^(BOOL editing) {
        self.tableView.editing = editing;
        return self;
    };
}
- (EGChainKitForUITableView *(^)(BOOL)) allowsSelection {
    return ^(BOOL allowsSelection) {
        self.tableView.allowsSelection = allowsSelection;
        return self;
    };
}
- (EGChainKitForUITableView *(^)(BOOL)) allowsSelectionDuringEditing {
    return ^(BOOL allowsSelectionDuringEditing) {
        self.tableView.allowsSelectionDuringEditing = allowsSelectionDuringEditing;
        return self;
    };
}
- (EGChainKitForUITableView *(^)(NSInteger)) sectionIndexMinimumDisplayRowCount {
    return ^(NSInteger sectionIndexMinimumDisplayRowCount) {
        self.tableView.sectionIndexMinimumDisplayRowCount = sectionIndexMinimumDisplayRowCount;
        return self;
    };
}
- (EGChainKitForUITableView *(^)(UIColor *)) sectionIndexColor {
    return ^(UIColor * sectionIndexColor) {
        self.tableView.sectionIndexColor = sectionIndexColor;
        return self;
    };
}
- (EGChainKitForUITableView *(^)(UIColor *)) sectionIndexBackgroundColor {
    return ^(UIColor * sectionIndexBackgroundColor) {
        self.tableView.sectionIndexBackgroundColor = sectionIndexBackgroundColor;
        return self;
    };
}
- (EGChainKitForUITableView *(^)(UIColor *)) sectionIndexTrackingBackgroundColor {
    return ^(UIColor * sectionIndexTrackingBackgroundColor) {
        self.tableView.sectionIndexTrackingBackgroundColor = sectionIndexTrackingBackgroundColor;
        return self;
    };
}
- (EGChainKitForUITableView *(^)(UITableViewCellSeparatorStyle)) separatorStyle {
    return ^(UITableViewCellSeparatorStyle separatorStyle) {
        self.tableView.separatorStyle = separatorStyle;
        return self;
    };
}
- (EGChainKitForUITableView *(^)(UIColor *)) separatorColor {
    return ^(UIColor * separatorColor) {
        self.tableView.separatorColor = separatorColor;
        return self;
    };
}
- (EGChainKitForUITableView *(^)(UIVisualEffect *)) separatorEffect {
    return ^(UIVisualEffect * separatorEffect) {
        self.tableView.separatorEffect = separatorEffect;
        return self;
    };
}
- (EGChainKitForUITableView *(^)(BOOL)) cellLayoutMarginsFollowReadableWidth {
    return ^(BOOL  cellLayoutMarginsFollowReadableWidth) {
        self.tableView.cellLayoutMarginsFollowReadableWidth = cellLayoutMarginsFollowReadableWidth;
        return self;
    };
}
- (EGChainKitForUITableView *(^)(BOOL)) insetsContentViewsToSafeArea {
    return ^(BOOL  insetsContentViewsToSafeArea) {
        self.tableView.insetsContentViewsToSafeArea = insetsContentViewsToSafeArea;
        return self;
    };
}
- (EGChainKitForUITableView *(^)(UIView *)) tableHeaderView {
    return ^(UIView * tableHeaderView) {
        self.tableView.tableHeaderView = tableHeaderView;
        return self;
    };
}
- (EGChainKitForUITableView *(^)(UIView *)) tableFooterView {
    return ^(UIView * tableFooterView) {
        self.tableView.tableFooterView = tableFooterView;
        return self;
    };
}

- (EGChainKitForUITableView *(^)(BOOL)) dragInteractionEnabled {
    return ^(BOOL  dragInteractionEnabled) {
        self.tableView.dragInteractionEnabled = dragInteractionEnabled;
        return self;
    };
}

//register class ..
- (EGChainKitForUITableView *(^)(Class, NSString *)) registerClass {
    return ^(Class cls, NSString *Id) {
        [self.tableView registerClass:cls forHeaderFooterViewReuseIdentifier:Id];
        return self;
    };
}
- (EGChainKitForUITableView *(^)(UINib *, NSString *)) registerNib {
    return ^(UINib *nib, NSString *Id) {
        [self.tableView registerNib:nib forCellReuseIdentifier:Id];
        return self;
    };
}
- (EGChainKitForUITableView *(^)(Class, NSString *)) registerHeaderFooterClass {
    return ^(Class cls, NSString *Id) {
        [self.tableView registerClass:cls forHeaderFooterViewReuseIdentifier:Id];
        return self;
    };
}

- (EGChainKitForUITableView *(^)(UINib *, NSString *)) registerHeaderFooterNib {
    return ^(UINib *nib, NSString *Id) {
        [self.tableView registerNib:nib forHeaderFooterViewReuseIdentifier:Id];
        return self;
    };
}

#pragma mark layer
- (EGChainKitForCALayer *(^)(void)) layerMaker {
    return ^(void) {
        return self.tableView.layer.chainMaker;
    };
}

@end

#import <objc/runtime.h>

@implementation UITableView (EGChainKit)

- (EGChainKitForUITableView *)tableViewChain {
    EGChainKitForUITableView *chain = objc_getAssociatedObject(self, _cmd);
    if (!chain) {
        chain = [EGChainKitForUITableView new];
        chain.tableView = self;
        objc_setAssociatedObject(self, _cmd, chain, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return chain;
}

@end
