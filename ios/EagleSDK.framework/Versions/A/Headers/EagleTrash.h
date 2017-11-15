//
//  EagleTrash.h
//  Eagle
//
//  Created by pantao on 2017/11/6.
//  Copyright © 2017年 pantao. All rights reserved.
//  针对不支持的 Eaglekit 类型进行响应，如：UIAppearance 等类。

#import "Eaglekit.h"

typedef void(^EagleTrashBlock)(id);

@interface EagleTrash : Eaglekit

- (EagleTrashBlock)barTintColor;
- (EagleTrashBlock)tintColor;
- (EagleTrashBlock)titleTextAttributes;

@end
