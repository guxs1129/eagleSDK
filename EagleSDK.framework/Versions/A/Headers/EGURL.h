//
//  EGURL.h
//
//  Created by 顾新生 on 2017/11/20.
//
typedef NS_ENUM(NSInteger,EGURLScheme) {
    EGURLSchemeDefault, //"eagle"
    EGURLSchemeMedia,   //"media"
    EGURLSchemeUnknown  //unknown
};
#import <Foundation/Foundation.h>

@interface EGURL : NSObject
@property(nonatomic,assign)EGURLScheme schemeType;
@property(nonatomic,copy)NSString *scheme;
@property(nonatomic,copy)NSString *host;
@property(nonatomic,copy)NSString *path;
@property(nonatomic,strong)NSArray *pathComponents;
@property(nonatomic,strong)NSDictionary *query;
@property(nonatomic,copy)NSString *queryString;
@property(nonatomic,copy)NSString *relativePath;
@property(nonatomic,copy)NSString *absolutePath;


/** Is a hash path. */
@property(nonatomic,assign)BOOL isHashURL;
/** Value that a hash path carries. */
@property(nonatomic,copy)NSString *hashPathValue;


-(instancetype)initWithScheme:(EGURLScheme)scheme components:(NSArray *)pathComponents query:(NSDictionary *)query;
-(instancetype)initWithString:(NSString *)urlString;
-(NSString *)queryObj:(NSString *)key;
-(NSString *)moduleName;
@end
