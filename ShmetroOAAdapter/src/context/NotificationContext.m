//
//  NotificationContext.m
//  ShmetroOA
//
//  Created by caven shen on 11/15/12.
//
//

#import "NotificationContext.h"

@implementation NotificationContext
static NotificationContext *instance = NULL;

+(id)singletonInstance{
    if(instance==nil){
        instance = [[NotificationContext alloc]init];
        
    }
    return (instance);
}
-(id)init{
	self = [super init];
    if(self){
        
    }
    return self;
}
-(void)reflashUploadMonitor{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reflashUploadMonitor" object:nil];
}

-(void)uploadChangeMonitor{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"eyunUpload_uploadChangeMonitor" object:nil];
}
-(void)reflashDownloadMonitor{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reflashDownloadMonitor" object:nil];
}

-(void)downloadChangeMonitor{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"downloadChangeMonitor" object:nil];
    });
}
@end
