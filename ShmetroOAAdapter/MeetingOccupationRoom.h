//
//  MeetingOccupationRoom.h
//  ShmetroOA
//
//  Created by gisteam on 7/1/13.
//
//

#import <Foundation/Foundation.h>

@interface MeetingOccupationRoom : NSObject

@property(nonatomic,retain)NSString *mrId;
@property(nonatomic,retain)NSString *name;
@property(nonatomic,retain)NSString *meetOrg;
@property(nonatomic,retain)NSMutableArray *meetinglist;

@end
