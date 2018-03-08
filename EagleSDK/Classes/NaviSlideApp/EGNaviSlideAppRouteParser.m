//
//  EGNaviSlideAppRouteParser.m
//  AFNetworking
//
//  Created by 顾新生 on 2017/11/20.
//

#import "EGNaviSlideAppRouteParser.h"

@implementation EGNaviSlideAppRouteParser
NSString * const EGURLParseException    =@"EGURLParseException";

NSString * const HOME_VC                =@"home_vc";
NSString * const HOME_TITLE             =@"home_title";

NSString * const LEFT_VC                =@"left_vc";
NSString * const LEFT_TITLE             =@"left_title";
NSString * const LEFT_IMAGE             =@"left_img";
NSString * const LEFT_IMAGE_COLOR             =@"left_color";

NSString * const LEFT_SELECTED_IMAGE    =@"left_selectedImg";
NSString * const LEFT_IMAGE_SELECTED_COLOR             =@"left_selectedColor";

NSString * const RIGHT_VC               =@"right_vc";
NSString * const RIGHT_TITLE            =@"right_title";
NSString * const RIGHT_IMAGE            =@"right_img";
NSString * const RIGHT_SELECTED_IMAGE   =@"right_selectedImg";
NSString * const RIGHT_IMAGE_COLOR             =@"right_color";
NSString * const RIGHT_IMAGE_SELECTED_COLOR             =@"right_selectedColor";

+(EGURL *)parse:(NSArray *)routes{
    id route=[routes firstObject];
    EGURL *url=nil;
    if ([route isKindOfClass:[NSString class]]) {

        url=[[EGURL alloc]initWithString:route];
//        EGURL *url2=[[EGURL alloc]initWithScheme:EGURLSchemeDefault components:@[@"vc",@"hello"] query:@{@"item":@"首页",@"left":@"U",@"right":@"S"}];
        if (url.scheme==nil||url.host==nil) {
            @throw [NSException exceptionWithName:EGURLParseException reason:@"Illegal router passed." userInfo:nil];
        }
    }
    return url;
}
@end
