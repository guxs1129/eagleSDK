//
//  Eagle_ macros.h
//  Eagle
//
//  Created by 潘涛 on 2017/10/23.
//  Copyright © 2017年 pantao. All rights reserved.
//

#ifndef Eagle__macros_h
#define Eagle__macros_h

/**********************************LOG*****************************************/
#ifdef DEBUG  //调试阶段
#define EagleLog(...)  NSLog(__VA_ARGS__)
#else //发布阶段
#define EagleLog(...)
#endif
/**********************************LOG*****************************************/

/**********************************weak、strong*****************************************/
#define weakify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
autoreleasepool{} __weak __typeof__(x) __weak_##x##__ = x; \
_Pragma("clang diagnostic pop")

#define strongify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
try{} @finally{} __typeof__(x) x = __weak_##x##__; \
_Pragma("clang diagnostic pop")
/**********************************weak、strong*****************************************/

/**********************************EGSize*****************************************/
struct EGSize {
    BOOL usePercent;// YES -- 使用百分比布局，反之使用固定值布局
    CGFloat horizontal;
    CGFloat vertical;
    CGFloat width;
    CGFloat height;
};
typedef struct CG_BOXABLE EGSize EGSize;

//CG_EXTERN const CGSize EGSizeZero
//CG_AVAILABLE_STARTING(__MAC_10_0, __IPHONE_2_0);

CG_INLINE EGSize EGSizeMake(BOOL usePercent,
                              CGFloat horizontal,
                              CGFloat vertical,
                              CGFloat width,
                              CGFloat height);

CG_INLINE EGSize
EGSizeMake(BOOL usePercent,
           CGFloat horizontal,
           CGFloat vertical,
           CGFloat width,
           CGFloat height)
{
    EGSize size; size.usePercent = usePercent; size.horizontal = horizontal; size.vertical = vertical; size.width = width; size.height = height; return size;
}
/**********************************EGSize*****************************************/

/**********************************random*****************************************/
#define random(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]
#define randomColor random(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))
/**********************************random*****************************************/

#endif /* Eagle__macros_h */
