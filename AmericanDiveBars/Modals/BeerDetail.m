//
//  BeerDetail.m
//  AmericanDiveBars
//
//  Created by spaculus on 9/28/15.
//  Copyright (c) 2015 spaculus. All rights reserved.
//

#import "BeerDetail.h"

@implementation BeerDetail

+(instancetype)getBeerDetailWithDictionary:(NSDictionary *)dict {
    BeerDetail *beerDetail = [[BeerDetail alloc] init];
    
    beerDetail.beer_id = [CommonUtils getNotNullString:[dict valueForKey:@"beer_id"]];
    beerDetail.beer_image = [CommonUtils getNotNullString:[dict valueForKey:@"beer_image"]];
    beerDetail.beer_name = [CommonUtils getNotNullString:[dict valueForKey:@"beer_name"]];
    beerDetail.beer_type = [CommonUtils getNotNullString:[dict valueForKey:@"beer_type"]];
    beerDetail.beer_website = [CommonUtils getNotNullString:[dict valueForKey:@"beer_website"]];
    beerDetail.beer_city_produced = [CommonUtils getNotNullString:[dict valueForKey:@"city_produced"]];
    beerDetail.beer_producer = [CommonUtils getNotNullString:[dict valueForKey:@"producer"]];
    beerDetail.beer_slug = [CommonUtils getNotNullString:[dict valueForKey:@"beer_slug"]];
    
    beerDetail.beer_abv =  [CommonUtils getNotNullString:[dict valueForKey:@"abv"]];
    beerDetail.beer_beer_desc = [CommonUtils getNotNullString:[dict valueForKey:@"beer_desc"]];
    beerDetail.beer_fav_beer = [CommonUtils getNotNullString:[dict valueForKey:@"fav_beer"]];
    beerDetail.beer_image_default = [CommonUtils getNotNullString:[dict valueForKey:@"image_default"]];
    beerDetail.beer_like_beer = [CommonUtils getNotNullString:[dict valueForKey:@"like_beer"]];
    beerDetail.beer_upload_type = [CommonUtils getNotNullString:[dict valueForKey:@"upload_type"]];
    beerDetail.beer_video_link = [CommonUtils getNotNullString:[dict valueForKey:@"video_link"]];
    
    beerDetail.beer_status = [CommonUtils getNotNullString:[dict valueForKey:@"status"]];
    
    return beerDetail;
}



@end
