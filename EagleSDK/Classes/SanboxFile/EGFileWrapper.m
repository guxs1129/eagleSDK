//
//  EGFileWrapper.m
//  FileHelper
//
//  Created by 顾新生 on 2018/1/16.
//  Copyright © 2018年 顾新生. All rights reserved.
//

#import "EGFileWrapper.h"
#import "EGFileManager.h"
@interface EGFileWrapper()
@property(nonatomic,strong)NSDictionary *allTypes;


@end
@implementation EGFileWrapper

-(instancetype)initWithURL:(NSURL *)fileURL{
    if (self=[super init]) {
        self.urlPath=fileURL;
        [self initData];
    }
    return self;
}

-(void)initData{
    NSError *error;
    NSFileWrapper *file=[[NSFileWrapper alloc]initWithURL:self.urlPath options:NSFileWrapperReadingImmediate error:&error];
    if (error) {
        NSString *eString=nil;
        NSDictionary *info=error.userInfo;
        NSString *errorInfo=[info valueForKey:NSUnderlyingErrorKey];
        if (self.urlPath==nil) {
            eString=@"File URL can't be nil.";
        }else if (errorInfo){
            eString=errorInfo;
        }else{
            eString=@"Error happens while getting file infomations";
        }
        @throw [NSError errorWithDomain:NSCocoaErrorDomain code:999 userInfo:@{NSUnderlyingErrorKey:eString}];
    }else{
        [self convertFileWrapper:file];
    }
}

-(void)convertFileWrapper:(NSFileWrapper *)fileWrapper{
    NSDictionary *metaDict=fileWrapper.fileAttributes;
    self.name=fileWrapper.filename;
    self.fileAttributes=[NSDictionary dictionaryWithDictionary:fileWrapper.fileAttributes];
    
    self.createDate=[metaDict valueForKey:NSFileCreationDate];
    self.lastModificationDate=[metaDict valueForKey:NSFileModificationDate];
    NSString *type=[metaDict valueForKey:NSFileType];
    self.fileType=[self getFileType:type];
    self.isDirectory=self.fileType==EGFileTypeDirectory;
    self.absolutePath=[[[self.urlPath absoluteString]componentsSeparatedByString:@"file://"]lastObject];
    self.size=[[metaDict valueForKey:NSFileSize]intValue];
    NSLog(@"%lu",(unsigned long)self.rootDirType);
}

-(void)setAbsolutePath:(NSString *)absolutePath{
    _absolutePath=absolutePath;
    self.urlPath=[NSURL fileURLWithPath:absolutePath];
    NSArray *pathComponents=[absolutePath componentsSeparatedByString:@"."];
    if (!self.isDirectory && ![self.name hasPrefix:@"."]&&pathComponents.count>=2) {//not a directory and not a hidden file
        self.suffix=[pathComponents lastObject];
    }else{
        self.suffix=nil;
    }
}

-(NSString *)description{
    return [NSString stringWithFormat:@"[File]%@ -- [Type]%@ -- [Size]:%d",self.name,self.isDirectory?@"Directory":@"File",self.size];
}


#pragma mark ---------------file type convert---------------
-(EGFileType)getFileType:(NSString *)type{
    if ([type isEqualToString:NSFileTypeRegular]) {
        return EGFileTypeRegular;
    } else if ([type isEqualToString:NSFileTypeDirectory]) {
        return EGFileTypeDirectory;
    } else if ([type isEqualToString:NSFileTypeSymbolicLink]) {
        return EGFileTypeSymbolicLink;
    } else if ([type isEqualToString:NSFileTypeSocket]) {
        return EGFileTypeSocket;
    }else if ([type isEqualToString:NSFileTypeBlockSpecial]) {
        return EGFileTypeBlockSpecial;
    } else if ([type isEqualToString:NSFileTypeCharacterSpecial]) {
        return EGFileTypeCharacterSpecial;
    } else {
        return EGFileTypeUnknown;
    }
}
-(NSString *)getNSFileType:(EGFileType)type{
    switch (type) {
        case EGFileTypeRegular:
            return NSFileTypeRegular;
            break;
        case EGFileTypeDirectory:
            return NSFileTypeDirectory;
            break;
        case EGFileTypeSymbolicLink:
            return NSFileTypeSymbolicLink;
            break;
        case EGFileTypeSocket:
            return NSFileTypeSocket;
            break;
        case EGFileTypeBlockSpecial:
            return NSFileTypeBlockSpecial;
            break;
        case EGFileTypeCharacterSpecial:
            return NSFileTypeCharacterSpecial;
            break;
        default:
            return NSFileTypeUnknown;
            break;
    }
}

