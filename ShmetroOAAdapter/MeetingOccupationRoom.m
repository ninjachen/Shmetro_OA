//
//  MeetingOccupationRoom.m
//  ShmetroOA
//
//  Created by gisteam on 7/1/13.
//
//

#import "MeetingOccupationRoom.h"

@implementation MeetingOccupationRoom
@synthesize mrId,meetOrg,meetinglist,name;

-(void)dealloc{
    [mrId release];
    [name release];
    [meetinglist release];
    [meetOrg release];
    [super dealloc];
}
@end
