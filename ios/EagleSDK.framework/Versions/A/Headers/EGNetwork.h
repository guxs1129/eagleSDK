//
//  EGNetwork.h
//

#import <Foundation/Foundation.h>

#ifndef _EGNETWORK_
    #define _EGNETWORK_

#if __has_include(<EGNetwork/EGNetwork.h>)

    FOUNDATION_EXPORT double EGNetworkVersionNumber;
    FOUNDATION_EXPORT const unsigned char EGNetworkVersionString[];

    #import <EGNetwork/EGRequest.h>
    #import <EGNetwork/EGBaseRequest.h>
    #import <EGNetwork/EGNetworkAgent.h>
    #import <EGNetwork/EGBatchRequest.h>
    #import <EGNetwork/EGBatchRequestAgent.h>
    #import <EGNetwork/EGChainRequest.h>
    #import <EGNetwork/EGChainRequestAgent.h>
    #import <EGNetwork/EGNetworkConfig.h>

#else

    #import "EGRequest.h"
    #import "EGBaseRequest.h"
    #import "EGNetworkAgent.h"
    #import "EGBatchRequest.h"
    #import "EGBatchRequestAgent.h"
    #import "EGChainRequest.h"
    #import "EGChainRequestAgent.h"
    #import "EGNetworkConfig.h"

#endif /* __has_include */

#endif /* _EGNETWORK_ */
