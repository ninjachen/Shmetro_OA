//
//  ContactInfo.h
//  ShmetroOA
//
//  Created by gisteam on 6/7/13.
//
//

#import <Foundation/Foundation.h>

@interface ContactInfo : NSObject{
    NSString *uid;
    NSString *loginName;
    NSString *name;
    NSString *email;
    NSString *mobile1;
    NSString *mobile2;
    NSString *fax;
    NSString *phone;
    NSString *cphone;
    NSString *company;
    NSString *dept;
  //  NSString *removed;
}

@property(nonatomic,retain)NSString *uid;
@property(nonatomic,retain)NSString* loginName;
@property(nonatomic,retain)NSString *name;
@property(nonatomic,retain)NSString *email;
@property(nonatomic,retain)NSString *mobile1;
@property(nonatomic,retain)NSString *mobile2;
@property(nonatomic,retain)NSString *fax;
@property(nonatomic,retain)NSString *phone;
@property(nonatomic,retain)NSString *cphone;
@property(nonatomic,retain)NSString *company;
@property(nonatomic,retain)NSString *dept;
//@property(nonatomic,retain)NSString *removed;

@end
