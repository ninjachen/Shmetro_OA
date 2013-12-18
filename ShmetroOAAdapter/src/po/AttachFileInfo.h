//
//  AttachFileInfo.h
//  ShmetroOA
//
//  Created by  on 12-9-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AttachFileInfo : NSObject{
    NSString *fileId;
    NSString *fileName;
    NSString *fileExtName;
    NSString *path;
    NSString *fileSize;
    NSString *uploader;
    NSString *uploaderLoginName;
    NSString *uploadDate;
    NSString *groupId;
    NSString *appName;
    NSString *saveFileName;
    NSString *memo;
    NSString *version;
    NSString *status;
    NSString *operateTime;
    NSString *removed;
    NSString *pid;
    NSString *localPath;
    NSString *downloadUrl;
}
@property (nonatomic,retain) NSString *fileId;
@property (nonatomic,retain) NSString *fileName;
@property (nonatomic,retain) NSString *fileExtName;
@property (nonatomic,retain) NSString *path;
@property (nonatomic,retain) NSString *fileSize;
@property (nonatomic,retain) NSString *uploader;
@property (nonatomic,retain) NSString *uploaderLoginName;
@property (nonatomic,retain) NSString *uploadDate;
@property (nonatomic,retain) NSString *groupId;
@property (nonatomic,retain) NSString *appName;
@property (nonatomic,retain) NSString *saveFileName;
@property (nonatomic,retain) NSString *memo;
@property (nonatomic,retain) NSString *version;
@property (nonatomic,retain) NSString *status;
@property (nonatomic,retain) NSString *operateTime;
@property (nonatomic,retain) NSString *removed;
@property (nonatomic,retain) NSString *pid;
@property (nonatomic,retain) NSString *localPath;
@property (nonatomic,retain) NSString *downloadUrl;
@end
