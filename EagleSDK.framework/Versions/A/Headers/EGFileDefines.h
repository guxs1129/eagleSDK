//
//  EGFileDefines.h
//  FileHelper
//
//  Created by 顾新生 on 2018/1/16.
//  Copyright © 2018年 顾新生. All rights reserved.
//

#ifndef EGFileDefines_h
#define EGFileDefines_h
@class EGFileWrapper;
typedef NS_ENUM(NSInteger,EGFileType) {
    EGFileTypeRegular=1,
    EGFileTypeDirectory,
    EGFileTypeSymbolicLink,
    EGFileTypeSocket,
    EGFileTypeCharacterSpecial,
    EGFileTypeBlockSpecial,
    EGFileTypeUnknown
};

typedef NS_ENUM(NSUInteger, EGDirectoryType){
    EGDirectoryTypeHome=1,
    EGDirectoryTypeDocument,
    EGDirectoryTypeCaches,
    EGDirectoryTypeLibrary,
    EGDirectoryTypeTmp,
    EGDirectoryTypeDefault   //present somethings under main directories
};

typedef NS_ENUM(NSInteger,EGFileKindType) {
    EGFileKindTypeImage=1,
    EGFileKindTypeVideo,
    EGFileKindTypeAudio,
    EGFileKindTypeJS,
    EGFileKindTypeHtml,
    EGFileKindTypeCss,
    EGFileKindTypeDoc,
    EGFileKindTypeExcel,
    EGFileKindTypePdf,
    EGFileKindTypeOther,
    EGFileKindTypeHasNoSuffix
};

typedef void(^ResultHandler) (NSArray<EGFileWrapper *> *result,NSError *error);
typedef void(^AddFileResultHandler) (BOOL isSucess,EGFileWrapper *fileWrapper,NSError *error);

#endif /* EGFileDefines_h */
