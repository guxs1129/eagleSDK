//
//  EGChainKitForUICollectionView.m
//  EGChainKit
//
//  Created by TengShuQiang on 2018/1/2.
//  Copyright © 2018年 TTeng. All rights reserved.
//

#import "EGChainKitForUICollectionView.h"

@interface EGChainKitForUICollectionView ()

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation EGChainKitForUICollectionView

- (EGChainKitForUIView *(^)(void)) viewMaker {
    return ^(void) {
        return ((UIView *)self.collectionView).viewChain;
    };
}

- (EGChainKitForUIScrollView *(^)(void)) scrollMaker {
    return ^(void) {
        return ((UIScrollView *)self.collectionView).scrollChain;
    };
}

#pragma mark - collectionView

- (EGChainKitForUICollectionView *(^)(UICollectionViewLayout *)) collectionViewLayout {
    return ^(UICollectionViewLayout * collectionViewLayout) {
        self.collectionView.collectionViewLayout = collectionViewLayout;
        return self;
    };
}
- (EGChainKitForUICollectionView *(^)(id <UICollectionViewDelegate>)) delegate {
    return ^(id <UICollectionViewDelegate> delegate) {
        self.collectionView.delegate = delegate;
        return self;
    };
}
- (EGChainKitForUICollectionView *(^)(id <UICollectionViewDataSource>)) dataSource {
    return ^(id <UICollectionViewDataSource> dataSource) {
        self.collectionView.dataSource = dataSource;
        return self;
    };
}
- (EGChainKitForUICollectionView *(^)(id<UICollectionViewDataSourcePrefetching>)) prefetchDataSource NS_AVAILABLE_IOS(10_0) {
    return ^(id<UICollectionViewDataSourcePrefetching> prefetchDataSource) {
        self.collectionView.prefetchDataSource = prefetchDataSource;
        return self;
    };
}
- (EGChainKitForUICollectionView *(^)(BOOL)) prefetchingEnabled NS_AVAILABLE_IOS(10_0) {
    return ^(BOOL prefetchingEnabled) {
        self.collectionView.prefetchingEnabled = prefetchingEnabled;
        return self;
    };
}
- (EGChainKitForUICollectionView *(^)(id <UICollectionViewDragDelegate>)) dragDelegate API_AVAILABLE(ios(11.0)) API_UNAVAILABLE(tvos, watchos) {
    return ^(id <UICollectionViewDragDelegate> dragDelegate) {
        self.collectionView.dragDelegate = dragDelegate;
        return self;
    };
}
- (EGChainKitForUICollectionView *(^)(id <UICollectionViewDropDelegate>)) dropDelegate API_AVAILABLE(ios(11.0)) API_UNAVAILABLE(tvos, watchos) {
    return ^(id <UICollectionViewDropDelegate> dropDelegate) {
        self.collectionView.dropDelegate = dropDelegate;
        return self;
    };
}

- (EGChainKitForUICollectionView *(^)(BOOL)) dragInteractionEnabled API_AVAILABLE(ios(11.0)) API_UNAVAILABLE(tvos, watchos) {
    return ^(BOOL dragInteractionEnabled) {
        self.collectionView.dragInteractionEnabled = dragInteractionEnabled;
        return self;
    };
}
- (EGChainKitForUICollectionView *(^)(UICollectionViewReorderingCadence)) reorderingCadence API_AVAILABLE(ios(11.0)) API_UNAVAILABLE(tvos, watchos) {
    return ^(UICollectionViewReorderingCadence reorderingCadence) {
        self.collectionView.reorderingCadence = reorderingCadence;
        return self;
    };
}
- (EGChainKitForUICollectionView *(^)(UIView *)) backgroundView {
    return ^(UIView * backgroundView) {
        self.collectionView.backgroundView = backgroundView;
        return self;
    };
}
- (EGChainKitForUICollectionView *(^)(BOOL)) allowsSelection {
    return ^(BOOL allowsSelection) {
        self.collectionView.allowsSelection = allowsSelection;
        return self;
    };
}
- (EGChainKitForUICollectionView *(^)(BOOL)) allowsMultipleSelection {
    return ^(BOOL allowsMultipleSelection) {
        self.collectionView.allowsMultipleSelection = allowsMultipleSelection;
        return self;
    };
}
- (EGChainKitForUICollectionView *(^)(BOOL)) remembersLastFocusedIndexPath NS_AVAILABLE_IOS(9_0) {
    return ^(BOOL remembersLastFocusedIndexPath) {
        self.collectionView.remembersLastFocusedIndexPath = remembersLastFocusedIndexPath;
        return self;
    };
}

// register class
- (EGChainKitForUICollectionView *(^)(Class, NSString *)) registerClass {
    return ^(Class cls, NSString *Id) {
        [self.collectionView registerClass:cls forCellWithReuseIdentifier:Id];
        return self;
    };
}
- (EGChainKitForUICollectionView *(^)(UINib *, NSString *)) registerNib {
    return ^(UINib *nib, NSString *Id) {
        [self.collectionView registerNib:nib forCellWithReuseIdentifier:Id];
        return self;
    };
}
- (EGChainKitForUICollectionView *(^)(Class, NSString *)) registerHeaderClass {
    return ^(Class cls, NSString *Id) {
        [self.collectionView registerClass:cls forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:Id];
        return self;
    };
}
- (EGChainKitForUICollectionView *(^)(UINib *, NSString *)) registerHeaderNib {
    return ^(UINib *nib, NSString *Id) {
        [self.collectionView registerNib:nib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:Id];
        return self;
    };
}

- (EGChainKitForUICollectionView *(^)(Class, NSString *)) registerFooterClass {
    return ^(Class cls, NSString *Id) {
        [self.collectionView registerClass:cls forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:Id];
        return self;
    };
}

- (EGChainKitForUICollectionView *(^)(UINib *, NSString *)) registerFooterNib {
    return ^(UINib *nib, NSString *Id) {
        [self.collectionView registerNib:nib forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:Id];
        return self;
    };
}

#pragma mark layer
- (EGChainKitForCALayer *(^)(void)) layerMaker {
    return ^(void) {
        return self.collectionView.layer.chainMaker;
    };
}

@end

#import <objc/runtime.h>

@implementation UICollectionView (EGChainKit)

- (EGChainKitForUICollectionView *)collectionViewChain {
    EGChainKitForUICollectionView *chain = objc_getAssociatedObject(self, _cmd);
    if (!chain) {
        chain = [EGChainKitForUICollectionView new];
        chain.collectionView = self;
        objc_setAssociatedObject(self, _cmd, chain, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return chain;
}

@end
