//
//  ContactTableViewCell.h
//  ShmetroOA
//
//  Created by gisteam on 6/8/13.
//
//

#import <UIKit/UIKit.h>

@interface ContactTableViewCell : UITableViewCell

@property(retain,nonatomic)IBOutlet UIImageView * iconImageView;
@property(retain,nonatomic)IBOutlet UILabel * lblName;
@property(retain,nonatomic)IBOutlet UILabel *lblDept;
@property(retain,nonatomic)IBOutlet UILabel *lblPhone;
@property(retain,nonatomic)IBOutlet UIView *uiContentView;

@end
