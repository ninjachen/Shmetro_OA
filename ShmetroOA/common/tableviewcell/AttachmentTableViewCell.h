//
//  AttachmentTableViewCell.h
//  ShmetroOA
//
//  Created by caven shen on 11/1/12.
//
//

#import <UIKit/UIKit.h>

@interface AttachmentTableViewCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIView *view_contentView;
-(void)useSmall;
-(void)useLong;
@end
