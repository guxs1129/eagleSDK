//
//  EGFileManager.h
//  FileHelper
//
//  Created by 顾新生 on 2018/1/15.
//  Copyright © 2018年 顾新生. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "EGFileDefines.h"
@class EGFileWrapper;


@interface EGFileManager : NSObject
@property(nonatomic,strong)NSArray *rootDirs;

+(instancetype)manager;

#pragma mark  Sandbox Directory Path

-(NSString *)getDirPathWithType:(EGDirectoryType)type;
/** Home */
-(NSString *)getHomeDirectoryPath;

/** Document */
-(NSString *)getDocumentDirectoryPath;

/** Caches */
-(NSString *)getCacheDirectoryPath;

/** Library */
-(NSString *)getLibDirectoryPath;

/** tmp */
-(NSString *)getTmpDirectoryPath;


#pragma mark File Check
-(BOOL)fileExistsAtPath:(NSString *)filePath;

#pragma mark List Directory files
-(void)contentsOfDirectory:(NSString *)dirPath withResultHandler:(ResultHandler)resultHandler;
/**
 List files and directories under relative path if it is a directory ,it will throw an error if it's a file or not exist.


 @param dirPath Relative path.
 @param rootDir Root dir
 @param resultHandler Result callback with success or error.
 */
-(void)contentsOfDirectory:(NSString *)dirPath relateToRootDir:(EGDirectoryType)rootDir withResultHandler:(ResultHandler)resultHandler;


/**
 Convince methods to list files and directories relate to a special root directory if it is a directory ,it will throw an error if it's a file or not exist.

 @param dirPath Relative path.
 @param resultHandler Result callback with success or error.
 */
-(void)contentsOfDirectoryRelativeToDocuments:(NSString *)dirPath withResultHandler:(ResultHandler)resultHandler;
-(void)contentsOfDirectoryRelativeToLibrary:(NSString *)dirPath withResultHandler:(ResultHandler)resultHandler;
-(void)contentsOfDirectoryRelativeToCaches:(NSString *)dirPath withResultHandler:(ResultHandler)resultHandler;
-(void)contentsOfDirectoryRelativeToTmp:(NSString *)dirPath withResultHandler:(ResultHandler)resultHandler;


#pragma mark Add a file or a directory
-(void)addFileAsync:(NSString *)fileName data:(NSData *)data toRootPath:(NSString *)rootPath withResultHandler:(AddFileResultHandler)resultHandler;
-(void)addFileAsync:(NSString *)fileName data:(NSData *)data toRootURL:(NSURL *)rootURL withResultHandler:(AddFileResultHandler)resultHandler;
-(void)addFileAsync:(NSString *)fileName data:(NSData *)data toRootFileWrapper:(EGFileWrapper *)fileWrapper withResultHandler:(AddFileResultHandler)resultHandler;

/**
 Add a directory to a absolute path.

 @param dirName Directory name
 @param rootPath Super directory path
 @return Result
 */
-(BOOL)addDirectory:(NSString *)dirName toRootPath:(NSString *)rootPath;
-(BOOL)addDirectory:(NSString *)dirName toRootURL:(NSURL *)rootURL;
-(BOOL)addDirectory:(NSString *)dirName toRootFileWrapper:(EGFileWrapper *)fileWrapper;

-(BOOL)addFile:(NSString *)fileName data:(NSData *)data toRootPath:(NSString *)rootPath;
-(BOOL)addFile:(NSString *)fileName data:(NSData *)data toRootURL:(NSURL *)rootURL;
-(BOOL)addFile:(NSString *)fileName data:(NSData *)data toRootFileWrapper:(EGFileWrapper *)fileWrapper;

#pragma mark Remove a file or a directory

-(BOOL)deleteItemAtPath:(NSString *)itemPath;
-(BOOL)deleteItemAtURL:(NSURL *)itemURL;
-(BOOL)deleteItemFileWrapper:(EGFileWrapper *)fileWrapper;

/**
 Use a directory path to delete a directory

 @param dirPath Directory path
 @return Result
 */
-(BOOL)deleteDirAtPath:(NSString *)dirPath;


/**
 Use a URL to delete a directory

 @param dirURL Directory URL
 @return Result
 */
-(BOOL)deleteDirAtURL:(NSURL *)dirURL;


/**
 Use a filewrapper to delete a directory

 @param fileWrapper Filewrapper
 @return Result
 */
-(BOOL)deleteDirFileWrapper:(EGFileWrapper *)fileWrapper;

/**
 Use a file path to delete a file


 @param filePath File Path
 @return Result
 */
-(BOOL)deleteFileAtPath:(NSString *)filePath;


/**
 Use a URL to delete a file


 @param fileURL File URL
 @return Result
 */
-(BOOL)deleteFileAtURL:(NSURL *)fileURL;


/**
 Use a filewrapper to delete a file

 @param fileWrapper Filewrapper
 @return Result
 */
-(BOOL)deleteFileWrapper:(EGFileWrapper *)fileWrapper;


#pragma mark Debug option

-(void)enableDebug:(BOOL)enable;

@end
