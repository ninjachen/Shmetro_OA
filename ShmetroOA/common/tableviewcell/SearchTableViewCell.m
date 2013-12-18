//
//  SearchTableViewCell.m
//  ShmetroOA
//
//  Created by caven shen on 10/30/12.
//
//

#import "SearchTableViewCell.h"

@implementation SearchTableViewCell
@synthesize uicontentView;
@synthesize img_title;
@synthesize img_number;
@synthesize lab_count;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            [[NSBundle mainBundle] loadNibNamed:@"SearchTableViewCell_iPhone"
                                          owner:self
                                        options:nil];
        } else {
            [[NSBundle mainBundle] loadNibNamed:@"SearchTableViewCell_iPad"
                                          owner:self
                                        options:nil];
        }
        [self.contentView addSubview:self.uicontentView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [uicontentView release];
    [img_title release];
    [img_number release];
    [lab_count release];
    [super dealloc];
}
@end
