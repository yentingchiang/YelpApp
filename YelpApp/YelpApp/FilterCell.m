//
//  FilterCell.m
//  YelpApp
//
//  Created by Tim Chiang on 2015/6/23.
//  Copyright (c) 2015年 Tim Chiang. All rights reserved.
//

#import "FilterCell.h"

@implementation FilterCell

- (void)awakeFromNib {
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
}


- (IBAction)switchValueChanged:(id)sender {
    
    [self.delegate filterCell:self didUpdateCategoryValue:self.filterSwitch.on];
}


- (void)setOn:(BOOL)on {
    
    [self setOn:on animated:NO];
}

- (void)setOn:(BOOL)on animated:(BOOL)animated {
   
    _on = on;
    [self.filterSwitch setOn:on animated:animated];
}
- (IBAction)clickSortMode:(id)sender {
    [self.delegate filterCell:self didUpdateSortModeValue:self.sortSegment.selectedSegmentIndex];
}


- (IBAction)clickRadius:(id)sender {
    [self.delegate filterCell:self didUpdateRadiusValue:self.radiusSegment.selectedSegmentIndex];
}


- (IBAction)clickDeals:(id)sender {
   
    [self.delegate filterCell:self didUpdateDealsValue:self.dealsSwitch.on];
}

@end
