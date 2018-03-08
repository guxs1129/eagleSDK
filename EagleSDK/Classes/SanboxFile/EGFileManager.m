//
//  EGFileManager.m
//  FileHelper
//
//  Created by 顾新生 on 2018/1/15.
//  Copyright © 2018年 顾新生. All rights reserved.
//

#import "EGFileManager.h"
#import "EGFileWrapper.h"
@interface EGFileManager()
@property(nonatomic,strong)NSFileManager *fileManager;
@property(nonatomic,assign)BOOL isDebug;
@property(nonatomic,strong)dispatch_queue_t fileQueue;

@end
@implementation EGFileManager
static const char* queueID="com.linkstec.fileQueue";
+(instancetype)manager{
    static EGFileManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager=[[self alloc]init];
        manager.isDebug=NO;
        manager.fileQueue=dispatch_queue_create(queueID, DISPATCH_QUEUE_CONCURRENT);
    });
    return manager;
}

-(NSString *)getDirPathWithType:(EGDirectoryType)type{
    switch (type) {
        case EGDirectoryTypeHome:
            return [self getHomeDirectoryPath];
            break;
        case EGDirectoryTypeDocument:
            return [self getDocumentDirectoryPath];
            break;
        case EGDirectoryTypeCaches:
            return [self getCacheDirectoryPath];
            break;
        case EGDirectoryTypeLibrary:
            return [self getLibDirectoryPath];
            break;
        case EGDirectoryTypeTmp:
            return [self getTmpDirectoryPath];
            break;
        default:
            return nil;
            break;
    }
}

-(NSString *)getHomeDirectoryPath{
    return NSHomeDirectory();
}

-(NSString *)getDocumentDirectoryPath{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

-(NSString *)getCacheDirectoryPath{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
}

-(NSString *)getLibDirectoryPath{
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
}

-(NSString *)getTmpDirectoryPath{
    return NSTemporaryDirectory();
}

-(BOOL)fileExistsAtPath:(NSString *)filePath{
    return [self.fileManager fileExistsAtPath:filePath];
}

-(void)contentsOfDirectoryRelativeToDocuments:(NSString *)dirPath withResultHandler:(ResultHandler)resultHandler{
    [self contentsOfDirectory:dirPath relateToRootDir:EGDirectoryTypeDocument withResultHandler:resultHandler];
}

-(void)contentsOfDirectoryRelativeToLibrary:(NSString *)dirPath withResultHandler:(ResultHandler)resultHandler{
    [self contentsOfDirectory:dirPath relateToRootDir:EGDirectoryTypeLibrary withResultHandler:resultHandler];
}

-(void)contentsOfDirectoryRelativeToCaches:(NSString *)dirPath withResultHandler:(ResultHandler)resultHandler{
    [self contentsOfDirectory:dirPath relateToRootDir:EGDirectoryTypeCaches withResultHandler:resultHandler];
}

-(void)contentsOfDirectoryRelativeToTmp:(NSString *)dirPath withResultHandler:(ResultHandler)resultHandler{
    [self contentsOfDirectory:dirPath relateToRootDir:EGDirectoryTypeTmp withResultHandler:resultHandler];
}

-(void)contentsOfDirectory:(NSString *)dirPath relateToRootDir:(EGDirectoryType)rootDir withResultHandler:(ResultHandler)resultHandler{
    if (rootDir==EGDirectoryTypeDefault) {
        NSError *error=[NSError errorWithDomain:NSCocoaErrorDomain code:999 userInfo:@{NSUnderlyingErrorKey:@"Invalid root dir type"}];
        if (resultHandler) {
            resultHandler(nil,error);
        }
        return;
    }
    
    if (!dirPath || dirPath.length==0) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:999 userInfo:@{NSFilePathErrorKey:@"Dir path invalid"}];
        if (resultHandler) {
            resultHandler(nil,error);
        }
        return;
    }
    
    NSString *absolutePath=nil;
    NSString *rootDirPath=[self getDirPathWithType:rootDir];

    if (![dirPath isEqualToString:@"/"]) {
        absolutePath=[rootDirPath stringByAppendingPathComponent:dirPath];
    }else{
        absolutePath=rootDirPath;
    }
    
    if (self.isDebug) {
        NSLog(@"[File Path]:%@",absolutePath);
    }
    
    BOOL isDirectory=YES;
    if (![self.fileManager fileExistsAtPath:absolutePath isDirectory:&isDirectory]) {
        NSError *error  = [NSError errorWithDomain:NSCocoaErrorDomain code:999 userInfo:@{NSFilePathErrorKey:@"Dir is not exist."}];
        if (resultHandler) {
            resultHandler(nil,error);
        }
        return;
    }else{
        NSError *error;
        NSArray *result=nil;
        if (!isDirectory) {
            error = [NSError errorWithDomain:NSCocoaErrorDomain code:999 userInfo:@{NSFilePathErrorKey:@"Dir path is not a directory."}];
        }else{
            result=[self.fileManager contentsOfDirectoryAtPath:absolutePath error:&error];
            NSMutableArray *tmp=[NSMutableArray array];
            for (NSString *fileName in result) {
                
                NSString *filePath=[absolutePath stringByAppendingPathComponent:fileName];
                NSURL *url=[NSURL fileURLWithPath:filePath];
                EGFileWrapper *fileWrapper=nil;
                @try{
                    fileWrapper=[[EGFileWrapper alloc]initWithURL:url];
                    NSLog(@"%@",fileWrapper.relativePath);
                    [tmp addObject:fileWrapper];
                }@catch(NSError *e){
                    error=e;
                    break;
                }
            }
            result=[NSArray arrayWithArray:tmp];
        }
        
        if (resultHandler) {
            resultHandler(result,error);
        }
    }
}

