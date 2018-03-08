//
//  EGNetworkPrivate.h
//

#import <Foundation/Foundation.h>
#import "EGRequest.h"
#import "EGBaseRequest.h"
#import "EGBatchRequest.h"
#import "EGChainRequest.h"
#import "EGNetworkAgent.h"
#import "EGNetworkConfig.h"

NS_ASSUME_NONNULL_BEGIN

//FOUNDATION_EXPORT void EGLog(NSString *format, ...) NS_FORMAT_FUNCTION(1,2);

@class AFHTTPSessionManager;

@interface EGNetworkUtils : NSObject

+ (BOOL)validateJSON:(id)json withValidator:(id)jsonValidator;

+ (void)addDoNotBackupAttribute:(NSString *)path;

+ (NSString *)md5StringFromString:(NSString *)string;

+ (NSString *)appVersionString;

+ (NSStringEncoding)stringEncodingWithRequest:(EGBaseRequest *)request;

+ (BOOL)validateResumeData:(NSData *)data;

@end

@interface EGRequest (Getter)

- (NSString *)cacheBasePath;

@end

@interface EGBaseRequest (Setter)

@property (nonatomic, strong, readwrite) NSURLSessionTask *requestTask;
@property (nonatomic, strong, readwrite, nullable) NSData *responseData;
@property (nonatomic, strong, readwrite, nullable) id responseJSONObject;
@property (nonatomic, strong, readwrite, nullable) id responseObject;
@property (nonatomic, strong, readwrite, nullable) NSString *responseString;
@property (nonatomic, strong, readwrite, nullable) NSError *error;

@end

@interface EGBaseRequest (RequestAccessory)

- (void)toggleAccessoriesWillStartCallBack;
- (void)toggleAccessoriesWillStopCallBack;
- (void)toggleAccessoriesDidStopCallBack;

@end

@interface EGBatchRequest (RequestAccessory)

- (void)toggleAccessoriesWillStartCallBack;
- (void)toggleAccessoriesWillStopCallBack;
- (void)toggleAccessoriesDidStopCallBack;

@end

@interface EGChainRequest (RequestAccessory)

- (void)toggleAccessoriesWillStartCallBack;
- (void)toggleAccessoriesWillStopCallBack;
- (void)toggleAccessoriesDidStopCallBack;

@end

@interface EGNetworkAgent (Private)

- (AFHTTPSessionManager *)manager;
- (void)resetURLSessionManager;
- (void)resetURLSessionManagerWithConfiguration:(NSURLSessionConfiguration *)configuration;

- (NSString *)incompleteDownloadTempCacheFolder;

@end

NS_ASSUME_NONNULL_END

