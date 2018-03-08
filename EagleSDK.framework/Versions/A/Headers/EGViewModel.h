//
//  EGViewModel.h
//  Pods
//
//  Created by pantao on 2017/11/27.
//
#define BindViewModelToController(module,vcClazz)   +(void)load{\
[super load];\
[[EGModuleManager manager]bindViewModel:self forVC:(vcClazz) inModule:(module)];\
}

typedef void(^EGUIActionBlock)(UIViewController *presentVC);
static NSString * const EGViewModel_UIAction_Channel=@"EGViewModel_UIAction_Channel";

#import <Foundation/Foundation.h>

@interface EGViewModel : NSObject

/**
 viewModel基类方法，在该方法内处理UIKit属性与model成员属性的双向绑定、UIKit的事件回调block

 @param kit     UIKit
 @param model   model
 */
- (void)EGViewModelDealUIKit:(NSObject *)kit model:(NSObject *)model;

-(void)sendUIAction:(EGUIActionBlock)actionBlock;
@end