-(void)contentsOfDirectory:(NSString *)dirPath withResultHandler:(ResultHandler)resultHandler{
    BOOL isDirectory=YES;
    if (![self.fileManager fileExistsAtPath:dirPath isDirectory:&isDirectory]) {
        NSError *error  = [NSError errorWithDomain:NSCocoaErrorDomain code:999 userInfo:@{NSFilePathErrorKey:@"Dir is not exist."}];
        if (resultHandler) {
            resultHandler(nil,error);
        }
        return;
    }else{
        NSError *error;
        NSArray *result=nil;
        if (!isDirectory) {
            error = [NSError errorWithDomain:NSCocoaErrorDomain code:999 userInfo:@{NSFilePathErrorKey:@"Dir path is not a directory."}];
        }else{
            result=[self.fileManager contentsOfDirectoryAtPath:dirPath error:&error];
            NSMutableArray *tmp=[NSMutableArray array];
            for (NSString *fileName in result) {
                
                NSString *filePath=[dirPath stringByAppendingPathComponent:fileName];
                NSURL *url=[NSURL fileURLWithPath:filePath];
                EGFileWrapper *fileWrapper=nil;
                @try{
                    fileWrapper=[[EGFileWrapper alloc]initWithURL:url];
                    NSLog(@"%@",fileWrapper.relativePath);
                    [tmp addObject:fileWrapper];
                }@catch(NSError *e){
                    error=e;
                    break;
                }
            }
            result=[NSArray arrayWithArray:tmp];
        }
        
        if (resultHandler) {
            resultHandler(result,error);
        }
    }
}

#pragma mark ---------------Add---------------
#pragma mark add directory
-(BOOL)addDirectory:(NSString *)dirName toRootPath:(NSString *)rootPath{
    NSURL *url=[NSURL fileURLWithPath:rootPath];
    return [self addDirectory:dirName toRootURL:url];
}
-(BOOL)addDirectory:(NSString *)dirName toRootURL:(NSURL *)rootURL{
    EGFileWrapper *file=[[EGFileWrapper alloc]initWithURL:rootURL];
    return [self addDirectory:dirName toRootFileWrapper:file];
}
-(BOOL)addDirectory:(NSString *)dirName toRootFileWrapper:(EGFileWrapper *)fileWrapper{
    if (!fileWrapper.isDirectory) {
        @throw [NSError errorWithDomain:NSCocoaErrorDomain code:999 userInfo:@{NSUnderlyingErrorKey:@"Target can't add a directory which is not a directory."}];
        return NO;
    }
    NSError *error;
    NSString *fullPath=[fileWrapper.absolutePath stringByAppendingPathComponent:dirName];
    if (self.isDebug) {
        NSLog(@"[Create Dir]%@",fullPath);
    }
    if([self.fileManager fileExistsAtPath:fullPath]){
        @throw [NSError errorWithDomain:NSCocoaErrorDomain code:999 userInfo:@{NSUnderlyingErrorKey:@"Directory is already exist."}];
        return NO;
    }else{
        BOOL flag = [self.fileManager createDirectoryAtPath:fullPath withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            @throw error;
        }
        return flag;
    }
}

