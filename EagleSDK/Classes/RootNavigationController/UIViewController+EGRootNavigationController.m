// 

#import <objc/runtime.h>

#import "UIViewController+EGRootNavigationController.h"
#import "EGRootNavigationController.h"

@implementation UIViewController (EGRootNavigationController)
@dynamic rt_disableInteractivePop;

- (void)setRt_disableInteractivePop:(BOOL)rt_disableInteractivePop
{
    objc_setAssociatedObject(self, @selector(rt_disableInteractivePop), @(rt_disableInteractivePop), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)rt_disableInteractivePop
{
    return [objc_getAssociatedObject(self, @selector(rt_disableInteractivePop)) boolValue];
}

- (Class)rt_navigationBarClass
{
    return nil;
}

- (EGRootNavigationController *)rt_navigationController
{
    UIViewController *vc = self;
    while (vc && ![vc isKindOfClass:[EGRootNavigationController class]]) {
        vc = vc.navigationController;
    }
    return (EGRootNavigationController *)vc;
}

@end
