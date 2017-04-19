//
//  TaxiDirectory.h
//  AmericanDiveBars
//
//  Created by spaculus on 9/12/15.
//  Copyright (c) 2015 spaculus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaxiDirectory : NSObject

@property (strong, nonatomic) NSString *taxi_address;
@property (strong, nonatomic) NSString *taxi_city;
@property (strong, nonatomic) NSString *taxi_cmpn_zipcode;
@property (strong, nonatomic) NSString *taxi_phone_number;
@property (strong, nonatomic) NSString *taxi_state;
@property (strong, nonatomic) NSString *taxi_status;
@property (strong, nonatomic) NSString *taxi_company;
@property (strong, nonatomic) NSString *taxi_id;
@property (strong, nonatomic) NSString *taxi_image;
@property (strong, nonatomic) NSString *taxi_desc;
@property (strong, nonatomic) NSString *fulladdress;
+(instancetype)getTaxiWithDictionary:(NSDictionary *)dict;
@end
