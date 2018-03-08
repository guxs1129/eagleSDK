//
//  EGViewModel.m
//  Pods
//
//  Created by pantao on 2017/11/27.
//

#import "EGViewModel.h"

@implementation EGViewModel


- (void)EGViewModelDealUIKit:(id)kit model:(NSObject *)model
{
    
}

-(void)sendUIAction:(EGUIActionBlock)actionBlock{
    [self post:EGViewModel_UIAction_Channel withOptions:@{@"viewmodel":self,@"action":actionBlock}];
}

@end
