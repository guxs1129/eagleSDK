//
//  EGChainKitForUITextView.m
//  ChainProperty
//
//  Created by TengShuQiang on 2017/12/25.
//  Copyright © 2017年 TTeng. All rights reserved.
//

#import "EGChainKitForUITextView.h"

@interface EGChainKitForUITextView ()

@property (nonatomic, strong) UITextView *textView;

@end

@implementation EGChainKitForUITextView

- (EGChainKitForUIView *(^)(void))viewMaker {
    return ^(void) {
        return ((UIView *)self.textView).viewChain;
    };
}

- (EGChainKitForUIScrollView *(^)(void))scrollMaker {
    return ^(void) {
        return ((UIScrollView *)self.textView).scrollChain;
    };
}

#pragma mark - UITextInputTraits

- (EGChainKitForUITextView *(^)(UITextAutocapitalizationType)) autocapitalizationType {
    return ^(UITextAutocapitalizationType autocapitalizationType) {
        self.textView.autocapitalizationType = autocapitalizationType;
        return self;
    };
}
- (EGChainKitForUITextView *(^)(UITextAutocorrectionType)) autocorrectionType {
    return ^(UITextAutocorrectionType autocorrectionType) {
        self.textView.autocorrectionType = autocorrectionType;
        return self;
    };
}
- (EGChainKitForUITextView *(^)(UITextSpellCheckingType)) spellCheckingType NS_AVAILABLE_IOS(5_0) {
    return ^(UITextSpellCheckingType spellCheckingType) {
        self.textView.spellCheckingType = spellCheckingType;
        return self;
    };
}
- (EGChainKitForUITextView *(^)(UITextSmartQuotesType)) smartQuotesType NS_AVAILABLE_IOS(11_0) {
    return ^(UITextSmartQuotesType smartQuotesType) {
        self.textView.smartQuotesType = smartQuotesType;
        return self;
    };
}
- (EGChainKitForUITextView *(^)(UITextSmartDashesType)) smartDashesType NS_AVAILABLE_IOS(11_0) {
    return ^(UITextSmartDashesType smartDashesType) {
        self.textView.smartDashesType = smartDashesType;
        return self;
    };
}
- (EGChainKitForUITextView *(^)(UITextSmartInsertDeleteType)) smartInsertDeleteType NS_AVAILABLE_IOS(11_0) {
    return ^(UITextSmartInsertDeleteType smartInsertDeleteType) {
        self.textView.smartInsertDeleteType = smartInsertDeleteType;
        return self;
    };
}
- (EGChainKitForUITextView *(^)(UIKeyboardType)) keyboardType {
    return ^(UIKeyboardType keyboardType) {
        self.textView.keyboardType = keyboardType;
        return self;
    };
}
- (EGChainKitForUITextView *(^)(UIKeyboardAppearance)) keyboardAppearance {
    return ^(UIKeyboardAppearance keyboardAppearance) {
        self.textView.keyboardAppearance = keyboardAppearance;
        return self;
    };
}
- (EGChainKitForUITextView *(^)(UIReturnKeyType)) returnKeyType {
    return ^(UIReturnKeyType returnKeyType) {
        self.textView.returnKeyType = returnKeyType;
        return self;
    };
}
- (EGChainKitForUITextView *(^)(BOOL)) enablesReturnKeyAutomatically {
    return ^(BOOL enablesReturnKeyAutomatically) {
        self.textView.enablesReturnKeyAutomatically = enablesReturnKeyAutomatically;
        return self;
    };
}
- (EGChainKitForUITextView *(^)(BOOL)) secureTextEntry {
    return ^(BOOL secureTextEntry) {
        self.textView.secureTextEntry = secureTextEntry;
        return self;
    };
}
- (EGChainKitForUITextView *(^)(UITextContentType)) textContentType {
    return ^(UITextContentType textContentType) {
        self.textView.textContentType = textContentType;
        return self;
    };
}

#pragma mark - UIContentSizeCategoryAdjusting

