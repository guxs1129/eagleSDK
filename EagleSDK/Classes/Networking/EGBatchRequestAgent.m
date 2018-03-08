//
//  EGBatchRequestAgent.m
//

#import "EGBatchRequestAgent.h"
#import "EGBatchRequest.h"

@interface EGBatchRequestAgent()

@property (strong, nonatomic) NSMutableArray<EGBatchRequest *> *requestArray;

@end

@implementation EGBatchRequestAgent

+ (EGBatchRequestAgent *)sharedAgent {
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

- (void)addBatchRequest:(EGBatchRequest *)request {
    @synchronized(self) {
        [_requestArray addObject:request];
    }
}

- (void)removeBatchRequest:(EGBatchRequest *)request {
    @synchronized(self) {
        [_requestArray removeObject:request];
    }
}

@end
