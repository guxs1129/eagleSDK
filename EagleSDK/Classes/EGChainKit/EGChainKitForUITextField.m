//
//  EGChainKitForUITextField.m
//  ChainProperty
//
//  Created by TengShuQiang on 2017/12/25.
//  Copyright © 2017年 TTeng. All rights reserved.
//

#import "EGChainKitForUITextField.h"

@interface EGChainKitForUITextField ()

@property (nonatomic, strong) UITextField *textField;

@end

@implementation EGChainKitForUITextField

- (EGChainKitForUIView *(^)(void)) viewMaker {
    return ^(void) {
        return ((UIView *)self.textField).viewChain;
    };
}

- (EGChainKitForUIControl *(^)(void)) controlMaker {
    return ^(void) {
        return ((UIControl *)self.textField).controlChain;
    };
}

#pragma mark - UITextInputTraits

- (EGChainKitForUITextField *(^)(UITextAutocapitalizationType)) autocapitalizationType {
    return ^(UITextAutocapitalizationType autocapitalizationType) {
        self.textField.autocapitalizationType = autocapitalizationType;
        return self;
    };
}
- (EGChainKitForUITextField *(^)(UITextAutocorrectionType)) autocorrectionType {
    return ^(UITextAutocorrectionType autocorrectionType) {
        self.textField.autocorrectionType = autocorrectionType;
        return self;
    };
}
- (EGChainKitForUITextField *(^)(UITextSpellCheckingType)) spellCheckingType NS_AVAILABLE_IOS(5_0) {
    return ^(UITextSpellCheckingType spellCheckingType) {
        self.textField.spellCheckingType = spellCheckingType;
        return self;
    };
}
- (EGChainKitForUITextField *(^)(UITextSmartQuotesType)) smartQuotesType NS_AVAILABLE_IOS(11_0) {
    return ^(UITextSmartQuotesType smartQuotesType) {
        self.textField.smartQuotesType = smartQuotesType;
        return self;
    };
}
- (EGChainKitForUITextField *(^)(UITextSmartDashesType)) smartDashesType NS_AVAILABLE_IOS(11_0) {
    return ^(UITextSmartDashesType smartDashesType) {
        self.textField.smartDashesType = smartDashesType;
        return self;
    };
}
- (EGChainKitForUITextField *(^)(UITextSmartInsertDeleteType)) smartInsertDeleteType NS_AVAILABLE_IOS(11_0) {
    return ^(UITextSmartInsertDeleteType smartInsertDeleteType) {
        self.textField.smartInsertDeleteType = smartInsertDeleteType;
        return self;
    };
}
- (EGChainKitForUITextField *(^)(UIKeyboardType)) keyboardType {
    return ^(UIKeyboardType keyboardType) {
        self.textField.keyboardType = keyboardType;
        return self;
    };
}
- (EGChainKitForUITextField *(^)(UIKeyboardAppearance)) keyboardAppearance {
    return ^(UIKeyboardAppearance keyboardAppearance) {
        self.textField.keyboardAppearance = keyboardAppearance;
        return self;
    };
}
- (EGChainKitForUITextField *(^)(UIReturnKeyType)) returnKeyType {
    return ^(UIReturnKeyType returnKeyType) {
        self.textField.returnKeyType = returnKeyType;
        return self;
    };
}
- (EGChainKitForUITextField *(^)(BOOL)) enablesReturnKeyAutomatically {
    return ^(BOOL enablesReturnKeyAutomatically) {
        self.textField.enablesReturnKeyAutomatically = enablesReturnKeyAutomatically;
        return self;
    };
}
- (EGChainKitForUITextField *(^)(BOOL)) secureTextEntry {
    return ^(BOOL secureTextEntry) {
        self.textField.secureTextEntry = secureTextEntry;
        return self;
    };
}
- (EGChainKitForUITextField *(^)(UITextContentType)) textContentType {
    return ^(UITextContentType textContentType) {
        self.textField.textContentType = textContentType;
        return self;
    };
}

#pragma mark - UIContentSizeCategoryAdjusting

- (EGChainKitForUITextField *(^)(BOOL)) adjustsFontForContentSizeCategory NS_AVAILABLE_IOS(10_0) {
    return ^(BOOL adjustsFontForContentSizeCategory) {
        self.textField.adjustsFontForContentSizeCategory = adjustsFontForContentSizeCategory;
        return self;
    };
}

#pragma mark - textField

