//
//  EGChainKitForUIButton.m
//  ChainProperty
//
//  Created by TengShuQiang on 2017/12/25.
//  Copyright © 2017年 TTeng. All rights reserved.
//

#import "EGChainKitForUIButton.h"

@interface EGChainKitForUIButton ()

@property (nonatomic, strong) UIButton *button;

@end

@implementation EGChainKitForUIButton

- (EGChainKitForUIView *(^)(void)) viewMaker {
    return ^(void) {
        return ((UIView *)self.button).viewChain;
    };
}

- (EGChainKitForUIControl *(^)(void)) controlMaker {
    return ^(void) {
        return ((UIControl *)self.button).controlChain;
    };
}

#pragma mark - button

- (EGChainKitForUIButton *(^)(UIEdgeInsets)) contentEdgeInsets {
    return ^(UIEdgeInsets contentEdgeInsets) {
        self.button.contentEdgeInsets = contentEdgeInsets;
        return self;
    };
}
- (EGChainKitForUIButton *(^)(UIEdgeInsets)) titleEdgeInsets {
    return ^(UIEdgeInsets titleEdgeInsets) {
        self.button.titleEdgeInsets = titleEdgeInsets;
        return self;
    };
}
- (EGChainKitForUIButton *(^)(BOOL)) reversesTitleShadowWhenHighlighted {
    return ^(BOOL reversesTitleShadowWhenHighlighted) {
        self.button.reversesTitleShadowWhenHighlighted = reversesTitleShadowWhenHighlighted;
        return self;
    };
}
- (EGChainKitForUIButton *(^)(UIEdgeInsets)) imageEdgeInsets {
    return ^(UIEdgeInsets imageEdgeInsets) {
        self.button.imageEdgeInsets = imageEdgeInsets;
        return self;
    };
}
- (EGChainKitForUIButton *(^)(BOOL)) adjustsImageWhenHighlighted {
    return ^(BOOL adjustsImageWhenHighlighted) {
        self.button.adjustsImageWhenHighlighted = adjustsImageWhenHighlighted;
        return self;
    };
}
- (EGChainKitForUIButton *(^)(BOOL)) adjustsImageWhenDisabled {
    return ^(BOOL adjustsImageWhenDisabled) {
        self.button.adjustsImageWhenDisabled = adjustsImageWhenDisabled;
        return self;
    };
}
- (EGChainKitForUIButton *(^)(BOOL)) showsTouchWhenHighlighted {
    return ^(BOOL showsTouchWhenHighlighted) {
        self.button.showsTouchWhenHighlighted = showsTouchWhenHighlighted;
        return self;
    };
}


- (EGChainKitForUIButton *(^)(UIColor *, UIControlState)) titleColor {
    return ^(UIColor *titleColor, UIControlState state) {
        [self.button setTitleColor:titleColor forState:state];
        return self;
    };
}
- (EGChainKitForUIButton *(^)(NSString *, UIControlState)) title {
    return ^(NSString *title, UIControlState state) {
        [self.button setTitle:title forState:state];
        return self;
    };
}

- (EGChainKitForUIButton *(^)(UIFont *)) titleFont {
    return ^(UIFont *font) {
        self.button.titleLabel.font = font;
        return self;
    };
}

- (EGChainKitForUIButton *(^)(UIImage *, UIControlState)) image {
    return ^(UIImage *image, UIControlState state) {
        [self.button setImage:image forState:state];
        return self;
    };
}

- (EGChainKitForUIButton *(^)(UIImage *, UIControlState)) backgroundImage {
    return ^(UIImage *image, UIControlState state) {
        [self.button setBackgroundImage:image forState:state];
        return self;
    };
}

- (EGChainKitForUIButton *(^)(id, SEL, UIControlEvents)) targetAction {
    return ^(id target, SEL action, UIControlEvents event) {
        [self.button addTarget:target action:action forControlEvents:event];
        return self;
    };
}

#pragma mark layer
- (EGChainKitForCALayer *(^)(void)) layerMaker {
    return ^(void) {
        return self.button.layer.chainMaker;
    };
}

@end

#import <objc/runtime.h>

@implementation UIButton (EGChainKit)

- (EGChainKitForUIButton *)buttonChain {
    EGChainKitForUIButton *chain = objc_getAssociatedObject(self, _cmd);
    if (!chain) {
        chain = [EGChainKitForUIButton new];
        chain.button = self;
        objc_setAssociatedObject(self, _cmd, chain, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return chain;
}

@end
