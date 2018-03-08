#import <UIKit/UIKit.h>


#define EGColorForTabBar(r, g, b)       [UIColor colorWithRed:(r)/255.0f \
                                                        green:(g)/255.0f \
                                                         blue:(b)/255.0f \
                                                        alpha:1.0f]

#define EGNotificationTabBarItemChanged @"EGNotificationTabBarItemChanged"


//#define LC_TABBAR_ITEM_TITLE_COLOR      LCColorForTabBar(117, 117, 117) // tabBar 标题字体颜色
//#define LC_TABBAR_ITEM_TITLE_COLOR_SEL  LCColorForTabBar(234, 103, 7)   // tabBar 标题字体颜色 (选中)
//
//
//UIKIT_EXTERN const CGFloat LCTabBarItemImageRatio;      // tabBar 图片所占比例
//UIKIT_EXTERN const CGFloat LCTabBarItemTitleFontSize;   // tabBar 标题字体大小
//UIKIT_EXTERN const CGFloat LCTabBarBadgeTitleFontSize;  // tabBar badge 字体大小
