//
//  UserAccountInfo.m
//  ShmetroOA
//
//  Created by  on 12-9-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UserAccountInfo.h"

@implementation UserAccountInfo
@synthesize userId,userName,md5Pass,loginName,token,md5Sign,deptId,deptName,desPass;

-(void)dealloc{
    [userId release];
    [userName release];
    [md5Pass release];
    [loginName release];
    [token release];
    [md5Sign release];
    [desPass release];
    [deptId release];
    [deptName release];
    [super dealloc];
}

@end
