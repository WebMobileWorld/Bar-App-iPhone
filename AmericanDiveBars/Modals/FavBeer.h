//
//  FavBeer.h
//  AmericanDiveBars
//
//  Created by spaculus on 10/6/15.
//  Copyright © 2015 spaculus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FavBeer : NSObject
@property (strong, nonatomic) NSString *fav_beer_id;
@property (strong, nonatomic) NSString *fav_beer_name;
@property (strong, nonatomic) NSString *fav_beer_type;
@property (strong, nonatomic) NSString *fav_date_added;
@property (strong, nonatomic) NSString *fav_beer_producer;
@property (strong, nonatomic) NSString *fav_beer_image;

@property (strong, nonatomic) NSString *fav_checked;
@property (strong, nonatomic) NSIndexPath *indexPath;
+(instancetype)getFavBeerWithDictionary:(NSDictionary *)dict;

@end
