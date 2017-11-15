//
//  EaglekitManager.m
//  Eagle
//
//  Created by pantao on 2017/11/6.
//  Copyright © 2017年 pantao. All rights reserved.
//

#define EagleRGBHex(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:1.0]

#import "EaglekitManager.h"
#import <objc/runtime.h>

// 参数类型
UIKIT_EXTERN NSString *const kEagleArgColor;
UIKIT_EXTERN NSString *const kEagleArgCGColor;
UIKIT_EXTERN NSString *const kEagleArgImage;
UIKIT_EXTERN NSString *const kEagleArgFont;
UIKIT_EXTERN NSString *const kEagleArgTextAttributes;
UIKIT_EXTERN NSString *const kEagleArgTitle;

UIKIT_EXTERN NSString *const kEagleArgBarStyle;
UIKIT_EXTERN NSString *const kEagleArgStatusBarStyle;
UIKIT_EXTERN NSString *const kEagleActivityIndicatorViewStyle;
UIKIT_EXTERN NSString *const kEagleArgKeyboardAppearance;
UIKIT_EXTERN NSString *const kEagleArgBool;

UIKIT_EXTERN NSString *const kEagleArgFloat;

// Default sakura name.
EagleName *const kEagleDefault = @"default";

// Format of config files
static NSString *const kFileExtensionJSON = @"json";
static NSString *const kFileExtensionPLIST = @"plist";
static NSString *const kFileExtensionZIP = @"zip";
// Format of image files
static NSString *const kImageExtensionPNG = @"png";
static NSString *const kImageExtensionJPG = @"jpg";

static NSString *const kEagleCurrentName = @"com.linkage.eagle.current.name";
static NSString *const kEagleCurrentType = @"com.linkage.eagle.current.type";

#pragma mark - C Function

SEL getSelectorWithPattern(const char *prefix, const char *key, const char *suffix)
{
    size_t prefixLength = prefix ? strlen(prefix) : 0;
    size_t suffixLength = suffix ? strlen(suffix) : 0;
    
    char initial = key[0];
    if (prefixLength) initial = (char)toupper(initial);
    size_t initialLength = 1;
    
    const char *rest = key + initialLength;
    size_t restLength = strlen(rest);
    
    char selector[prefixLength + initialLength + restLength + suffixLength + 1];
    memcpy(selector, prefix, prefixLength);
    selector[prefixLength] = initial;
    memcpy(selector + prefixLength + initialLength, rest, restLength);
    memcpy(selector + prefixLength + initialLength + restLength, suffix, suffixLength);
    selector[prefixLength + initialLength + restLength + suffixLength] = '\0';
    
    return sel_registerName(selector);
}

@implementation EaglekitManager

/** Resources Path */
static NSString *_resourcesPath;
/** Configs file of resources */
static NSString *_configsFilePath;
/** Bundle or Sandbox */
static EagleType _currentEagleType;
/** Share instance */
static EaglekitManager *_manager;
/** Current name of sakura  */
static EagleName *_currentEagleName;

- (instancetype)init
{
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Please use + manager: method instead." userInfo:nil];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [super allocWithZone:zone];
    });
    return _manager;
}

+ (instancetype)manager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[self alloc] init];
    });
    return _manager;
}

+ (BOOL)shiftEagleWithName:(EagleName *)name type:(EagleType)type {
    if (name &&
        [name isEqualToString:_currentEagleName]) return NO;
    if (!name) name = kEagleDefault;
    switch (type) {
        case EagleTypeMainBundle:
            _resourcesPath = nil;
            _configsFilePath = [self eagle_getEagleConfigsFileBundlePathWithName:name];
            break;
        case EagleTypeSandbox:{
            _resourcesPath = [self eagle_getEagleResourceSandboxPathWithName:name];
            _configsFilePath = [self eagle_tryGetEagleConfigsFileSandboxPathWithName:name];
            if (!_configsFilePath.length && _resourcesPath.length) {
                _configsFilePath = [self eagle_getEagleConfigsFileBundlePathWithName:kEagleDefault];
            }
        }
            break;
        default:
            break;
    }
    
    if (_configsFilePath.length) {
        [self saveCurrentSakuraInfosWithName:name type:type];
        [[NSNotificationCenter defaultCenter] postNotificationName:EagleSkinChangeNotification object:nil];
        return YES;
    }
#ifdef DEBUG
    else {
        NSLog(@"resources not exists!");
    }
    NSLog(@"%@", _configsFilePath);
#endif
    return NO;
}