#pragma mark add file
#pragma mark -- async
-(void)addFileAsync:(NSString *)fileName data:(NSData *)data toRootPath:(NSString *)rootPath withResultHandler:(AddFileResultHandler)resultHandler{
    NSURL *url=[NSURL fileURLWithPath:rootPath];
    [self addFileAsync:fileName data:data toRootURL:url withResultHandler:resultHandler];
}
-(void)addFileAsync:(NSString *)fileName data:(NSData *)data toRootURL:(NSURL *)rootURL withResultHandler:(AddFileResultHandler)resultHandler{
    EGFileWrapper *file=[[EGFileWrapper alloc]initWithURL:rootURL];
    [self addFileAsync:fileName data:data toRootFileWrapper:file withResultHandler:resultHandler];
}
-(void)addFileAsync:(NSString *)fileName data:(NSData *)data toRootFileWrapper:(EGFileWrapper *)fileWrapper withResultHandler:(AddFileResultHandler)resultHandler{
    __weak typeof(self) weakSelf=self;
    dispatch_async(self.fileQueue, ^{
        __strong typeof(weakSelf) sSelf=weakSelf;

        BOOL flag=NO;
        NSError *error=nil;
        EGFileWrapper *file=nil;
        @try{
            flag=[sSelf addFile:fileName data:data toRootFileWrapper:fileWrapper];
            if (flag) {
                file=[[EGFileWrapper alloc]initWithURL:[NSURL fileURLWithPathComponents:@[fileWrapper.absolutePath,fileName]]];
            }
        }@catch(NSError *e){
            error=e;
        }@finally{
            dispatch_async(dispatch_get_main_queue(), ^{
                if (resultHandler) {
                    resultHandler(flag,file,error);
                }
            });
        }
    });
}

#pragma mark --sync
-(BOOL)addFile:(NSString *)fileName data:(NSData *)data toRootPath:(NSString *)rootPath{
    NSURL *url=[NSURL fileURLWithPath:rootPath];
    return [self addFile:fileName data:data toRootURL:url];
}

-(BOOL)addFile:(NSString *)fileName data:(NSData *)data toRootURL:(NSURL *)rootURL{
    EGFileWrapper *file=[[EGFileWrapper alloc]initWithURL:rootURL];
    return [self addFile:fileName data:data toRootFileWrapper:file];
}

-(BOOL)addFile:(NSString *)fileName data:(NSData *)data toRootFileWrapper:(EGFileWrapper *)fileWrapper{
    if (!fileWrapper.isDirectory) {
        @throw [NSError errorWithDomain:NSCocoaErrorDomain code:999 userInfo:@{NSUnderlyingErrorKey:@"Target can't add a file which is not a directory."}];
        return NO;
    }
    NSError *error;
    NSString *fullPath=[fileWrapper.absolutePath stringByAppendingPathComponent:fileName];
    if (self.isDebug) {
        NSLog(@"[Create File]%@",fullPath);
    }
    if([self.fileManager fileExistsAtPath:fullPath]){
        @throw [NSError errorWithDomain:NSCocoaErrorDomain code:999 userInfo:@{NSUnderlyingErrorKey:@"File is already exist."}];
        return NO;
    }else{
        BOOL flag = [self.fileManager createFileAtPath:fullPath contents:data attributes:nil];
        if (error) {
            @throw error;
        }
        return flag;
    }
}


