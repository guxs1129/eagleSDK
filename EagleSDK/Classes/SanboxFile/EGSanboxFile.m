//
//  EGSanboxFile.m
//  Eagle
//
//  Created by pantao on 2017/11/8.
//  Copyright © 2017年 pantao. All rights reserved.
//

#import "EGSanboxFile.h"
#import "ZipArchive.h"

@implementation EGSanboxFile

static dispatch_queue_t _getsanBoxFileBackgroundQueue(void)
{
    static dispatch_once_t onceToken;
    static dispatch_queue_t backgroundQueue = nil;
    dispatch_once(&onceToken, ^{
        /** backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0); */
        backgroundQueue = dispatch_queue_create("linkage.eagle.sanbox.Queue", DISPATCH_QUEUE_CONCURRENT);
    });
    return backgroundQueue;
}

+ (instancetype)shared
{
    static EGSanboxFile *sanboxFile = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        if (!sanboxFile) {
            sanboxFile = [[self alloc] init];
            [EGSanboxFile initCacheDir];
        }
    });
    return sanboxFile;
}

+ (void)initCacheDir
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:eagleDir]) {
        //文件夹已存在
        return;
    } else {
        //创建文件夹
        [[NSFileManager defaultManager] createDirectoryAtPath:eagleDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

+ (unsigned long long)getFileSize:(NSString *)fileName
{
    [EGSanboxFile initCacheDir];
    if (![[NSFileManager defaultManager] fileExistsAtPath:[eagleDir stringByAppendingPathComponent:fileName]]) {
        return 0;
    }
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[eagleDir stringByAppendingPathComponent:fileName] error:nil];
    return [fileAttributes[NSFileSize] unsignedLongLongValue];;
}

+ (void)unzipFileName:(NSString *)fileName toFilename:(NSString *)toFilename progress:(unzipProgress)progress completedHandler:(unzipCompletedHandler)completedHandler
{
    __block unsigned long long fileSize = [EGSanboxFile getFileSize:fileName];
    __block unsigned long long currentPosition = 0;
    dispatch_async(_getsanBoxFileBackgroundQueue(), ^{
        __block NSError *tempError = nil;
        BOOL success = [SSZipArchive unzipFileAtPath:[eagleDir stringByAppendingPathComponent:fileName]
                                       toDestination:[eagleDir stringByAppendingPathComponent:toFilename]
                                     progressHandler:^(NSString * _Nonnull entry, unz_file_info zipInfo, long entryNumber, long total) {
                                         currentPosition += zipInfo.compressed_size;
                                         dispatch_async(dispatch_get_main_queue(), ^{
                                             long long current = currentPosition/1024;
                                             long long totalB = fileSize/1024;
                                             progress(current, totalB);
                                         });
                                     }
                              completionHandler:^(NSString * _Nonnull path, BOOL succeeded, NSError * _Nullable error) {
                                  tempError = error;
                              }];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                completedHandler(YES, nil);
            } else {
                completedHandler(NO, tempError);
            }
        });
    });
}

+ (void)createZipFileName:(NSString *)fileName withContentsOfDirectoryName:(NSString *)directoryName completedHandler:(createZipCompletedHandler)completedHandler
{
    dispatch_async(_getsanBoxFileBackgroundQueue(), ^{
       BOOL success =  [SSZipArchive createZipFileAtPath:[eagleDir stringByAppendingPathComponent:fileName] withContentsOfDirectory:[eagleDir stringByAppendingPathComponent:directoryName]];
        dispatch_async(dispatch_get_main_queue(), ^{
            completedHandler(success);
        });
    });
}

+ (void)debug
{
//    EagleLog(@" --- 沙盒地址：%@ --- ", eagleDir);
}

@end
