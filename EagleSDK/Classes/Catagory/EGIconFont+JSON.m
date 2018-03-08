//
//  EGIconFont+JSON.m
//  EagleSDK
//
//  Created by 顾新生 on 27/12/2017.
//

#import "EGIconFont+JSON.h"
#define ICONFONT_SCHEME @"iconfont://"
#define ICONFONT_PREFIX @"iconfont"

@implementation EGIconFont (JSON)
+(UIImage *)iconFontFromName:(NSString *)fontName color:(NSString *)color size:(CGFloat)size{
    UIImage *image=nil;
    if (!color||color.length==0) {
        color=@"#666666";
    }
    NSString *targetName=[self replaceUnicodeString:[fontName stringByReplacingOccurrencesOfString:@"0x" withString:@"\\U"]];
    UIColor *fontColor=[UIColor eg_colorWithHexString:color];
    image=[UIImage iconWithInfo:EGIconInfoMake(targetName, size, fontColor)];
    return image;
}

+(UIImage *)iconFontFromString:(NSString *)iconStr{
    UIImage *image=nil;
    NSString *iconU=[iconStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    //scheme check
    if(![iconU hasPrefix:ICONFONT_SCHEME]){
        @throw [NSException exceptionWithName:@"<EGIconFont Error>" reason:@"String must have iconfont:// prefix." userInfo:nil];
    }
    NSArray *arr=[[[iconU componentsSeparatedByString:ICONFONT_SCHEME]lastObject]componentsSeparatedByString:@"/"];
    if(arr.count!=3){
        @throw [NSException exceptionWithName:@"<EGIconFont Error>" reason:@"Path parameters must be in :fontUnicode/:fontSize/:fontColor pattern." userInfo:nil];
    }

    //font convert
    NSString *fontName=[self replaceUnicodeString:[[arr firstObject] stringByReplacingOccurrencesOfString:@"&#x" withString:@"\\U"]];
    
    //font size
    NSRegularExpression *numRe=[NSRegularExpression regularExpressionWithPattern:@"^\\+?[1-9][0-9]*$" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *sizeStr=[arr objectAtIndex:1];
    NSInteger fontSize=-1;
    NSArray *sizeResult=[numRe matchesInString:sizeStr options:NSMatchingReportProgress range:NSMakeRange(0, sizeStr.length)];
    if(sizeResult==nil || sizeResult.count==0 || sizeResult.count>1){
        @throw [NSException exceptionWithName:@"<EGIconFont Error>" reason:[NSString stringWithFormat:@"Icon size:(%@) is invalid.",sizeStr] userInfo:nil];
    }else{
        fontSize=[sizeStr integerValue];
    }
    
    //font color
    NSRegularExpression *colorRe=[NSRegularExpression regularExpressionWithPattern:@"[0-9a-fA-F]{6}" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *colorStr=[arr objectAtIndex:2];
    UIColor *fontColor=nil;
    NSArray *colorResult=[colorRe matchesInString:colorStr options:NSMatchingReportProgress range:NSMakeRange(0, colorStr.length)];
    if(colorResult.count>1){
        @throw [NSException exceptionWithName:@"<EGIconFont Error>" reason:[NSString stringWithFormat:@"Icon color:(%@) is invalid.",colorStr] userInfo:nil];
    }else if (colorResult==nil || colorResult.count==0 ){
        SEL colSel=NSSelectorFromString(colorStr);
        if([UIColor respondsToSelector:colSel]){
            fontColor=[UIColor performSelector:colSel];
        }
    }else{
        fontColor=[UIColor eg_colorWithHexString:[NSString stringWithFormat:@"#%@",colorStr]];
    }
    if(fontColor==nil){
        @throw [NSException exceptionWithName:@"<EGIconFont Error>" reason:[NSString stringWithFormat:@"Icon color:(%@) is invalid.",colorStr] userInfo:nil];
    }
    
    //rendor to image
    if(fontName!=nil && fontName.length>0 && fontSize>=0 && fontColor!=nil){
        [self setFontName:ICONFONT_PREFIX];
        image=[UIImage iconWithInfo:EGIconInfoMake(fontName, fontSize, fontColor)];
    }
    
    return image;
}


/**
 Unicode Convert

 @param unicodeStr unicode string
 @return convert result
 */
+(NSString *)replaceUnicodeString:(NSString *)unicodeStr{
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    return [NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListImmutable format:nil error:nil];
}
@end