#pragma mark ---------------properties---------------

-(EGDirectoryType)rootDirType{
    if (_rootDirType==0) {
        NSString *relativePath=self.relativePath;
        NSArray *pathComponents=[relativePath pathComponents];
        if (pathComponents.count==1) {
            _rootDirType=EGDirectoryTypeHome;
        }else if (pathComponents.count>=2) {
            NSString *root=[pathComponents objectAtIndex:1];
            if ([root isEqualToString:@"Documents"]) {
                _rootDirType = EGDirectoryTypeDocument;
            } else if ([root isEqualToString:@"tmp"]) {
                _rootDirType = EGDirectoryTypeTmp;
            } else if ([root isEqualToString:@"Library"]) {
                if (pathComponents.count>=3) {
                    NSString *next=[pathComponents objectAtIndex:2];
                    if ([next isEqualToString:@"Caches"]) {
                        _rootDirType = EGDirectoryTypeCaches;
                    }else{
                        _rootDirType = EGDirectoryTypeLibrary;
                    }
                } else {
                    _rootDirType = EGDirectoryTypeLibrary;
                }
            }
        }else{
            _rootDirType = EGDirectoryTypeDefault;
        }
    }
    return _rootDirType;
}

-(NSString *)relativePath{
    if (_relativePath==nil) {
        NSString *home=[[EGFileManager manager]getHomeDirectoryPath];
        NSArray *arrHome=[self.absolutePath componentsSeparatedByString:home];
        if (arrHome.count==2) {
            _relativePath=[arrHome lastObject];
        }
    }
    return _relativePath;
}

-(EGFileKindType)kindType{
    if (_kindType==0) {
        if (self.suffix) {
            NSArray *keys=self.allTypes.allKeys;
            for (id key in keys) {
                NSArray *typeArrs=[self.allTypes objectForKey:key];
                if ([typeArrs containsObject:[self.suffix lowercaseString]]) {
                    _kindType=(EGFileKindType)[key integerValue];
                    break;
                }
            }
            if (_kindType==0) {
                _kindType=EGFileKindTypeOther;
            }
        }else{
            _kindType=EGFileKindTypeHasNoSuffix;
        }
    }
    return _kindType;
}
-(NSURL *)parentDirPath{
    if (_parentDirPath==nil) {
        NSMutableArray *pathArrM=[NSMutableArray arrayWithArray:[self.urlPath pathComponents]];
        [pathArrM removeLastObject];
        _parentDirPath=[NSURL fileURLWithPathComponents:pathArrM];
    }
    return _parentDirPath;
}
#pragma mark ---------------types defines---------------
-(NSDictionary *)allTypes{
    if (_allTypes==nil) {
        _allTypes=@{
                    @(EGFileKindTypeImage):@[@"png",@"jpeg",@"jpg",@"gif",@"tiff",@""],
                    @(EGFileKindTypeVideo):@[@"mp4",@"avi",@"mpeg"],
                    @(EGFileKindTypeAudio):@[@"mp3",@"ogg",@"ape"],
                    @(EGFileKindTypeJS):@[@"js"],
                    @(EGFileKindTypeHtml):@[@"html",@"htm"],
                    @(EGFileKindTypeCss):@[@"css"],
                    @(EGFileKindTypeDoc):@[@"doc",@"docx"],
                    @(EGFileKindTypeExcel):@[@"xls",@"xlsx"],
                    @(EGFileKindTypePdf):@[@"pdf"]
                    };
    }
    return _allTypes;
}

@end
