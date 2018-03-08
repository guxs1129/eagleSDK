//
//  EGChainKitForUICollectionViewFlowLayout.h
//  EGChainKit
//
//  Created by TengShuQiang on 2018/1/2.
//  Copyright © 2018年 TTeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface EGChainKitForUICollectionViewFlowLayout : NSObject

- (EGChainKitForUICollectionViewFlowLayout *(^)(CGFloat)) minimumLineSpacing;
- (EGChainKitForUICollectionViewFlowLayout *(^)(CGFloat)) minimumInteritemSpacing;
- (EGChainKitForUICollectionViewFlowLayout *(^)(CGSize)) itemSize;
- (EGChainKitForUICollectionViewFlowLayout *(^)(CGSize)) estimatedItemSize NS_AVAILABLE_IOS(8_0);
- (EGChainKitForUICollectionViewFlowLayout *(^)(UICollectionViewScrollDirection)) scrollDirection;
- (EGChainKitForUICollectionViewFlowLayout *(^)(CGSize)) headerReferenceSize;
- (EGChainKitForUICollectionViewFlowLayout *(^)(CGSize)) footerReferenceSize;
- (EGChainKitForUICollectionViewFlowLayout *(^)(UIEdgeInsets)) sectionInset;
- (EGChainKitForUICollectionViewFlowLayout *(^)(UICollectionViewFlowLayoutSectionInsetReference)) sectionInsetReference API_AVAILABLE(ios(11.0), tvos(11.0)) API_UNAVAILABLE(watchos);
- (EGChainKitForUICollectionViewFlowLayout *(^)(BOOL)) sectionHeadersPinToVisibleBounds NS_AVAILABLE_IOS(9_0);
- (EGChainKitForUICollectionViewFlowLayout *(^)(BOOL)) sectionFootersPinToVisibleBounds NS_AVAILABLE_IOS(9_0);

@end

@interface UICollectionViewFlowLayout (EGChainKit)

@property (nonatomic, strong, readonly) EGChainKitForUICollectionViewFlowLayout *flowLayoutChain;

@end
