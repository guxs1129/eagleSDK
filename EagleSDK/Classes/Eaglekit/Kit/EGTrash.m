//
//  EagleTrash.m
//  Eagle
//
//  Created by pantao on 2017/11/6.
//  Copyright © 2017年 pantao. All rights reserved.
//

#define EGTrashReturn return [self trashBlock];

#import "EGTrash.h"

@implementation EGTrash

- (EGTrashBlock)trashBlock {
    return ^(id obj) { };
}

- (EGTrashBlock)barTintColor {
    EGTrashReturn
}

- (EGTrashBlock)tintColor {
    EGTrashReturn
}

- (EGTrashBlock)titleTextAttributes {
    EGTrashReturn
}

@end
