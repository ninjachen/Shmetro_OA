//
//  TodoDetailTableviewCell.m
//  ShmetroOA
//
//  Created by caven shen on 10/30/12.
//
//

#import "TodoDetailTableviewCell.h"
@interface TodoDetailTableviewCell(PrivateMethod)

@end
@implementation TodoDetailTableviewCell
@synthesize lab_name;
@synthesize lab_value;
@synthesize img_h;
@synthesize img_v;
@synthesize uicontnetView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            [[NSBundle mainBundle] loadNibNamed:@"TodoDetailTableviewCell_iPhone"
                                          owner:self
                                        options:nil];
        } else {
            [[NSBundle mainBundle] loadNibNamed:@"TodoDetailTableviewCell_iPad"
                                          owner:self
                                        options:nil];
        }
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self.contentView addSubview:self.uicontnetView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [lab_name release];
    [lab_value release];
    [img_h release];
    [img_v release];
    [uicontnetView release];
    [super dealloc];
}

#pragma mark - PublicMethod
-(void)useSmall{
    CGSize theStringSize;
    theStringSize = [self.lab_value.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(409.0, MAXFLOAT) lineBreakMode:UILineBreakModeClip];
    int height = 27+theStringSize.height;
    [self setFrame:CGRectMake(0, 0, 580, height)];
    [self.contentView setFrame:CGRectMake(0, 0, 580, height)];
    [self.img_v setFrame:CGRectMake(130, 0, 2, height)];
    [self.img_h setFrame:CGRectMake(0, height-1, 580, 2)];
    [self.img_h setImage:[UIImage imageNamed:@"bg_13lineshort.png"]];
    [self.lab_value setFrame:CGRectMake(159, 0, 409, height)];
}
-(void)useLong{
    CGSize theStringSize;
    theStringSize = [self.lab_value.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(753.0, MAXFLOAT) lineBreakMode:UILineBreakModeClip];
    int height = 27+theStringSize.height;
    [self setFrame:CGRectMake(0, 0, 920, height)];
    [self.contentView setFrame:CGRectMake(0, 0, 920, height)];
    [self.img_v setFrame:CGRectMake(130, 0, 2, height)];
    [self.img_h setFrame:CGRectMake(0, height-1, 920, 2)];
    [self.img_h setImage:[UIImage imageNamed:@"bg_15linelong.png"]];
    [self.lab_value setFrame:CGRectMake(159, 0, 753, height)];
}

-(void)setHeadCell{
    [self setFrame:CGRectMake(0, 0, 580, 74)];
    [self.contentView setFrame:CGRectMake(0, 0, 580, 74)];
    [self.uicontnetView setFrame:CGRectMake(0, 0, 580, 74)];
    [self.img_v setHidden:YES];
    [self.img_h setFrame:CGRectMake(0, 73, 580, 2)];
    [self.img_h setImage:[UIImage imageNamed:@"bg_13lineshort.png"]];
    [self.lab_value setFrame:CGRectMake(10, 0, 409, 73)];
}
@end
