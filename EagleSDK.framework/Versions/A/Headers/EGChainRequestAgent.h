//
//  EGChainRequestAgent.h
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class EGChainRequest;

///  EGChainRequestAgent handles chain request management. It keeps track of all
///  the chain requests.
@interface EGChainRequestAgent : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

///  Get the shared chain request agent.
+ (EGChainRequestAgent *)sharedAgent;

///  Add a chain request.
- (void)addChainRequest:(EGChainRequest *)request;

///  Remove a previously added chain request.
- (void)removeChainRequest:(EGChainRequest *)request;

@end

NS_ASSUME_NONNULL_END
