//
//  TodoInfo.h
//  ShmetroOA
//
//  Created by  on 12-9-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TodoInfo : NSObject{
    NSString *todoId;
    NSString *app;
    NSString *todoType;
    //相关业务表主键ID
    NSString *key;
    //待办项发生时间
    NSString *occurTime;
    NSString *title;
    NSString *data;
    NSString *userId;
    NSString *loginName;
    NSString *status;
    NSString *removed;
    NSString *deptId;
    NSString *steplabel;
    
//    主送单位ID
    NSString *mainUnitId;
//    主送单位
    NSString *mainUnit;
//    抄送单位ID
    NSString *copyUnitId;
//    抄送单位
    NSString *copyUnit;
//    联系时间
    NSString *contactDate;
//    要求回复时间
    NSString *replyDate;
//    时间差
    NSString *timeDiff;
//    主题
    NSString *theme;
//    内容概述
    NSString *content;
//    内容附件编号
    NSString *contentAttachmentId;
//    流程名称
    NSString *processname;
//    流程实例号
    NSString *incidentno;
//    编号
    NSString *serial;
//    发起部门ID
    NSString *createDeptid;
//    发起部门名称
    NSString *createDeptName;
//    发起人工号
    NSString *initiator;
//    发起人姓名
    NSString *initiatorName;
//    开始时间
    NSString *startTime;
//    最新内容变化时间
    NSString *updateTime;
//    修改人工号
    NSString *operateUser;
//    修改人姓名
    NSString *operateName;
//    修改日期
    NSString *operateDate;
    NSString *recordPath;
    NSString *processFlag;
    NSString *processText;
    NSString *uploadfilegroupid;
    NSArray *applyApprovedArr;
    NSArray *subApprovedArr;
    NSArray *backApplyApprovedArr;
}

@property (nonatomic,retain) NSString *todoId;
@property (nonatomic,retain) NSString *app;
@property (nonatomic,retain) NSString *todoType;
//相关业务表主键ID
@property (nonatomic,retain) NSString *key;
//待办项发生时间
@property (nonatomic,retain) NSString *occurTime;
@property (nonatomic,retain) NSString *title;
@property (nonatomic,retain) NSString *data;
@property (nonatomic,retain) NSString *userId;
@property (nonatomic,retain) NSString *loginName;
@property (nonatomic,retain) NSString *status;
@property (nonatomic,retain) NSString *removed;
@property (nonatomic,retain) NSString *deptId;


@property (nonatomic,retain) NSString *mainUnitId;
@property (nonatomic,retain) NSString *mainUnit;
@property (nonatomic,retain) NSString *copyUnitId;
@property (nonatomic,retain) NSString *copyUnit;
@property (nonatomic,retain) NSString *contactDate;
@property (nonatomic,retain) NSString *replyDate;
@property (nonatomic,retain) NSString *timeDiff;
@property (nonatomic,retain) NSString *theme;
@property (nonatomic,retain) NSString *content;
@property (nonatomic,retain) NSString *contentAttachmentId;
@property (nonatomic,retain) NSString *processname;
@property (nonatomic,retain) NSString *incidentno;
@property (nonatomic,retain) NSString *serial;
@property (nonatomic,retain) NSString *createDeptid;
@property (nonatomic,retain) NSString *createDeptName;
@property (nonatomic,retain) NSString *initiator;
@property (nonatomic,retain) NSString *initiatorName;
@property (nonatomic,retain) NSString *startTime;
@property (nonatomic,retain) NSString *updateTime;
@property (nonatomic,retain) NSString *operateUser;
@property (nonatomic,retain) NSString *operateName;
@property (nonatomic,retain) NSString *operateDate;
@property (nonatomic,retain) NSString *instanceId;
@property (nonatomic,retain) NSString *recordPath;
@property (nonatomic,retain) NSString *processFlag;
@property (nonatomic,retain) NSString *processText;
@property (nonatomic,retain) NSString *steplabel;
@property (nonatomic,retain) NSString *uploadfilegroupid;

@property (nonatomic,retain) NSArray *applyApprovedArr;
@property (nonatomic,retain) NSArray *subApprovedArr;
@property (nonatomic,retain) NSArray *backApplyApprovedArr;
@property (nonatomic,retain) NSArray *attachmentFileArr;
-(NSMutableDictionary *)getTodoInfoDic;
-(NSArray *)getContentAttachmentFileArr;
@end
