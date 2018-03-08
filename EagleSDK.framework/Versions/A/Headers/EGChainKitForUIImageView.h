//
//  EGChainKitForUIImageView.h
//  ChainProperty
//
//  Created by TengShuQiang on 2017/12/25.
//  Copyright © 2017年 TTeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGChainKitHeader.h"

@class EGChainKitForCALayer;
@interface EGChainKitForUIImageView : NSObject

- (EGChainKitForUIView *(^)(void)) viewMaker;

#pragma mark -

- (EGChainKitForUIImageView *(^)(UIImage *)) image;
- (EGChainKitForUIImageView *(^)(UIImage *)) highlightedImage;
- (EGChainKitForUIImageView *(^)(BOOL)) userInteractionEnabled;
- (EGChainKitForUIImageView *(^)(BOOL)) highlighted;
- (EGChainKitForUIImageView *(^)(NSArray<UIImage *> *)) animationImages;
- (EGChainKitForUIImageView *(^)( NSArray<UIImage *> *)) highlightedAnimationImages;
- (EGChainKitForUIImageView *(^)(NSTimeInterval)) animationDuration;
- (EGChainKitForUIImageView *(^)(NSInteger)) animationRepeatCount;
- (EGChainKitForUIImageView *(^)(UIColor *)) tintColor NS_AVAILABLE_IOS(7_0);

#pragma mark layer

- (EGChainKitForCALayer *(^)(void)) layerMaker;

@end

@interface UIImageView (EGChainKit)

@property (nonatomic, strong, readonly) EGChainKitForUIImageView *imageViewChain;

@end
