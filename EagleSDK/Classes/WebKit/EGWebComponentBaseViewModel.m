    //
    //  EGWebComponentBaseViewModel.m
    //  EagleSDK
    //
    //  Created by 顾新生 on 2018/2/12.
    //

#import "EGWebComponentBaseViewModel.h"
#import <AVFoundation/AVFoundation.h>
#import "TZImagePickerController.h"

@implementation EGWebComponentBaseViewModel


-(NSURL *)loadURL{
    NSLog(@"You should override %s method in your subclass.",__func__);
    return nil;
}
-(NSArray *)handlers{
    if ([[self class] isSubclassOfClass:[EGWebComponentBaseViewModel class]]) {
        unsigned int count;
        Method *methodList = class_copyMethodList([self class],&count);
        NSMutableArray *tmpArrM=[NSMutableArray array];
        for (int i = 0; i < count; i++) {
            Method method = methodList[i];
            const char *pConstChar=sel_getName(method_getName(method));
            NSString *strNSString = [[NSString alloc] initWithUTF8String:pConstChar];
            if ([strNSString hasSuffix:@"Handler"]) {
                [tmpArrM addObject:strNSString];
            }
        }
        return [NSArray arrayWithArray:tmpArrM];
    }else{
        return @[];
    }
}

-(void)navtiveCall:(NSString *)handler data:(id)data callBack:(JSCallBack)callback{
    if ([handler hasPrefix:@"_"]&&[handler hasSuffix:@"_"]) {
        [self callNaitveInternalHandler:handler data:data callBack:callback];
    }else{
        SEL sel= NSSelectorFromString(handler);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        if ([self respondsToSelector:sel]) {
            JSCallNativeBlock blk = [self performSelector:sel];
            blk(handler,data,callback);
        }else{
            [self jsCallNativeForUndefinedHandler:handler data:data callBack:callback];
        }
#pragma clang diagnostic pop
    }
}



-(void)jsCall:(NSString *)handler options:(id)options{
    NSLog(@"%@%@",handler,options);
    
}
-(void)urlCall:(NSString *)handler params:(NSArray *)params msg:(id)msg{
    NSLog(@"%@%@%@",handler,params,msg);
}


-(void)callNaitveInternalHandler:(NSString *)handler data:(id)data callBack:(JSCallBack)callback{
    
    SEL sel=NSSelectorFromString(handler);
    EGWebComponentInternalHandler *internalHandler=[EGWebComponentInternalHandler handlerWithTarget:self];
    if ([internalHandler respondsToSelector:sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        JSCallNativeBlock blk = [internalHandler performSelector:sel];
#pragma clang diagnostic pop
        blk(handler,data,callback);
    }else{
        [self jsCallNativeForUndefinedHandler:handler data:data callBack:callback];
    }
}

-(void)jsCallNativeForUndefinedHandler:(NSString *)handler data:(id)data callBack:(JSCallBack)callback{
    NSLog(@"%@ handler undefined.%s called",handler,__func__);
}

@end


#pragma mark ----------------Internal Handler-----------------
@interface EGWebComponentInternalHandler()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic,weak)EGViewModel *target;
@property(nonatomic,copy)JSCallBack cameraAction;

@end

@implementation EGWebComponentInternalHandler
+(instancetype)handlerWithTarget:(EGViewModel *)target{
    EGWebComponentInternalHandler *handler=[[EGWebComponentInternalHandler alloc]init];
    handler.target=target;
    return handler;
}

