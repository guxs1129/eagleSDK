// 

#import <objc/runtime.h>

#import "UIViewController+RootNavigationController.h"
#import "RootNavigationController.h"

@implementation UIViewController (RootNavigationController)
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

- (RootNavigationController *)rt_navigationController
{
    UIViewController *vc = self;
    while (vc && ![vc isKindOfClass:[RootNavigationController class]]) {
        vc = vc.navigationController;
    }
    return (RootNavigationController *)vc;
}

@end
