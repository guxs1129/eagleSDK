//
//  EGChainKitForUITextField.h
//  ChainProperty
//
//  Created by TengShuQiang on 2017/12/25.
//  Copyright © 2017年 TTeng. All rights reserved.
//

#import "EGChainKitHeader.h"

@class EGChainKitForCALayer;
@interface EGChainKitForUITextField : NSObject

- (EGChainKitForUIView *(^)(void)) viewMaker;
- (EGChainKitForUIControl *(^)(void)) controlMaker;

#pragma mark - UITextInputTraits

- (EGChainKitForUITextField *(^)(UITextAutocapitalizationType)) autocapitalizationType;
- (EGChainKitForUITextField *(^)(UITextAutocorrectionType)) autocorrectionType;
- (EGChainKitForUITextField *(^)(UITextSpellCheckingType)) spellCheckingType NS_AVAILABLE_IOS(5_0);
- (EGChainKitForUITextField *(^)(UITextSmartQuotesType)) smartQuotesType NS_AVAILABLE_IOS(11_0);
- (EGChainKitForUITextField *(^)(UITextSmartDashesType)) smartDashesType NS_AVAILABLE_IOS(11_0);
- (EGChainKitForUITextField *(^)(UITextSmartInsertDeleteType)) smartInsertDeleteType NS_AVAILABLE_IOS(11_0);
- (EGChainKitForUITextField *(^)(UIKeyboardType)) keyboardType;
- (EGChainKitForUITextField *(^)(UIKeyboardAppearance)) keyboardAppearance;
- (EGChainKitForUITextField *(^)(UIReturnKeyType)) returnKeyType;
- (EGChainKitForUITextField *(^)(BOOL)) enablesReturnKeyAutomatically;
- (EGChainKitForUITextField *(^)(BOOL)) secureTextEntry;
- (EGChainKitForUITextField *(^)(UITextContentType)) textContentType;

#pragma mark - UIContentSizeCategoryAdjusting
- (EGChainKitForUITextField *(^)(BOOL)) adjustsFontForContentSizeCategory NS_AVAILABLE_IOS(10_0);

#pragma mark - textField

- (EGChainKitForUITextField *(^)(NSString *)) text;
- (EGChainKitForUITextField *(^)(NSAttributedString *)) attributedText NS_AVAILABLE_IOS(6_0);
- (EGChainKitForUITextField *(^)(UIColor *)) textColor;
- (EGChainKitForUITextField *(^)(UIFont *)) font;
- (EGChainKitForUITextField *(^)(NSTextAlignment)) textAlignment;
- (EGChainKitForUITextField *(^)(UITextBorderStyle)) borderStyle;
- (EGChainKitForUITextField *(^)(NSDictionary<NSString *, id> *)) defaultTextAttributes;
- (EGChainKitForUITextField *(^)(NSString *)) placeholder;

- (EGChainKitForUITextField *(^)(NSAttributedString *)) attributedPlaceholder;
- (EGChainKitForUITextField *(^)(BOOL)) clearsOnBeginEditing;
- (EGChainKitForUITextField *(^)(BOOL)) adjustsFontSizeToFitWidth;
- (EGChainKitForUITextField *(^)(id<UITextFieldDelegate>)) delegate;
- (EGChainKitForUITextField *(^)(UIImage *)) background;
- (EGChainKitForUITextField *(^)(UIImage *)) disabledBackground;

- (EGChainKitForUITextField *(^)(BOOL)) allowsEditingTextAttributes NS_AVAILABLE_IOS(6_0);
- (EGChainKitForUITextField *(^)(NSDictionary<NSString *, id> *)) typingAttributes NS_AVAILABLE_IOS(6_0);
- (EGChainKitForUITextField *(^)(UITextFieldViewMode)) clearButtonMode;
- (EGChainKitForUITextField *(^)(UIView *)) leftView;
- (EGChainKitForUITextField *(^)(UITextFieldViewMode)) leftViewMode;
- (EGChainKitForUITextField *(^)(UIView *)) rightView;
- (EGChainKitForUITextField *(^)(UITextFieldViewMode)) rightViewMode;
- (EGChainKitForUITextField *(^)(BOOL)) clearsOnInsertion NS_AVAILABLE_IOS(6_0);
- (EGChainKitForUITextField *(^)(id, SEL, UIControlEvents)) targetAction;

#pragma mark layer
- (EGChainKitForCALayer *(^)(void)) layerMaker;
@end

@interface UITextField (EGChainKit)

@property (nonatomic, strong, readonly) EGChainKitForUITextField *textFieldChain;

@end
