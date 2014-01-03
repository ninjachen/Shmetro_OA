//
//  MessageListInfo.m
//  ShmetroOA
//
//  Created by gisteam on 6/13/13.
//
//

#import "MessageListInfo.h"

@implementation MessageListInfo
@synthesize messageId,title,pubDate;

-(void)dealloc{
    [messageId release];
    [title release];
    [pubDate release];
    [super dealloc];
}
@end
