//
//  EGMapZoomBar.h
//  EagleSDK
//
//  Created by 顾新生 on 2018/1/23.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,EGMapZoomBarType) {
    EGMapZoomBarTypeDefault,
    EGMapZoomBarTypeButtons
};
@interface EGMapZoomBar : UIView
@property(nonatomic,assign)int level;
@property(nonatomic,assign)EGMapZoomBarType type;
@property(nonatomic,copy)EGMapZoomBarActionBlock actionBlock;
-(instancetype)initWithAction:(EGMapZoomBarActionBlock)actionBlock;
-(instancetype)initWithType:(EGMapZoomBarType)type action:(EGMapZoomBarActionBlock)actionBlock;

@end
