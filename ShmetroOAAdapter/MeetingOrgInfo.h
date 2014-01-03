//
//  MeetingOrgInfo.h
//  ShmetroOA
//
//  Created by gisteam on 6/16/13.
//
//

#import <Foundation/Foundation.h>

@interface MeetingOrgInfo : NSObject
{
    NSString *orgId;
    NSString *name;
}
@property(nonatomic,retain)NSString *orgId;
@property(nonatomic,retain)NSString *name;

@end
