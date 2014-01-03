//
//  ApproveTableviewCell.m
//  ShmetroOA
//
//  Created by caven shen on 11/2/12.
//
//

#import "ApproveTableviewCell.h"

@implementation ApproveTableviewCell
@synthesize view_contentView;
@synthesize lab_companyName;
@synthesize lab_content;
@synthesize lab_date;
@synthesize btn_file;
@synthesize img_line;
@synthesize delegate;
@synthesize fileGroupId;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            [[NSBundle mainBundle] loadNibNamed:@"ApproveTableviewCell_iPhone"
                                          owner:self
                                        options:nil];
        } else {
            [[NSBundle mainBundle] loadNibNamed:@"ApproveTableviewCell_iPad"
                                          owner:self
                                        options:nil];
        }
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self.contentView addSubview:self.view_contentView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [delegate release];
    [view_contentView release];
    [lab_companyName release];
    [lab_content release];
    [lab_date release];
    [btn_file release];
    [img_line release];
    [super dealloc];
}


#pragma mark - PublicMethod
-(void)useSmall{
    CGSize theStringSize;
    theStringSize = [self.lab_content.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(523.0, MAXFLOAT) lineBreakMode:UILineBreakModeClip];
    int height = 70+theStringSize.height;
    [self setFrame:CGRectMake(0, 0, 545, height)];
    [self.contentView setFrame:CGRectMake(0, 0, 545, height)];
    [self.lab_companyName setFrame:CGRectMake(10, 5,523, 21)];
    [self.lab_content setFrame:CGRectMake(10, 34, 523, theStringSize.height)];
    [self.btn_file setFrame:CGRectMake(10, 42+theStringSize.height, 60, 19)];
    [self.lab_date setFrame:CGRectMake(275, 42+theStringSize.height, 258, 21)];
}
-(void)useLong{
    CGSize theStringSize;
    theStringSize = [self.lab_content.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(845.0, MAXFLOAT) lineBreakMode:UILineBreakModeClip];
    int height = 70+theStringSize.height;
    [self setFrame:CGRectMake(0, 0, 867, height)];
    [self.contentView setFrame:CGRectMake(0, 0, 867, height)];
    [self.lab_companyName setFrame:CGRectMake(10, 5,845, 21)];
    [self.lab_content setFrame:CGRectMake(10, 34, 845, theStringSize.height)];
    [self.btn_file setFrame:CGRectMake(10, 42+theStringSize.height, 60, 19)];
    [self.lab_date setFrame:CGRectMake(598, 42+theStringSize.height, 258, 21)];
}

-(void)usePhone{
    CGSize theStringSize;
    theStringSize = [self.lab_content.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(280.0, MAXFLOAT) lineBreakMode:UILineBreakModeClip];
  //  int height = 70+theStringSize.height;
    [self.lab_content setFrame:CGRectMake(10, 34, 280, theStringSize.height)];
    [self.btn_file setFrame:CGRectMake(10, 42+theStringSize.height, 60, 19)];
    [self.lab_date setFrame:CGRectMake(92, 42+theStringSize.height, 198, 21)];
}

- (IBAction)action_file:(UIButton *)sender {
    if (delegate) {
        [delegate getAttachfileArr:self.fileGroupId UIButton:self.btn_file];
    }
}

-(void)setApprovedInfo:(ApprovedInfo *)approvedInfo{
    [self.lab_companyName setText:[NSString stringWithFormat:@"%@ %@",approvedInfo.dept,approvedInfo.stepname]];
    [self.lab_content setText:approvedInfo.remark];
    [self.lab_date setText:[NSString stringWithFormat:@"%@ %@",approvedInfo.userFullName,approvedInfo.day]];
    self.fileGroupId = approvedInfo.fileGroupId;
    [self.btn_file setHidden:(self.fileGroupId==nil)];
}
@end
