//
//  PopView.m
//

#import "EGPopView.h"

#define DEGREES_TO_RADIANS(degrees) ((3.14159265359 * degrees) / 180)

@interface EGPopView ()

@property (nonatomic, strong, readwrite) UIControl *blackOverlay;
@property (nonatomic, weak) UIView *containerView;
@property (nonatomic, assign) CGPoint arrowShowPoint;
@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, assign) CGRect contentViewFrame;
@property (nonatomic, strong) UIColor *contentColor;

@end

@implementation EGPopView
{
    BOOL _setNeedsReset;
}

+ (instancetype)popover
{
    return [[EGPopView alloc] init];
}

- (instancetype)init
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    self.arrowSize = CGSizeMake(11.0, 9.0);
    self.cornerRadius = 5.0;
    self.backgroundColor = [UIColor whiteColor];
    self.animationIn = 0.4;
    self.animationOut = 0.3;
    self.animationSpring = YES;
    self.sideEdge = 10.0;
    self.betweenAtViewAndArrowHeight = 4.0;
    self.applyShadow = YES;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:[UIColor clearColor]];
    self.contentColor = backgroundColor;
}

- (void)setApplyShadow:(BOOL)applyShadow
{
    _applyShadow = applyShadow;
    if (_applyShadow) {
        self.layer.shadowColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.9].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 2);
        self.layer.shadowOpacity = 0.5;
        self.layer.shadowRadius = 2.0;
    } else {
        self.layer.shadowColor = nil;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowOpacity = 0.0;
        self.layer.shadowRadius = 0.0;
    }
}

- (void)_setup
{
    if (_setNeedsReset == NO) {
        return;
    }
    
    CGRect frame = self.contentViewFrame;

    CGFloat frameMidx = self.arrowShowPoint.x - CGRectGetWidth(frame) * 0.5;
    frame.origin.x = frameMidx;

    // we don't need the edge now
    CGFloat sideEdge = 0.0;
    if (CGRectGetWidth(frame) < CGRectGetWidth(self.containerView.frame)) {
        sideEdge = self.sideEdge;
    }

    // righter the edge
    CGFloat outerSideEdge = CGRectGetMaxX(frame) - CGRectGetWidth(self.containerView.bounds);
    if (outerSideEdge > 0) {
        frame.origin.x -= (outerSideEdge + sideEdge);
    } else {
        if (CGRectGetMinX(frame) < 0) {
            frame.origin.x += ABS(CGRectGetMinX(frame)) + sideEdge;
        }
    }

    self.frame = frame;

    CGPoint arrowPoint = [self.containerView convertPoint:self.arrowShowPoint toView:self];

    CGPoint anchorPoint;
    frame.origin.y = self.arrowShowPoint.y;
    anchorPoint = CGPointMake(arrowPoint.x / CGRectGetWidth(frame), 0);

    CGPoint lastAnchor = self.layer.anchorPoint;
    self.layer.anchorPoint = anchorPoint;
    self.layer.position = CGPointMake(
        self.layer.position.x + (anchorPoint.x - lastAnchor.x) * self.layer.bounds.size.width,
        self.layer.position.y + (anchorPoint.y - lastAnchor.y) * self.layer.bounds.size.height);

    if (self.borderType == EGPopViewBorderArrow) {
        frame.size.height += self.arrowSize.height;
    }
    self.frame = frame;
    _setNeedsReset = NO;
}