-(JSCallNativeBlock)_getSystemInfo_{
    return ^(NSString *hanlder,id data,JSCallBack callback){
        UIDevice *device = [UIDevice currentDevice];
        
        NSDictionary *infoDict=@{@"苹果设备唯一标识UUID":device.identifierForVendor.UUIDString,
                                 @"设备别名":device.name,
                                 @"系统名称":device.systemName,
                                 @"系统版本":device.systemVersion,
                                 @"设备型号": device.model,
                                 @"国际化区域名称": device.localizedModel
                                 };
        NSLog(@"%@",infoDict);
        callback(infoDict);
    };
}
-(JSCallNativeBlock)_getNetworkType_{
    return ^(NSString *hanlder,id data,JSCallBack callback){
        NSLog(@"%s",__func__);
        
    };
}
-(JSCallNativeBlock)_getAppVersion_{
    return ^(NSString *hanlder,id data,JSCallBack callback){
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        if (callback) {
            callback(app_Version);
        }
    };
}
-(JSCallNativeBlock)_generateQRCode_{
    return ^(NSString *hanlder,id data,JSCallBack callback){
        NSDictionary *dataDict=(NSDictionary *)data;
//        [EGRouterManager navigateTo:[NSString stringWithFormat:@"eagle://generateQRCode?title=我的二维码&descrip=扫一扫可以识别我哦&data=%@&iconUrl=%@",[dataDict objectForKey:@"data"], [dataDict objectForKey:@"iconUrl"]]];
        CGFloat dimension=[[dataDict valueForKey:@"size"]floatValue];
        NSInteger pattern=[[dataDict valueForKey:@"pattern"]integerValue];
        [self callService:ModuleService(@"EGScanCode", @"com.linkstec.egscancode.qrcode") params:@{@"content":[dataDict objectForKey:@"iconUrl"],@"pattern":pattern==0?@0:@(pattern),@"dimension":@(dimension)} resultHandler:^(id msg) {
            callback(msg);
        }];
    };
}
-(JSCallNativeBlock)_openQRCode_{
    return ^(NSString *hanlder,id data,JSCallBack callback){
        NSDictionary *dataDict=(NSDictionary *)data;
        if ([dataDict objectForKey:@"needResult"]) {
            int needResult = [[dataDict objectForKey:@"needResult"] intValue];
                //FIXME:use scan's router
//            [self callService:ModuleService(@"EGScanCode", @"com.linkstec.egscancode.qrcode") params:@{@"hello":@"world"} resultHandler:^(id msg) {
//                NSLog(@"=====>Result:%@",msg);
//            }];
            
            switch (needResult) {
                case 0:// 扫一扫内部处理
                {
                
                }
                    break;
                case 1:{// 扫一扫返回结果
                    [self.target sendUIAction:^(UIViewController *presentVC) {
                        if (presentVC.navigationController) {
                            [EGRouterManager navigateToModule:[[EGURL alloc]initWithString:EGModuleHashRouter(@"EGScanCode",@"EGScanViewController")] options:@{@"hello":@"world"} callback:^(id data) {
                                NSLog(@"===>ScanCode callback");
                                callback(data);
                            }];
                        }
                    }];
                
                }
                    break;
                default:
                    break;
            }
        }
    };
}
-(JSCallNativeBlock)_openAlbum_{
    return ^(NSString *hanlder,id data,JSCallBack callback){
        if ([self checkAVAuthorizationStatu]) {
            [self callImagePickerWithCallback:callback];
        }
        
    };
}
-(JSCallNativeBlock)_openCamera_{
    return ^(NSString *hanlder,id data,JSCallBack callback){
        if ([self checkAVAuthorizationStatu]) {
            [self _openCameraWithResutlCallback:callback];
        }
    };
}
-(JSCallNativeBlock)_getLocationInfo_{
    return ^(NSString *hanlder,id data,JSCallBack callback){
        NSLog(@"%s",__func__);
        
    };
}
-(JSCallNativeBlock)_closeWindow_{
    return ^(NSString *hanlder,id data,JSCallBack callback){
        NSDictionary *dataDict=(NSDictionary *)data;
        [self.target sendUIAction:^(UIViewController *presentVC) {
            if (dataDict && presentVC.eg_callback) {
                presentVC.eg_callback([dataDict objectForKey:@"data"]);
            }
            if ([[presentVC.params objectForKey:@"_modal"] boolValue]) {
                [presentVC dismissViewControllerAnimated:YES completion:nil];
            }else {
                [presentVC.navigationController popViewControllerAnimated:YES];
            }
        }];
        
    };
}
-(JSCallNativeBlock)_openWindow_{
    return ^(NSString *hanlder,id data,JSCallBack callback){
        NSString *urlStr=[(NSDictionary *)data valueForKey:@"url"];
        if ([urlStr hasPrefix:@"http"]||[urlStr hasPrefix:@"https"]||[urlStr hasPrefix:@"file"]) {
            [self post:EGW_OpenURL_Channel withOptions:[NSURL URLWithString:urlStr]];
        }else{
            NSDictionary *dataDict=(NSDictionary *)data;
            BOOL needResult = [[dataDict objectForKey:@"needResult"] boolValue];
            if ([dataDict objectForKey:@"url"]) {
                if (needResult) {
                    [EGRouterManager navigateTo:[dataDict objectForKey:@"url"] callback:^(id data) {
                        if (callback) {
                            callback(data);
                        }
                    }];
                }else {
                    [EGRouterManager navigateTo:[dataDict objectForKey:@"url"]];
                }
            }
        }
        
    };
}

