//
//  UserInfo.m
//  ShmetroOA
//
//  Created by gisteam on 6/14/13.
//
//

#import "UserInfo.h"
#import "SystemContext.h"
#include "JSON.h"
#import "NSString+SBJSON.h"

@implementation UserInfo
@synthesize uid,loginName,name,nickName,rank,company,dept,sex,email,fax,phone,mobile1,mobile2;
@synthesize idCard,birthday,nation,birthplace,political,degree,address,postcode,grade,title,major,cpostcode,caddress;
@synthesize retire,remark,household,cphone;

-(void)dealloc{
    [uid release];
    [loginName release];
    [name release];
    [nickName release];
    [rank release];
    [company release];
    [dept release];
    [sex release];
    [email release];
    [fax release];
    [phone release];
    [mobile1 release];
    [mobile2 release];
    [idCard release];
    [birthday release];
    [nation release];
    [birthplace release];
    [political release];
    [degree release];
    [address release];
    [postcode release];
    [grade release];
    [title release];
    [major release];
    [cpostcode release];
    [caddress release];
    [retire release];
    [remark release];
    [cphone release];
    [household release];
    [super dealloc];
}

-(UserInfo *)loadUserInfoFromJsonValue:(id)jsonObj{
    UserInfo *userInfo = [[[UserInfo alloc]init]autorelease];
    if (jsonObj!=nil && [jsonObj valueForKey:@"code"]) {
        NSString *code = [jsonObj valueForKey:@"code"];
        NSString *description = @"";
        if ([jsonObj valueForKey:@"description"]) {
            description = [jsonObj valueForKey:@"description"];
        }
        
        if ([[SystemContext singletonInstance]processHttpResponseCode:code Desc:description]) {
            SBJsonParser *paramsObj = [jsonObj valueForKey:@"params"];
            if (paramsObj) {
                if ([paramsObj valueForKey:@"uid"]) {
                    userInfo.uid= [paramsObj valueForKey:@"uid"];
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
            }
        }
    }
        return  userInfo;
}
@end
