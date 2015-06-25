//
//  BusinessCell.m
//  YelpApp
//
//  Created by Tim Chiang on 2015/6/22.
//  Copyright (c) 2015年 Tim Chiang. All rights reserved.
//

#import "BusinessCell.h"
#import <UIImageView+AFNetworking.h>

@implementation BusinessCell

- (void)awakeFromNib {
    
    self.nameLabel.preferredMaxLayoutWidth = self.nameLabel.frame.size.width;
    
    self.thumbImageView.layer.cornerRadius = 3;
    self.thumbImageView.clipsToBounds = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //self.nameLabel.preferredMaxLayoutWidth = self.nameLabel.frame.size.width;
}

@end
