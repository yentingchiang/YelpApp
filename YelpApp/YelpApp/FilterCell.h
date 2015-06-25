//
//  FilterCell.h
//  YelpApp
//
//  Created by Tim Chiang on 2015/6/23.
//  Copyright (c) 2015年 Tim Chiang. All rights reserved.
//

#import <UIKit/UIKit.h>


@class FilterCell;

@protocol FilterCellDelegate <NSObject>

- (void)filterCell:(FilterCell *)cell didUpdateCategoryValue:(BOOL)value;
- (void)filterCell:(FilterCell *)cell didUpdateDealsValue:(BOOL)value;
- (void)filterCell:(FilterCell *)cell didUpdateRadiusValue:(NSInteger)value;
- (void)filterCell:(FilterCell *)cell didUpdateSortModeValue:(NSInteger)value;

@end


@interface FilterCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UISwitch *dealsSwitch;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UISwitch *filterSwitch;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sortSegment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *radiusSegment;

@property (nonatomic, assign) BOOL on;
@property (nonatomic, weak) id<FilterCellDelegate> delegate;

- (void)setOn:(BOOL)on animated:(BOOL)animated;

@end
