//
//  EGChainKitForUILabel.h
//  ChainProperty
//
//  Created by TengShuQiang on 2017/12/25.
//  Copyright © 2017年 TTeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGChainKitHeader.h"

@class EGChainKitForCALayer;
@class EGChainKitForUIView;
@interface EGChainKitForUILabel : NSObject

#pragma mark - view

- (EGChainKitForUIView *(^)(void))viewMaker;

#pragma mark - label
- (EGChainKitForUILabel *(^)(NSString *)) text;
- (EGChainKitForUILabel *(^)(UIFont *)) font;
- (EGChainKitForUILabel *(^)(UIColor *)) textColor;
- (EGChainKitForUILabel *(^)(UIColor *)) shadowColor;
- (EGChainKitForUILabel *(^)(CGSize)) shadowOffset;
- (EGChainKitForUILabel *(^)(NSTextAlignment)) textAlignment;
- (EGChainKitForUILabel *(^)(NSLineBreakMode)) lineBreakMode;
- (EGChainKitForUILabel *(^)(NSAttributedString *)) attributedText;

- (EGChainKitForUILabel *(^)(UIColor *)) highlightedTextColor;
- (EGChainKitForUILabel *(^)(BOOL)) highlighted;
- (EGChainKitForUILabel *(^)(BOOL)) userInteractionEnabled;
- (EGChainKitForUILabel *(^)(BOOL)) enabled;
- (EGChainKitForUILabel *(^)(NSInteger)) numberOfLines;
- (EGChainKitForUILabel *(^)(BOOL)) adjustsFontSizeToFitWidth;
- (EGChainKitForUILabel *(^)(UIBaselineAdjustment)) baselineAdjustment;
- (EGChainKitForUILabel *(^)(CGFloat)) minimumScaleFactor NS_AVAILABLE_IOS(6_0);

- (EGChainKitForUILabel *(^)(BOOL)) allowsDefaultTighteningForTruncation NS_AVAILABLE_IOS(9_0);
- (EGChainKitForUILabel *(^)(CGFloat)) preferredMaxLayoutWidth NS_AVAILABLE_IOS(6_0);

#pragma mark layer
- (EGChainKitForCALayer *(^)(void)) layerMaker;

@end

@interface UILabel (EGChainKit)

@property (nonatomic, strong, readonly) EGChainKitForUILabel *labelChain;

@end
