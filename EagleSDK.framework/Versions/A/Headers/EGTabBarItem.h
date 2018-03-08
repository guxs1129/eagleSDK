#import <UIKit/UIKit.h>

@interface EGTabBarItem : UIView

/**
 *  TabBar's image view
 */
@property (nonatomic, weak) UIImageView *imageView;

/**
 *  TabBar's title label
 */
@property (nonatomic, weak) UILabel *titleLabel;

/**
 *  Is tabBar be selected
 */
@property (nonatomic, assign, getter=isSelected) BOOL selected;

/**
 *  TabBar item
 */
@property (nonatomic, strong) UITabBarItem *tabBarItem;

/**
 *  TabBar's item count
 */
@property (nonatomic, assign) NSInteger tabBarItemCount;

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
 *  TabBar item init func
 */
- (instancetype)initWithItemImageRatio:(CGFloat)itemImageRatio;

@end
