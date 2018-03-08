#import <UIKit/UIKit.h>


@class EGTabBar, EGTabBarItem;

@protocol EGTabBarDelegate <NSObject>

@optional

/**
 TabBar's item be selected handler
 */
- (void)tabBar:(EGTabBar *)tabBarView didSelectedItemFrom:(NSInteger)from to:(NSInteger)to;

@end



@interface EGTabBar : UIView

/**
 *  TabBar item title color
 */
@property (nonatomic, strong) UIColor *itemTitleColor;

/**
 *  TabBar selected item title color
 */
@property (nonatomic, strong) UIColor *selectedItemTitleColor;

/**
 *  TabBar item title font
 */
@property (nonatomic, strong) UIFont *itemTitleFont;

/**
 *  TabBar item's badge title font
 */
@property (nonatomic, strong) UIFont *badgeTitleFont;

/**
 *  TabBar item image ratio
 */
@property (nonatomic, assign) CGFloat itemImageRatio;

/**
 *  TabBar's item count
 */
@property (nonatomic, assign) NSInteger tabBarItemCount;

/**
 *  TabBar's selected item
 */
@property (nonatomic, strong) EGTabBarItem *selectedItem;

/**
 *  TabBar items array
 */
@property (nonatomic, strong) NSMutableArray *tabBarItems;

/**
 *  TabBar delegate
 */
@property (nonatomic, weak) id<EGTabBarDelegate> delegate;

/**
 *  Add tabBar item
 */
- (void)addTabBarItem:(UITabBarItem *)item;

@end
