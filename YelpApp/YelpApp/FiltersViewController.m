//
//  FiltersViewController.m
//  YelpApp
//
//  Created by Tim Chiang on 2015/6/23.
//  Copyright (c) 2015年 Tim Chiang. All rights reserved.
//

#import "FiltersViewController.h"
#import "FilterCell.h"

@interface FiltersViewController () <UITableViewDelegate, UITableViewDataSource, FilterCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, readonly) NSDictionary *filters;
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) NSArray *sortModes;
@property (nonatomic, strong) NSArray *radius;
@property (nonatomic, strong) NSArray *deals;
@property (nonatomic, strong) NSArray *titleForSection;
@property (nonatomic, strong) NSMutableArray *filterGroup;

@end

@implementation FiltersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self initFilterGroup];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSDictionary *)filters {
    NSMutableDictionary *filters = [NSMutableDictionary dictionary];
    
    if (self.selectedCategories > 0) {
        NSMutableArray *names = [NSMutableArray array];
        for (NSDictionary *category in self.selectedCategories)  {
            [names addObject:category[@"code"]];
        }
        
        NSString *categoryFilter = [names componentsJoinedByString:@","];
        [filters setObject:categoryFilter forKey:@"category_filter"];
        
    }
    
    return filters;
}

- (IBAction)onCancel:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)onSearch:(id)sender {
    
    //[self.delegate filtersViewController:self didChangeFilters:self.filters];
    [self.delegate filtersViewController:self didChangeWithCategoryFilters:self.filters withDeals:self.selectedDeals withSortMode:self.selectedSortMode withRadius:self.selectedRadius selectedCateory:self.selectedCategories];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.filterGroup.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 3) {
        return [self.filterGroup[section] count];
    } else {
        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    FilterCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"FilterCell" forIndexPath:indexPath];
 
    switch (indexPath.section) {
            
        case 0:
            // deals
            cell.radiusSegment.hidden = YES;
            cell.sortSegment.hidden = YES;
            
            cell.nameLabel.text = self.deals[indexPath.row][@"name"];
            
            [cell.dealsSwitch setOn:self.selectedDeals animated:NO];
            
            cell.filterSwitch.hidden = YES;
            cell.delegate = self;
            break;
            
        case 1:
            // radius
            cell.dealsSwitch.hidden = YES;
            cell.sortSegment.hidden = YES;
            
            cell.nameLabel.hidden = YES;
            cell.filterSwitch.hidden = YES;
            [self setSegmentControl:cell.radiusSegment withData:self.filterGroup[indexPath.section]];
            cell.radiusSegment.selectedSegmentIndex = self.selectedRadius;
            cell.delegate = self;
            break;
            
        case 2:
            // sortMdoe
            cell.dealsSwitch.hidden = YES;
            cell.radiusSegment.hidden = YES;
            
            cell.filterSwitch.hidden = YES;
            cell.nameLabel.hidden = YES;
            [self setSegmentControl:cell.sortSegment withData:self.filterGroup[indexPath.section]];
            cell.sortSegment.selectedSegmentIndex = self.selectedSortMode;
            cell.delegate = self;
            break;
            
        case 3:
            
            cell.dealsSwitch.hidden = YES;
            cell.radiusSegment.hidden = YES;
            cell.sortSegment.hidden = YES;
            
            cell.on = [self.selectedCategories containsObject:self.categories[indexPath.row]];
            cell.delegate = self;
            cell.nameLabel.text = self.categories[indexPath.row][@"name"];
            break;
            
        default:
            break;
    }
    
    return cell;
}


- (void)setSegmentControl:(UISegmentedControl *)segment withData:(NSArray *)data {
   
    int count = (int)data.count;
    for (int i = 0; i <count; i++ ) {
        [segment setTitle:data[i] forSegmentAtIndex:i];
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return self.titleForSection[section];
}

- (void)filterCell:(FilterCell *)cell didUpdateCategoryValue:(BOOL)value {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    if (value) {
        [self.selectedCategories addObject:self.categories[indexPath.row]];
    } else {
        [self.selectedCategories removeObject:self.categories[indexPath.row]];
    }
}

- (void)filterCell:(FilterCell *)cell didUpdateDealsValue:(BOOL)value {
    if (value) {
        self.selectedDeals = YES;
    } else {
        self.selectedDeals = NO;
    }
}

- (void)filterCell:(FilterCell *)cell didUpdateRadiusValue:(NSInteger)value {

    self.selectedRadius = cell.radiusSegment.selectedSegmentIndex;
}

- (void)filterCell:(FilterCell *)cell didUpdateSortModeValue:(NSInteger)value {
    self.selectedSortMode = cell.sortSegment.selectedSegmentIndex;
}


- (void)initDeals{
    
    self.deals =
    @[
       @{@"name": @"Offering a Deal", @"code" : @"on" },
    ];
}

//Sort mode: 0=Best matched (default), 1=Distance, 2=Highest Rated.

- (void)initSortModes {
    self.sortModes =
    @[
       @"Best matched",
       @"Distance",
       @"Highest"
    ];
}

- (void)initRadius {
    self.radius =
    @[
       @"Auto",
       @"5 miles",
       @"10 miles",
       @"15 miles"
    ];
}


- (void)initCategories {
    self.categories =
    @[
       @{@"name": @"American, New", @"code" : @"newamerican" },
       @{@"name": @"American, Traditional", @"code" : @"tradamerican" },
       @{@"name": @"Arabian", @"code" : @"arabian" },
       @{@"name": @"Argentine", @"code" : @"argentine" },
       @{@"name": @"Armenian", @"code" : @"armenian" },
       @{@"name": @"Asian Fusion", @"code" : @"asianfusion" },
    ];
}

- (void)initTitleForSection {
    self.titleForSection =
    @[@"Deals", @"Radius", @"Sort", @"Category"];
}

- (void)initFilterGroup {
    
    [self initTitleForSection];
    [self initDeals];
    [self initRadius];
    [self initSortModes];
    [self initCategories];
    
    self.filterGroup = [[NSMutableArray alloc] initWithObjects:
                        self.deals,
                        self.radius,
                        self.sortModes,
                        self.categories,
                        nil];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
