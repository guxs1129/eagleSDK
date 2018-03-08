//
//  EGChainKitForUITextView.h
//  ChainProperty
//
//  Created by TengShuQiang on 2017/12/25.
//  Copyright © 2017年 TTeng. All rights reserved.
//

#import "EGChainKitHeader.h"

@class EGChainKitForCALayer;
@interface EGChainKitForUITextView : NSObject


- (EGChainKitForUIView *(^)(void))viewMaker;

- (EGChainKitForUIScrollView *(^)(void))scrollMaker;

#pragma mark - UITextInputTraits

- (EGChainKitForUITextView *(^)(UITextAutocapitalizationType)) autocapitalizationType;
- (EGChainKitForUITextView *(^)(UITextAutocorrectionType)) autocorrectionType;
- (EGChainKitForUITextView *(^)(UITextSpellCheckingType)) spellCheckingType NS_AVAILABLE_IOS(5_0);
- (EGChainKitForUITextView *(^)(UITextSmartQuotesType)) smartQuotesType NS_AVAILABLE_IOS(11_0);
- (EGChainKitForUITextView *(^)(UITextSmartDashesType)) smartDashesType NS_AVAILABLE_IOS(11_0);
- (EGChainKitForUITextView *(^)(UITextSmartInsertDeleteType)) smartInsertDeleteType NS_AVAILABLE_IOS(11_0);
- (EGChainKitForUITextView *(^)(UIKeyboardType)) keyboardType;
- (EGChainKitForUITextView *(^)(UIKeyboardAppearance)) keyboardAppearance;
- (EGChainKitForUITextView *(^)(UIReturnKeyType)) returnKeyType;
- (EGChainKitForUITextView *(^)(BOOL)) enablesReturnKeyAutomatically;
- (EGChainKitForUITextView *(^)(BOOL)) secureTextEntry;
- (EGChainKitForUITextView *(^)(UITextContentType)) textContentType;

#pragma mark - UIContentSizeCategoryAdjusting
- (EGChainKitForUITextView *(^)(BOOL)) adjustsFontForContentSizeCategory NS_AVAILABLE_IOS(10_0);

#pragma mark - textView
- (EGChainKitForUITextView *(^)(id<UITextViewDelegate>)) delegate;
- (EGChainKitForUITextView *(^)(NSString *)) text;
- (EGChainKitForUITextView *(^)(UIColor *)) textColor;
- (EGChainKitForUITextView *(^)(UIFont *)) font;
- (EGChainKitForUITextView *(^)(NSTextAlignment)) textAlignment;
- (EGChainKitForUITextView *(^)(NSRange)) selectedRange;
- (EGChainKitForUITextView *(^)(BOOL)) editable;
- (EGChainKitForUITextView *(^)(BOOL)) selectable NS_AVAILABLE_IOS(7_0);

- (EGChainKitForUITextView *(^)(UIDataDetectorTypes)) dataDetectorTypes NS_AVAILABLE_IOS(3_0);
- (EGChainKitForUITextView *(^)(BOOL)) allowsEditingTextAttributes NS_AVAILABLE_IOS(6_0);
- (EGChainKitForUITextView *(^)(NSAttributedString *)) attributedText NS_AVAILABLE_IOS(6_0);
- (EGChainKitForUITextView *(^)(NSDictionary<NSString *, id> *)) typingAttributes NS_AVAILABLE_IOS(6_0);
- (EGChainKitForUITextView *(^)(BOOL)) clearsOnInsertion NS_AVAILABLE_IOS(6_0);

- (EGChainKitForUITextView *(^)(UIEdgeInsets)) textContainerInset;
- (EGChainKitForUITextView *(^)(NSDictionary<NSString *, id> *)) linkTextAttributes NS_AVAILABLE_IOS(7_0);

#pragma mark layer
- (EGChainKitForCALayer *(^)(void)) layerMaker;

@end

@interface UITextView (EGChainKit)

@property (nonatomic, strong, readonly) EGChainKitForUITextView *textViewChain;

@end
