//
//  TaxiDetail.h
//  AmericanDiveBars
//
//  Created by spaculus on 10/1/15.
//  Copyright © 2015 spaculus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaxiDetail : NSObject
@property (strong, nonatomic) NSString *taxi_address;
@property (strong, nonatomic) NSString *taxi_city;
@property (strong, nonatomic) NSString *taxi_cmpn_website;
@property (strong, nonatomic) NSString *taxi_cmpn_zipcode;
@property (strong, nonatomic) NSString *taxi_first_name;
@property (strong, nonatomic) NSString *taxi_last_name;
@property (strong, nonatomic) NSString *taxi_mobile_no;
@property (strong, nonatomic) NSString *taxi_phone_number;
@property (strong, nonatomic) NSString *taxi_state;
@property (strong, nonatomic) NSString *taxi_taxi_company;
@property (strong, nonatomic) NSString *taxi_taxi_desc;
@property (strong, nonatomic) NSString *taxi_taxi_id;
@property (strong, nonatomic) NSString *taxi_taxi_image;
@property (strong, nonatomic) NSString *taxi_taxi_owner_id;

@property (strong, nonatomic) NSString *taxi_fullName;
@property (strong, nonatomic) NSString *fullAddress;
@property (strong, nonatomic) NSString *fullAddress_Unformated;

+(instancetype)getTaxiDetailWithDictionary:(NSDictionary *)dict;
@end
