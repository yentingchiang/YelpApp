//
//  FiltersViewController.h
//  YelpApp
//
//  Created by Tim Chiang on 2015/6/23.
//  Copyright (c) 2015年 Tim Chiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FiltersViewController;

@protocol FiltersViewControllerDelegate <NSObject>

- (void)filtersViewController:(FiltersViewController *)filtersViewController didChangeWithCategoryFilters:(NSDictionary *)categoryFilters withDeals:(BOOL)deals withSortMode:(NSInteger)sortMode withRadius:(NSInteger)radius selectedCateory:(NSMutableSet *)selectedCategory;
@end

@interface FiltersViewController : UIViewController


@property (nonatomic, strong) NSMutableSet *selectedCategories;
@property (nonatomic) BOOL selectedDeals;
@property (nonatomic) NSInteger selectedRadius;
@property (nonatomic) NSInteger selectedSortMode;


@property (nonatomic, weak) id<FiltersViewControllerDelegate> delegate;

@end
