//
//  EGBatchRequest.h
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class EGRequest;
@class EGBatchRequest;
@protocol EGRequestAccessory;

///  The EGBatchRequestDelegate protocol defines several optional methods you can use
///  to receive network-related messages. All the delegate methods will be called
///  on the main queue. Note the delegate methods will be called when all the requests
///  of batch request finishes.
@protocol EGBatchRequestDelegate <NSObject>

@optional
///  Tell the delegate that the batch request has finished successfully/
///
///  @param batchRequest The corresponding batch request.
- (void)batchRequestFinished:(EGBatchRequest *)batchRequest;

///  Tell the delegate that the batch request has failed.
///
///  @param batchRequest The corresponding batch request.
- (void)batchRequestFailed:(EGBatchRequest *)batchRequest;

@end

///  EGBatchRequest can be used to batch several EGRequest. Note that when used inside EGBatchRequest, a single
///  EGRequest will have its own callback and delegate cleared, in favor of the batch request callback.
@interface EGBatchRequest : NSObject

///  All the requests are stored in this array.
@property (nonatomic, strong, readonly) NSArray<EGRequest *> *requestArray;

///  The delegate object of the batch request. Default is nil.
@property (nonatomic, weak, nullable) id<EGBatchRequestDelegate> delegate;

///  The success callback. Note this will be called only if all the requests are finished.
///  This block will be called on the main queue.
@property (nonatomic, copy, nullable) void (^successCompletionBlock)(EGBatchRequest *);

///  The failure callback. Note this will be called if one of the requests fails.
///  This block will be called on the main queue.
@property (nonatomic, copy, nullable) void (^failureCompletionBlock)(EGBatchRequest *);

///  Tag can be used to identify batch request. Default value is 0.
@property (nonatomic) NSInteger tag;

///  This can be used to add several accossories object. Note if you use `addAccessory` to add acceesory
///  this array will be automatically created. Default is nil.
@property (nonatomic, strong, nullable) NSMutableArray<id<EGRequestAccessory>> *requestAccessories;

///  The first request that failed (and causing the batch request to fail).
@property (nonatomic, strong, readonly, nullable) EGRequest *failedRequest;

///  Creates a `EGBatchRequest` with a bunch of requests.
///
///  @param requestArray requests useds to create batch request.
///
- (instancetype)initWithRequestArray:(NSArray<EGRequest *> *)requestArray;

///  Set completion callbacks
- (void)setCompletionBlockWithSuccess:(nullable void (^)(EGBatchRequest *batchRequest))success
                              failure:(nullable void (^)(EGBatchRequest *batchRequest))failure;

///  Nil out both success and failure callback blocks.
- (void)clearCompletionBlock;

///  Convenience method to add request accessory. See also `requestAccessories`.
- (void)addAccessory:(id<EGRequestAccessory>)accessory;

///  Append all the requests to queue.
- (void)start;

///  Stop all the requests of the batch request.
- (void)stop;

///  Convenience method to start the batch request with block callbacks.
- (void)startWithCompletionBlockWithSuccess:(nullable void (^)(EGBatchRequest *batchRequest))success
                                    failure:(nullable void (^)(EGBatchRequest *batchRequest))failure;

///  Whether all response data is from local cache.
- (BOOL)isDataFromCache;

@end

NS_ASSUME_NONNULL_END
