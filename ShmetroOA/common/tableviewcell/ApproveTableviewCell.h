//
//  ApproveTableviewCell.h
//  ShmetroOA
//
//  Created by caven shen on 11/2/12.
//
//

#import <UIKit/UIKit.h>
#import "ApprovedInfo.h"
#import "ShmetroOADelegate.h"
@interface ApproveTableviewCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIView *view_contentView;
@property (retain, nonatomic) IBOutlet UILabel *lab_companyName;
@property (retain, nonatomic) IBOutlet UILabel *lab_content;
@property (retain, nonatomic) IBOutlet UILabel *lab_date;
@property (retain, nonatomic) IBOutlet UIButton *btn_file;
@property (retain, nonatomic) IBOutlet UIImageView *img_line;
@property (nonatomic, assign) id<DetailViewControllerDelegate> delegate;
@property (nonatomic,retain) NSString *fileGroupId;
-(void)useSmall;
-(void)useLong;
-(void)usePhone;
- (IBAction)action_file:(UIButton *)sender;

-(void)setApprovedInfo:(ApprovedInfo *)approvedInfo;
@end
