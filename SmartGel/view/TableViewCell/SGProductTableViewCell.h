//
//  SGProductTableViewCell.h
//  SmartGel
//
//  Created by rockstar on 10/7/18.
//  Copyright © 2018 AFCO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGTag.h"

@interface SGProductTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *itemLabel;
@property (strong, nonatomic) IBOutlet UIImageView *checkBox;

-(void)setCell:(SGTag *)sgTag;
@end
