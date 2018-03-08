    //
    //  RouterManager+Blocks.h
    //  Eagle
    //
    //  Created by pantao on 2017/10/31.
    //  Copyright © 2017年 pantao. All rights reserved.
    //

#import "EGRouterManager.h"

typedef id (^EGRouterBlock)(NSDictionary *dict);

@interface EGRouterManager (Blocks)

- (EGRouterBlock)openEagleWithCallback:(EGCallback)callback;
- (EGRouterBlock)openHtml;
- (EGRouterBlock)openHtmlWithCallback:(EGCallback)callback;
- (EGRouterBlock)openRN;
- (EGRouterBlock)openOnlineFile;
- (EGRouterBlock)openLocalFile;
- (EGRouterBlock)openTel;
-(EGRouterBlock)openEagleWithOptions:(id)options callback:(EGCallback)callback;

@end