- (void)showAtPoint:(CGPoint)point
    withContentView:(UIView *)contentView
             inView:(UIView *)containerView
{
    CGFloat contentWidth = CGRectGetWidth(contentView.bounds);
    CGFloat contentHeight = CGRectGetHeight(contentView.bounds);
    CGFloat containerWidth = CGRectGetWidth(containerView.bounds);
    CGFloat containerHeight = CGRectGetHeight(containerView.bounds);

    NSAssert(contentWidth > 0 && contentHeight > 0,
             @"PopView contentView bounds.size should not be zero");
    NSAssert(containerWidth > 0 && containerHeight > 0,
             @"PopView containerView bounds.size should not be zero");
    NSAssert(containerWidth >= (contentWidth + self.contentInset.left + self.contentInset.right),
             @"PopView containerView width %f should be wider than contentViewWidth %f & "
             @"contentInset %@",
             containerWidth, contentWidth, NSStringFromUIEdgeInsets(self.contentInset));

    if (!self.blackOverlay) {
        self.blackOverlay = [[UIControl alloc] init];
        self.blackOverlay.autoresizingMask =
            UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    self.blackOverlay.frame = containerView.bounds;
    if (self.avoidNavigationHeight) {
        self.blackOverlay.frame = CGRectMake(0, kNavigationHeight + kStatusBarHeight, containerView.bounds.size.width, containerView.bounds.size.height);
    }

    UIColor *maskColor;
    maskColor = self.maskColor ? : [UIColor clearColor];
    self.blackOverlay.userInteractionEnabled = YES;
    self.blackOverlay.backgroundColor = maskColor;
    [self.blackOverlay addTarget:self
                          action:@selector(dismiss)
                forControlEvents:UIControlEventTouchUpInside];

    self.containerView = containerView;
    self.contentView = contentView;
    self.arrowShowPoint = point;

    CGRect contentFrame = [containerView convertRect:contentView.frame toView:containerView];
    BOOL isEdgeZero = UIEdgeInsetsEqualToEdgeInsets(self.contentInset, UIEdgeInsetsZero);
    // if the edgeInset is not be setted, we use need set the contentViews cornerRadius
    if (isEdgeZero) {
        self.contentView.layer.cornerRadius = self.cornerRadius;
        self.contentView.layer.masksToBounds = YES;
    } else {
        contentFrame.size.width += self.contentInset.left + self.contentInset.right;
        contentFrame.size.height += self.contentInset.top + self.contentInset.bottom;
    }

    self.contentViewFrame = contentFrame;
    [self show];
}

- (void)show
{
    if ([self dismiss]) {
        return;
    }
    _setNeedsReset = YES;
    [self setNeedsDisplay];

    if (![self.blackOverlay.superview isEqual:self.containerView]) {
        [self.containerView addSubview:self.blackOverlay];
    }
    CGRect contentViewFrame = self.contentView.frame;
    CGFloat originY = self.arrowSize.height;

    contentViewFrame.origin.x = self.contentInset.left;
    contentViewFrame.origin.y = originY + self.contentInset.top;
    if (self.borderType == EGPopViewBorderNone) {
        contentViewFrame.origin.y = self.contentInset.top;
    }

    self.contentView.frame = contentViewFrame;
    if (![self.contentView.superview isEqual:self]) {
         [self addSubview:self.contentView];
    }
    if (![self.superview isEqual:self.containerView]) {
        [self.containerView addSubview:self];
    }
    
    self.transform = CGAffineTransformIdentity;
//    self.transform = CGAffineTransformMakeScale(0.0, 0.0);
    switch (_animationType) {
        case EGPopViewAnimationHas:
        {
            if (self.animationSpring) {
                [UIView animateWithDuration:self.animationIn
                                      delay:0
                     usingSpringWithDamping:0.7
                      initialSpringVelocity:3
                                    options:UIViewAnimationOptionCurveEaseInOut
                                 animations:^{
                                     self.alpha = 1.0;
                                 }
                                 completion:^(BOOL finished) {
                                     //                self.transform = CGAffineTransformIdentity;
                                     if (self.didShowHandler) {
                                         self.didShowHandler();
                                     }
                                 }];
            } else {
                [UIView animateWithDuration:self.animationIn
                                      delay:0
                                    options:UIViewAnimationOptionCurveEaseInOut
                                 animations:^{
                                     self.alpha = 1.0;
                                 }
                                 completion:^(BOOL finished) {
                                     //                self.transform = CGAffineTransformIdentity;
                                     if (self.didShowHandler) {
                                         self.didShowHandler();
                                     }
                                 }];
            }
        }
            break;
            
        default:
        {
            self.alpha = 1.0;
            if (self.didShowHandler) {
                self.didShowHandler();
            }
        }
            break;
    }
    
}

- (BOOL)dismiss
{
    if (self.superview) {
        switch (_animationType) {
            case EGPopViewAnimationHas:
            {
                [UIView animateWithDuration:self.animationOut
                                      delay:0.0
                                    options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseIn
                                 animations:^{
                                     self.alpha = 0.0;
                                     self.transform = CGAffineTransformMakeScale(0.5, 0.5);
                                 }
                                 completion:^(BOOL finished) {
                                     [self.contentView removeFromSuperview];
                                     [self.blackOverlay removeFromSuperview];
                                     [self removeFromSuperview];
                                     if (self.didDismissHandler) {
                                         self.didDismissHandler();
                                     }
                                 }];
            }
                break;
                
            default:
            {
                self.alpha = 0.0;
                self.transform = CGAffineTransformMakeScale(0.5, 0.5);
                [self.contentView removeFromSuperview];
                [self.blackOverlay removeFromSuperview];
                [self removeFromSuperview];
                if (self.didDismissHandler) {
                    self.didDismissHandler();
                }
            }
                break;
        }
        
        return YES;
    }
    return NO;
}

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *arrow = [[UIBezierPath alloc] init];
    UIColor *contentColor = self.contentColor;
    // the point in the ourself view coordinator
    CGPoint arrowPoint = [self.containerView convertPoint:self.arrowShowPoint toView:self];
    CGSize arrowSize = self.arrowSize;
    CGFloat cornerRadius = self.cornerRadius;
    CGSize size = self.bounds.size;
    switch (_borderType) {
        case EGPopViewBorderArrow:
        {
            [arrow moveToPoint:CGPointMake(arrowPoint.x, 0)];
            [arrow addLineToPoint:CGPointMake(arrowPoint.x + arrowSize.width * 0.5, arrowSize.height)];
            [arrow addLineToPoint:CGPointMake(size.width - cornerRadius, arrowSize.height)];
            [arrow addArcWithCenter:CGPointMake(size.width - cornerRadius,
                                                arrowSize.height + cornerRadius)
                             radius:cornerRadius
                         startAngle:DEGREES_TO_RADIANS(270.0)
                           endAngle:DEGREES_TO_RADIANS(0)
                          clockwise:YES];
            [arrow addLineToPoint:CGPointMake(size.width, size.height - cornerRadius)];
            [arrow addArcWithCenter:CGPointMake(size.width - cornerRadius, size.height - cornerRadius)
                             radius:cornerRadius
                         startAngle:DEGREES_TO_RADIANS(0)
                           endAngle:DEGREES_TO_RADIANS(90.0)
                          clockwise:YES];
            [arrow addLineToPoint:CGPointMake(0, size.height)];
            [arrow addArcWithCenter:CGPointMake(cornerRadius, size.height - cornerRadius)
                             radius:cornerRadius
                         startAngle:DEGREES_TO_RADIANS(90)
                           endAngle:DEGREES_TO_RADIANS(180.0)
                          clockwise:YES];
            [arrow addLineToPoint:CGPointMake(0, arrowSize.height + cornerRadius)];
            [arrow addArcWithCenter:CGPointMake(cornerRadius, arrowSize.height + cornerRadius)
                             radius:cornerRadius
                         startAngle:DEGREES_TO_RADIANS(180.0)
                           endAngle:DEGREES_TO_RADIANS(270)
                          clockwise:YES];
            [arrow addLineToPoint:CGPointMake(arrowPoint.x - arrowSize.width * 0.5, arrowSize.height)];
        }
            break;
        default:
        {
            [arrow moveToPoint:CGPointMake(arrowPoint.x, arrowSize.height)];
            [arrow addLineToPoint:CGPointMake(arrowPoint.x + arrowSize.width * 0.5, arrowSize.height)];
            [arrow addLineToPoint:CGPointMake(size.width - cornerRadius, arrowSize.height)];
            [arrow addArcWithCenter:CGPointMake(size.width - cornerRadius,
                                                arrowSize.height + cornerRadius)
                             radius:cornerRadius
                         startAngle:DEGREES_TO_RADIANS(270.0)
                           endAngle:DEGREES_TO_RADIANS(0)
                          clockwise:YES];
            [arrow addLineToPoint:CGPointMake(size.width, size.height - cornerRadius)];
            [arrow addArcWithCenter:CGPointMake(size.width - cornerRadius, size.height - cornerRadius)
                             radius:cornerRadius
                         startAngle:DEGREES_TO_RADIANS(0)
                           endAngle:DEGREES_TO_RADIANS(90.0)
                          clockwise:YES];
            [arrow addLineToPoint:CGPointMake(0, size.height)];
            [arrow addArcWithCenter:CGPointMake(cornerRadius, size.height - cornerRadius)
                             radius:cornerRadius
                         startAngle:DEGREES_TO_RADIANS(90)
                           endAngle:DEGREES_TO_RADIANS(180.0)
                          clockwise:YES];
            [arrow addLineToPoint:CGPointMake(0, arrowSize.height + cornerRadius)];
            [arrow addArcWithCenter:CGPointMake(cornerRadius, arrowSize.height + cornerRadius)
                             radius:cornerRadius
                         startAngle:DEGREES_TO_RADIANS(180.0)
                           endAngle:DEGREES_TO_RADIANS(270)
                          clockwise:YES];
            [arrow addLineToPoint:CGPointMake(arrowPoint.x - arrowSize.width * 0.5, arrowSize.height)];
        }
            break;
    }
    
    [contentColor setFill];
    [arrow fill];
}

- (void)layoutSubviews
{
    [self _setup];
}

@end
