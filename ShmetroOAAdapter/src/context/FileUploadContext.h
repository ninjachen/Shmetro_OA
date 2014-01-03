//
//  FileUploadContext.h
//  ShmetroOA
//
//  Created by caven shen on 11/15/12.
//
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"
#include <netinet/in.h>
#import "UserAccountContext.h"
#import <SystemConfiguration/SCNetworkReachability.h>
#import "ApiConfig.h"
#import "FileInfo.h"
@interface FileUploadContext : NSObject<ASIHTTPRequestDelegate,ASIProgressDelegate,UIAlertViewDelegate> {
    NSMutableArray *uploadQueue;
    ASINetworkQueue *networkQueue;
    NSTimer *uploadTimmer;
    Boolean isUploadding;
    ASIFormDataRequest *currentUploadRequest;
    NSString *currentUploadFileIndex;
}
@property (nonatomic,retain) NSMutableArray *uploadQueue;
@property (nonatomic,retain) NSTimer *uploadTimmer;
@property (nonatomic,retain) ASINetworkQueue *networkQueue;
@property (nonatomic,retain) ASIFormDataRequest *currentUploadRequest;
@property (nonatomic,retain) NSString *currentUploadFileIndex;
@property Boolean isUploadding;
+(id)singletonInstance;
-(id)init;
-(void)put:(FileInfo *)fileInfo;
-(void)putLocalFile:(NSString *)filePath TodoId:(NSString *)todoId;
@end
