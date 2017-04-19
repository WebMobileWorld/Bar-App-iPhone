//
//  BeerDirectory.m
//  AmericanDiveBars
//
//  Created by spaculus on 9/11/15.
//  Copyright (c) 2015 spaculus. All rights reserved.
//

#import "BeerDirectory.h"

@implementation BeerDirectory
+(instancetype)getBeerWithDictionary:(NSDictionary *)dict {
    BeerDirectory *beer = [[BeerDirectory alloc] init];

    beer.beer_id = [CommonUtils getNotNullString:[dict valueForKey:@"beer_id"]];
    beer.beer_image = [CommonUtils getNotNullString:[dict valueForKey:@"beer_image"]];
    beer.beer_name = [CommonUtils getNotNullString:[dict valueForKey:@"beer_name"]];
    beer.beer_type = [CommonUtils getNotNullString:[dict valueForKey:@"beer_type"]];
    beer.beer_website = [CommonUtils getNotNullString:[dict valueForKey:@"beer_website"]];
    beer.beer_city_produced = [CommonUtils getNotNullString:[dict valueForKey:@"city_produced"]];
    beer.beer_producer = [CommonUtils getNotNullString:[dict valueForKey:@"producer"]];
    beer.beer_status = [CommonUtils getNotNullString:[dict valueForKey:@"status"]];
    
    return beer;
}

@end
