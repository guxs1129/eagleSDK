//
//  PopView.h
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, EGPopViewBorderType)
{
    EGPopViewBorderNone,
    EGPopViewBorderArrow
};

typedef NS_ENUM(NSInteger, EGPopViewAnimationType)
{
    EGPopViewAnimationNone,
    EGPopViewAnimationHas
};

@interface EGPopView : UIView

+ (instancetype)popover;

/**
 *  The contentView positioned in container, default is zero;
 */
@property (nonatomic, assign) UIEdgeInsets contentInset;

/**
 *  The popover arrow size, default is {10.0, 10.0};
 */
@property (nonatomic, assign) CGSize arrowSize;

/**
 *  The popover corner radius, default is 7.0;
 */
@property (nonatomic, assign) CGFloat cornerRadius;

/**
 *  The popover animation show in duration, default is 0.4;
 */
@property (nonatomic, assign) CGFloat animationIn;

/**
 *  The popover animation dismiss duration, default is 0.3;
 */
@property (nonatomic, assign) CGFloat animationOut;

/**
 *  If the drop in animation using spring animation, default is YES;
 */
@property (nonatomic, assign) BOOL animationSpring;

/**
 *  If maskType does not satisfy your need, use blackoverylay to control the touch
 * event(userInterfaceEnabled) for
 * background color
 */
@property (nonatomic, strong, readonly) UIControl *blackOverlay;

/**
 *  If the popover has the shadow behind it, default is YES, if you wanna custom the shadow, set it
 * by
 * popover.layer.shadowColor, shadowOffset, shadowOpacity, shadowRadius
 */
@property (nonatomic, assign) BOOL applyShadow;

/**
 *  when you using atView show API, this value will be used as the distance between popovers'arrow
 * and atView. Note:
 * this value is invalid when popover show using the atPoint API
 */
@property (nonatomic, assign) CGFloat betweenAtViewAndArrowHeight;

/**
 * Decide the nearest edge between the containerView's border and popover, default is 4.0
 */
@property (nonatomic, assign) CGFloat sideEdge;

/**
 *  The callback when popover did show in the containerView
 */
@property (nonatomic, copy) dispatch_block_t didShowHandler;

/**
 *  The callback when popover did dismiss in the containerView;
 */
@property (nonatomic, copy) dispatch_block_t didDismissHandler;

/**
 *  Show API
 *
 *  @param point         the point in the container coordinator system.
 *  @param contentView   the contentView to show
 *  @param containerView the containerView to contain
 */
- (void)showAtPoint:(CGPoint)point
    withContentView:(UIView *)contentView
             inView:(UIView *)containerView;

- (void)show;
- (BOOL)dismiss;

/**
 边框类型，目前暂定有无箭头
 */
@property (nonatomic, assign) EGPopViewBorderType borderType;

/**
 动画类型，暂定有无动画
 */
@property (nonatomic, assign) EGPopViewAnimationType animationType;

/**
 背景色
 */
@property (nonatomic, strong) UIColor *maskColor;

/**
 是否要避免导航栏的那部分高度
 */
@property (nonatomic, assign) BOOL avoidNavigationHeight;

@end
