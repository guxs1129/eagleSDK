//
//  NSObject+EGBind.m
//  Pods
//
//  Created by pantao on 2017/11/27.
//

#import "NSObject+EGBind.h"
#import <ReactiveObjC/ReactiveObjC.h>

@implementation NSObject (EGBind)

- (void)EGBindUIKit:(id)kit keyPath:(NSString *)keyPath model:(NSObject *)model property:(NSString *)property
{
    if ([kit isKindOfClass:[UILabel class]] || [kit isKindOfClass:[UIButton class]])// UILabel、UIButton
    {
        [[RACKVOChannel alloc] initWithTarget:kit keyPath:keyPath nilValue:nil][@"followingTerminal"] = [[RACKVOChannel alloc] initWithTarget:model keyPath:property nilValue:nil][@"followingTerminal"];
    }
    else if ([kit isKindOfClass:[UITextField class]])// UITextField
    {
        UITextField *textField = (UITextField *)kit;
        RACChannelTerminal *modelTerminal = [[RACKVOChannel alloc] initWithTarget:model keyPath:property nilValue:nil][@"followingTerminal"];
        RACSubscriptingAssignmentTrampoline *subscriptingAssignmentTrampoline = [[RACSubscriptingAssignmentTrampoline alloc] initWithTarget:textField nilValue:nil];
        [subscriptingAssignmentTrampoline setObject:modelTerminal forKeyedSubscript:keyPath];
        [textField.rac_textSignal subscribe:modelTerminal];
    }else if ([kit isKindOfClass:[UITextView class]])// UITextView
    {
        UITextView *textView = (UITextView *)kit;
        RACChannelTerminal *modelTerminal = [[RACKVOChannel alloc] initWithTarget:model keyPath:property nilValue:nil][@"followingTerminal"];
        RACSubscriptingAssignmentTrampoline *subscriptingAssignmentTrampoline = [[RACSubscriptingAssignmentTrampoline alloc] initWithTarget:textView nilValue:nil];
        [subscriptingAssignmentTrampoline setObject:modelTerminal forKeyedSubscript:keyPath];
        [textView.rac_textSignal subscribe:modelTerminal];
    }
}

@end
