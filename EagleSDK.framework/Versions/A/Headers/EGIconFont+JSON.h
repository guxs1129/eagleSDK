//
//  EGIconFont+JSON.h
//  EagleSDK
//
//  Created by 顾新生 on 27/12/2017.
//

#import <EGIconFont/EGIconFont.h>

@interface EGIconFont (JSON)
+(UIImage *)iconFontFromString:(NSString *)iconStr;
+(UIImage *)iconFontFromName:(NSString *)fontName color:(NSString *)color size:(CGFloat)size;
+(NSString *)replaceUnicodeString:(NSString *)unicodeStr;
@end
