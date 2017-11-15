//
//  RouterManager.h
//  Eagle
//
//  Created by pantao on 2017/10/30.
//  Copyright © 2017年 pantao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface RouterManager : NSObject

@property (nonatomic, strong) NSMutableDictionary *eagleMap;

+ (instancetype)shared;
+ (void)navigateTo:(NSString *)router;
+ (NSString *)filterRoute:(NSString *)route;
- (UIViewController *)topViewController;

@end
