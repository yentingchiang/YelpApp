//
//  Business.h
//  YelpApp
//
//  Created by Tim Chiang on 2015/6/22.
//  Copyright (c) 2015年 Tim Chiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Business : NSObject

@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *ratingImageUrl;
@property (nonatomic, assign) NSInteger numReviews;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *categories;
@property (nonatomic, assign) CGFloat distance;


+ (NSArray *)businessesWithDisctionaries:(NSArray *)distionaries;

@end
