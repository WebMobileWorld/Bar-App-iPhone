//
//  BeerServed.h
//  AmericanDiveBars
//
//  Created by spaculus on 9/16/15.
//  Copyright (c) 2015 spaculus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BeerServed : NSObject

@property (strong, nonatomic) NSString *beer_id;
@property (strong, nonatomic) NSString *beer_image;
@property (strong, nonatomic) NSString *beer_name;
@property (strong, nonatomic) NSString *beer_type;
@property (strong, nonatomic) NSString *beer_city_produced;
@property (strong, nonatomic) NSString *beer_producer;
@property (strong, nonatomic) NSString *beer_state;

+(instancetype)getBeerServedWithDictionary:(NSDictionary *)dict;

@end
