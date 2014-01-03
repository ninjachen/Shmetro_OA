//
//  DateUtil.m
//  ShmetroOA
//
//  Created by gisteam on 7/2/13.
//
//

#import "DateUtil.h"

@implementation DateUtil

+(NSNumber *)convertStringToNumber:(NSString *)dateString{
    NSDateFormatter *dataFormatter = [[[NSDateFormatter alloc]init]autorelease];
    [dataFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dataFormatter dateFromString:dateString];
    NSNumber *dateNumber =[NSNumber numberWithDouble:[date timeIntervalSinceReferenceDate]];
    return dateNumber;
}

+(NSString*)convertNumberToString:(NSNumber *)dateNumber{
    NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:[dateNumber doubleValue]];
    NSDateFormatter *dataFormatter = [[[NSDateFormatter alloc]init]autorelease];
    [dataFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dataFormatter stringFromDate:date];
    return dateString;
}

+(NSNumber *)addDay:(NSInteger*)dayNum AppendDate:(NSNumber *)date{
    int dayInterval = dayNum;
    NSTimeInterval days= dayInterval * 24 * 60 * 60;
    double newdayValue = [date doubleValue] +days;
    NSNumber *dateNumber =[NSNumber numberWithDouble:newdayValue];
    return dateNumber;
}

+(NSString *)convertDateToString:(NSDate *)date{
    NSDateFormatter *dataFormatter = [[[NSDateFormatter alloc]init]autorelease];
    [dataFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dataFormatter stringFromDate:date];
    return dateString;
}

+(NSString *)getNextDay:(NSString *)currentday{
    NSNumber *dayNum = [DateUtil convertStringToNumber:currentday];
    dayNum = [DateUtil addDay:1 AppendDate:dayNum];
    
    NSString *nextday = [DateUtil convertNumberToString:dayNum];
    return nextday;    
}

+(NSString *)getPreDay:(NSString *)currentday{
    NSNumber *dayNum = [DateUtil convertStringToNumber:currentday];
    dayNum = [DateUtil addDay:-1 AppendDate:dayNum];
    
    NSString *nextday = [DateUtil convertNumberToString:dayNum];
    return nextday;
}
@end
