//
//  RouterManager+Blocks.h
//  Eagle
//
//  Created by pantao on 2017/10/31.
//  Copyright © 2017年 pantao. All rights reserved.
//

#import "RouterManager.h"

typedef NS_ENUM(NSInteger, RouterType)
{
    RouterUnkown,           // 未知类型
    RouterEagle,            // eagle内部native跳转
    RouterHtml,             // H5跳转
    RouterRN,               // react-native跳转
    RouterOnlineFile,       // 在线pdf、doc等预览
    RouterLocalFile,        // 本地文件
    RouterTel               // 电话
};

typedef id (^EagleRouterBlock)(NSDictionary *dict);

@interface RouterManager (Blocks)

- (EagleRouterBlock)openEagle;
- (EagleRouterBlock)openHtml;
- (EagleRouterBlock)openRN;
- (EagleRouterBlock)openOnlineFile;
- (EagleRouterBlock)openLocalFile;
- (EagleRouterBlock)openTel;

@end
