//
//  MeetingRoomInfo.h
//  ShmetroOA
//
//  Created by gisteam on 6/16/13.
//
//

#import <Foundation/Foundation.h>

@interface MeetingRoomInfo : NSObject{
    NSString *mrId;
    NSString *address;
    NSString *equip;
    NSString *load;
    NSString *name;
    NSString *org;
}

@property(nonatomic,retain) NSString *mrId;
@property(nonatomic,retain) NSString *address;
@property(nonatomic,retain) NSString *equip;
@property(nonatomic,retain) NSString *load;
@property(nonatomic,retain) NSString *name;
@property(nonatomic,retain) NSString *org;

@end
