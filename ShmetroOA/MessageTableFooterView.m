

#import "MessageTableFooterView.h"

@implementation MessageTableFooterView

@synthesize activityIndicator;
@synthesize infoLabel;


- (void) awakeFromNib
{
  self.backgroundColor = [UIColor clearColor];
  [super awakeFromNib];
}

- (void) dealloc
{
  [activityIndicator release];
  [infoLabel release];
  [super dealloc];
}

@end
