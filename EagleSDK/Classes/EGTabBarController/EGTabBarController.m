#import "EGTabBarController.h"
#import "EGTabBarCONST.h"
#import "EGTabBarItem.h"

@interface EGTabBarController () <EGTabBarDelegate>

@end

@implementation EGTabBarController

@synthesize badgeTitleFont;
@synthesize itemTitleFont;
@synthesize itemTitleColor;
@synthesize selectedItemTitleColor;

- (void)setBadgeTitleFont:(UIFont *)aBadgeTitleFont {
    badgeTitleFont = aBadgeTitleFont;
    
    self.EGTabBar.badgeTitleFont = aBadgeTitleFont;
}

- (void)setItemTitleFont:(UIFont *)aItemTitleFont {
    itemTitleFont = aItemTitleFont;
    
    self.EGTabBar.itemTitleFont = aItemTitleFont;
}

- (void)setItemTitleColor:(UIColor *)aItemTitleColor {
    itemTitleColor = aItemTitleColor;
    
    self.EGTabBar.itemTitleColor = aItemTitleColor;
}

- (void)setItemImageRatio:(CGFloat)itemImageRatio {
    _itemImageRatio = itemImageRatio;
    
    self.EGTabBar.itemImageRatio = itemImageRatio;
}

- (void)setSelectedItemTitleColor:(UIColor *)aSelectedItemTitleColor {
    selectedItemTitleColor = aSelectedItemTitleColor;
    
    self.EGTabBar.selectedItemTitleColor = aSelectedItemTitleColor;
}

- (UIFont *)itemTitleFont {
    if (!itemTitleFont) {
        itemTitleFont = [UIFont systemFontOfSize:10.0f];
    }
    return itemTitleFont;
}

- (UIFont *)badgeTitleFont {
    if (!badgeTitleFont) {
        badgeTitleFont = [UIFont systemFontOfSize:11.0f];
    }
    return badgeTitleFont;
}

- (UIColor *)itemTitleColor {
    if (!itemTitleColor) {
        itemTitleColor = EGColorForTabBar(117, 117, 117);
    }
    return itemTitleColor;
}

- (UIColor *)selectedItemTitleColor {
    if (!selectedItemTitleColor) {
        selectedItemTitleColor = EGColorForTabBar(234, 103, 7);
    }
    return selectedItemTitleColor;
}

#pragma mark -

- (void)loadView {
    
    [super loadView];
    
    self.itemImageRatio = 0.70f;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.tabBar addSubview:({
        
        EGTabBar *tabBar = [[EGTabBar alloc] init];
        tabBar.frame     = self.tabBar.bounds;
        tabBar.delegate  = self;
        
        tabBar.badgeTitleFont         = self.badgeTitleFont;
        tabBar.itemTitleFont          = self.itemTitleFont;
        tabBar.itemTitleColor         = self.itemTitleColor;
        tabBar.itemImageRatio         = self.itemImageRatio;
        tabBar.selectedItemTitleColor = self.selectedItemTitleColor;
        
        self.EGTabBar = tabBar;
    })];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTabBarItemChanged)
                                                 name:EGNotificationTabBarItemChanged object:nil];
}

- (void)handleTabBarItemChanged {
    [self hideOriginControls];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self hideOriginControls];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self hideOriginControls];
}

- (void)hideOriginControls {
    if ([UIDevice currentDevice].systemVersion.floatValue >= 1.0) {
        // iOS 11.0+
        [self.tabBar.subviews enumerateObjectsUsingBlock:^(__kindof UIView * obj, NSUInteger idx, BOOL * stop) {
            if ([obj isKindOfClass:[UIControl class]]) {
                [obj setHidden:YES];
            }
        }];
    } else {
        // TODO: fix iOS 11.0-
        
    }
}

- (void)removeOriginControls {
    [self hideOriginControls];
}

- (void)addChildViewController:(UIViewController *)childController {
    [super addChildViewController:childController];
    
    self.EGTabBar.tabBarItemCount = self.viewControllers.count;
    
    UIImage *selectedImage = childController.tabBarItem.selectedImage;
    childController.tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [self.EGTabBar addTabBarItem:childController.tabBarItem];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    
    [super setSelectedIndex:selectedIndex];
    
    self.EGTabBar.selectedItem.selected = NO;
    self.EGTabBar.selectedItem = self.EGTabBar.tabBarItems[selectedIndex];
    self.EGTabBar.selectedItem.selected = YES;
}

#pragma mark - XXTabBarDelegate Method

- (void)tabBar:(EGTabBar *)tabBarView didSelectedItemFrom:(NSInteger)from to:(NSInteger)to {
    
    self.selectedIndex = to;
}

@end

