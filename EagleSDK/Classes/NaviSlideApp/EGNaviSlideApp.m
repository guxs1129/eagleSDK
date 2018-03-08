//
//  EGNaviSlideApp.m
//  AFNetworking
//
//  Created by 顾新生 on 2017/11/17.
//

#import "EGNaviSlideApp.h"
#import "EGNaviSlideAppRouteParser.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"
#import <ReactiveObjC/ReactiveObjC.h>
@interface EGNaviSlideApp()
@property(nonatomic,strong)EGURL *url;
@property(nonatomic,strong)NSException *parseError;
@end

@implementation EGNaviSlideApp
NSString * const EGNaviSlideAppException=@"<EGNaviSlideApp Error>";

+(EGNaviSlideApp *(^)(NSArray *))parseRoutes{

    return ^EGNaviSlideApp *(NSArray *routes){
        EGNaviSlideApp *app = [[EGNaviSlideApp alloc]init];
        @try {
            app.url=[EGNaviSlideAppRouteParser parse:routes];
        } @catch (NSException *exception) {
            app.parseError=exception;
        } @finally {
            [UIApplication sharedApplication].naviSlideApp=app;
            return app;
        }

    };
}
-(void (^)(void))engineStart{
    @weakify(self)
    return ^{
        @strongify(self)
        if (self.parseError) {
            NSLog(@"App Engine can't start.Rease:%@",self.parseError);
        }else{
            [self initialApp];
        }
    };
}
-(void)initialApp{

        //create vcs
    UIViewController *homeVC=[self createCenterVC];
    UIViewController *leftVC=[self createLeftVC];
    UIViewController *rightVC=[self createRightVC];
    UINavigationController *naviCenter=nil;
    UINavigationController *naviLeft=nil;
    UINavigationController *naviRight=nil;
    if (homeVC) {
        naviCenter=[[EGRootNavigationController alloc]initWithRootViewController:homeVC];
    }
    if (leftVC) {
        naviLeft=[[UINavigationController alloc]initWithRootViewController:leftVC];
    }
    if (rightVC) {
        naviRight=[[UINavigationController alloc]initWithRootViewController:rightVC];
    }

    homeVC.navigationController.navigationBar.translucent=NO;

    //setup navigationItems
    NSString *leftItemImg=[self.url queryObj:LEFT_IMAGE];
    NSString *leftColor=[self.url queryObj:LEFT_IMAGE_COLOR];
    NSString *leftItemSelImg=[self.url queryObj:LEFT_IMAGE];
    NSString *leftSelectColor=[self.url queryObj:LEFT_IMAGE_SELECTED_COLOR];
    
    UIButton *leftBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    
    leftBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    if (leftItemImg) {
        UIImage *leftImage=[self imageFromName:leftItemImg color:leftColor];

        [leftBtn setImage:leftImage forState:UIControlStateNormal];
        
        if (leftItemSelImg) {
            UIImage *leftSelectImage=[self imageFromName:leftItemSelImg color:leftSelectColor];
            [leftBtn setImage:leftSelectImage forState:UIControlStateSelected];
        }
    }

    [leftBtn addTarget:self action:@selector(leftItemClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    homeVC.navigationItem.leftBarButtonItem=leftItem;

    UIButton *rightBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    NSString *rightItemImg=[self.url queryObj:RIGHT_IMAGE];
    NSString *rightColor=[self.url queryObj:LEFT_IMAGE_COLOR];
    NSString *rightItemSelImg=[self.url queryObj:LEFT_IMAGE];
    NSString *rightSelectColor=[self.url queryObj:LEFT_IMAGE_SELECTED_COLOR];
    rightBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    if (rightItemImg) {
        UIImage *rightImage=[self imageFromName:rightItemImg color:rightColor];
        
        [rightBtn setImage:rightImage forState:UIControlStateNormal];
        
        if (rightItemSelImg) {
            UIImage *rightSelectImage=[self imageFromName:rightItemSelImg color:rightSelectColor];
            [leftBtn setImage:rightSelectImage forState:UIControlStateSelected];
        }
    }
    [[rightBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self.drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
    }];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];

    homeVC.navigationItem.rightBarButtonItem=rightItem;

    //setup drawercontroller
    self.drawerController = [self createDrawerControllerWithCenter:naviCenter left:naviLeft right:naviRight];
    [self.drawerController setShowsShadow:YES];
    [self.drawerController setMaximumRightDrawerWidth:200.0];
    [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    if (self.drawerController) {
        [UIApplication sharedApplication].delegate.window.rootViewController=self.drawerController;
    }else{
        @throw [NSException exceptionWithName:EGNaviSlideAppException reason:@"Not enough params to build App." userInfo:nil];
    }
}
-(void)leftItemClick:(id)sender{
    [self.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}
-(void)rightItemClick{
    [self.drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}

-(UIViewController *)createCenterVC{
    UIViewController *homeVC=[self vcFromKey:[self.url queryObj:HOME_VC]];
    if (homeVC==nil) {
        homeVC=[[UIViewController alloc]init];
    }
    homeVC.title=[self.url queryObj:HOME_TITLE];
    homeVC.view.backgroundColor=[UIColor whiteColor];

    return homeVC;

}
-(UIViewController *)createLeftVC{
    UIViewController *leftVC=[self vcFromKey:[self.url queryObj:LEFT_VC]];
    if (leftVC) {
        leftVC.view.backgroundColor=[UIColor redColor];
        leftVC.title=[self.url queryObj:LEFT_TITLE];
    }
    return leftVC;
}
-(UIViewController *)createRightVC{
    UIViewController *rightVC=[self vcFromKey:[self.url queryObj:RIGHT_VC]];
    if (rightVC) {
        rightVC.view.backgroundColor=[UIColor greenColor];
        rightVC.title=[self.url queryObj:RIGHT_TITLE];
    }
    return rightVC;
}
-(UIViewController *)vcFromKey:(NSString *)key{
    if (!key||key.length==0) {
        return nil;
    }
    Class keyClazz=NSClassFromString(key);
    if (keyClazz==nil) {
        @throw [NSException exceptionWithName:EGNaviSlideAppException reason:[NSString stringWithFormat:@"%@ class not found",key] userInfo:nil];
    }
    id target=[[keyClazz alloc]init];
    if ([target isKindOfClass:[UIViewController class]]) {
        return target;
    }
    return nil;
}
-(MMDrawerController *)createDrawerControllerWithCenter:(UIViewController *)centerVC left:(UIViewController *)leftVC right:(UIViewController *)rightVC{
    MMDrawerController *drawerController=nil;
    if (leftVC!=nil&&rightVC==nil) {
        drawerController=[[MMDrawerController alloc]initWithCenterViewController:centerVC leftDrawerViewController:leftVC];
    }else if (leftVC==nil&&rightVC!=nil) {
        drawerController = [[MMDrawerController alloc]initWithCenterViewController:centerVC rightDrawerViewController:rightVC];
    }else if (leftVC&&rightVC) {
        drawerController = [[MMDrawerController alloc]initWithCenterViewController:centerVC leftDrawerViewController:leftVC rightDrawerViewController:rightVC];
    }
    if (drawerController) {
        [drawerController setShowsShadow:YES];
        [drawerController setMaximumRightDrawerWidth:200.0];
        [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
        [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    }
    
    return drawerController;
}


-(UIImage *)imageFromName:(NSString *)fontName color:(NSString *)color{
    UIImage *image=nil;
    if ([fontName hasPrefix:@"0x"]) {
        image=[EGIconFont iconFontFromName:fontName color:color size:25];
    }else{
        image=[UIImage imageNamed:fontName];
    }
    return image;
}
@end
