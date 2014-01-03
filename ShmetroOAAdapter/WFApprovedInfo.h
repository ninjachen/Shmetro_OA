//
//  WFApprovedInfo.h
//  ShmetroOA
//
//  Created by gisteam on 8/26/13.
//
//

#import <Foundation/Foundation.h>

@interface WFApprovedInfo : NSObject{
    NSString *guid;
    NSString *process;
    NSString *incidentno;
    NSString *dept;
    NSString *stepname;
    NSString *deptId;
    NSString *userName;
    NSString *userFullName;
    NSString *remark;
    NSString *upddate;
    NSString *agree;
    NSString *disagree;
    NSString *returned;
    NSString *status;
    NSString *fllowFlag;
    NSString *readFlag;
    NSString *rounds;
    NSString *upddateStr;
    NSString *optionCode;
}

@property (nonatomic,retain)NSString *guid;
@property (nonatomic,retain)NSString *process;
@property (nonatomic,retain)NSString *incidentno;
@property (nonatomic,retain)NSString *dept;
@property (nonatomic,retain)NSString *stepname;
@property (nonatomic,retain)NSString *deptId;
@property (nonatomic,retain)NSString *userName;
@property (nonatomic,retain)NSString *userFullName;
@property (nonatomic,retain)NSString *remark;
@property (nonatomic,retain)NSString *upddate;
@property (nonatomic,retain)NSString *agree;
@property (nonatomic,retain)NSString *disagree;
@property (nonatomic,retain)NSString *returned;
@property (nonatomic,retain)NSString *status;
@property (nonatomic,retain)NSString *fllowFlag;
@property (nonatomic,retain)NSString *readFlag;
@property (nonatomic,retain)NSString *rounds;
@property (nonatomic,retain)NSString *upddateStr;
@property (nonatomic,retain)NSString *optionCode;
@end
