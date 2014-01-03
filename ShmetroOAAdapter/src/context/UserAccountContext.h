//
//  UserAccountContext.h
//  ShmetroOA
//
//  Created by  on 12-9-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "UserAccountInfo.h"
#import <Foundation/Foundation.h>

@interface UserAccountContext : NSObject{
    UserAccountInfo *userAccountInfo;
}
@property (nonatomic,retain) UserAccountInfo *userAccountInfo;

+(id)singletonInstance;
-(void)updateUserInfo:(UserAccountInfo *)userInfo;
-(Boolean)isSign;
-(void)userLogout;
@end
