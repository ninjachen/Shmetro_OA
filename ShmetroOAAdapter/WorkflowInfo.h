//
//  WorkflowInfo.h
//  ShmetroOA
//
//  Created by gisteam on 8/14/13.
//
//

#import <Foundation/Foundation.h>

@interface WorkflowInfo : NSObject

@property(nonatomic,retain)NSString *sendId;//发文字号
@property(nonatomic,retain)NSString *id;
@property(nonatomic,retain)NSString *app;
@property(nonatomic,retain)NSString *pid;
@property(nonatomic,retain)NSString *occurTime;
@property(nonatomic,retain)NSString *typeName;
@property(nonatomic,retain)NSString *pname;
@property(nonatomic,retain)NSString *cname;
@property(nonatomic,retain)NSString *stepname;
@property(nonatomic,retain)NSString *docClass;
@property(nonatomic,retain)NSString *secretClass;
@property(nonatomic,retain)NSString *hj;
@property(nonatomic,retain)NSString *fileType;
@property(nonatomic,retain)NSString *secretLimit;
@property(nonatomic,retain)NSString *docTitle;
@property(nonatomic,retain)NSString *sendMain;
@property(nonatomic,retain)NSString *sendMainId;
@property(nonatomic,retain)NSString *sendCopy;
@property(nonatomic,retain)NSString *sendInside;
@property(nonatomic,retain)NSString *sendInsideId;
@property(nonatomic,retain)NSString *sendType;
@property(nonatomic,retain)NSString *contentAttMain;
@property(nonatomic,retain)NSString *typeTitle;
@property(nonatomic,retain)NSString *sendTitleType;
@property(nonatomic,retain)NSString *sendUser;
@property(nonatomic,retain)NSString *sendUserLeader;
@property(nonatomic,retain)NSString *sendUserdept;
@property(nonatomic,retain)NSString *operator;
@property(nonatomic,retain)NSString *sendDate;
@property(nonatomic,retain)NSString *docCount;
@property(nonatomic,retain)NSString *operateTime;
@property(nonatomic,retain)NSString *processText;
@end
