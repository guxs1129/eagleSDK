//
//  UIViewController+ViewModel.h
//  EagleSDK
//
//  Created by 顾新生 on 19/12/2017.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ViewModel)
@property(nonatomic,strong)EGViewModel *viewModel;
@property(nonatomic,strong)NSMutableArray *componentsArr;
@end
