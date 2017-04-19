//
//  BarHour.h
//  AmericanDiveBars
//
//  Created by spaculus on 9/16/15.
//  Copyright (c) 2015 spaculus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BarHour : NSObject
@property (strong, nonatomic) NSString *barHour_days;
@property (strong, nonatomic) NSString *barHour_start_from;
@property (strong, nonatomic) NSString *barHour_start_to;
@property (strong, nonatomic) NSString *barHour_is_closed;

+(instancetype)getBarHourWithDictionary:(NSDictionary *)dict;
@end
