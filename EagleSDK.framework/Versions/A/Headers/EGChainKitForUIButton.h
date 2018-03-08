//
//  EGChainKitForUIButton.h
//  ChainProperty
//
//  Created by TengShuQiang on 2017/12/25.
//  Copyright © 2017年 TTeng. All rights reserved.
//

#import "EGChainKitHeader.h"

@class EGChainKitForCALayer;
@interface EGChainKitForUIButton : NSObject

- (EGChainKitForUIView *(^)(void)) viewMaker;
- (EGChainKitForUIControl *(^)(void)) controlMaker;

#pragma mark - button

- (EGChainKitForUIButton *(^)(UIEdgeInsets)) contentEdgeInsets;
- (EGChainKitForUIButton *(^)(UIEdgeInsets)) titleEdgeInsets;
- (EGChainKitForUIButton *(^)(BOOL)) reversesTitleShadowWhenHighlighted;
- (EGChainKitForUIButton *(^)(UIEdgeInsets)) imageEdgeInsets;
- (EGChainKitForUIButton *(^)(BOOL)) adjustsImageWhenHighlighted;
- (EGChainKitForUIButton *(^)(BOOL)) adjustsImageWhenDisabled;
- (EGChainKitForUIButton *(^)(BOOL)) showsTouchWhenHighlighted;

- (EGChainKitForUIButton *(^)(UIColor *, UIControlState)) titleColor;
- (EGChainKitForUIButton *(^)(NSString *, UIControlState)) title;
- (EGChainKitForUIButton *(^)(UIFont *)) titleFont;
- (EGChainKitForUIButton *(^)(UIImage *, UIControlState)) image;
- (EGChainKitForUIButton *(^)(UIImage *, UIControlState)) backgroundImage;
- (EGChainKitForUIButton *(^)(id, SEL,UIControlEvents)) targetAction;

#pragma mark layer

- (EGChainKitForCALayer *(^)(void)) layerMaker;

@end

@interface UIButton (EGChainKit)

@property (nonatomic, strong, readonly) EGChainKitForUIButton *buttonChain;

@end
