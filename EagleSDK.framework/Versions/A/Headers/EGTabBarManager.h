//
//  EGTabBarManager.h
//  AFNetworking
//
//  Created by pantao on 2017/11/16.
//

#import <Foundation/Foundation.h>
#import "EGTabBarController.h"

@interface EGTabBarManager : NSObject

+ (instancetype)shared;

/**
 EGTabBarController
 */
@property (nonatomic, strong) EGTabBarController *tabBarVC;

/**
 被选中下标
 */
- (NSUInteger (^)(NSUInteger selectedIndex))selectedIndex;

/**
 当前选中的tabBarItem的title
 */
- (NSString *(^)(NSString *selectedTitle))selectedTitle;

/**
 重置指定下标的tabBarItem
 */
- (EGTabBarManager *(^)(NSString *title, UIColor *tintColor, UIFont *font, NSUInteger idx, UIImage *image, UIImage *selectedImage))resetItem;

@end
