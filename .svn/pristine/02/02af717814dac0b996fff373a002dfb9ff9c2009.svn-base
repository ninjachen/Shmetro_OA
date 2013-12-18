//
//  MeetingOccupationTableViewCell.m
//  ShmetroOA
//
//  Created by gisteam on 6/21/13.
//
//

#import "MeetingOccupationTableViewCell.h"

@implementation MeetingOccupationTableViewCell
@synthesize img_line,img_v,lblMeetingRoomName,uicontentView,dynamicContentView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            
            [[NSBundle mainBundle] loadNibNamed:@"MeetingOccupationTableViewCell_iPad"
                                          owner:self
                                        options:nil];
            
        }
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self.contentView addSubview:self.uicontentView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)resetCell:(CGFloat)cellHeight{
    [self setFrame:CGRectMake(0, 0, 852, cellHeight)];
    [self.contentView setFrame:CGRectMake(0, 0, 852, cellHeight)];
    [self.uicontentView setFrame:CGRectMake(0, 0, 852, cellHeight)];
    [self.img_v setFrame:CGRectMake(110, 0, 1, cellHeight)];
    [self.img_line setFrame:CGRectMake(0, cellHeight-1, 852, 2)];
    [self.lblMeetingRoomName setFrame:CGRectMake(14, (cellHeight-50)/2, 80, 50)];
    [self.dynamicContentView setFrame:CGRectMake(111, 0, 741, cellHeight)];
}

-(void)dealloc{
    [lblMeetingRoomName release];
    [uicontentView release];
    [img_v release];
    [img_line release];
    [dynamicContentView release];
    [super dealloc];
}

@end
