//
//  MeetingHeadView.m
//  ShmetroOA
//
//  Created by gisteam on 6/26/13.
//
//

#import "MeetingHeadView.h"

@implementation MeetingHeadView
@synthesize lblMon,lblMeeting,lblFri,lblSat,lblSun,lblThu,lblTus,lblWed,view_background;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
         
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)dealloc{
    [view_background release];
    [lblWed release];
    [lblMeeting release];
    [lblMon release];
    [lblSat release];
    [lblSun release];
    [lblThu release];
    [lblTus release];
    [lblFri release];
    [super dealloc];
}
@end