+ (void)saveCurrentSakuraInfosWithName:(EagleName *)name type:(EagleType)type
{
    _currentEagleName = name;
    _currentEagleType = type;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:_currentEagleName forKey:kEagleCurrentName];
    [userDefaults setObject:@(_currentEagleType) forKey:kEagleCurrentType];
    [userDefaults synchronize];
}

+ (EagleName *)getEagleCurrentName
{
    if (_currentEagleName && _currentEagleName.length) {
        return _currentEagleName;
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    EagleName *currentEagleName = [userDefaults objectForKey:kEagleCurrentName];
    return currentEagleName;
}

+ (EagleType)getEagleCurrentType
{
    if (_currentEagleType) {
        return _currentEagleType;
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    EagleType currentEagleType = [[userDefaults objectForKey:kEagleCurrentType] integerValue];
    return currentEagleType;
}

#pragma mark - Fetch Resource

+ (NSDictionary *)getEagleConfigsFileData
{
    NSDictionary *configsFile = [NSDictionary dictionaryWithContentsOfFile:_configsFilePath];
    if (!configsFile && _configsFilePath) {
        NSData *data = [NSData dataWithContentsOfFile:_configsFilePath];
        if (!data) return nil;
        configsFile = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
#ifdef DEBUG
        if (!configsFile) {
            NSLog(@"Maybe an error: %@ file content format!",[_configsFilePath lastPathComponent]);
        }
#endif
    }
    if (![configsFile isKindOfClass:[NSDictionary class]]) return nil;
    return configsFile;
}


@end

#pragma mark -- EagleDownload

static NSString *kEagleDiretoryName = @"com.linkage.eagle";

@implementation EaglekitManager(EagleDownload)

+ (NSString *)_getLibraryPath
{
    return NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject;
}

+ (NSString *)eagle_getEagleDirectoryPath
{
    NSString *libraryPath = [self _getLibraryPath];
    NSString *path = [libraryPath stringByAppendingPathComponent:kEagleDiretoryName];
    return path;
}

+ (NSString *)eagle_getEagleSandboxPathWithName:(NSString *)name
{
    NSString *sakurasDirectoryPath = [self eagle_getEagleDirectoryPath];
    NSString *savePath = [sakurasDirectoryPath stringByAppendingPathComponent:name];
    return savePath;
}

+ (NSString *)eagle_getEagleResourceSandboxPathWithName:(NSString *)eagleName
{
    if (!eagleName) return nil;
    NSString *fileFolder = [eagleName stringByDeletingPathExtension];
    NSString *savePath = [self eagle_getEagleSandboxPathWithName:fileFolder];
    return savePath;
}

+ (NSString *)eagle_getEagleConfigsFileBundlePathWithName:(NSString *)eagleName
{
    NSString *configsFilepath = [[NSBundle mainBundle] pathForResource:eagleName ofType:kFileExtensionPLIST];
    if (!configsFilepath) {
        configsFilepath = [[NSBundle mainBundle] pathForResource:eagleName ofType:kFileExtensionJSON];
    }
    return configsFilepath;
}


+ (NSString *)_filePathWithName:(NSString *)configsName type:(NSString *)type
{
    NSString *configsFullName = [configsName stringByAppendingPathExtension:type];
    NSString *configFilePath = [[self eagle_getEagleResourceSandboxPathWithName:configsName] stringByAppendingPathComponent:configsFullName];
    return configFilePath;
}

+ (BOOL)_fileExistsAtPath:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:filePath];
}

+ (NSString *)eagle_tryGetEagleConfigsFileSandboxPathWithName:(NSString *)eagleName
{
    if (!eagleName) return nil;
    NSString *configsFilePath = [self _filePathWithName:eagleName type:kFileExtensionJSON];
    if (![self _fileExistsAtPath:configsFilePath]) {
        configsFilePath = [self _filePathWithName:eagleName type:kFileExtensionPLIST];
        if (![self _fileExistsAtPath:configsFilePath]) return nil;
    }
    return configsFilePath;
}

@end

#pragma mark -- Eaglekitlization

@implementation EaglekitManager(Eaglekitlization)

