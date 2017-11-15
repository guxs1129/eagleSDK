//
//  EGBatchRequestAgent.h
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class EGBatchRequest;

///  EGBatchRequestAgent handles batch request management. It keeps track of all
///  the batch requests.
@interface EGBatchRequestAgent : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

///  Get the shared batch request agent.
+ (EGBatchRequestAgent *)sharedAgent;

///  Add a batch request.
- (void)addBatchRequest:(EGBatchRequest *)request;

///  Remove a previously added batch request.
- (void)removeBatchRequest:(EGBatchRequest *)request;

@end

NS_ASSUME_NONNULL_END
