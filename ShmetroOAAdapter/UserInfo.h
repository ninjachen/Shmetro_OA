//
//  UserInfo.h
//  ShmetroOA
//
//  Created by gisteam on 6/14/13.
//
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject{
    NSString *uid;  //用户id
    NSString *loginName;
    NSString *nickName;
    NSString *name;
    NSString *rank; //目前职务
    NSString *company;
    NSString *dept;
    NSString *sex;
    NSString *email;
    NSString *fax;
    NSString *phone;
    NSString *mobile1;
    NSString *mobile2;
    NSString *idCard;
    NSString *birthday;
    NSString *nation;
    NSString *birthplace;
    NSString *political;
    NSString *degree;
    NSString *address;
    NSString *postcode;
    NSString *grade;
    NSString *title; //最高职称
    NSString *major;
    NSString *cpostcode;
    NSString *cphone;
    NSString *household; //支内或农口
    NSString *retire;//在职或退休
    NSString *caddress;
    NSString *remark;
}

@property(nonatomic,retain) NSString *uid;  
@property(nonatomic,retain) NSString *loginName;
@property(nonatomic,retain) NSString *name;
@property(nonatomic,retain) NSString *nickName;
@property(nonatomic,retain) NSString *rank; 
@property(nonatomic,retain) NSString *company;
@property(nonatomic,retain) NSString *dept;
@property(nonatomic,retain) NSString *sex;
@property(nonatomic,retain) NSString *email;
@property(nonatomic,retain) NSString *fax;
@property(nonatomic,retain) NSString *phone;
@property(nonatomic,retain) NSString *mobile1;
@property(nonatomic,retain) NSString *mobile2;
@property(nonatomic,retain) NSString *idCard;
@property(nonatomic,retain) NSString *birthday;
@property(nonatomic,retain) NSString *nation;
@property(nonatomic,retain) NSString *birthplace;
@property(nonatomic,retain) NSString *political;
@property(nonatomic,retain) NSString *degree;
@property(nonatomic,retain) NSString *address;
 @property(nonatomic,retain) NSString *postcode;
@property(nonatomic,retain) NSString *grade;
@property(nonatomic,retain) NSString *title; 
@property(nonatomic,retain) NSString *major;
@property(nonatomic,retain) NSString *cpostcode;
@property(nonatomic,retain) NSString *household; 
@property(nonatomic,retain) NSString *retire;
@property(nonatomic,retain) NSString *caddress;
@property(nonatomic,retain) NSString *remark;
@property(nonatomic,retain) NSString *cphone;


-(UserInfo *)loadUserInfoFromJsonValue:(id)jsonObj;
@end
