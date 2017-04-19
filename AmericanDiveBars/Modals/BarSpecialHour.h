//
//  BarSpecialHour.h
//  AmericanDiveBars
//
//  Created by spaculus on 2/24/16.
//  Copyright © 2016 spaculus. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SPHDetail;
@interface BarSpecialHour : NSObject

@property (strong, nonatomic) NSString *sph_bar_hour_id;
@property (strong, nonatomic) NSString *sph_bar_id;
@property (strong, nonatomic) NSString *sph_day;
@property (strong, nonatomic) NSString *sph_days;

@property (strong, nonatomic) NSString *sph_hour_from;
@property (strong, nonatomic) NSString *sph_hour_to;
@property (strong, nonatomic) NSString *sph_price;
@property (strong, nonatomic) NSString *sph_speciality;

@property (strong, nonatomic) NSString *sph_duration;
@property (strong, nonatomic) SPHDetail *sph_detail;

@property (strong, nonatomic) NSString *sph_cat;

@property (strong, nonatomic) NSArray *arySPH_Details;

+(instancetype)getBarSpecialHourWithDictionary:(NSDictionary *)dict;

@end

/*
 "bar_hour_id" = 7;
 "bar_id" = 68645;
 day = 1;
 days = Monday;
 "hour_from" = "6:00 PM";
 "hour_to" = "10:00 PM";
 price = "$10";
 speciality = "Rum Cocktails";
 */
