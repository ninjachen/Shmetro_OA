//
//  AttachmentTableViewCell.m
//  ShmetroOA
//
//  Created by caven shen on 11/1/12.
//
//

#import "AttachmentTableViewCell.h"

@implementation AttachmentTableViewCell
@synthesize view_contentView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            [[NSBundle mainBundle] loadNibNamed:@"AttachmentTableViewCell_iPhone"
                                          owner:self
                                        options:nil];
        } else {
            [[NSBundle mainBundle] loadNibNamed:@"AttachmentTableViewCell_iPad"
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
    [view_contentView release];
    [super dealloc];
}

#pragma mark - PublicMethod
-(void)useSmall{
    [self.contentView setFrame:CGRectMake(0, 0, 580, 47)];
}
-(void)useLong{
    [self setFrame:CGRectMake(0, 0, 920, 47)];
    
}

@end
