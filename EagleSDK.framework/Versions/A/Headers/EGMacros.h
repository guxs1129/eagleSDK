//
//  Eagle_ macros.h
//  Eagle
//
//  Created by 潘涛 on 2017/10/23.
//  Copyright © 2017年 pantao. All rights reserved.
//

#ifndef EGMacros_h
#define EGMacros_h

/**********************************extern*****************************************/
#ifndef EG_EXTERN
#define EG_EXTERN extern
#endif
/**********************************LOG*****************************************/
#ifdef DEBUG  //调试阶段
#define EGLog(...)  NSLog(__VA_ARGS__)
#else //发布阶段
#define EGLog(...)
#endif
/**********************************LOG*****************************************/

/**********************************weak、strong*****************************************/
#define eg_weakify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
autoreleasepool{} __weak __typeof__(x) __weak_##x##__ = x; \
_Pragma("clang diagnostic pop")

#define eg_strongify( x ) \
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

// UIScreen width.
#define kScreenWidth          [UIScreen mainScreen].bounds.size.width
// UIScreen height.
#define kScreenHeight         [UIScreen mainScreen].bounds.size.height
// iPhone X
#define kIPhoneX              (kScreenWidth == 375.f && kScreenHeight == 812.f ? YES : NO)
// Status bar height.
#define kStatusBarHeight      (kIPhoneX ? 44.f : 20.f)
// navigation bar height.
#define kNavigationHeight     44.f

#pragma mark -- framework bundle
#define IB_Resource_Bundle(x)   [NSBundle bundleWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:(x) ofType:@"bundle"]]

#pragma mark -- IPhoneX
#define IS_IPHONEX  (CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(812, 375))||CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(375, 812)))

#endif /* EGMacros_h */
