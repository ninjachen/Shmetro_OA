//
//  SearchTableViewCell.h
//  ShmetroOA
//
//  Created by caven shen on 10/30/12.
//
//

#import <UIKit/UIKit.h>

@interface SearchTableViewCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIView *uicontentView;
@property (retain, nonatomic) IBOutlet UIImageView *img_title;
@property (retain, nonatomic) IBOutlet UIImageView *img_number;
@property (retain, nonatomic) IBOutlet UILabel *lab_count;

@end
