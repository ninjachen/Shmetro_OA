//
//  UserInfoDao.m
//  ShmetroOA
//
//  Created by gisteam on 6/17/13.
//
//

#import "UserInfoDao.h"
#import "UserInfo.h"
#import "SystemContext.h"
#include "JSON.h"
#import "NSString+SBJSON.h"
#define TABLE_NAME @"userinfo"

@interface UserInfoDao(PrivateMethods)
-(BOOL)containsKey:(NSString *)uid;
-(void)setUserInfoProp:(FMResultSet *)rs UserInfo:(UserInfo *)userInfo;
@end

@implementation UserInfoDao

-(BOOL)insert:(UserInfo *)userInfo{
    if (![self containsKey:userInfo.uid]) {
        [db executeUpdate:[self SQL:@"INSERT INTO %@ (uid,loginName,name,nickName,rank,company,dept,sex,email,mobile1,mobile2,fax,phone,idCard,birthday,nation,birthplace,political,degree,address,postcode,grade,title,major,cpostcode,cphone,household,retire,caddress,remark) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) " inTable:TABLE_NAME],userInfo.uid,userInfo.loginName,userInfo.name,userInfo.nickName,userInfo.rank,userInfo.company,userInfo.dept,userInfo.sex,userInfo.email,userInfo.mobile1,userInfo.mobile2,userInfo.fax,userInfo.phone,userInfo.idCard,userInfo.birthday,userInfo.nation,userInfo.birthplace,userInfo.political,userInfo.degree,userInfo.address,userInfo.postcode,userInfo.grade,userInfo.title,userInfo.major,userInfo.cpostcode,userInfo.cphone,userInfo.household,userInfo.retire,userInfo.caddress,userInfo.remark];
        if ([db hadError]) {
            NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
            return NO;
        }
    }else
    {
        [self update:userInfo];
    }
    return YES;
}