+ (NSDictionary *)eagle_getObjVectorOperationKV
{
    return @{
             kEagleArgColor:@"eagle_colorWithPath:",
             kEagleArgCGColor:@"eagle_cgColorWithPath:",
             kEagleArgImage:@"eagle_imageWithPath:",
             kEagleArgFont:@"eagle_fontWithPath:",
             kEagleArgTextAttributes:@"eagle_titleTextAttributesDictionaryWithPath:",
             kEagleArgTitle:@"eagle_stringWithPath:"
             };
}

+ (NSDictionary *)eagle_getIntVectorOperationKV
{
    return @{
             kEagleArgBarStyle:@"eagle_barStyleWithPath:",
             kEagleArgStatusBarStyle:@"eagle_statusBarStyleWithPath:",
             kEagleActivityIndicatorViewStyle:@"eagle_activityIndicatorStyleWithPath:",
             kEagleArgKeyboardAppearance:@"eagle_keyboardAppearanceWithPath:",
             kEagleArgBool:@"eagle_boolWithPath:"
             };
}

+ (NSDictionary *)eagle_getFloatVectorOperationKV
{
    return @{
             kEagleArgFloat:@"eagle_floatWithPath:"
             };
}

+ (CGFloat)eagle_floatWithPath:(NSString *)path
{
    NSString *valueStr = [[self getEagleConfigsFileData] valueForKeyPath:path];
    return [valueStr floatValue];
}

+ (UIColor *)eagle_colorWithPath:(NSString *)path
{
    NSString *colorHexStr = [[self getEagleConfigsFileData] valueForKeyPath:path];
    if (!colorHexStr) return nil;
    return [self eagle_colorFromString:colorHexStr];
}

+ (CGColorRef)eagle_cgColorWithPath:(NSString *)path
{
    UIColor *rgbColor = [self eagle_colorWithPath:path];
    return rgbColor.CGColor;
}

+ (NSString *)eagle_stringWithPath:(NSString *)path
{
    return [[self getEagleConfigsFileData] valueForKeyPath:path];
}

+ (UIFont *)eagle_fontWithPath:(NSString *)path {
    CGFloat fontSize = [self eagle_floatWithPath:path];
    if (!fontSize) return nil;
    return [UIFont systemFontOfSize:fontSize];
}

+ (UIKeyboardAppearance)eagle_keyboardAppearanceWithPath:(NSString *)path
{
    NSString *kbAppearance = [self eagle_stringWithPath:path];
    
    if ([kbAppearance isKindOfClass:[NSNumber class]]) {
        return [self _enumValueWith:(NSNumber *)kbAppearance];
    }
    if (![kbAppearance isKindOfClass:[NSString class]]) return UIKeyboardAppearanceDefault;
    
    if ([kbAppearance isEqualToString:@"UIKeyboardAppearanceLight"]) {
        return UIKeyboardAppearanceLight;
    }else if ([kbAppearance isEqualToString:@"UIKeyboardAppearanceDark"]) {
        return UIKeyboardAppearanceDark;
    }else {
        return UIKeyboardAppearanceDefault;
    }
}

+ (NSDictionary *)eagle_origDictionaryWithPath:(NSString *)path
{
    return [[self getEagleConfigsFileData] valueForKeyPath:path];
}

+ (NSDictionary *)eagle_titleTextAttributesDictionaryWithPath:(NSString *)path
{
    NSDictionary *origDict = [self eagle_origDictionaryWithPath:path];
    NSMutableDictionary *factDict = [NSMutableDictionary dictionary];
    // 暂时只支持两种类型（Welcome PR ！）
    [origDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([key isEqualToString:@"NSForegroundColorAttributeName"]) {
            UIColor *color = [self eagle_colorFromString:(NSString *)obj];
            [factDict setObject:color forKey:NSForegroundColorAttributeName];
        }else if ([key isEqualToString:@"NSFontAttributeName"]) {
            CGFloat fontValue = [obj floatValue];
            UIFont *font = [UIFont systemFontOfSize:fontValue];
            [factDict setObject:font forKey:NSFontAttributeName];
        }else {}
    }];
    return factDict;
}

+ (BOOL)eagle_boolWithPath:(NSString *)path
{
    return [[[self getEagleConfigsFileData] valueForKeyPath:path] boolValue];
}

