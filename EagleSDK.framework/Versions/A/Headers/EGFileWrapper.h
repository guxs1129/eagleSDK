//
//  EGFileWrapper.h
//  FileHelper
//
//  Created by 顾新生 on 2018/1/16.
//  Copyright © 2018年 顾新生. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EGFileDefines.h"


@interface EGFileWrapper : NSObject
/** file name */
@property(nonatomic,copy)NSString *name;
/** file absolute path */
@property(nonatomic,copy)NSString *absolutePath;
/** file relative path */
@property(nonatomic,copy)NSString *relativePath;
/** file root path. Like:Documents,Caches,tmp,Library */
@property(nonatomic,assign)EGDirectoryType rootDirType;
/** file suffix */
@property(nonatomic,copy)NSString *suffix;
/** file URL path */
@property(nonatomic,strong)NSURL *urlPath;
/** file is a directory? */
@property(nonatomic,assign)BOOL isDirectory;
/** file's kind */
@property(nonatomic,assign)EGFileKindType kindType;
/** file's parentDir */
@property(nonatomic,strong)NSURL *parentDirPath;

#pragma mark meta
/** file create date */
@property(nonatomic,strong)NSDate *createDate;
/** file last modification date */
@property(nonatomic,strong)NSDate *lastModificationDate;
/** file system type */
@property(nonatomic,assign)EGFileType fileType;
/** file size. (Unit:byte) */
@property(nonatomic,assign)int size;
/** file system attributes */
@property(nonatomic,strong)NSDictionary *fileAttributes;


/**
 Convert a NSFileWrapper to EGFileWrapper
 
 @param fileWrapper Filewrapper
 */
-(void)convertFileWrapper:(NSFileWrapper *)fileWrapper;

-(instancetype)initWithURL:(NSURL *)fileURL;

@end

