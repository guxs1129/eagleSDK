//
//  EagleTrash.m
//  Eagle
//
//  Created by pantao on 2017/11/6.
//  Copyright © 2017年 pantao. All rights reserved.
//

#define EagleTrashReturn return [self trashBlock];

#import "EagleTrash.h"

@implementation EagleTrash

- (EagleTrashBlock)trashBlock {
    return ^(id obj) { };
}

- (EagleTrashBlock)barTintColor {
    EagleTrashReturn
}

- (EagleTrashBlock)tintColor {
    EagleTrashReturn
}

- (EagleTrashBlock)titleTextAttributes {
    EagleTrashReturn
}

@end
