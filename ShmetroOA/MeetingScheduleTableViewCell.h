//
//  MeetingScheduleTableViewCell.h
//  ShmetroOA
//
//  Created by gisteam on 6/21/13.
//
//

#import <UIKit/UIKit.h>

@interface MeetingScheduleTableViewCell : UITableViewCell

@property(nonatomic,retain)IBOutlet UILabel *lblMeetingRoomName;
@property(nonatomic,retain)IBOutlet UIView *uicontentView;
@property(nonatomic,retain)IBOutlet UIImageView *img_line;
@property(nonatomic,retain)IBOutlet UIImageView *img_1;
@property(nonatomic,retain)IBOutlet UIImageView *img_2;
@property(nonatomic,retain)IBOutlet UIImageView *img_3;
@property(nonatomic,retain)IBOutlet UIImageView *img_4;
@property(nonatomic,retain)IBOutlet UIImageView *img_5;
@property(nonatomic,retain)IBOutlet UIImageView *img_6;
@property(nonatomic,retain)IBOutlet UIImageView *img_7;
@property (retain, nonatomic) IBOutlet UIView *dynamicContentView;

-(void)resetCell:(CGFloat)cellHeight;
@end
