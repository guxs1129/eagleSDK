//
//  EGTabBarManager.m
//  AFNetworking
//
//  Created by pantao on 2017/11/16.
//

#import "EGTabBarManager.h"
#import "EGTabBarItem.h"

@implementation EGTabBarManager

+ (instancetype)shared
{
    static EGTabBarManager *tabBar = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        if (!tabBar) {
            tabBar = [[self alloc] init];
        }
    });
    return tabBar;
}

#pragma mark -- Private

+ (NSMutableArray *)tabBarItemArray
{
    return [EGTabBarManager shared].tabBarVC.EGTabBar.tabBarItems;
}

+ (EGTabBarItem *)tabBarItemWithIdx:(NSInteger)idx
{
    if (idx > [EGTabBarManager tabBarItemArray].count - 1) {
        return nil;
    }
    return (EGTabBarItem *)[EGTabBarManager tabBarItemArray][idx];
}

+ (EGTabBarItem *)selectedTabBarItem
{
    return [EGTabBarManager shared].tabBarVC.EGTabBar.selectedItem;
}

#pragma mark -- Public

- (NSUInteger (^)(NSUInteger selectedIndex))selectedIndex
{
    return ^NSUInteger (NSUInteger selectedIndex) {
        if (selectedIndex > [EGTabBarManager tabBarItemArray].count - 1) {
            return [EGTabBarManager shared].tabBarVC.selectedIndex;
        }
        [EGTabBarManager shared].tabBarVC.selectedIndex = selectedIndex;
        return selectedIndex;
    };
}

- (NSString *(^)(NSString *selectedTitle))selectedTitle
{
    return ^NSString *(NSString *selectedTitle) {
        if (!selectedTitle) {
            return [EGTabBarManager selectedTabBarItem].tabBarItem.title;
        }
        [EGTabBarManager selectedTabBarItem].tabBarItem.title = selectedTitle;
        return selectedTitle;
    };
}

- (EGTabBarManager *(^)(NSString *title, UIColor *tintColor, UIFont *font, NSUInteger idx, UIImage *image, UIImage *selectedImage))resetItem
{
    return ^EGTabBarManager *(NSString *title, UIColor *tintColor, UIFont *font, NSUInteger idx, UIImage *image, UIImage *selectedImage) {
        EGTabBarItem *tabBarItem = [EGTabBarManager tabBarItemWithIdx:idx];
        if (tabBarItem) {
            tabBarItem.tabBarItem.title = title;
            if (tintColor) {
                tabBarItem.titleLabel.textColor = tintColor;
            }
            if (font) {
                tabBarItem.titleLabel.font = font;
            }
            if (image) {
                tabBarItem.tabBarItem.image = image;
            }
            if (selectedImage) {
                tabBarItem.tabBarItem.selectedImage = selectedImage;
            }
            tabBarItem.tabBarItem.title = title;
        }
        return self;
    };
}

@end
