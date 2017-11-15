//
//  EGNetworkAgent.h
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class EGBaseRequest;

///  EGNetworkAgent is the underlying class that handles actual request generation,
///  serialization and response handling.
@interface EGNetworkAgent : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

///  Get the shared agent.
+ (EGNetworkAgent *)sharedAgent;

///  Add request to session and start it.
- (void)addRequest:(EGBaseRequest *)request;

///  Cancel a request that was previously added.
- (void)cancelRequest:(EGBaseRequest *)request;

///  Cancel all requests that were previously added.
- (void)cancelAllRequests;

///  Return the constructed URL of request.
///
///  @param request The request to parse. Should not be nil.
///
///  @return The result URL.
- (NSString *)buildRequestUrl:(EGBaseRequest *)request;

@end

NS_ASSUME_NONNULL_END
