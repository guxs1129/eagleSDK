//
//  EGSearchHeaderDefault.m
//  EagleSDK-iOS8.0
//
//  Created by 顾新生 on 2017/11/24.
//
#define _kScreenWidth [UIScreen mainScreen].bounds.size.width
#define _kScreenHeight [UIScreen mainScreen].bounds.size.height
#define _kSearchInputMargin 80
#define _kSearchInputWidth  (_kScreenWidth-(2*_kSearchInputMargin))
#define _kSearchInputBgOffset 15


#import "EGSearchHeaderDefault.h"
#import <ReactiveObjC/ReactiveObjC.h>
@interface EGSearchHeaderDefault()
{
    UITextField *_searchInput;
    __weak EGSearchViewController *_searchVC;
    NSString *_placeholder;
}
@property(nonatomic,strong)UIView *inputBg;
@property(nonatomic,strong)UIButton *searchBtn;

@end

@implementation EGSearchHeaderDefault
@synthesize searchInput;
@synthesize searchVC;
@synthesize placeholder;

-(instancetype)init{
    if (self=[super init]) {
        self.backgroundColor=[UIColor redColor];
        [self setupSubviews];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor=[UIColor whiteColor];
        [self setupSubviews];
    }
    return self;
}
-(void)setupSubviews{
    [self addSubview:self.inputBg];
    [self addSubview:self.searchBtn];
    [self addSubview:self.searchInput];
}

#pragma mark ---------------animations---------------
-(void)inputShouldBeginEditingAnimation{
    [UIView animateWithDuration:0.25 animations:^{
        self.searchBtn.center=CGPointMake(_kScreenWidth-_kSearchInputMargin+_kSearchInputBgOffset+20, 22);
    }];
}
-(void)inputShouldEndEditingAnimation{
    if (self.searchInput.text.length==0) {
        [UIView animateWithDuration:0.25 animations:^{
            self.searchBtn.center=CGPointMake(_kSearchInputMargin+17, 22);
        }];
    }
}


#pragma mark ---------------lazy var---------------

-(UITextField *)searchInput{
    if (_searchInput==nil) {
        _searchInput=[[UITextField alloc]initWithFrame:CGRectMake(_kSearchInputMargin, 10, _kSearchInputWidth, 24)];
        _searchInput.returnKeyType=UIReturnKeySearch;
        _searchInput.clearButtonMode=UITextFieldViewModeWhileEditing;
    }
    return _searchInput;
}
-(UIView *)inputBg{
    if (_inputBg==nil) {
        _inputBg=[[UIView alloc]initWithFrame:CGRectMake(_kSearchInputMargin-_kSearchInputBgOffset, 5, _kSearchInputWidth+2*_kSearchInputBgOffset, 34)];
        _inputBg.backgroundColor=[UIColor colorWithWhite:0.8 alpha:0.8];
        _inputBg.layer.cornerRadius=17;
        _inputBg.clipsToBounds=YES;
    }
    return _inputBg;
}
-(UIButton *)searchBtn{
    if (_searchBtn==nil) {
        _searchBtn=[UIButton buttonWithType:UIButtonTypeInfoDark];
        _searchBtn.center=CGPointMake(_kSearchInputMargin+17, 22);
        @weakify(self)
        [[_searchBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            [self.searchInput resignFirstResponder];
        }];
    }
    return _searchBtn;
}
-(void)setSearchVC:(EGSearchViewController *)searchVC{
    _searchVC=searchVC;
    self.searchInput.delegate=(id<UITextFieldDelegate>)searchVC;
}
-(void)setPlaceholder:(NSString *)placeholder{
    _placeholder=placeholder;
    self.searchInput.placeholder=placeholder;
}
@end