- (EGChainKitForUITextView *(^)(BOOL)) adjustsFontForContentSizeCategory NS_AVAILABLE_IOS(10_0) {
    return ^(BOOL adjustsFontForContentSizeCategory) {
        self.textView.adjustsFontForContentSizeCategory = adjustsFontForContentSizeCategory;
        return self;
    };
}

#pragma mark - textView

- (EGChainKitForUITextView *(^)(id<UITextViewDelegate>)) delegate {
    return ^(id<UITextViewDelegate> delegate) {
        self.textView.delegate = delegate;
        return self;
    };
}
- (EGChainKitForUITextView *(^)(NSString *))text {
    return ^(NSString * text) {
        self.textView.text = text;
        return self;
    };
}
- (EGChainKitForUITextView *(^)(UIColor *)) textColor {
    return ^(UIColor * textColor) {
        self.textView.textColor = textColor;
        return self;
    };
}
- (EGChainKitForUITextView *(^)(UIFont *)) font {
    return ^(UIFont * font) {
        self.textView.font = font;
        return self;
    };
}
- (EGChainKitForUITextView *(^)(NSTextAlignment)) textAlignment {
    return ^(NSTextAlignment textAlignment) {
        self.textView.textAlignment = textAlignment;
        return self;
    };
}
- (EGChainKitForUITextView *(^)(NSRange)) selectedRange {
    return ^(NSRange selectedRange) {
        self.textView.selectedRange = selectedRange;
        return self;
    };
}
- (EGChainKitForUITextView *(^)(BOOL)) editable {
    return ^(BOOL editable) {
        self.textView.editable = editable;
        return self;
    };
}
- (EGChainKitForUITextView *(^)(BOOL)) selectable {
    return ^(BOOL selectable) {
        self.textView.selectable = selectable;
        return self;
    };
}

- (EGChainKitForUITextView *(^)(UIDataDetectorTypes)) dataDetectorTypes {
    return ^(UIDataDetectorTypes dataDetectorTypes) {
        self.textView.dataDetectorTypes = dataDetectorTypes;
        return self;
    };
}
- (EGChainKitForUITextView *(^)(BOOL)) allowsEditingTextAttributes {
    return ^(BOOL allowsEditingTextAttributes) {
        self.textView.allowsEditingTextAttributes = allowsEditingTextAttributes;
        return self;
    };
}
- (EGChainKitForUITextView *(^)(NSAttributedString *)) attributedText {
    return ^(NSAttributedString * attributedText) {
        self.textView.attributedText = attributedText;
        return self;
    };
}
- (EGChainKitForUITextView *(^)(NSDictionary<NSString *, id> *)) typingAttributes {
    return ^(NSDictionary<NSString *, id> * typingAttributes) {
        self.textView.typingAttributes = typingAttributes;
        return self;
    };
}
- (EGChainKitForUITextView *(^)(BOOL)) clearsOnInsertion {
    return ^(BOOL clearsOnInsertion) {
        self.textView.clearsOnInsertion = clearsOnInsertion;
        return self;
    };
}

- (EGChainKitForUITextView *(^)(UIEdgeInsets)) textContainerInset {
    return ^(UIEdgeInsets textContainerInset) {
        self.textView.textContainerInset = textContainerInset;
        return self;
    };
}
- (EGChainKitForUITextView *(^)(NSDictionary<NSString *, id> *)) linkTextAttributes {
    return ^(NSDictionary<NSString *, id> * linkTextAttributes) {
        self.textView.linkTextAttributes = linkTextAttributes;
        return self;
    };
}

#pragma mark layer
- (EGChainKitForCALayer *(^)(void)) layerMaker {
    return ^(void) {
        return self.textView.layer.chainMaker;
    };
}

@end

#import <objc/runtime.h>

@implementation UITextView (EGChainKit)

- (EGChainKitForUITextView *)textViewChain {
    EGChainKitForUITextView *chain = objc_getAssociatedObject(self, _cmd);
    if (!chain) {
        chain = [EGChainKitForUITextView new];
        chain.textView = self;
        objc_setAssociatedObject(self, _cmd, chain, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return chain;
}

@end
