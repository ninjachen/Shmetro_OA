//
//  AttachFileInfo.m
//  ShmetroOA
//
//  Created by  on 12-9-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AttachFileInfo.h"

@implementation AttachFileInfo
@synthesize memo,path,fileId,status,appName,groupId,removed,version,fileName,fileSize,uploader,uploadDate,fileExtName,operateTime,saveFileName,uploaderLoginName,pid;
@synthesize localPath,downloadUrl;
-(void)dealloc{
    [memo release];
    [path release];
    [fileId release];
    [status release];
    [appName release];
    [groupId release];
    [removed release];
    [version release];
    [fileName release];
    [fileSize release];
    [uploader release];
    [uploadDate release];
    [fileExtName release];
    [operateTime release];
    [saveFileName release];
    [pid release];
    [localPath release];
    [downloadUrl release];
    [super dealloc];
}
@end
