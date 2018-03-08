    //
    //  EGComponentJsonParser.m
    //  EagleSDK
    //
    //  Created by 顾新生 on 21/12/2017.
    //
const NSArray *__flex;
#define _get_flex_ (__flex == nil ? __flex = [[NSArray alloc] initWithObjects:\
@"FlexCloum",\
@"FlexRow",nil] : __flex)
#define FLEX_ENUM(string) ([_get_flex_ indexOfObject:string])

#import "EGComponentJsonParser.h"
@interface EGComponentJsonParser()

@end
@implementation EGComponentJsonParser

+(EGComponentDesc)parseWithDict:(NSDictionary *)dict{
    EGComponentDesc component={@"",EGSizeMake(NO, 0, 0, 0, 0),FlexCloum,@"",nil};;

        // classname
    id className=[dict.allKeys firstObject];
    component.className=[self getStrValue:className];
    
    NSDictionary *params=[dict objectForKey:className];
    
        //eg_id
    id eg_id=[params valueForKey:@"eg_id"];
    if(eg_id==nil){
        @throw [NSException exceptionWithName:@"<JSON Build Parse Error>" reason:@"Component must have an eg_id." userInfo:nil];
    }
    component.eg_id=[self getStrValue:eg_id];
    
        //dataSource
    id dataSource=[params valueForKeyPath:@"dataSource"];
    component.dataSource=dataSource;
    
        //flex
    id flexStr=[params valueForKeyPath:@"flex"];
    Flex flex=FLEX_ENUM([self getStrValue:flexStr]);
    component.flex=flex;
    
        //size
    id cSize=[params valueForKeyPath:@"size"];
    if (![cSize isKindOfClass:[NSNull class]]) {
            //usepercent
        id usePercent=[params valueForKeyPath:@"size.usePercent"];
        [self setBoolValue:usePercent forKey:&component.size.usePercent];
        
            //horizontal
        id horizontal=[params valueForKeyPath:@"size.horizontal"];
        [self setFloatValue:horizontal forKey:&component.size.horizontal];
        
            //vertical
        id vertical=[params valueForKeyPath:@"size.vertical"];
        [self setFloatValue:vertical forKey:&component.size.vertical];
        
            //width
        id isWidthFull=[params valueForKeyPath:@"size.width-full"];
        if (![isWidthFull isKindOfClass:[NSNull class]] && [isWidthFull boolValue]) {
            [self setFloatValue:@(kScreenWidth) forKey:&component.size.width];
        }else{
            id width=[params valueForKeyPath:@"size.width"];
            [self setFloatValue:width forKey:&component.size.width];
        }
        
            //height
        id isHeightFull=[params valueForKeyPath:@"size.height-full"];
        if (![isHeightFull isKindOfClass:[NSNull class]] && [isHeightFull boolValue]) {
            [self setFloatValue:@(kScreenHeight) forKey:&component.size.height];
        }else{
            id height=[params valueForKeyPath:@"size.height"];
            [self setFloatValue:height forKey:&component.size.height];
        }
    }
    return component;
}

+(NSString *)getStrValue:(id)value{
    if (![value isKindOfClass:[NSNull class]] && [value isKindOfClass:[NSString class]]) {
        return value;
    }
    return @"";
}

+(void)setBoolValue:(id)value forKey:(BOOL *)key{
    if (![value isKindOfClass:[NSNull class]]) {
        * key = [value boolValue];
    }
}
+(void)setFloatValue:(id)value forKey:(CGFloat *)key{
    if (![value isKindOfClass:[NSNull class]]) {
        * key = [value floatValue];
    }
}
@end
