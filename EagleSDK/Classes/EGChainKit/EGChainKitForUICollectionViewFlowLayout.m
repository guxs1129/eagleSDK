//
//  EGChainKitForUICollectionViewFlowLayout.m
//  EGChainKit
//
//  Created by TengShuQiang on 2018/1/2.
//  Copyright © 2018年 TTeng. All rights reserved.
//

#import "EGChainKitForUICollectionViewFlowLayout.h"

@interface EGChainKitForUICollectionViewFlowLayout()

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@end

@implementation EGChainKitForUICollectionViewFlowLayout

- (EGChainKitForUICollectionViewFlowLayout *(^)(CGFloat)) minimumLineSpacing {
    return ^(CGFloat minimumLineSpacing) {
        self.flowLayout.minimumLineSpacing = minimumLineSpacing;
        return self;
    };
}

- (EGChainKitForUICollectionViewFlowLayout *(^)(CGFloat)) minimumInteritemSpacing {
    return ^(CGFloat minimumInteritemSpacing) {
        self.flowLayout.minimumInteritemSpacing = minimumInteritemSpacing;
        return self;
    };
}
- (EGChainKitForUICollectionViewFlowLayout *(^)(CGSize)) itemSize {
    return ^(CGSize itemSize) {
        self.flowLayout.itemSize = itemSize;
        return self;
    };
}
- (EGChainKitForUICollectionViewFlowLayout *(^)(CGSize)) estimatedItemSize NS_AVAILABLE_IOS(8_0) {
    return ^(CGSize estimatedItemSize) {
        self.flowLayout.estimatedItemSize = estimatedItemSize;
        return self;
    };
}
- (EGChainKitForUICollectionViewFlowLayout *(^)(UICollectionViewScrollDirection)) scrollDirection {
    return ^(UICollectionViewScrollDirection scrollDirection) {
        self.flowLayout.scrollDirection = scrollDirection;
        return self;
    };
}
- (EGChainKitForUICollectionViewFlowLayout *(^)(CGSize)) headerReferenceSize {
    return ^(CGSize headerReferenceSize) {
        self.flowLayout.headerReferenceSize = headerReferenceSize;
        return self;
    };
}
- (EGChainKitForUICollectionViewFlowLayout *(^)(CGSize)) footerReferenceSize {
    return ^(CGSize footerReferenceSize) {
        self.flowLayout.footerReferenceSize = footerReferenceSize;
        return self;
    };
}
- (EGChainKitForUICollectionViewFlowLayout *(^)(UIEdgeInsets)) sectionInset {
    return ^(UIEdgeInsets sectionInset) {
        self.flowLayout.sectionInset = sectionInset;
        return self;
    };
}
- (EGChainKitForUICollectionViewFlowLayout *(^)(UICollectionViewFlowLayoutSectionInsetReference)) sectionInsetReference  {
    return ^(UICollectionViewFlowLayoutSectionInsetReference sectionInsetReference) {
        self.flowLayout.sectionInsetReference = sectionInsetReference;
        return self;
    };
}
- (EGChainKitForUICollectionViewFlowLayout *(^)(BOOL)) sectionHeadersPinToVisibleBounds NS_AVAILABLE_IOS(9_0) {
    return ^(BOOL sectionHeadersPinToVisibleBounds) {
        self.flowLayout.sectionHeadersPinToVisibleBounds = sectionHeadersPinToVisibleBounds;
        return self;
    };
}
- (EGChainKitForUICollectionViewFlowLayout *(^)(BOOL)) sectionFootersPinToVisibleBounds {
    return ^(BOOL sectionFootersPinToVisibleBounds) {
        self.flowLayout.sectionFootersPinToVisibleBounds = sectionFootersPinToVisibleBounds;
        return self;
    };
}

@end

#import <objc/runtime.h>

@implementation UICollectionViewFlowLayout(EGChainKit)

- (EGChainKitForUICollectionViewFlowLayout *)flowLayoutChain {
    EGChainKitForUICollectionViewFlowLayout *chain = objc_getAssociatedObject(self, _cmd);
    if (!chain) {
        chain = [EGChainKitForUICollectionViewFlowLayout new];
        chain.flowLayout = self;
        objc_setAssociatedObject(self, _cmd, chain, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return chain;
}

@end
