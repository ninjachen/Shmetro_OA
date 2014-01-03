//
//  MeetingDetailInfo.h
//  ShmetroOA
//
//  Created by gisteam on 6/16/13.
//
//

#import <Foundation/Foundation.h>

@interface MeetingInfo : NSObject{
    NSString *mId;
    NSString *meetId;
    NSString *title;
    NSNumber *startDate;
    NSString *startTime;
    NSString *endTime;
    NSString *address;
    NSString *topic;
    NSString *compere;
    NSString *present;
    NSString *presentOther;
    NSString *dept;
    NSString *memo;
}

@property(nonatomic,retain) NSString *mId;
@property(nonatomic,retain) NSString *meetId;
@property(nonatomic,retain) NSString *title;
@property(nonatomic,retain) NSNumber *startDate;
@property(nonatomic,retain) NSString *startTime;
@property(nonatomic,retain) NSString *endTime;
@property(nonatomic,retain) NSString *address;
@property(nonatomic,retain) NSString *topic;
@property(nonatomic,retain) NSString *compere;
@property(nonatomic,retain) NSString *present;
@property(nonatomic,retain) NSString *presentOther;
@property(nonatomic,retain) NSString *dept;
@property(nonatomic,retain) NSString *memo;

-(NSMutableDictionary *)getMeetingInfoDic;
@end
