//
//  EGChainRequestAgent.m
//
//  

#import "EGChainRequestAgent.h"
#import "EGChainRequest.h"

@interface EGChainRequestAgent()

@property (strong, nonatomic) NSMutableArray<EGChainRequest *> *requestArray;

@end

@implementation EGChainRequestAgent

+ (EGChainRequestAgent *)sharedAgent {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _requestArray = [NSMutableArray array];
    }
    return self;
}

- (void)addChainRequest:(EGChainRequest *)request {
    @synchronized(self) {
        [_requestArray addObject:request];
    }
}

- (void)removeChainRequest:(EGChainRequest *)request {
    @synchronized(self) {
        [_requestArray removeObject:request];
    }
}

@end
