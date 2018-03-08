//
//  EGChainKitForUIControl.m
//  EGChainKit
//
//  Created by TengShuQiang on 2017/12/28.
//  Copyright © 2017年 TTeng. All rights reserved.
//

#import "EGChainKitForUIControl.h"

@interface EGChainKitForUIControl ()

@property (nonatomic, strong) UIControl *control;

@end

@implementation EGChainKitForUIControl

- (EGChainKitForUIView *(^)(void)) viewMaker {
    return ^(void) {
        return ((UIView *)self.control).viewChain;
    };
}

- (EGChainKitForUIControl *(^)(BOOL)) enabled {
    return ^(BOOL enabled) {
        self.control.enabled = enabled;
        return self;
    };
}
- (EGChainKitForUIControl *(^)(BOOL)) selected {
    return ^(BOOL selected) {
        self.control.selected = selected;
        return self;
    };
}
- (EGChainKitForUIControl *(^)(BOOL)) highlighted {
    return ^(BOOL highlighed) {
        self.control.highlighted = highlighed;
        return self;
    };
}
- (EGChainKitForUIControl *(^)(UIControlContentVerticalAlignment)) contentVerticalAlignment {
    return ^(UIControlContentVerticalAlignment contentVerticalAlignment) {
        self.control.contentVerticalAlignment = contentVerticalAlignment;
        return self;
    };
}
- (EGChainKitForUIControl *(^)(UIControlContentHorizontalAlignment)) contentHorizontalAlignment {
    return ^(UIControlContentHorizontalAlignment alignment) {
        self.control.contentHorizontalAlignment = alignment;
        return self;
    };
}
- (EGChainKitForUIControl *(^)(id, SEL, UIControlEvents)) addTarget {
    return ^(id target, SEL action ,UIControlEvents event) {
        [self.control addTarget:target action:action forControlEvents:event];
        return self;
    };
}
- (EGChainKitForUIControl *(^)(id, SEL, UIControlEvents)) removeTarget {
    return ^(id target, SEL action ,UIControlEvents event) {
        [self.control removeTarget:target action:action forControlEvents:event];
        return self;
    };
}
- (EGChainKitForUIControl *(^)(SEL, id, UIEvent *)) sendActionTarget {
    return ^(SEL action, id target, UIEvent *event) {
        [self.control sendAction:action to:target forEvent:event];
        return self;
    };
}
- (EGChainKitForUIControl *(^)(UIControlEvents)) sendActionEvent {
    return ^(UIControlEvents event) {
        [self.control sendActionsForControlEvents:event];
        return self;
    };
}

#pragma mark layer
- (EGChainKitForCALayer *(^)(void)) layerMaker {
    return ^(void) {
        return self.control.layer.chainMaker;
    };
}

#pragma mark - subviews

- (EGChainKitForUIButton *(^)(void))buttonMaker {
    return ^(void) {
        NSAssert([self.control isKindOfClass:[UIButton class]], @"textFieldChain's target must be UIbutton class");
        return ((UIButton *)self.control).buttonChain;
    };
}
- (EGChainKitForUITextField *(^)(void))textFieldMaker {
    return ^(void) {
        NSAssert([self.control isKindOfClass:[UITextField class]], @"textFieldChain's target must be UITextField class");
        return ((UITextField *)self.control).textFieldChain;
    };
}

@end

#import <objc/runtime.h>

@implementation UIControl (EGChainKit)

- (EGChainKitForUIControl *)controlChain {
    EGChainKitForUIControl *chain = objc_getAssociatedObject(self, _cmd);
    if (!chain) {
        chain = [EGChainKitForUIControl new];
        chain.control = self;
        objc_setAssociatedObject(self, _cmd, chain, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return chain;
}

@end
