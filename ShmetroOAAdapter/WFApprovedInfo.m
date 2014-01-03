//
//  WFApprovedInfo.m
//  ShmetroOA
//
//  Created by gisteam on 8/26/13.
//
//

#import "WFApprovedInfo.h"

@implementation WFApprovedInfo
@synthesize guid,process,incidentno;
@synthesize dept,deptId,stepname,userName,userFullName;
@synthesize remark,upddate,upddateStr;
@synthesize agree,disagree,returned,readFlag,status,fllowFlag,rounds,optionCode;

-(void)dealloc{
    [guid release];
    [process release];
    [incidentno release];
    [dept release];
    [deptId release];
    [stepname release];
    [userFullName release];
    [userName release];
    [remark release];
    [upddate release];
    [agree release];
    [disagree release];
    [returned release];
    [status release];
    [fllowFlag release];
    [readFlag release];
    [rounds release];
    [upddateStr release];
    [optionCode release];
    [super dealloc];
}
@end
