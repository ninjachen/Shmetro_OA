//
//  DateUtil.h
//  ShmetroOA
//
//  Created by gisteam on 7/2/13.
//
//

#import <Foundation/Foundation.h>

@interface DateUtil : NSObject


+(NSNumber *)convertStringToNumber:(NSString *)dateString;
+(NSString *)convertNumberToString:(NSNumber *)dateNumber;
+(NSString *)convertDateToString:(NSDate *)date;
+(NSString *)getNextDay:(NSString *)currentday;
+(NSString *)getPreDay:(NSString *)currentday;
+(NSNumber *)addDay:(NSInteger*)dayNum AppendDate:(NSNumber *)dateString;

@end