- (EGChainKitForUITextField *(^)(NSString *)) text {
    return ^(NSString *text) {
        self.textField.text = text;
        return self;
    };
}
- (EGChainKitForUITextField *(^)(NSAttributedString *)) attributedText {
    return ^(NSAttributedString *attributedText) {
        self.textField.attributedText = attributedText;
        return self;
    };
}
- (EGChainKitForUITextField *(^)(UIColor *)) textColor {
    return ^(UIColor *textColor) {
        self.textField.textColor = textColor;
        return self;
    };
}
- (EGChainKitForUITextField *(^)(UIFont *)) font {
    return ^(UIFont *font) {
        self.textField.font = font;
        return self;
    };
}
- (EGChainKitForUITextField *(^)(NSTextAlignment)) textAlignment {
    return ^(NSTextAlignment textAlignment) {
        self.textField.textAlignment = textAlignment;
        return self;
    };
}
- (EGChainKitForUITextField *(^)(UITextBorderStyle)) borderStyle {
    return ^(UITextBorderStyle borderStyle) {
        self.textField.borderStyle = borderStyle;
        return self;
    };
}
- (EGChainKitForUITextField *(^)(NSDictionary<NSString *, id> *)) defaultTextAttributes {
    return ^(NSDictionary<NSString *, id> *defaultTextAttributes) {
        self.textField.defaultTextAttributes = defaultTextAttributes;
        return self;
    };
}
- (EGChainKitForUITextField *(^)(NSString *)) placeholder {
    return ^(NSString * placeholder) {
        self.textField.placeholder = placeholder;
        return self;
    };
}

- (EGChainKitForUITextField *(^)(NSAttributedString *)) attributedPlaceholder {
    return ^(NSAttributedString * attributedPlaceholder) {
        self.textField.attributedPlaceholder = attributedPlaceholder;
        return self;
    };
}
- (EGChainKitForUITextField *(^)(BOOL)) clearsOnBeginEditing {
    return ^(BOOL clearsOnBeginEditing) {
        self.textField.clearsOnBeginEditing = clearsOnBeginEditing;
        return self;
    };
}
- (EGChainKitForUITextField *(^)(BOOL)) adjustsFontSizeToFitWidth {
    return ^(BOOL adjustsFontSizeToFitWidth) {
        self.textField.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth;
        return self;
    };
}
- (EGChainKitForUITextField *(^)(id<UITextFieldDelegate>)) delegate {
    return ^(id<UITextFieldDelegate> delegate) {
        self.textField.delegate = delegate;
        return self;
    };
}
- (EGChainKitForUITextField *(^)(UIImage *)) background {
    return ^(UIImage * background) {
        self.textField.background = background;
        return self;
    };
}
- (EGChainKitForUITextField *(^)(UIImage *)) disabledBackground {
    return ^(UIImage * disabledBackground) {
        self.textField.disabledBackground = disabledBackground;
        return self;
    };
}

- (EGChainKitForUITextField *(^)(BOOL)) allowsEditingTextAttributes {
    return ^(BOOL allowsEditingTextAttributes) {
        self.textField.allowsEditingTextAttributes = allowsEditingTextAttributes;
        return self;
    };
}
- (EGChainKitForUITextField *(^)(NSDictionary<NSString *, id> *)) typingAttributes {
    return ^(NSDictionary<NSString *, id> * typingAttributes) {
        self.textField.typingAttributes = typingAttributes;
        return self;
    };
}
- (EGChainKitForUITextField *(^)(UITextFieldViewMode)) clearButtonMode {
    return ^(UITextFieldViewMode clearButtonMode) {
        self.textField.clearButtonMode = clearButtonMode;
        return self;
    };
}
- (EGChainKitForUITextField *(^)(UIView *)) leftView {
    return ^(UIView * leftView) {
        self.textField.leftView = leftView;
        return self;
    };
}
- (EGChainKitForUITextField *(^)(UITextFieldViewMode)) leftViewMode {
    return ^(UITextFieldViewMode leftViewMode) {
        self.textField.leftViewMode = leftViewMode;
        return self;
    };
}
- (EGChainKitForUITextField *(^)(UIView *)) rightView {
    return ^(UIView * rightView) {
        self.textField.rightView = rightView;
        return self;
    };
}
- (EGChainKitForUITextField *(^)(UITextFieldViewMode)) rightViewMode {
    return ^(UITextFieldViewMode rightViewMode) {
        self.textField.rightViewMode = rightViewMode;
        return self;
    };
}
- (EGChainKitForUITextField *(^)(BOOL)) clearsOnInsertion {
    return ^(BOOL clearsOnInsertion) {
        self.textField.clearsOnInsertion = clearsOnInsertion;
        return self;
    };
}

- (EGChainKitForUITextField *(^)(id, SEL, UIControlEvents)) targetAction {
    return ^(id target, SEL selector ,UIControlEvents event) {
        [self.textField  addTarget:target action:selector forControlEvents:event];
        return self;
    };
}

#pragma mark layer
- (EGChainKitForCALayer *(^)(void)) layerMaker {
    return ^(void) {
        return self.textField.layer.chainMaker;
    };
}

@end

#import <objc/runtime.h>

@implementation UITextField (EGChainKit)

- (EGChainKitForUITextField *)textFieldChain {
    EGChainKitForUITextField *chain = objc_getAssociatedObject(self, _cmd);
    if (!chain) {
        chain = [EGChainKitForUITextField new];
        chain.textField = self;
        objc_setAssociatedObject(self, _cmd, chain, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return chain;
}

@end
