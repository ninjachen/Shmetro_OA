//
//  FileInfo.h
//  EYun
//
//  Created by caven on 11-9-6.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FileInfo : NSObject {
    NSString *index;
    NSString *fileID;
    NSString *fileName;
    NSString *fileType;
    NSString *fileSize;
    NSString *status;
    NSString *uploadStatus;
    NSString *uploadType;
    NSString *createTime;
    NSString *downloadUrl;
    NSString *localPath;
    NSString *date;
    NSString *localDate;
    NSString *localModifyTime;
    NSString *uploadFlag;
    NSString *downloadFlag;
    int percent;
    long offset;
    NSString *syncFlag;
    NSString *mediaPath;
    NSString *groupId;
    NSString *todoId;
}
@property (nonatomic,retain) NSString *index;
@property (nonatomic,retain) NSString *fileID;
@property (nonatomic,retain) NSString *fileName;
@property (nonatomic,retain) NSString *fileType;
@property (nonatomic,retain) NSString *fileSize;
@property (nonatomic,retain) NSString *status;
@property (nonatomic,retain) NSString *uploadStatus;
@property (nonatomic,retain) NSString *uploadType;
@property (nonatomic,retain) NSString *createTime;
@property (nonatomic,retain) NSString *downloadUrl;
@property (nonatomic,retain) NSString *localPath;
@property (nonatomic,retain) NSString *date;
@property (nonatomic,retain) NSString *localDate;
@property (nonatomic,retain) NSString *localModifyTime;
@property (nonatomic,retain) NSString *uploadFlag;
@property (nonatomic,retain) NSString *downloadFlag;
@property (nonatomic) int percent;
@property (nonatomic) long offset;
@property (nonatomic,retain) NSString *syncFlag;
@property (nonatomic,retain) NSString *mediaPath;
@property (nonatomic,retain) NSString *groupId;
@property (nonatomic,retain) NSString *todoId;
+(NSString *)DOWNLOAD_FLAG_BEGIN;
+(NSString *)DOWNLOAD_FLAG_ING;
+(NSString *)DOWNLOAD_FLAG_SUCCESS;
+(NSString *)DOWNLOAD_FLAG_FAIL;

+(NSString *)UPLOAD_FLAG_BEGIN;
+(NSString *)UPLOAD_FLAG_ING;
+(NSString *)UPLOAD_FLAG_SUCCESS;
+(NSString *)UPLOAD_FLAG_FAIL;

-(NSString *)getLocalFilePath;
-(void)download;
-(BOOL)isDownloading;
-(BOOL)checkDownloadPercentChange:(int)percent;
@end
