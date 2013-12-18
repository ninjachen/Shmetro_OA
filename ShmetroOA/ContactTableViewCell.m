//
//  ContactTableViewCell.m
//  ShmetroOA
//
//  Created by gisteam on 6/8/13.
//
//

#import "ContactTableViewCell.h"

@implementation ContactTableViewCell
@synthesize iconImageView,lblDept,lblName,lblPhone,uiContentView;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if ([[UIDevice currentDevice]userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            [[NSBundle mainBundle]loadNibNamed:@"ContactTableViewCell_iPad" owner:self options:nil];
            UIImageView *backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_10middle_on.png"]];
            [self setSelectedBackgroundView:backgroundView];
            [backgroundView release];
        }
        
        [self.contentView addSubview:self.uiContentView];
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)dealloc{
    [iconImageView release];
    [lblPhone release];
    [lblName release];
    [lblDept release];
    [uiContentView release];
    [super dealloc];
}
@end
