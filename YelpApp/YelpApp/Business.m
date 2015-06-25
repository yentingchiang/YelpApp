//
//  Business.m
//  YelpApp
//
//  Created by Tim Chiang on 2015/6/22.
//  Copyright (c) 2015年 Tim Chiang. All rights reserved.
//

#import "Business.h"

@implementation Business

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        NSArray *categories = dictionary[@"categories"];
        NSMutableArray *categoryNames = [NSMutableArray array];
        if (categories.count > 0) {
            [categories enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [categoryNames addObject:obj[0]];
            }];
        };
        
        self.categories = [categoryNames componentsJoinedByString:@", "];
        
        self.name = dictionary[@"name"];
        self.imageUrl = dictionary[@"image_url"];
        
        NSString *street = @"";
        NSArray *streetInDictionary = [dictionary valueForKeyPath:@"location.address"];
        if (streetInDictionary.count > 0) {
            street = streetInDictionary[0];
        }
            
        NSString *neighborhood = @"";
        NSArray *neighborhoodInDictionary = [dictionary valueForKeyPath:@"location.neighborhoods"];
        
        if (neighborhoodInDictionary.count > 0) {
            neighborhood = neighborhoodInDictionary[0];
        }
    
        self.address = [NSString stringWithFormat:@"%@ , %@", street, neighborhood];
        
        self.numReviews = [dictionary[@"review_count"] integerValue];
        self.ratingImageUrl = dictionary[@"rating_img_url"];
        
        float milesPerMeter = 0.000621371;
        self.distance = [dictionary[@"distance"] integerValue] *milesPerMeter;
    }
    
    return self;
}


+ (NSArray *)businessesWithDisctionaries:(NSArray *)distionaries {
   
    NSMutableArray *businesses = [NSMutableArray array];
    for (NSDictionary *dictionary in distionaries) {
        Business *business = [[Business alloc] initWithDictionary:dictionary];
        [businesses addObject:business];
    }
   
    return businesses;
}



@end
