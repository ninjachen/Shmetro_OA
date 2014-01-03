//
//  MessageDetailInfo.m
//  ShmetroOA
//
//  Created by gisteam on 6/13/13.
//
//

#import "MessageDetailInfo.h"

@implementation MessageDetailInfo
@synthesize mid,title,pubDate,source,content,attachId,app;

-(void)dealloc{
    [mid release];
    [title release];
    [pubDate release];
    [source release];
    [content release];
    [attachId release];
    [app release];
    [super dealloc];
}
@end
