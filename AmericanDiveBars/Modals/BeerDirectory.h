//
//  BeerDirectory.h
//  AmericanDiveBars
//
//  Created by spaculus on 9/11/15.
//  Copyright (c) 2015 spaculus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BeerDirectory : NSObject

@property (strong, nonatomic) NSString *beer_id;
@property (strong, nonatomic) NSString *beer_image;
@property (strong, nonatomic) NSString *beer_name;
@property (strong, nonatomic) NSString *beer_type;
@property (strong, nonatomic) NSString *beer_website;
@property (strong, nonatomic) NSString *beer_city_produced;
@property (strong, nonatomic) NSString *beer_producer;
@property (strong, nonatomic) NSString *beer_status;

+(instancetype)getBeerWithDictionary:(NSDictionary *)dict;
@end