+ (UIImage *)eagle_imageWithPath:(NSString *)path
{
    NSString *imageName = [self eagle_stringWithPath:path];
    UIImage *image = nil;
    if (imageName && imageName.length) {
        if (_currentEagleType == EagleTypeMainBundle) {
            image = [UIImage imageNamed:imageName];
        }else if (_currentEagleType == EagleTypeSandbox) {
            image = [self _getImagePathWithImageName:imageName fileType:kImageExtensionPNG];
            if (!image) {
                image = [self _getImagePathWithImageName:imageName fileType:kImageExtensionJPG];
            }
        }
    }
    if (image) return image;
    return [self _searchImageWithPath:path];
}

+ (UIActivityIndicatorViewStyle)eagle_activityIndicatorStyleWithPath:(NSString *)path
{
    NSString *activityIndicatorStyle = [self eagle_stringWithPath:path];
    
    if ([activityIndicatorStyle isKindOfClass:[NSNumber class]]) {
        return [self _enumValueWith:(NSNumber *)activityIndicatorStyle];
    }
    if (![activityIndicatorStyle isKindOfClass:[NSString class]]) return UIActivityIndicatorViewStyleWhite;
    
    if ([activityIndicatorStyle isEqualToString:@"UIActivityIndicatorViewStyleWhiteLarge"]) {
        return UIActivityIndicatorViewStyleWhiteLarge;
    }else if ([activityIndicatorStyle isEqualToString:@"UIActivityIndicatorViewStyleGray"]) {
        return UIActivityIndicatorViewStyleGray;
    }else {
        return UIActivityIndicatorViewStyleWhite;
    }
}

+ (UIBarStyle)eagle_barStyleWithPath:(NSString *)path
{
    NSString *barStyle = [self eagle_stringWithPath:path];
    if ([barStyle isKindOfClass:[NSNumber class]]) {
        return [self _enumValueWith:(NSNumber *)barStyle];
    }
    if (![barStyle isKindOfClass:[NSString class]]) return UIBarStyleDefault;
    
    if ([barStyle isEqualToString:@"UIBarStyleBlack"]) {
        return UIBarStyleBlack;
    }else {
        return UIBarStyleDefault;
    }
}

// Private
+ (NSUInteger)_enumValueWith:(NSNumber *)number
{
    return [number unsignedIntegerValue];
}

+ (UIImage *)_getImagePathWithImageName:(NSString *)imageName fileType:(NSString *)fileType
{
    NSString *imagePath = [_resourcesPath stringByAppendingPathComponent:[imageName stringByAppendingPathExtension:fileType]];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    return image;
}

/** searching local resouces */
+ (UIImage *)_searchImageWithPath:(NSString *)path
{
    NSArray *components = [path componentsSeparatedByString:@"."];
    NSString *component = [components lastObject];
    
    if ((component && [component isEqualToString:kImageExtensionPNG]) ||
        [component isEqualToString:kImageExtensionJPG]) {
        component = path;
    }
    
    if (component) {
        UIImage *localImage = [UIImage imageNamed:component];
        return localImage;
    }
    return nil;
}

+ (UIStatusBarStyle)eagle_statusBarStyleWithPath:(NSString *_Nullable)path
{
    NSString *stateStr = [self eagle_stringWithPath:path];
    if ([stateStr isKindOfClass:[NSNumber class]]) {
        return [self _enumValueWith:(NSNumber *)stateStr];
    }
    if (![stateStr isKindOfClass:[NSString class]]) return UIStatusBarStyleDefault;
    
    if ([stateStr isEqualToString:@"UIStatusBarStyleLightContent"]) {
        return UIStatusBarStyleLightContent;
    }else {
        return UIStatusBarStyleDefault;
    }
}

@end

#pragma mark -- EaglekitTool

@implementation EaglekitManager(EaglekitTool)

+ (UIColor*)eagle_colorFromString:(NSString*)hexStr
{
    hexStr = [hexStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if([hexStr hasPrefix:@"0x"]) {
        hexStr = [hexStr substringFromIndex:2];
    }
    if([hexStr hasPrefix:@"#"]) {
        hexStr = [hexStr substringFromIndex:1];
    }
    
    NSUInteger hex = [self _intFromHexString:hexStr];
    if(hexStr.length > 6) {
        return EagleRGBHex(hex);
    }
    return EagleRGBHex(hex);
}

// - Private
+ (NSUInteger)_intFromHexString:(NSString *)hexStr
{
    unsigned int hexInt = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexStr];
    [scanner scanHexInt:&hexInt];
    return hexInt;
}

@end
