//
//  MainViewController.m
//  YelpApp
//
//  Created by Tim Chiang on 2015/6/23.
//  Copyright (c) 2015年 Tim Chiang. All rights reserved.
//

#import "MainViewController.h"

#import "YelpClient.h"
#import "Business.h"
#import "BusinessCell.h"
#import <UIImageView+AFNetworking.h>
#import "FiltersViewController.h"
#import <SVProgressHUD.h>


NSString * const kYelpConsumerKey = @"vxKwwcR_NMQ7WaEiQBK_CA";
NSString * const kYelpConsumerSecret = @"33QCvh5bIF5jIHR5klQr7RtBDhQ";
NSString * const kYelpToken = @"uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV";
NSString * const kYelpTokenSecret = @"mqtKIxMIR4iBtBPZCmCLEb-Dz3Y";

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate, FiltersViewControllerDelegate, UISearchBarDelegate>
@property (nonatomic, strong) NSArray *businesses;
@property (nonatomic, strong) YelpClient *client;
@property (nonatomic, strong) NSArray *CategorySwitchs;


//@property (nonatomic, strong) NSDictionary *filters;
@property (nonatomic, strong) NSDictionary *categoryFilters;

@property (nonatomic, strong) NSString *searchTerm;
@property (nonatomic, strong) NSString *defaultSearchTerm;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;


@property (nonatomic, strong) NSMutableSet *selectedCategories;
@property (nonatomic) BOOL selectedDeals;
@property (nonatomic) NSInteger selectedRadius;
@property (nonatomic) NSInteger selectedSortMode;


- (void)fetchBusinessesWithQuery:(NSString *)query params:(NSDictionary *)params;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
   
    self.tableView.estimatedRowHeight = 100.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.searchBar.delegate = self;
    
    self.selectedCategories = [NSMutableSet set];
    self.selectedDeals = NO;
    self.selectedRadius = 0;
    self.selectedSortMode = 0;
    self.defaultSearchTerm = @"Restaurants";
    self.searchTerm = self.defaultSearchTerm;
    
    [self initApi];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)initApi {
    
    self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
    
}

- (void)loadData {
   
    [self fetchBusinessesWithQuery:self.searchTerm params:nil];
}


- (void)fetchBusinessesWithQuery:(NSString *)query params:(NSDictionary *)params {
    
    [SVProgressHUD show];
    [self.client searchWithTerm:query params:params success:^(AFHTTPRequestOperation *operation, id response) {
        //NSLog(@"response: %@", response);
        
        NSArray *businessDictionaries = response[@"businesses"];
        if (businessDictionaries != nil) {
            self.businesses = [Business businessesWithDisctionaries:businessDictionaries];
        } else {
            self.businesses = [[NSArray alloc] init];
        }
        
        [SVProgressHUD dismiss];
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"error: %@", [error description]);
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.businesses.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BusinessCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BusinessCell" forIndexPath:indexPath];
    
    Business *business = self.businesses[indexPath.row];
    
    [cell.thumbImageView setImageWithURL:[NSURL URLWithString:business.imageUrl]];
    
    cell.nameLabel.text = business.name;
    
    [cell.ratingImageView setImageWithURL:[NSURL URLWithString:business.ratingImageUrl]];
    
    cell.ratingLabel.text = [NSString stringWithFormat:@"%ld Reviews", (long)business.numReviews ];
    
    cell.addressLabel.text = business.address;
    cell.categoryLabel.text = business.categories;
    cell.distanceLabel.text = [NSString stringWithFormat:@"%.2f mi", business.distance];
    
    //[cell setCustomData]
    
    return cell;
}

- (void) filtersViewController:(FiltersViewController *)filtersViewController didChangeWithCategoryFilters:(NSDictionary *)categoryFilters withDeals:(BOOL)deals withSortMode:(NSInteger)sortMode withRadius:(NSInteger)radius selectedCateory:(NSMutableSet *)selectedCategory {
    // do query
   
   
    NSMutableDictionary *allFilters = [NSMutableDictionary dictionary];
   
    NSString *searchCategory = categoryFilters[@"category_filter"];
    if (searchCategory.length > 0) {
        self.categoryFilters = categoryFilters;
        [allFilters addEntriesFromDictionary:categoryFilters];
    }
    self.selectedCategories = selectedCategory;
    
   
    if (deals) {
        [allFilters setObject:[NSNumber numberWithBool:deals] forKey:@"deals_filter"];
    }
    self.selectedDeals = deals;
   
    if (sortMode > 0) {
        [allFilters setObject:[NSNumber numberWithInt:(int)sortMode] forKey:@"sort"];
    }
    self.selectedSortMode = sortMode;
    
    if (radius > 0) {
        NSInteger memtersOfPerMiles = 1600;
        NSInteger radiusMeters = memtersOfPerMiles * 5 * radius;
        [allFilters setObject:[NSNumber numberWithInt:(int)radiusMeters] forKey:@"radius_filter"];
    }
    self.selectedRadius = radius;
    
   
    
    NSLog(@"search start");
    [self fetchBusinessesWithQuery:self.searchTerm params:allFilters];
}

#pragma mark - SearchBar

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    searchBar.text =@"";
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    self.searchTerm = searchBar.text;
    
    NSMutableDictionary *allFilters = [NSMutableDictionary dictionary];
    
    NSString *searchCategory = self.categoryFilters[@"category_filter"];
    if (searchCategory.length > 0) {
        [allFilters addEntriesFromDictionary:self.categoryFilters];
    }
   
    if (self.selectedDeals) {
        [allFilters setObject:[NSNumber numberWithBool:self.selectedDeals] forKey:@"deals_filter"];
    }
   
    if (self.selectedSortMode > 0) {
        [allFilters setObject:[NSNumber numberWithInt:(int)self.selectedSortMode] forKey:@"sort"];
    }
    
    if (self.selectedRadius > 0) {
        NSInteger memtersOfPerMiles = 1600;
        NSInteger radiusMeters = memtersOfPerMiles * 5 * self.selectedRadius;
        [allFilters setObject:[NSNumber numberWithInt:(int)radiusMeters] forKey:@"radius_filter"];
    }
    
    [self fetchBusinessesWithQuery:self.searchTerm params:allFilters];
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    UINavigationController *navVC = segue.destinationViewController;
    FiltersViewController *filter = (FiltersViewController*)navVC.topViewController;
    filter.delegate = self;
    
    filter.selectedCategories = self.selectedCategories;
    filter.selectedDeals = self.selectedDeals;
    filter.selectedRadius = self.selectedRadius;
    filter.selectedSortMode = self.selectedSortMode;

}

@end