-(JSCallNativeBlock)_setNavBarStyle_{
    return ^(NSString *hanlder,id data,JSCallBack callback){
        NSDictionary *dataDict=(NSDictionary *)data;
        [self.target sendUIAction:^(UIViewController *presentVC) {
            if ([dataDict objectForKey:@"backgroundColor"]) {
                presentVC.navigationController.navigationBar.barTintColor = [UIColor eg_colorWithHexString:[dataDict objectForKey:@"backgroundColor"]];
                presentVC.navigationController.navigationBar.backgroundColor = [UIColor eg_colorWithHexString:[dataDict objectForKey:@"backgroundColor"]];
            }
            if ([dataDict objectForKey:@"title"]) {
                presentVC.title = [dataDict objectForKey:@"title"];
            }
            if ([dataDict objectForKey:@"isHidden"]) {
                BOOL isHidden = [[dataDict objectForKey:@"isHidden"] boolValue];
                [presentVC.navigationController setNavigationBarHidden:isHidden animated:YES];
            }
        }];
        
    };
}
-(JSCallNativeBlock)_setOptionMenu_{
    return ^(NSString *hanlder,id data,JSCallBack callback){
        NSDictionary *dataDict=(NSDictionary *)data;
        NSLog(@"%@",self.target);
        [self.target sendUIAction:^(UIViewController *presentVC) {
            if (dataDict && ![data isKindOfClass:[NSNull class]]) {// 创建导航栏右边按钮
                                                                   //TODO:fix here
                @throw [NSException exceptionWithName:@"这里与AutoMenu有相互引用的问题，后期修复" reason:nil userInfo:nil];
                EGComponent *temp = presentVC.initComponent(@"EGAutoMenuC").done()[0];
                temp.params = @{@"color":@"#FFFFFF"};
                [self eg_performSelector:temp actionStr:@"reSetDelegate:" withObject:self.target];
                if ([dataDict objectForKey:@"menus"]) {
                    [self eg_performSelector:temp actionStr:@"setMenus:" withObject:(NSArray *)[dataDict objectForKey:@"menus"]];
                }
            }else {// 清除导航栏右边按钮
                presentVC.navigationItem.rightBarButtonItems = [NSArray array];
            }
        }];
        
    };
}

#pragma mark ---------------camera---------------
#pragma mark -- 相机、相册

- (BOOL)checkAVAuthorizationStatu{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusRestricted || status == AVAuthorizationStatusDenied) {
        [self.target sendUIAction:^(UIViewController *presentVC) {
                // 无权限
                // do something...
            NSString *title = [NSString stringWithFormat:@"您是否想开启\"相机权限的系统设置"];
            NSString *message = @"选择\"允许\"您将跳转到系统设置";
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(title, nil) message:NSLocalizedString(message, nil) preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"不允许" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"允许" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }];
            [alertController addAction:cancelAction];
            [alertController addAction:okAction];
            [presentVC presentViewController:alertController animated:YES completion:nil];
        }];
        return NO;
    }
    return YES;
}

- (void)callImagePickerWithCallback:(JSCallBack)callback{
    
    [self.target sendUIAction:^(UIViewController *presentVC) {
        UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"选择图像" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            UIAlertAction *cameraActin=[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self _openCameraWithResutlCallback:callback];
            }];
            [alertController addAction:cameraActin];
        }
        UIAlertAction *albumAction=[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self _openAlbumWithResultCallback:callback];
        }];
        UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:albumAction];
        [alertController addAction:cancelAction];
        [presentVC presentViewController:alertController animated:YES completion:nil];
    }];
}


