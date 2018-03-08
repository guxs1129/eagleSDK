#import "UIImage+EGIconFont.h"
#import "EGIconInfo.h"

#define EGIconInfoMake(text, imageSize, imageColor) [EGIconInfo iconInfoWithText:text size:imageSize color:imageColor]

@interface NSBundle (EGIconFontExtension)
+ (NSBundle *)EGIconFontBundle;
@end

@interface EGIconFont : NSObject

+ (UIFont *)fontWithSize: (CGFloat)size;
+ (void)setFontName:(NSString *)fontName;

@end
