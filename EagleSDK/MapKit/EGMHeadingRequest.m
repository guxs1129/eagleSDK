//
//  EGMHeadingRequest.m
//  EagleSDK
//
//  Created by 顾新生 on 2018/1/15.
//

#import "EGMHeadingRequest.h"

@implementation EGMHeadingRequest

-(instancetype)init{
    if (self=[super init]) {
        self.requestID=[EGMRequestIDGenerator getUniqueRequestID];
        self.isRecurring=YES;
    }
    return self;
}

- (BOOL)isEqual:(id)object{
    if (object == self) {
        return YES;
    }
    if (!object || ![object isKindOfClass:[self class]]) {
        return NO;
    }
    if (((EGMHeadingRequest *)object).requestID == self.requestID) {
        return YES;
    }
    return NO;
}

- (NSUInteger)hash{
    return [[NSString stringWithFormat:@"%ld", (long)self.requestID] hash];
}
@end
