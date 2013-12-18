//
//  TotoListTableViewCell.m
//  ShmetroOA
//
//  Created by caven shen on 10/10/12.
//
//

#import "TotoListTableViewCell.h"

@implementation TotoListTableViewCell
@synthesize imageView,imgViewIcon,labSubTitle,labTitle,uiviewContent;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            [[NSBundle mainBundle] loadNibNamed:@"TotoListTableViewCell_iPhone"
                                          owner:self
                                        options:nil];
        } else {
            [[NSBundle mainBundle] loadNibNamed:@"TotoListTableViewCell_iPad"
                                          owner:self
                                        options:nil];
            UIImageView *bgImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_10middle_on.png"]];
            [self setSelectedBackgroundView:bgImgView];
            [bgImgView release];
        }
        [self.contentView addSubview:self.uiviewContent];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)dealloc{
    [uiviewContent release];
    [imageView release];
    [imgViewIcon release];
    [labSubTitle release];
    [labTitle release];
    [super dealloc];
}

@end
