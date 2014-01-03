//
//  UserAccountContext.m
//  ShmetroOA
//
//  Created by  on 12-9-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UserAccountContext.h"
#import "FileUtil.h"
@interface UserAccountContext(PrivateMethods)
-(void)initUserInfo;
@end
@implementation UserAccountContext
@synthesize userAccountInfo;
static UserAccountContext *instance = NULL;
Boolean isSign;
+(id)singletonInstance{
    if(instance==nil){
        instance = [[UserAccountContext alloc]init];
        
    }
    return (instance);
}
-(id)init{
	self = [super init];
    if(self){
        isSign = NO;
        [self initUserInfo];
    }
    return self;
}

-(void)initUserInfo{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *signInfoPath=[path stringByAppendingPathComponent:@"signInfo.plist"]; 	
	NSMutableArray *array = [[[NSArray alloc] initWithContentsOfFile:signInfoPath] autorelease];
    UserAccountInfo *userObj = [[[UserAccountInfo alloc]init] autorelease];
    if (array!=nil) {
        if ([array objectAtIndex:0]) {
            userObj.userId = [array objectAtIndex:0];
        }
        if ([array objectAtIndex:1]) {
            userObj.token = [array objectAtIndex:1];
        }
        if ([array objectAtIndex:2]) {
            userObj.loginName = [array objectAtIndex:2];
        }
        if ([array objectAtIndex:3]) {
            userObj.md5Sign = [array objectAtIndex:3];
        }
        if ([array objectAtIndex:4]) {
            userObj.md5Pass = [array objectAtIndex:4];
        }
        if ([array objectAtIndex:5]) {
            userObj.userName = [array objectAtIndex:5];
        }
        if ([array objectAtIndex:6]) {
            userObj.deptId = [array objectAtIndex:6];
        }
        if ([array objectAtIndex:7]) {
            userObj.deptName = [array objectAtIndex:7];
        }
    }
    if (userObj.userId!=nil) {
        self.userAccountInfo = userObj;
        isSign = YES;
    }
}

-(Boolean)isSign{
    return isSign;
}

-(void)updateUserInfo:(UserAccountInfo *)userInfo{
    self.userAccountInfo = userInfo;
    isSign = YES;
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *signInfoPath=[path stringByAppendingPathComponent:@"signInfo.plist"]; 	
	
	NSMutableArray *array = [[NSMutableArray alloc]init];
    [array insertObject:userInfo.userId atIndex:0];
    [array insertObject:userInfo.token atIndex:1];
    [array insertObject:userInfo.loginName atIndex:2];
    [array insertObject:userInfo.md5Sign atIndex:3];
    [array insertObject:userInfo.md5Pass atIndex:4];
    [array insertObject:userInfo.userName atIndex:5];
    [array insertObject:userInfo.deptId atIndex:6];
    [array insertObject:userInfo.deptName atIndex:7];
    [array writeToFile:signInfoPath atomically:YES];
    [array release];
}

-(void)userLogout{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *signInfoPath=[path stringByAppendingPathComponent:@"signInfo.plist"];
    [FileUtil deleteSingleFile:signInfoPath];
    self.userAccountInfo = nil;
}

@end
