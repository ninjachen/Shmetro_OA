//
//  ContactInfoDao.h
//  ShmetroOA
//
//  Created by gisteam on 6/7/13.
//
//

#import "BaseDao.h"
#import "ContactInfo.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"

@interface ContactInfoDao : BaseDao{

}

-(BOOL)insert:(ContactInfo *)contactInfo;
-(BOOL)update:(ContactInfo *)contactInfo;
-(BOOL)deleteAllContacts;
-(NSMutableArray *)queryAllContactByDept:(NSString *)dept;
-(NSMutableArray *)queryContactByDept:(NSString *)searchText;
-(NSMutableArray *)queryContactByName:(NSString *)searchText;
-(ContactInfo *)getContactByUid:(NSString *)uid;
-(ContactInfo *)getContactByLoginName:(NSString *)loginName;

-(void)saveContactFromJsonValue:(id)jsonObj clearContacts:(BOOL)isClear;
@end
