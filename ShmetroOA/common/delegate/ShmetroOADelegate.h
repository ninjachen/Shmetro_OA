//
//  ShmetroOADelegate.h
//  ShmetroOA
//
//  Created by caven shen on 10/10/12.
//
//

#import <Foundation/Foundation.h>
#import "TodoInfo.h"
#import "AttachFileInfo.h"
@interface ShmetroOADelegate : NSObject

@end

@protocol  MainViewControllerDelegate<NSObject>
-(void)viewDetail_iPad:(id)obj;
-(void)closeViewDetail;
-(void)fullView;
-(void)smallView;
-(void)refresh;
-(void)openAttachmentFile:(AttachFileInfo *)attachFileInfo;
@end

@protocol DetailViewControllerDelegate <NSObject>

-(void)getAttachfileArr:(NSString *)fileGroupId UIButton:(UIButton *)btn;
-(void)processTodo:(TodoInfo *)todoInfo;
-(void)closePopoverViewController;
@end

@protocol SettingViewControllerDelegate <NSObject>

-(void)setAutoRefreshTime:(int)index;
@end

@protocol TabbarViewControllerDelegate <NSObject>

-(void)hiddenTabbar:(BOOL)animation;
-(void)showTabbar:(BOOL)animation;

@end