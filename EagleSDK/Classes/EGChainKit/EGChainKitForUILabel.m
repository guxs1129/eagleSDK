//
//  EGChainKitForUILabel.m
//  ChainProperty
//
//  Created by TengShuQiang on 2017/12/25.
//  Copyright © 2017年 TTeng. All rights reserved.
//

#import "EGChainKitForUILabel.h"

@interface EGChainKitForUILabel ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation EGChainKitForUILabel

#pragma mark - view

- (EGChainKitForUIView *(^)(void))viewMaker {
    return ^(void) {
        return ((UIView *)self.label).viewChain;
    };
}

#pragma mark - label

- (EGChainKitForUILabel *(^)(NSString *)) text {
    return ^(NSString *text) {
        self.label.text = text;
        return self;
    };
}
- (EGChainKitForUILabel *(^)(UIFont *)) font {
    return ^(UIFont *font) {
        self.label.font = font;
        return self;
    };
}
- (EGChainKitForUILabel *(^)(UIColor *)) textColor {
    return ^(UIColor *textColor) {
        self.label.textColor = textColor;
        return self;
    };
}
- (EGChainKitForUILabel *(^)(UIColor *)) shadowColor {
    return ^(UIColor *shadowColor) {
        self.label.shadowColor = shadowColor;
        return self;
    };
}
- (EGChainKitForUILabel *(^)(CGSize)) shadowOffset {
    return ^(CGSize shadowOffset) {
        self.label.shadowOffset = shadowOffset;
        return self;
    };
}
- (EGChainKitForUILabel *(^)(NSTextAlignment)) textAlignment {
    return ^(NSTextAlignment textAlignment) {
        self.label.textAlignment = textAlignment;
        return self;
    };
}
- (EGChainKitForUILabel *(^)(NSLineBreakMode)) lineBreakMode {
    return ^(NSLineBreakMode lineBreakMode) {
        self.label.lineBreakMode = lineBreakMode;
        return self;
    };
}
- (EGChainKitForUILabel *(^)(NSAttributedString *)) attributedText {
    return ^(NSAttributedString * attributedText) {
        self.label.attributedText = attributedText;
        return self;
    };
}

- (EGChainKitForUILabel *(^)(UIColor *)) highlightedTextColor {
    return ^(UIColor * highlightedTextColor) {
        self.label.highlightedTextColor = highlightedTextColor;
        return self;
    };
}
- (EGChainKitForUILabel *(^)(BOOL)) highlighted {
    return ^(BOOL highlighted) {
        self.label.highlighted = highlighted;
        return self;
    };
}
- (EGChainKitForUILabel *(^)(BOOL)) userInteractionEnabled {
    return ^(BOOL userInteractionEnabled) {
        self.label.userInteractionEnabled = userInteractionEnabled;
        return self;
    };
}
- (EGChainKitForUILabel *(^)(BOOL)) enabled {
    return ^(BOOL enabled) {
        self.label.enabled = enabled;
        return self;
    };
}
- (EGChainKitForUILabel *(^)(NSInteger)) numberOfLines {
    return ^(NSInteger numberOfLines) {
        self.label.numberOfLines = numberOfLines;
        return self;
    };
}
- (EGChainKitForUILabel *(^)(BOOL)) adjustsFontSizeToFitWidth {
    return ^(BOOL adjustsFontSizeToFitWidth) {
        self.label.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth;
        return self;
    };
}
- (EGChainKitForUILabel *(^)(UIBaselineAdjustment)) baselineAdjustment {
    return ^(UIBaselineAdjustment baselineAdjustment) {
        self.label.baselineAdjustment = baselineAdjustment;
        return self;
    };
}
- (EGChainKitForUILabel *(^)(CGFloat)) minimumScaleFactor{
    return ^(CGFloat minimumScaleFactor) {
        self.label.minimumScaleFactor = minimumScaleFactor;
        return self;
    };
}

- (EGChainKitForUILabel *(^)(BOOL)) allowsDefaultTighteningForTruncation {
    return ^(BOOL allowsDefaultTighteningForTruncation) {
        self.label.allowsDefaultTighteningForTruncation = allowsDefaultTighteningForTruncation;
        return self;
    };
}
- (EGChainKitForUILabel *(^)(CGFloat)) preferredMaxLayoutWidth {
    return ^(CGFloat preferredMaxLayoutWidth) {
        self.label.preferredMaxLayoutWidth = preferredMaxLayoutWidth;
        return self;
    };
}

#pragma mark layer
- (EGChainKitForCALayer *(^)(void)) layerMaker {
    return ^(void) {
        return self.label.layer.chainMaker;
    };
}

@end

#import <objc/runtime.h>

@implementation UILabel (EGChainKit)

- (EGChainKitForUILabel *)labelChain {
    EGChainKitForUILabel *chain = objc_getAssociatedObject(self, _cmd);
    if (!chain) {
        chain = [EGChainKitForUILabel new];
        chain.label = self;
        objc_setAssociatedObject(self, _cmd, chain, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return chain;
}

@end
