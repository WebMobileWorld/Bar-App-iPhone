//
//  BeerDetail.h
//  AmericanDiveBars
//
//  Created by spaculus on 9/28/15.
//  Copyright (c) 2015 spaculus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BeerDetail : NSObject
@property (strong, nonatomic) NSString *beer_id;
@property (strong, nonatomic) NSString *beer_image;
@property (strong, nonatomic) NSString *beer_name;
@property (strong, nonatomic) NSString *beer_type;
@property (strong, nonatomic) NSString *beer_website;
@property (strong, nonatomic) NSString *beer_city_produced;
@property (strong, nonatomic) NSString *beer_producer;

@property (strong, nonatomic) NSString *beer_abv;
@property (strong, nonatomic) NSString *beer_beer_desc;
@property (strong, nonatomic) NSString *beer_fav_beer;
@property (strong, nonatomic) NSString *beer_image_default;
@property (strong, nonatomic) NSString *beer_like_beer;
@property (strong, nonatomic) NSString *beer_upload_type;
@property (strong, nonatomic) NSString *beer_video_link;

@property (strong, nonatomic) NSString *beer_status;
@property (strong, nonatomic) NSString *beer_slug;


+(instancetype)getBeerDetailWithDictionary:(NSDictionary *)dict;

@end