#pragma mark ---------------Delete---------------
#pragma mark delete directory
-(BOOL)deleteItemAtPath:(NSString *)itemPath{
    NSURL *url=[NSURL fileURLWithPath:itemPath];
    return [self deleteItemAtURL:url];
}
-(BOOL)deleteItemAtURL:(NSURL *)itemURL{
    EGFileWrapper *file=[[EGFileWrapper alloc]initWithURL:itemURL];
    return [self deleteItemFileWrapper:file];
}
-(BOOL)deleteItemFileWrapper:(EGFileWrapper *)fileWrapper{
    if (fileWrapper.isDirectory) {
        return [self deleteDirFileWrapper:fileWrapper];
    } else {
        return [self deleteFileWrapper:fileWrapper];
    }
}


-(BOOL)deleteDirAtPath:(NSString *)dirPath{
    NSURL *url=[NSURL fileURLWithPath:dirPath];
    return [self deleteDirAtURL:url];
}

-(BOOL)deleteDirAtURL:(NSURL *)dirURL{
    EGFileWrapper *file=[[EGFileWrapper alloc]initWithURL:dirURL];
    return [self deleteDirFileWrapper:file];
}

-(BOOL)deleteDirFileWrapper:(EGFileWrapper *)fileWrapper{
    if (!fileWrapper.isDirectory) {
        @throw [NSError errorWithDomain:NSCocoaErrorDomain code:999 userInfo:@{NSUnderlyingErrorKey:@"File is not a directory,change api."}];
        return NO;
    }
    NSError *error;
    BOOL flag=[self.fileManager removeItemAtURL:fileWrapper.urlPath error:&error];
    if (error) {
        @throw error;
    }
    return flag;
}

#pragma mark delete file
-(BOOL)deleteFileAtPath:(NSString *)filePath{
    NSURL *url=[NSURL fileURLWithPath:filePath];
    return [self deleteFileAtURL:url];
}

-(BOOL)deleteFileAtURL:(NSURL *)fileURL{
    EGFileWrapper *file=[[EGFileWrapper alloc]initWithURL:fileURL];
    return [self deleteFileWrapper:file];
}

-(BOOL)deleteFileWrapper:(EGFileWrapper *)fileWrapper{
    if (fileWrapper.isDirectory) {
        @throw [NSError errorWithDomain:NSCocoaErrorDomain code:999 userInfo:@{NSUnderlyingErrorKey:@"File is a directory,change api."}];
        return NO;
    }
    NSError *error;
    BOOL flag=[self.fileManager removeItemAtURL:fileWrapper.urlPath error:&error];
    if (error) {
        @throw error;
    }
    return flag;
}

-(void)enableDebug:(BOOL)enable{
    self.isDebug=enable;
}

-(NSString *)rootDirWithType:(EGDirectoryType)type{
    switch (type) {
        case EGDirectoryTypeHome:
            return @"/";
            break;
        case EGDirectoryTypeDocument:
            return @"/Documents";
            break;
        case EGDirectoryTypeLibrary:
            return @"/Library";
            break;
        case EGDirectoryTypeCaches:
            return @"/Library/caches";
            break;
        case EGDirectoryTypeTmp:
            return @"/tmp";
            break;
        default:
            return nil;
            break;
    }
}

#pragma mark ----------------lazy var-----------------
-(NSFileManager *)fileManager{
    if (_fileManager==nil) {
        _fileManager=[NSFileManager defaultManager];
    }
    return _fileManager;
}
-(NSArray *)rootDirs{
    if (_rootDirs==nil) {
        NSMutableArray *tmp=[NSMutableArray array];
        [tmp addObject:[self getHomeDirectoryPath]];
        [tmp addObject:[self getLibDirectoryPath]];
        [tmp addObject:[self getTmpDirectoryPath]];
        [tmp addObject:[self getCacheDirectoryPath]];
        [tmp addObject:[self getDocumentDirectoryPath]];
        _rootDirs=[NSArray arrayWithArray:tmp];
    }
    return _rootDirs;
}
@end
