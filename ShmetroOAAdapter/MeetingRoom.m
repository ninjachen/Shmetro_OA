//
//  MeetingRoom.m
//  ShmetroOA
//
//  Created by gisteam on 6/24/13.
//
//

#import "MeetingRoom.h"

@implementation MeetingRoom
@synthesize mrId,meetOrg,name;
@synthesize monMeetinglist,tueMeetinglist,wedMeetinglist,thuMeetinglist,friMeetinglist,satMeetinglist,sunMeetinglist;

-(id)init{
    self = [super init];
    if (self) {
        NSMutableArray *tmpMonarray = [[NSMutableArray alloc]init];
        self.monMeetinglist = tmpMonarray;
        [tmpMonarray release];
        
        NSMutableArray *tmpTuearray = [[NSMutableArray alloc]init];
        self.tueMeetinglist = tmpTuearray;
        [tmpTuearray release];
        
        NSMutableArray *tmpWedarray = [[NSMutableArray alloc]init];
        self.wedMeetinglist = tmpWedarray;
        [tmpWedarray release];
        
        NSMutableArray *tmpThuarray = [[NSMutableArray alloc]init];
        self.thuMeetinglist = tmpThuarray;
        [tmpThuarray release];
        
        NSMutableArray *tmpFriarray = [[NSMutableArray alloc]init];
        self.friMeetinglist = tmpFriarray;
        [tmpFriarray release];
        
        NSMutableArray *tmpSatarray = [[NSMutableArray alloc]init];
        self.satMeetinglist = tmpSatarray;
        [tmpSatarray release];
        
        NSMutableArray *tmpSunarray = [[NSMutableArray alloc]init];
        self.sunMeetinglist = tmpSunarray;
        [tmpSunarray release];
//        self.monMeetinglist = [[[NSMutableArray alloc]init]autorelease];
//        self.tueMeetinglist =[[[NSMutableArray alloc]init]autorelease];
//        self.wedMeetinglist =[[[NSMutableArray alloc]init]autorelease];
//        self.thuMeetinglist = [[[NSMutableArray alloc]init]autorelease];
//        self.friMeetinglist = [[[NSMutableArray alloc]init]autorelease];
//        self.satMeetinglist = [[[NSMutableArray alloc]init]autorelease];
//        self.sunMeetinglist = [[[NSMutableArray alloc]init]autorelease];
    }
    return self;
}
-(void)dealloc{
    [mrId release];
    [name release];
    [meetOrg release];
    [monMeetinglist release];
    [tueMeetinglist release];
    [thuMeetinglist release];
    [friMeetinglist release];
    [satMeetinglist release];
    [sunMeetinglist release];
    [super dealloc];
}

@end
