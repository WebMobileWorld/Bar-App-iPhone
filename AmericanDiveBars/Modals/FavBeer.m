//
//  FavBeer.m
//  AmericanDiveBars
//
//  Created by spaculus on 10/6/15.
//  Copyright © 2015 spaculus. All rights reserved.
//

#import "FavBeer.h"

@implementation FavBeer
+(instancetype)getFavBeerWithDictionary:(NSDictionary *)dict {
    FavBeer *favBeer = [[FavBeer alloc] init];
    favBeer.fav_beer_id = [CommonUtils getNotNullString:[dict valueForKey:@"beer_id"]];
    favBeer.fav_beer_name = [CommonUtils getNotNullString:[dict valueForKey:@"beer_name"]];
    favBeer.fav_beer_type = [CommonUtils getNotNullString:[dict valueForKey:@"beer_type"]];
    favBeer.fav_date_added = [CommonUtils getNotNullString:[dict valueForKey:@"date_added"]];
    favBeer.fav_beer_producer = [CommonUtils getNotNullString:[dict valueForKey:@"brewed_by"]];
    favBeer.fav_beer_image = [CommonUtils getNotNullString:[dict valueForKey:@"beer_image"]];
    
    favBeer.fav_checked = @"0";
    favBeer.indexPath = nil;
    return favBeer;
}
@end
