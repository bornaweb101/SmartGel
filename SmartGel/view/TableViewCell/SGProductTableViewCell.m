//
//  SGProductTableViewCell.m
//  SmartGel
//
//  Created by rockstar on 10/7/18.
//  Copyright © 2018 AFCO. All rights reserved.
//

#import "SGProductTableViewCell.h"

@implementation SGProductTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setCell:(SGTag *)sgTag{
    self.itemLabel.text = sgTag.tagName;
}

@end
