//
//  EGSanboxFile.h
//  Eagle
//
//  Created by pantao on 2017/11/8.
//  Copyright © 2017年 pantao. All rights reserved.
//

#define eagleDir [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"Eagle"]

#import <Foundation/Foundation.h>

/**
 解压block

 @param loaded 已解压的文件大小
 @param total  被解压文件大小
 */
typedef void (^unzipProgress)(unsigned long long loaded, unsigned long long total);

/**
 解压完成block

 @param succeeded 是否成功
 @param error     错误
 */
typedef void (^unzipCompletedHandler)(BOOL succeeded, NSError *error);

/**
 压缩完成block
 
 @param succeeded 是否成功
 */
typedef void (^createZipCompletedHandler)(BOOL succeeded);

@interface EGSanboxFile : NSObject

+ (instancetype)shared;

/**
 获取文件大小

 @param fileName 文件名称
 @return 文件大小
 */
+ (unsigned long long)getFileSize:(NSString *)fileName;

/**
 文件解压

 @param fileName      zip文件名称
 @param toFilename    zip文件解压后的目标文件夹名称
 @param progress 已解压大小、文件总大小block
 */
+ (void)unzipFileName:(NSString *)fileName toFilename:(NSString *)toFilename progress:(unzipProgress)progress completedHandler:(unzipCompletedHandler)completedHandler;

/**
 压缩文件

 @param fileName      压缩后的目标文件名称
 @param directoryName 要压缩的文件夹名称
 */
+ (void)createZipFileName:(NSString *)fileName withContentsOfDirectoryName:(NSString *)directoryName completedHandler:(createZipCompletedHandler)completedHandler;

/**
 一些debug信息
 */
+ (void)debug;

@end
