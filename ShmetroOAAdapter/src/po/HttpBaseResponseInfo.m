//
//  HttpBaseResponsePO.m
//  ShmetroOA
//
//  Created by  on 12-9-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HttpBaseResponseInfo.h"

@implementation HttpBaseResponseInfo
@synthesize code,description,respObj;

-(void)dealloc{
    [code release];
    [description release];
    [respObj release];
    [super dealloc];
}
@end
