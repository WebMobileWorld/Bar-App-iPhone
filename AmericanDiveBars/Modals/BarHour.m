//
//  BarHour.m
//  AmericanDiveBars
//
//  Created by spaculus on 9/16/15.
//  Copyright (c) 2015 spaculus. All rights reserved.
//

#import "BarHour.h"

@implementation BarHour
+(instancetype)getBarHourWithDictionary:(NSDictionary *)dict {
    BarHour *barHour = [[BarHour alloc] init];
  
    barHour.barHour_days = [CommonUtils getNotNullString:[dict valueForKey:@"days"]];
    barHour.barHour_start_from = [BarHour getTweleveHourFormatOfTime:[CommonUtils getNotNullString:[dict valueForKey:@"start_from"]]];
    barHour.barHour_start_to = [BarHour getTweleveHourFormatOfTime:[CommonUtils getNotNullString:[dict valueForKey:@"start_to"]]];
    barHour.barHour_is_closed = [CommonUtils getNotNullString:[dict valueForKey:@"is_closed"]];
    
    return barHour;
}

+(NSString *)getTweleveHourFormatOfTime:(NSString *)strTime {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"HH:mm:ss";
    NSDate *date = [dateFormatter dateFromString:strTime];
    
    dateFormatter.dateFormat = @"hh:mm a";
    NSString *pmamDateString = [dateFormatter stringFromDate:date];
    
    return pmamDateString;
}

@end
