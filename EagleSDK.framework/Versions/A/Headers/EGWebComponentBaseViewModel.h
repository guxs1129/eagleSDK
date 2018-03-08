//
//  EGWebComponentBaseViewModel.h
//  EagleSDK
//
//  Created by 顾新生 on 2018/2/12.
//

typedef TopicResultBlock JSCallBack;
typedef void(^JSCallNativeBlock)(NSString *handler,id data,JSCallBack callback);
#define EGW_InternalHandler_ImageCompressRatio   1.0

#import <EagleSDK/EagleSDK.h>
#import "EGViewModel.h"

@interface EGWebComponentBaseViewModel : EGViewModel<WebComponent>

@property(nonatomic,strong)NSURL *loadURL;
@property(nonatomic,strong)NSArray *handlers;

@end

@interface EGWebComponentInternalHandler:NSObject

+(instancetype)handlerWithTarget:(EGViewModel *)target;
-(JSCallNativeBlock)_getSystemInfo_;
-(JSCallNativeBlock)_getNetworkType_;
-(JSCallNativeBlock)_getAppVersion_;
-(JSCallNativeBlock)_generateQRCode_;
-(JSCallNativeBlock)_openQRCode_;
-(JSCallNativeBlock)_openAlbum_;
-(JSCallNativeBlock)_openCamera_;
-(JSCallNativeBlock)_getLocationInfo_;
-(JSCallNativeBlock)_closeWindow_;
-(JSCallNativeBlock)_openWindow_;
-(JSCallNativeBlock)_setNavBarStyle_;
-(JSCallNativeBlock)_setOptionMenu_;

@end

