//
//  BeerServed.m
//  AmericanDiveBars
//
//  Created by spaculus on 9/16/15.
//  Copyright (c) 2015 spaculus. All rights reserved.
//

#import "BeerServed.h"

@implementation BeerServed
+(instancetype)getBeerServedWithDictionary:(NSDictionary *)dict {
    BeerServed *beerServed = [[BeerServed alloc] init];
    
    beerServed.beer_id = [CommonUtils getNotNullString:[dict valueForKey:@"beer_id"]];
    beerServed.beer_image = [CommonUtils getNotNullString:[dict valueForKey:@"beer_image"]];
    beerServed.beer_name = [CommonUtils getNotNullString:[dict valueForKey:@"beer_name"]];
    beerServed.beer_type = [CommonUtils getNotNullString:[dict valueForKey:@"beer_type"]];
    beerServed.beer_city_produced = [CommonUtils getNotNullString:[dict valueForKey:@"city_produced"]];
    beerServed.beer_producer = [CommonUtils getNotNullString:[dict valueForKey:@"producer"]];
    beerServed.beer_state = [CommonUtils getNotNullString:[dict valueForKey:@"state"]];
    
    return beerServed;
}
@end