/**
 相机

 @param callback 回调
 */
-(void)_openCameraWithResutlCallback:(JSCallBack)callback{
    NSString *desc = [[NSBundle mainBundle]objectForInfoDictionaryKey:@"NSCameraUsageDescription"];
    if (!desc) {
        @throw [NSException exceptionWithName:@"<EGWebModule Error>" reason:@"Attempted to access privacy-sensitive data without a usage description.  The app's Info.plist must contain an NSPhotoLibraryUsageDescription key with a string value explaining to the user how the app uses this data." userInfo:nil];
        return ;
    }
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.cameraAction = callback;
        [self.target sendUIAction:^(UIViewController *presentVC) {
            UIImagePickerController *controller=[[UIImagePickerController alloc]init];
            controller.allowsEditing = YES;
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            controller.delegate = self;
            [presentVC presentViewController:controller animated:YES completion:nil];
        }];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIGraphicsBeginImageContext(CGSizeMake(image.size.width, image.size.height));
        NSData *imageData=UIImageJPEGRepresentation(image, EGW_InternalHandler_ImageCompressRatio);
        UIGraphicsEndImageContext();
        NSString *base64String = [self _convertStr:[imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]];
        if (self.cameraAction) {
            self.cameraAction(base64String);
        }
    });
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
    if (self.cameraAction) {
        self.cameraAction = nil;
    }
}

/**
 相册

 @param callback 回调
 */
-(void)_openAlbumWithResultCallback:(JSCallBack)callback{
    [self.target sendUIAction:^(UIViewController *presentVC) {
        NSString *desc = [[NSBundle mainBundle]objectForInfoDictionaryKey:@"NSPhotoLibraryUsageDescription"];
        if (!desc) {
            @throw [NSException exceptionWithName:@"<EGWebModule Error>" reason:@"Attempted to access privacy-sensitive data without a usage description.  The app's Info.plist must contain an NSPhotoLibraryUsageDescription key with a string value explaining to the user how the app uses this data." userInfo:nil];
            return ;
        }
            //TODO:support multi select
        NSInteger maxCount=1; //max select allowed
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:maxCount delegate:nil];
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSString *result=nil;
                if (maxCount>1) {//multi select
                    NSMutableArray *dataArrM=[NSMutableArray array];
                    for (UIImage *selectImage in photos) {
                        UIGraphicsBeginImageContext(CGSizeMake(selectImage.size.width, selectImage.size.height));
                        NSData *imageData=UIImageJPEGRepresentation(selectImage, EGW_InternalHandler_ImageCompressRatio);
                        [dataArrM addObject:[imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]];
                        UIGraphicsEndImageContext();
                    }
                    result=[self _convertArrStr:dataArrM];
                    
                }else{//single select
                    UIImage *selectImage = [photos firstObject];
                    UIGraphicsBeginImageContext(CGSizeMake(selectImage.size.width, selectImage.size.height));
                    NSString *imageData=[UIImageJPEGRepresentation(selectImage, EGW_InternalHandler_ImageCompressRatio) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                    UIGraphicsEndImageContext();
                    result=[self _convertStr:imageData];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    callback(result);
                });
            });
        }];
        
        [presentVC presentViewController:imagePickerVc animated:YES completion:nil];
    }];
}

-(NSString *)_convertArrStr:(NSArray *)dataArr{
    NSString *base64String = [dataArr firstObject];
    NSString *mimeType=@"image/jpeg";
    return [NSString stringWithFormat:@"data:%@;base64,%@", mimeType,
            base64String];
}
-(NSString *)_convertStr:(NSString *)imageData{
    NSString *mimeType=@"image/jpeg";
    return [NSString stringWithFormat:@"data:%@;base64,%@", mimeType,
            imageData];
}
    //-(NSString *)_convertBase64Str:(NSDictionary *)info{
    //    NSError *error;
    //    NSData *data=[NSJSONSerialization dataWithJSONObject:info options:NSJSONWritingPrettyPrinted error:&error];
    //    if (error) {
    //        NSLog(@"%@",error);
    //        return nil;
    //    }
    //    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    //}

@end

