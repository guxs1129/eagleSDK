//
//  EGChainKitForUIControl.h
//  EGChainKit
//
//  Created by TengShuQiang on 2017/12/28.
//  Copyright © 2017年 TTeng. All rights reserved.
//

#import "EGChainKitHeader.h"

@class EGChainKitForCALayer;
@class EGChainKitForUIButton,EGChainKitForUITextField,EGChainKitForUIView;
@interface EGChainKitForUIControl : NSObject

- (EGChainKitForUIView *(^)(void)) viewMaker;

- (EGChainKitForUIControl *(^)(BOOL)) enabled;
- (EGChainKitForUIControl *(^)(BOOL)) selected;
- (EGChainKitForUIControl *(^)(BOOL)) highlighted;
- (EGChainKitForUIControl *(^)(UIControlContentVerticalAlignment)) contentVerticalAlignment;
- (EGChainKitForUIControl *(^)(UIControlContentHorizontalAlignment)) contentHorizontalAlignment;
- (EGChainKitForUIControl *(^)(id, SEL, UIControlEvents)) addTarget;
- (EGChainKitForUIControl *(^)(id, SEL, UIControlEvents)) removeTarget;
- (EGChainKitForUIControl *(^)(SEL, id, UIEvent *)) sendActionTarget;
- (EGChainKitForUIControl *(^)(UIControlEvents)) sendActionEvent;

#pragma mark layer

- (EGChainKitForCALayer *(^)(void)) layerMaker;

#pragma mark - subviews

- (EGChainKitForUIButton *(^)(void))buttonMaker;
- (EGChainKitForUITextField *(^)(void))textFieldMaker;

@end

@interface UIControl (EGChainKit)

@property (nonatomic, strong, readonly) EGChainKitForUIControl *controlChain;
@end
