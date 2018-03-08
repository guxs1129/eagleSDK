//
//  EGMapZoomBar.m
//  EagleSDK
//
//  Created by 顾新生 on 2018/1/23.
//
#define kButtonHeight    10
#define kBarHeight  200
#define kBarWidth  25
#define kStep    10
#define kBarButtonsHeight   60
#define kBarButtonsWidth    25
#define kBarButtonsOffSet   10

#import "EGMapZoomBar.h"
#import <ReactiveObjC/ReactiveObjC.h>
@interface EGMapZoomBar()
@property(nonatomic,strong)UIButton *btn;
@property(nonatomic,weak)MKMapView *mapView;
@property(nonatomic,assign)BOOL isDragBtn;
@property(nonatomic,assign)BOOL isMapZoom;//check if level change is triggered by mapview.YES by mapview,NO by self touches.
@property(nonatomic,strong)UIButton *plusBtn;
@property(nonatomic,strong)UIButton *minusBtn;
@end

@implementation EGMapZoomBar
-(instancetype)initWithAction:(EGMapZoomBarActionBlock)actionBlock{
    if (self=[super init]) {
        self.type=EGMapZoomBarTypeDefault;
        self.isDragBtn=NO;
        self.isMapZoom=YES;
        self.backgroundColor=[UIColor clearColor];
        self.actionBlock = actionBlock;
        [self setupSubviews];
    }
    return self;
}

-(instancetype)initWithType:(EGMapZoomBarType)type action:(EGMapZoomBarActionBlock)actionBlock{
    if (self=[super init]) {
        self.type=type;
        self.isDragBtn=NO;
        self.isMapZoom=YES;
        self.backgroundColor=[UIColor clearColor];
        self.actionBlock = actionBlock;
        [self setupSubviews];
    }
    return self;
}

-(instancetype)init{
    if (self=[super init]) {
        self.type=EGMapZoomBarTypeDefault;
        self.isDragBtn=NO;
        self.isMapZoom=YES;
        self.backgroundColor=[UIColor clearColor];
        [self setupSubviews];
    }
    return self;
}
-(void)setupSubviews{
    switch (self.type) {
        case EGMapZoomBarTypeDefault:{
            [self setupDefaultSubviews];
        }
            break;
        case EGMapZoomBarTypeButtons:{
            [self setupButtonsSubviews];
        }
            break;
        default:
            break;
    }
}

-(void)setupDefaultSubviews{
    
    self.btn=[[UIButton alloc]init];
    [self.btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:1.0 alpha:0.8]] forState:UIControlStateDisabled];
    self.btn.layer.cornerRadius=2;
    self.btn.layer.borderColor=[UIColor darkGrayColor].CGColor;
    self.btn.layer.borderWidth=1.0;
    self.btn.clipsToBounds=YES;
    [self addSubview:self.btn];
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.height.equalTo(@(kButtonHeight));
        make.top.equalTo(@(kBarHeight-kButtonHeight));
    }];
    self.btn.enabled=NO;
}

-(void)setupButtonsSubviews{
    self.backgroundColor=[UIColor clearColor];
    self.plusBtn=[[UIButton alloc]init];
    [self.plusBtn setTitle:@"+" forState:UIControlStateNormal];
    [self.plusBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.plusBtn.titleLabel.font=[UIFont systemFontOfSize:20];
    [self.plusBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:0.5 alpha:0.5]] forState:UIControlStateDisabled];
    self.plusBtn.layer.cornerRadius=2;
    self.plusBtn.layer.borderColor=[UIColor darkGrayColor].CGColor;
    self.plusBtn.layer.borderWidth=1.0;
    self.plusBtn.clipsToBounds=YES;
    [self addSubview:self.plusBtn];
    [self.plusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(@0);
        make.height.equalTo(@(kBarButtonsWidth));
    }];
    self.plusBtn.tag=1001;
    
    self.minusBtn=[[UIButton alloc]init];
    [self.minusBtn setTitle:@"-" forState:UIControlStateNormal];
    [self.minusBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.minusBtn.titleLabel.font=[UIFont systemFontOfSize:20];
    [self.minusBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:0.5 alpha:0.5]] forState:UIControlStateDisabled];
    self.minusBtn.layer.cornerRadius=2;
    self.minusBtn.layer.borderColor=[UIColor darkGrayColor].CGColor;
    self.minusBtn.layer.borderWidth=1.0;
    self.minusBtn.clipsToBounds=YES;
    [self addSubview:self.minusBtn];
    [self.minusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(@0);
        make.height.equalTo(@(kBarButtonsWidth));
    }];
    self.minusBtn.tag=1002;
    
    [self.plusBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.minusBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
}


