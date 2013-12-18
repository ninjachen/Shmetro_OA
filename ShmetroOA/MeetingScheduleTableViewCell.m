//
//  MeetingScheduleTableViewCell.m
//  ShmetroOA
//
//  Created by gisteam on 6/21/13.
//
//

#import "MeetingScheduleTableViewCell.h"

@implementation MeetingScheduleTableViewCell
@synthesize lblMeetingRoomName,uicontentView;
@synthesize img_1,img_2,img_3,img_4,img_5,img_6,img_7,img_line;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
           
            [[NSBundle mainBundle] loadNibNamed:@"MeetingScheduleTableViewCell_iPad1"
                                          owner:self
                                        options:nil];

        }
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self.contentView addSubview:self.uicontentView];
    }
    return self;

}

-(void)resetCell:(CGFloat)cellHeight{
    [self setFrame:CGRectMake(0, 0, 852, cellHeight)];
    [self.contentView setFrame:CGRectMake(0, 0, 852, cellHeight)];
    [self.uicontentView setFrame:CGRectMake(0, 0, 852, cellHeight)];
    [self.dynamicContentView setFrame:CGRectMake(111, 0, 741, cellHeight)];
    [self.img_1 setFrame:CGRectMake(110, 0, 2, cellHeight)];
     [self.img_2 setFrame:CGRectMake(216, 0, 2, cellHeight)];
     [self.img_3 setFrame:CGRectMake(322, 0, 2, cellHeight)];
     [self.img_4 setFrame:CGRectMake(428, 0, 2, cellHeight)];
     [self.img_5 setFrame:CGRectMake(534, 0, 2, cellHeight)];
    [self.img_6 setFrame:CGRectMake(640, 0, 2, cellHeight)];
    [self.img_7 setFrame:CGRectMake(746, 0, 2, cellHeight)];
    [self.img_line setFrame:CGRectMake(0, cellHeight-1, 852, 2)];
    [self.lblMeetingRoomName setFrame:CGRectMake(14, (cellHeight-50)/2, 80, 50)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)dealloc{
    [lblMeetingRoomName release];
    [uicontentView release];
    [img_1 release];
    [img_2 release];
    [img_3 release];
    [img_4 release];
    [img_5 release];
    [img_6 release];
    [img_7 release];
    [img_line release];
    [_dynamicContentView release];
    [super dealloc];
}
@end
