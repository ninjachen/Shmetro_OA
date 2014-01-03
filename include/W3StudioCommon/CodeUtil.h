//
//  CodeUtil.h
//  DoctorAssistant
//
//  Created by  on 12-2-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CodeUtil : NSObject
+(NSString *)decodeStr:(NSString *)encodeStr;
+(NSString *)encodeStr:(NSString *)str;
+(NSData*) gzipData: (NSData*)pUncompressedData;
@end
