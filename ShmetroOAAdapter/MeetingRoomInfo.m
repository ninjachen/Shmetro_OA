//
//  MeetingRoomInfo.m
//  ShmetroOA
//
//  Created by gisteam on 6/16/13.
//
//

#import "MeetingRoomInfo.h"

@implementation MeetingRoomInfo
@synthesize mrId,equip,address,load,name,org;

-(void)dealloc{
    [mrId release];
    [address release];
    [equip release];
    [load release];
    [name release];
    [org release];
    [super dealloc];
}

@end
