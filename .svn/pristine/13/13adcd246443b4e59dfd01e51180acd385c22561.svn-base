//
//  FileInfo.m
//  EYun
//
//  Created by caven on 11-9-6.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "FileInfo.h"
#import "FileInfoDao.h"
@implementation FileInfo

static NSString *DOWNLOAD_FLAG_BEGIN = @"00";
static NSString *DOWNLOAD_FLAG_ING = @"01";
static NSString *DOWNLOAD_FLAG_SUCCESS = @"02";
static NSString *DOWNLOAD_FLAG_FAIL = @"03";

static NSString *UPLOAD_FLAG_BEGIN = @"10";
static NSString *UPLOAD_FLAG_ING = @"11";
static NSString *UPLOAD_FLAG_SUCCESS = @"13";
static NSString *UPLOAD_FLAG_FAIL = @"14";

@synthesize createTime,date,downloadFlag,downloadUrl,fileID,fileName,fileSize,fileType,index,localDate,localModifyTime,localPath,mediaPath,offset,percent,status,syncFlag,uploadFlag,uploadStatus,uploadType;
@synthesize groupId,todoId;
+(NSString *)DOWNLOAD_FLAG_BEGIN{
    return DOWNLOAD_FLAG_BEGIN;
}
+(NSString *)DOWNLOAD_FLAG_ING{
    return DOWNLOAD_FLAG_ING;
}
+(NSString *)DOWNLOAD_FLAG_SUCCESS{
    return DOWNLOAD_FLAG_SUCCESS;
}
+(NSString *)DOWNLOAD_FLAG_FAIL{
    return DOWNLOAD_FLAG_FAIL;
}

+(NSString *)UPLOAD_FLAG_BEGIN{
    return UPLOAD_FLAG_BEGIN;
}
+(NSString *)UPLOAD_FLAG_ING{
    return UPLOAD_FLAG_ING;
}
+(NSString *)UPLOAD_FLAG_SUCCESS{
    return UPLOAD_FLAG_SUCCESS;
}
+(NSString *)UPLOAD_FLAG_FAIL{
    return UPLOAD_FLAG_FAIL;
}
-(NSString *)getLocalFilePath{
    NSString *resp = self.localPath;
    if (resp!=nil) {
        NSFileManager *fm = [NSFileManager defaultManager];
        if ([fm fileExistsAtPath:resp]) {
            NSDictionary *fileAttributes = [fm fileAttributesAtPath:self.localPath traverseLink:YES];
            if ([self.fileSize longLongValue]==[fileAttributes fileSize]) {
                resp=self.localPath;
            }else {
                if (uploadFlag!=nil&&uploadFlag==UPLOAD_FLAG_SUCCESS) {
                    [fm removeItemAtPath:self.localPath error:nil];
                }
                
                resp = nil;
            }
        }else {
            resp = nil;
        }
    }
    return resp;
}

-(BOOL)isDownloading{
//    BOOL resp = NO;
//    FileInfoDao *dao = [[FileInfoDao alloc]init];
//    FileInfo *tmpFileInfo = [dao getFileInfo:self.fileID];
//    [dao release];
//    self.downloadFlag = tmpFileInfo.downloadFlag;
//    if (self.downloadFlag!=nil) {
//        if ([self.downloadFlag isEqualToString:DOWNLOAD_FLAG_BEGIN]||[self.downloadFlag isEqualToString:DOWNLOAD_FLAG_ING]||[self.downloadFlag isEqualToString:DOWNLOAD_FLAG_FAIL]) {
//            resp = YES;
//        }
//    }
//    
//    return resp;
}

-(BOOL)checkDownloadPercentChange:(int)percent{
    FileInfoDao *dao = [[FileInfoDao alloc]init];
    FileInfo *tmpFileInfo = [dao getFileInfoByIndex:self.index];
    [dao release];
    
    int percentChange = fabs(tmpFileInfo.percent-percent);
    return percentChange>=4;
}
-(void)download{
//    if (![self isDownloading]) {
//        [[FileDownloadContext singletonInstance] put:self];
//    }
}
-(void)dealloc{
    [groupId release];
    [createTime release];
    [status release];
    [fileID release];
    [fileName release];
    [fileType release];
    [uploadType release];
    [uploadStatus release];
    [downloadUrl release];
    [localPath release];
    [date release];
    [fileSize release];
    [localDate release];
    [index release];
    [localModifyTime release];
    [uploadFlag release];
    [downloadFlag release];
    [syncFlag release];
    [mediaPath release];
    [todoId release];
    [super dealloc];
}
@end
