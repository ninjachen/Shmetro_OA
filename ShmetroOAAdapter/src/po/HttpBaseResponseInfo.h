//
//  HttpBaseResponsePO.h
//  ShmetroOA
//
//  Created by  on 12-9-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpBaseResponseInfo : NSObject{
    NSString *code;
    NSString *description;
    NSObject *respObj;
}
@property (nonatomic,retain) NSString *code;
@property (nonatomic,retain) NSString *description;
@property (nonatomic,retain) NSObject *respObj;

@end
