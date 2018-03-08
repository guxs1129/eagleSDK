//
//  EGSearchHeaderProtocol.h
//  Pods
//
//  Created by 顾新生 on 2017/11/24.
//

#ifndef EGSearchHeaderProtocol_h
#define EGSearchHeaderProtocol_h
/*
 * Custome Search HeaderView add to EGSearchViewController must comply with protocol <EGSearchHeaderView>
 * All properties must be @synthesize and add member variables with "_" prefix.
 */
@class EGSearchViewController;
@protocol EGSearchHeaderView<NSObject>


/**
 搜索框
 */
@required
@property(nonatomic,strong)UITextField *searchInput;

/**
 搜索框占位文字
 */
@required
@property(nonatomic,strong)NSString *placeholder;


/**
 搜索框所在的视图控制器
 */
@required
@property(nonatomic,weak)EGSearchViewController *searchVC;


/**
 搜索框获取焦点时的动画
 */
@optional
-(void)inputShouldBeginEditingAnimation;


/**
 搜索框失去焦点时的动画
 */
@optional
-(void)inputShouldEndEditingAnimation;

-(void)startSearchWithKeyword:(NSString *)keyword;


@end

#endif /* EGSearchHeaderProtocol_h */
