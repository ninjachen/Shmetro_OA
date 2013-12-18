//
//  StringUtil.h
//  EYun
//
//  Created by caven on 11-9-5.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringUtil : NSObject {
    
}
+(NSString *)md5Digest:(NSString *)str;
+(NSString *)getIdentifider;
+(NSString *)getDateString;
+(BOOL)isValidateEmail:(NSString *)email;
+(NSString *)formatDateString:(NSString *)date;
+(NSString *)encodeToPercentEscapeString:(NSString *)string;
+(NSString *)pinyinFirstLetter:(NSString *)str;
+ (NSString*)TripleDES:(NSString*)plainText;
+(NSString *)convertFileSize:(NSString *)size;
+(NSData *)encryptByRsa:(NSString *)plainText error:(NSError **)err;
@end
