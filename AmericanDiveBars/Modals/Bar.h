//
//  Bar.h
//  AmericanDiveBars
//
//  Created by spaculus on 9/4/15.
//  Copyright (c) 2015 spaculus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Bar : NSObject

@property (strong, nonatomic) NSString *bar_address;
@property (strong, nonatomic) NSString *bar_desc;
@property (strong, nonatomic) NSString *bar_id;
@property (strong, nonatomic) NSString *bar_logo;
@property (strong, nonatomic) NSString *bar_title;
@property (strong, nonatomic) NSString *bar_type;
@property (strong, nonatomic) NSString *bar_city;
@property (strong, nonatomic) NSString *bar_email;
@property (strong, nonatomic) NSString *bar_owner_id;
@property (strong, nonatomic) NSString *bar_phone;
@property (strong, nonatomic) NSString *bar_state;
@property (strong, nonatomic) NSString *bar_total_commnets;
@property (strong, nonatomic) NSString *bar_total_rating;
@property (strong, nonatomic) NSString *bar_zipcode;
@property (strong, nonatomic) NSString *bar_lat;
@property (strong, nonatomic) NSString *bar_lng;


@property (strong, nonatomic) NSString *bar_sph_duration;

@property (strong, nonatomic) NSString *fullAddress;

+(instancetype)getBarWithDictionary:(NSDictionary *)dict;

@end
