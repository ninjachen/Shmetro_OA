//
//  MeetingDetailInfo.m
//  ShmetroOA
//
//  Created by gisteam on 6/16/13.
//
//

#import "MeetingInfo.h"

@implementation MeetingInfo
@synthesize mId,meetId,title,startDate,startTime,endTime;
@synthesize address,topic,compere,present,presentOther,dept,memo;

-(void)dealloc{
    [mId release];
    [meetId release];
    [title release];
    [startDate release];
    [startTime release];
    [endTime release];
    [address release];
    [topic release];
    [compere release];
    [present release];
    [presentOther release];
    [dept release];
    [memo release];
    [super dealloc];
}

-(NSMutableDictionary *)getMeetingInfoDic{
    NSMutableDictionary *respDic = [[[NSMutableDictionary alloc]init] autorelease];
    [respDic setValue:meetId==nil?@" ":meetId forKey:@"会议编号"];
    [respDic setValue:title==nil?@" ":title forKey:@"会议标题"];
    [respDic setValue:startDate==nil?@" ":startDate forKey:@"开始日期"];
    [respDic setValue:startTime==nil?@" ":startTime forKey:@"开始时间"];
    [respDic setValue:endTime==nil?@" ":endTime forKey:@"结束时间"];
    [respDic setValue:address==nil?@" ":address forKey:@"会议地点"];
    [respDic setValue:topic==nil?@" ":topic forKey:@"会议议题"];
    [respDic setValue:compere==nil?@" ":compere forKey:@"会议主持人"];
    [respDic setValue:present==nil?@" ":present forKey:@"会议参与人（集团内部）"];
    [respDic setValue:presentOther==nil?@" ":presentOther forKey:@"会议参与人（集团外部）"];
    [respDic setValue:dept==nil?@" ":dept forKey:@"会议参与部门（集团内部"];
    [respDic setValue:memo==nil?@" ":memo forKey:@"备注"];
    return respDic;
}
@end