-(BOOL)update:(UserInfo *)userInfo
{
    NSMutableDictionary *updateDictionary = [[NSMutableDictionary alloc]init];
    if (userInfo.loginName && ![userInfo.loginName isEqualToString:@""]) {
        [updateDictionary setValue:userInfo.loginName forKey:@"loginName"];
    }
    if (userInfo.name && ![userInfo.name isEqualToString:@""]) {
        [updateDictionary setValue:userInfo.name forKey:@"name"];
    }
    if (userInfo.nickName && ![userInfo.nickName isEqualToString:@""]) {
        [updateDictionary setValue:userInfo.nickName forKey:@"nickName"];
    }
    if (userInfo.rank && ![userInfo.rank isEqualToString:@""]) {
        [updateDictionary setValue:userInfo.rank forKey:@"rank"];
    }
    if (userInfo.company && ![userInfo.company isEqualToString:@""]) {
        [updateDictionary setValue:userInfo.company forKey:@"company"];
    }
    if (userInfo.dept && ![userInfo.dept isEqualToString:@""]) {
        [updateDictionary setValue:userInfo.dept forKey:@"dept"];
    }
    if (userInfo.sex && ![userInfo.sex isEqualToString:@""]) {
        [updateDictionary setValue:userInfo.sex forKey:@"sex"];
    }
    if (userInfo.email && ![userInfo.email isEqualToString:@""]) {
        [updateDictionary setValue:userInfo.email forKey:@"email"];
    }
    if (userInfo.mobile1 && ![userInfo.mobile1 isEqualToString:@""]) {
        [updateDictionary setValue:userInfo.mobile1 forKey:@"mobile1"];
    }
    if (userInfo.mobile2 && ![userInfo.mobile2 isEqualToString:@""]) {
        [updateDictionary setValue:userInfo.mobile2 forKey:@"mobile2"];
    }
    if (userInfo.fax && ![userInfo.fax isEqualToString:@""]) {
        [updateDictionary setValue:userInfo.fax forKey:@"fax"];
    }
    if (userInfo.phone && ![userInfo.phone isEqualToString:@""]) {
        [updateDictionary setValue:userInfo.phone forKey:@"phone"];
    }
    if (userInfo.idCard && ![userInfo.idCard isEqualToString:@""]) {
        [updateDictionary setValue:userInfo.idCard forKey:@"idCard"];
    }
    if (userInfo.birthday && ![userInfo.birthday isEqualToString:@""]) {
        [updateDictionary setValue:userInfo.birthday forKey:@"birthday"];
    }
    if (userInfo.nation && ![userInfo.nation isEqualToString:@""]) {
        [updateDictionary setValue:userInfo.nation forKey:@"nation"];
    }
    if (userInfo.birthplace && ![userInfo.birthplace isEqualToString:@""]) {
        [updateDictionary setValue:userInfo.birthplace forKey:@"birthplace"];
    }
    if (userInfo.political && ![userInfo.political isEqualToString:@""]) {
        [updateDictionary setValue:userInfo.political forKey:@"political"];
    }
    if (userInfo.degree && ![userInfo.degree isEqualToString:@""]) {
        [updateDictionary setValue:userInfo.degree forKey:@"degree"];
    }
    if (userInfo.address && ![userInfo.address isEqualToString:@""]) {
        [updateDictionary setValue:userInfo.address forKey:@"address"];
    }
    if (userInfo.postcode && ![userInfo.postcode isEqualToString:@""]) {
        [updateDictionary setValue:userInfo.postcode forKey:@"postcode"];
    }
    if (userInfo.grade && ![userInfo.grade isEqualToString:@""]) {
        [updateDictionary setValue:userInfo.grade forKey:@"loginName"];
    }
    if (userInfo.title && ![userInfo.title isEqualToString:@""]) {
        [updateDictionary setValue:userInfo.title forKey:@"title"];
    }
    if (userInfo.major && ![userInfo.major isEqualToString:@""]) {
        [updateDictionary setValue:userInfo.major forKey:@"major"];
    }
    if (userInfo.cpostcode && ![userInfo.cpostcode isEqualToString:@""]) {
        [updateDictionary setValue:userInfo.cpostcode forKey:@"cpostcode"];
    }
    if (userInfo.cphone && ![userInfo.cphone isEqualToString:@""]) {
        [updateDictionary setValue:userInfo.cphone forKey:@"cphone"];
    }
    if (userInfo.household && ![userInfo.household isEqualToString:@""]) {
        [updateDictionary setValue:userInfo.household forKey:@"household"];
    }
    if (userInfo.retire && ![userInfo.retire isEqualToString:@""]) {
        [updateDictionary setValue:userInfo.retire forKey:@"retire"];
    }
    if (userInfo.caddress && ![userInfo.caddress isEqualToString:@""]) {
        [updateDictionary setValue:userInfo.caddress forKey:@"caddress"];
    }
    if (userInfo.remark && ![userInfo.remark isEqualToString:@""]) {
        [updateDictionary setValue:userInfo.remark forKey:@"remark"];
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
    [fieldValues addObject:userInfo.uid];
    [updateDictionary release];
    NSString *updateSql=[NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE uid=?",TABLE_NAME,fieldString];
    [db executeQuery:updateSql withArgumentsInArray:fieldValues];
    [fieldValues release];
    if ([db hadError]) {
        NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        return NO;
    }
    
    
    return YES;
}

-(BOOL)deleteAllUserInfo{
    [db executeUpdate:[self SQL:@"DELETE FROM  %@" inTable:TABLE_NAME]];
    if ([db hadError]) {
        NSLog(@"Err %d:%@",[db lastErrorCode],[db lastErrorMessage]);
        return NO;
    }
    
    return YES;
}

-(UserInfo*)getUserInfoByLoginName:(NSString *)loginName
{
    UserInfo *userInfo=nil;
    FMResultSet *rs = [db executeQuery:[self SQL:@"SELECT * FROM %@ WHERE loginName=?" inTable:TABLE_NAME],loginName];
    while ([rs next]) {
       userInfo  = [[[UserInfo alloc]init]autorelease];
        [self setUserInfoProp:rs UserInfo:userInfo];
    }
    
    [rs close];
    
    return userInfo;
}

-(void)saveUserInfoFromJsonValue:(id)jsonObj{
    UserInfo *userInfo = [[[UserInfo alloc]init]autorelease];
    if (jsonObj!=nil && [jsonObj valueForKey:@"code"]) {
        NSString *code = [jsonObj valueForKey:@"code"];
        
        if ([[SystemContext singletonInstance]processHttpResponseCode:code]) {
            if ([jsonObj valueForKey:@"result"]) {
                id paramArray = [jsonObj valueForKey:@"result"];
                if ([[paramArray class]isSubclassOfClass:[NSArray class]]) {
                    if (paramArray!=nil && [paramArray count]>0) {
                        [self deleteAllUserInfo];
                        for (int i=0; i<[paramArray count]; i++) {
                            SBJsonWriter *paramsObj = [paramArray objectAtIndex:i];

                            if ([paramsObj valueForKey:@"id"]) {
                                NSNumberFormatter* numberFormatter = [[[NSNumberFormatter alloc] init]autorelease];
                                 userInfo.uid= [numberFormatter stringFromNumber:[paramsObj valueForKey:@"id"]];
                            }
                            if ([paramsObj valueForKey:@"loginName"]) {
                                userInfo.loginName= [paramsObj valueForKey:@"loginName"];
                            }
                            if ([paramsObj valueForKey:@"name"]) {
                                userInfo.name= [paramsObj valueForKey:@"name"];
                            }
                            if ([paramsObj valueForKey:@"nickName"]) {
                                userInfo.nickName= [paramsObj valueForKey:@"nickName"];
                            }
                            if ([paramsObj valueForKey:@"rank"]) {
                                userInfo.rank= [paramsObj valueForKey:@"rank"];
                            }
                            if ([paramsObj valueForKey:@"company"]) {
                                userInfo.company= [paramsObj valueForKey:@"company"];
                            }
                            if ([paramsObj valueForKey:@"dept"]) {
                                userInfo.dept= [paramsObj valueForKey:@"dept"];
                            }
                            if ([paramsObj valueForKey:@"sex"]) {
                                userInfo.sex= [paramsObj valueForKey:@"sex"];
                            }
                            if ([paramsObj valueForKey:@"email"]) {
                                userInfo.email= [paramsObj valueForKey:@"email"];
                            }
                            if ([paramsObj valueForKey:@"fax"]) {
                                userInfo.fax= [paramsObj valueForKey:@"fax"];
                            }
                            if ([paramsObj valueForKey:@"phone"]) {
                                userInfo.phone= [paramsObj valueForKey:@"phone"];
                            }
                            if ([paramsObj valueForKey:@"mobile1"]) {
                                userInfo.mobile1= [paramsObj valueForKey:@"mobile1"];
                            }
                            if ([paramsObj valueForKey:@"mobile2"]) {
                                userInfo.mobile2= [paramsObj valueForKey:@"mobile2"];
                            }
                            if ([paramsObj valueForKey:@"idCard"]) {
                                userInfo.idCard= [paramsObj valueForKey:@"idCard"];
                            }
                            if ([paramsObj valueForKey:@"birthday"]) {
                                userInfo.birthday= [paramsObj valueForKey:@"birthday"];
                            }
                            if ([paramsObj valueForKey:@"nation"]) {
                                userInfo.nation= [paramsObj valueForKey:@"nation"];
                            }
                            if ([paramsObj valueForKey:@"birthplace"]) {
                                userInfo.birthplace= [paramsObj valueForKey:@"birthplace"];
                            }
                            if ([paramsObj valueForKey:@"political"]) {
                                userInfo.political= [paramsObj valueForKey:@"political"];
                            }
                            if ([paramsObj valueForKey:@"degree"]) {
                                userInfo.degree= [paramsObj valueForKey:@"degree"];
                            }
                            if ([paramsObj valueForKey:@"address"]) {
                                userInfo.address= [paramsObj valueForKey:@"address"];
                            }
                            if ([paramsObj valueForKey:@"postcode"]) {
                                userInfo.postcode= [paramsObj valueForKey:@"postcode"];
                            }
                            if ([paramsObj valueForKey:@"grade"]) {
                                userInfo.grade= [paramsObj valueForKey:@"grade"];
                            }
                            if ([paramsObj valueForKey:@"major"]) {
                                userInfo.major= [paramsObj valueForKey:@"major"];
                            }
                            if ([paramsObj valueForKey:@"cpostcode"]) {
                                userInfo.cpostcode= [paramsObj valueForKey:@"cpostcode"];
                            }
                            if ([paramsObj valueForKey:@"caddress"]) {
                                userInfo.caddress= [paramsObj valueForKey:@"caddress"];
                            }
                            if ([paramsObj valueForKey:@"retire"]) {
                                userInfo.retire= [paramsObj valueForKey:@"retire"];
                            }
                            if ([paramsObj valueForKey:@"remark"]) {
                                userInfo.remark= [paramsObj valueForKey:@"remark"];
                            }
                            if ([paramsObj valueForKey:@"cphone"]) {
                                userInfo.cphone= [paramsObj valueForKey:@"cphone"];
                            }
                            if ([paramsObj valueForKey:@"household"]) {
                                userInfo.household= [paramsObj valueForKey:@"household"];
                            }
                
                            [self insert:userInfo];
                
                        }
                    }
                }
            }
        }
    }
}

-(BOOL)containsKey:(NSString *)uid{
    if (uid==nil) {
        return NO;
    }
    FMResultSet *rs = [db executeQuery:[self SQL:@"SELECT * FROM %@	WHERE uid=?" inTable:TABLE_NAME],uid];
    while ([rs next]) {
        [rs close];
        return YES;
    }
    [rs close];
    return NO;
}

-(void)setUserInfoProp:(FMResultSet *)rs UserInfo:(UserInfo *)userInfo
{
    userInfo.uid = [rs stringForColumn:@"uid"];
    userInfo.loginName = [rs stringForColumn:@"loginName"];
     userInfo.name = [rs stringForColumn:@"name"];
     userInfo.nickName = [rs stringForColumn:@"nickName"];
     userInfo.rank = [rs stringForColumn:@"rank"];
     userInfo.company = [rs stringForColumn:@"company"];
     userInfo.dept = [rs stringForColumn:@"dept"];
     userInfo.sex = [rs stringForColumn:@"sex"];
     userInfo.email = [rs stringForColumn:@"email"];
     userInfo.mobile1 = [rs stringForColumn:@"mobile1"];
     userInfo.mobile2 = [rs stringForColumn:@"mobile2"];
     userInfo.fax = [rs stringForColumn:@"fax"];
     userInfo.phone = [rs stringForColumn:@"phone"];
     userInfo.idCard = [rs stringForColumn:@"idCard"];
    userInfo.birthday = [rs stringForColumn:@"birthday"];
     userInfo.nation = [rs stringForColumn:@"nation"];
     userInfo.birthplace = [rs stringForColumn:@"birthplace"];
     userInfo.political = [rs stringForColumn:@"political"];
     userInfo.degree = [rs stringForColumn:@"degree"];
     userInfo.address = [rs stringForColumn:@"address"];
     userInfo.postcode = [rs stringForColumn:@"postcode"];
     userInfo.grade = [rs stringForColumn:@"grade"];
     userInfo.title = [rs stringForColumn:@"title"];
     userInfo.major = [rs stringForColumn:@"major"];
     userInfo.cphone = [rs stringForColumn:@"cphone"];
     userInfo.cpostcode = [rs stringForColumn:@"cpostcode"];
     userInfo.household = [rs stringForColumn:@"household"];
     userInfo.retire = [rs stringForColumn:@"retire"];
     userInfo.caddress = [rs stringForColumn:@"caddress"];
     userInfo.remark = [rs stringForColumn:@"remark"];    
}
@end
