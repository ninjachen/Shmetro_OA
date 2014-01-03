//
//  NotificationContext.h
//  ShmetroOA
//
//  Created by caven shen on 11/15/12.
//
//

#import <Foundation/Foundation.h>

@interface NotificationContext : NSObject
+(id)singletonInstance;
-(id)init;

-(void)reflashUploadMonitor;
-(void)uploadChangeMonitor;
-(void)downloadChangeMonitor;
-(void)uploadChangeMonitor;
@end
