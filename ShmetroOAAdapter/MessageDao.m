//
//  MessageDao.m
//  ShmetroOA
//
//  Created by gisteam on 6/14/13.
//
//

#import "MessageDao.h"
#import "MessageDetailInfo.h"
#import "SystemContext.h"
#include "JSON.h"
#import "NSString+SBJSON.h"
#define TABLE_NAME @"messageinfo"

@interface MessageDao(PrivateMethods)
-(BOOL)containsKey:(NSString *)mid;
-(void)setMessageInfoProp:(FMResultSet *)rs MessageDetailInfo:(MessageDetailInfo *)messageInfo;
@end

@implementation MessageDao
-(BOOL)insert:(MessageDetailInfo *)messageInfo{
    if (![self containsKey:messageInfo.mid]) {
        [db executeUpdate:[self SQL:@"INSERT INTO %@ (title,mid,pubDate,app) VALUES(?,?,?,?) " inTable:TABLE_NAME],messageInfo.title,messageInfo.mid,messageInfo.pubDate,messageInfo.app];
        if ([db hadError]) {
            NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
            return NO;
        }
    }else
    {
        [self update:messageInfo];
    }
    return YES;
}

-(BOOL)update:(MessageDetailInfo *)messageInfo{
    NSMutableDictionary *updateDictionary = [[NSMutableDictionary alloc]init];
    if (messageInfo.title && ![messageInfo.title isEqualToString:@""]) {
        [updateDictionary setValue:messageInfo.title forKey:@"title"];
    }
    if (messageInfo.pubDate && ![messageInfo.pubDate isEqualToString:@""]) {
        [updateDictionary setValue:messageInfo.pubDate forKey:@"pubDate"];
    }
    if (messageInfo.source && ![messageInfo.source isEqualToString:@""]) {
        [updateDictionary setValue:messageInfo.source forKey:@"source"];
    }
    if (messageInfo.content && ![messageInfo.content isEqualToString:@""]) {
        [updateDictionary setValue:messageInfo.content forKey:@"content"];
    }
    if (messageInfo.app && ![messageInfo.app isEqualToString:@""]) {
        [updateDictionary setValue:messageInfo.app forKey:@"app"];
    }
    if (messageInfo.attachId && ![messageInfo.attachId isEqualToString:@""]) {
        [updateDictionary setValue:messageInfo.attachId forKey:@"attachId"];
    }

    NSString *fieldString = @"";
    NSString *key;
    for (int i=0; i<updateDictionary.allKeys.count; i++) {
        key = [updateDictionary.allKeys objectAtIndex:i];
        if (i==0) {
            fieldString = [NSString stringWithFormat:@"%@=?",key];
        }else{
            fieldString =  [NSString stringWithFormat:@"%@,%@=?",fieldString,key];
        }
    }
    
    NSMutableArray *fieldValues=[[NSMutableArray alloc]initWithArray:[updateDictionary allValues]];
    [fieldValues addObject:messageInfo.mid];
    [updateDictionary release];
    NSString *updateSql=[NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE mid=?",TABLE_NAME,fieldString];
    [db executeUpdate:updateSql withArgumentsInArray:fieldValues];
    [fieldValues release];
    if ([db hadError]) {
        NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        return NO;
    }
    
   
    return YES;
}

-(BOOL)deleteAllMessages{
    [db executeUpdate:[self SQL:@"DELETE FROM  %@" inTable:TABLE_NAME]];
    if ([db hadError]) {
        NSLog(@"Err %d:%@",[db lastErrorCode],[db lastErrorMessage]);
        return NO;
    }
    
    return YES;
}

-(BOOL)delete:(NSString *)mid{
    return YES;
}

-(MessageDetailInfo*)getMessageDetailById:(NSString *)mid App:(NSString *)appName;{
    MessageDetailInfo *messageDetailInfo =nil;
    FMResultSet *rs = [db executeQuery:[self SQL:@"SELECT * FROM %@ WHERE mid=? and app=?" inTable:TABLE_NAME],mid,appName];
    while ([rs next]) {
        messageDetailInfo = [[[MessageDetailInfo alloc]init]autorelease];
        [self setMessageInfoProp:rs MessageDetailInfo:messageDetailInfo];
    }
    
    [rs close];
    
    return messageDetailInfo;
}

-(NSMutableArray *)queryAllMessagelList{
    NSMutableArray *messageArray = [[[NSMutableArray alloc]init]autorelease];
    FMResultSet *messageResultSet = [db executeQuery:[self SQL:@"SELECT * FROM %@ ORDER BY pubDate DESC" inTable:TABLE_NAME]];
    while ([messageResultSet next]) {
        MessageDetailInfo *messageDetailInfo = [[MessageDetailInfo alloc]init];
        [self setMessageInfoProp:messageResultSet MessageDetailInfo:messageDetailInfo];
        
        [messageArray addObject:messageDetailInfo];
        [messageDetailInfo release];
    }
    
    [messageResultSet close];
    return messageArray;
}

-(void)saveMessagelistFromJsonValue:(id)jsonObj{
    if (jsonObj!=nil && [jsonObj valueForKey:@"code"]) {
        NSString *code = [jsonObj valueForKey:@"code"];
        
        if ([[SystemContext singletonInstance]processHttpResponseCode:code]) {
            if ([jsonObj valueForKey:@"result"]) {
                id paramArray = [jsonObj valueForKey:@"result"];
                if ([[paramArray class]isSubclassOfClass:[NSArray class]]) {
                    if (paramArray!=nil && [paramArray count]>0) {
                        [self deleteAllMessages];//清空消息表格
                        for (int i=0; i<[paramArray count]; i++) {
                            SBJsonWriter *paramObj = [paramArray objectAtIndex:i];
                            MessageDetailInfo *messageDetailInfo = [[MessageDetailInfo alloc]init];
                            if ([paramObj valueForKey:@"id"]) {
                                NSNumberFormatter* numberFormatter = [[[NSNumberFormatter alloc] init]autorelease];
                                messageDetailInfo.mid = [numberFormatter stringFromNumber:[paramObj valueForKey:@"id"]];
                            }
                            if ([paramObj valueForKey:@"app"]) {
                                messageDetailInfo.app = [paramObj valueForKey:@"app"];
                            }
                            if ([paramObj valueForKey:@"title"]) {
                                messageDetailInfo.title = [paramObj valueForKey:@"title"];
                            }
                            if ([paramObj valueForKey:@"pubDate"]) {
                                messageDetailInfo.pubDate = [paramObj valueForKey:@"pubDate"];
                            }
                            
                            [self insert:messageDetailInfo];
                            [messageDetailInfo release];
                        }
                    }
                }
            }
        }
    }
}
-(void)saveMessageDetailFromJsonValue:(id)jsonObj{
    if (jsonObj!=nil && [jsonObj valueForKey:@"code"]) {
        NSString *code = [jsonObj valueForKey:@"code"];
        
        if ([[SystemContext singletonInstance]processHttpResponseCode:code]) {
            if ([jsonObj valueForKey:@"result"]) {
                SBJsonParser *paramObj = [jsonObj valueForKey:@"result"];
                MessageDetailInfo *messageDetailInfo = [[MessageDetailInfo alloc]init];
                if ([paramObj valueForKey:@"app"]) {
                    messageDetailInfo.app = [paramObj valueForKey:@"app"];
                }
                if ([paramObj valueForKey:@"id"]) {
                    NSNumberFormatter* numberFormatter = [[[NSNumberFormatter alloc] init]autorelease];
                    messageDetailInfo.mid = [numberFormatter stringFromNumber:[paramObj valueForKey:@"id"]];
                }
                if ([paramObj valueForKey:@"title"]) {
                    messageDetailInfo.title = [paramObj valueForKey:@"title"];
                }
                if ([paramObj valueForKey:@"pubDate"]) {
                    messageDetailInfo.pubDate = [paramObj valueForKey:@"pubDate"];
                }
                if ([paramObj valueForKey:@"source"]) {
                    messageDetailInfo.source =[paramObj valueForKey:@"source"];
                }
                if ([paramObj valueForKey:@"content"]) {
                    messageDetailInfo.content = [paramObj valueForKey:@"content"];
                }
                [self insert:messageDetailInfo];
                [messageDetailInfo release];
            }
        }
    }
}
-(BOOL)containsKey:(NSString *)mid{
    if (mid==nil) {
        return NO;
    }
    FMResultSet *rs = [db executeQuery:[self SQL:@"SELECT * FROM %@	WHERE mid=?" inTable:TABLE_NAME],mid];
    while ([rs next]) {
        [rs close];
        return YES;
    }
    [rs close];
    return NO;
}
-(void)setMessageInfoProp:(FMResultSet *)rs MessageDetailInfo:(MessageDetailInfo *)messageInfo{
    messageInfo.mid = [rs stringForColumn:@"mid"];
    messageInfo.title = [rs stringForColumn:@"title"];
    messageInfo.pubDate = [rs stringForColumn:@"pubDate"];
    messageInfo.source = [rs stringForColumn:@"source"];
    messageInfo.content = [rs stringForColumn:@"content"];
    messageInfo.attachId = [rs stringForColumn:@"attachId"];
     messageInfo.app = [rs stringForColumn:@"app"];
}
@end