#pragma mark ---------------touches---------------
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.type==EGMapZoomBarTypeDefault) {
        
        CGPoint point=[[touches.allObjects lastObject] locationInView:self];
        self.isMapZoom=NO;
        
        int level=0;
        
        CGFloat y=point.y;
        if (y<kStep*0.5+kButtonHeight) {
            level=19;
        } else if(y>18.5*kStep+kButtonHeight){
            level=1;
        }else{
            int position=y-kButtonHeight*0.5;
            level = 19-position/kStep;
            int offset = position%kStep;
            if (offset>kStep*0.5) {
                level--;
            }
        }
        y=(19-level)*kStep+kButtonHeight*0.5;
        [self.btn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(y));
        }];
    }
    
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.type==EGMapZoomBarTypeDefault) {
        
        CGPoint point=[[touches.allObjects lastObject] locationInView:self];
        self.isMapZoom=NO;
        
        int level=0;
        
        CGFloat y=point.y;
        if (y<kStep*0.5+kButtonHeight) {
            level=19;
        } else if(y>18.5*kStep+kButtonHeight){
            level=1;
        }else{
            int position=y-kButtonHeight*0.5;
            level = 19-position/kStep;
            int offset = position%kStep;
            if (offset>kStep*0.5) {
                level--;
            }
        }
        y=(19-level)*kStep+kButtonHeight*0.5;
        [self.btn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(y));
        }];
        
    }
    
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.type==EGMapZoomBarTypeDefault) {
        
        CGPoint point=[[touches.allObjects lastObject] locationInView:self];
        self.isMapZoom=NO;
        
        int level=0;
        
        CGFloat y=point.y;
        if (y<kStep*0.5+kButtonHeight) {
            level=19;
        } else if(y>18.5*kStep+kButtonHeight){
            level=1;
        }else{
            int position=y-kButtonHeight*0.5;
            level = 19-position/kStep;
            int offset = position%kStep;
            if (offset>kStep*0.5) {
                level--;
            }
        }
        y=(19-level)*kStep+kButtonHeight*0.5;
        [self.btn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(y));
        }];
        
        if (self.actionBlock) {
            self.actionBlock(level);
        }
        self.isMapZoom=YES;
    }
}

#pragma mark ---------------button action---------------

-(void)btnClick:(UIButton *)sender{
    NSLog(@"%s",__func__);

    switch (sender.tag) {
        case 1001:{//plus
            if (self.level<19) {
                self.level++;
            }
        }
            break;
        case 1002:{//minus
            if (self.level>1) {
                self.level--;
            }
        }
            break;
        default:
            break;
    }
    if (self.actionBlock) {
        self.actionBlock(self.level);
    }
    
}

#pragma mark ---------------draw axis---------------
-(void)drawRect:(CGRect)rect{
    
    [super drawRect:rect];
    switch (self.type) {
        case EGMapZoomBarTypeDefault:{
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextSaveGState(context);
            CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
            CGContextSetLineWidth(context, 1.0);
            
            for (int i=0; i<=18; i++) {//draw horizontal lines
                CGFloat padding = i%6 == 0 ? 0 : 5;
                CGContextMoveToPoint(context, 0+padding, i*kStep+kButtonHeight);
                CGContextAddLineToPoint(context, kBarWidth-padding, i*kStep+kButtonHeight);
            }
            //draw vertical line
            CGContextMoveToPoint(context, kBarWidth*0.5, kButtonHeight);
            CGContextAddLineToPoint(context, kBarWidth*0.5, kBarHeight-kButtonHeight);
            
            CGContextStrokePath(context);
            CGContextRestoreGState(context);
            
        }
            break;
            
        default:
            break;
    }
   
}
#pragma mark ---------------setter & getter---------------
-(void)setType:(EGMapZoomBarType)type{
    _type=type;
    if (type==EGMapZoomBarTypeDefault) {
        self.frame=CGRectMake(0, 0, kBarWidth, kBarHeight);
    }else{
        self.frame=CGRectMake(0, 0, kBarButtonsWidth, kBarButtonsHeight);
    }
}
-(void)setLevel:(int)level{
    NSLog(@"%s",__func__);

    if (level<1||level>19) {
        return;
    }
    _level=level;
    self.minusBtn.enabled=level!=1;
    self.plusBtn.enabled=level!=19;
    if (self.isMapZoom) {
        CGFloat y=(19-level)*kStep+kButtonHeight*0.5;
        [self.btn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(y));
        }];
    }

}
@end
