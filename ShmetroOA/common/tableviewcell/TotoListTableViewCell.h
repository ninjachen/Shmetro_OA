//
//  TotoListTableViewCell.h
//  ShmetroOA
//
//  Created by caven shen on 10/10/12.
//
//

#import <UIKit/UIKit.h>

@interface TotoListTableViewCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *imgViewStatus;
@property (retain, nonatomic) IBOutlet UIImageView *imgViewIcon;
@property (retain, nonatomic) IBOutlet UILabel *labTitle;
@property (retain, nonatomic) IBOutlet UILabel *labSubTitle;
@property (retain, nonatomic) IBOutlet UIView *uiviewContent;
@end
