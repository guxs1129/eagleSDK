//
//  EGSearchViewController.h
//  EagleSDK-iOS9.3
//
//  Created by 顾新生 on 2017/11/24.
//

#import <UIKit/UIKit.h>
#import "EGSearchHeaderDefault.h"


@interface EGSearchViewController : UIViewController<UITextFieldDelegate,RouterProtocol>

@property(nonatomic,strong)UIView<EGSearchHeaderView> *headerView;

@end
