#import "EGIconFont.h"
#import <CoreText/CoreText.h>

@implementation NSBundle (EGIconFontExtension)

+ (NSBundle *)EGIconFontBundle
{
    static NSBundle *searchBundle = nil;
    if (nil == searchBundle) {
        //Default use `[NSBundle mainBundle]`.
        searchBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"EGIconFont" ofType:@"bundle"]];
        /**
         If you use pod import and configure `use_frameworks` in Podfile, [NSBundle mainBundle] does not load the `PYSearch.fundle` resource file in `PYSearch.framework`.
         */
        if (nil == searchBundle) { // Empty description resource file in `PYSearch.framework`.
            searchBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[EGIconFont class]] pathForResource:@"EGIconFont" ofType:@"bundle"]];
        }
    }
    return searchBundle;
}

@end

@implementation EGIconFont

static NSString *_fontName;

+ (void)registerFontWithURL:(NSURL *)url {
    NSAssert([[NSFileManager defaultManager] fileExistsAtPath:[url path]], @"Font file doesn't exist");
    CGDataProviderRef fontDataProvider = CGDataProviderCreateWithURL((__bridge CFURLRef)url);
    CGFontRef newFont = CGFontCreateWithDataProvider(fontDataProvider);
    CGDataProviderRelease(fontDataProvider);
    CTFontManagerRegisterGraphicsFont(newFont, nil);
    CGFontRelease(newFont);
}

+ (UIFont *)fontWithSize:(CGFloat)size {
    UIFont *font = [UIFont fontWithName:[self fontName] size:size];
    if (font == nil) {
        NSURL *fontFileUrl = [[NSBundle EGIconFontBundle] URLForResource:[self fontName] withExtension:@"ttf"];
        [self registerFontWithURL: fontFileUrl];
        font = [UIFont fontWithName:[self fontName] size:size];
        NSAssert(font, @"UIFont object should not be nil, check if the font file is added to the application bundle and you're using the correct font name.");
    }
    return font;
}


+ (void)setFontName:(NSString *)fontName {
    _fontName = fontName;
    
}

+ (NSString *)fontName {
    return _fontName ? : @"iconfont";
}

@end
