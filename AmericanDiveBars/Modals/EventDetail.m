//
//  EventDetail.m
//  AmericanDiveBars
//
//  Created by spaculus on 9/23/15.
//  Copyright (c) 2015 spaculus. All rights reserved.
//

#import "EventDetail.h"

@implementation EventDetail
+(instancetype)getEventDetailWithDictionary:(NSDictionary *)dict {
    EventDetail *eventDetail = [[EventDetail alloc] init];
    
    eventDetail.eventDetail_event_title = [CommonUtils getNotNullString:[dict valueForKey:@"event_title"]];
    eventDetail.eventDetail_event_id = [CommonUtils getNotNullString:[dict valueForKey:@"event_id"]];
    eventDetail.eventDetail_event_desc = [CommonUtils getNotNullString:[dict valueForKey:@"event_desc"]];
    eventDetail.eventDetail_start_date = [CommonUtils getNotNullString:[dict valueForKey:@"start_date"]];
    eventDetail.eventDetail_end_date = [CommonUtils getNotNullString:[dict valueForKey:@"end_date"]];
    eventDetail.eventDetail_bar_title = [CommonUtils getNotNullString:[dict valueForKey:@"bar_title"]];
    //eventDetail.eventDetail_event_image = [CommonUtils getNotNullString:[dict valueForKey:@"event_image"]];
    
    eventDetail.eventDetail_event_address = [CommonUtils getNotNullString:[dict valueForKey:@"address"]];
    eventDetail.eventDetail_event_city = [CommonUtils getNotNullString:[dict valueForKey:@"city"]];
    eventDetail.eventDetail_event_state = [CommonUtils getNotNullString:[dict valueForKey:@"state"]];
    eventDetail.eventDetail_event_zipcode = [CommonUtils getNotNullString:[dict valueForKey:@"zipcode"]];
    eventDetail.eventDetail_Category = [CommonUtils getNotNullString:[dict valueForKey:@"event_category"]];
    
    eventDetail.fullAddress = [EventDetail getFullAddress:eventDetail.eventDetail_event_address
                                             withCity:eventDetail.eventDetail_event_city
                                            withState:eventDetail.eventDetail_event_state
                                               andZip:eventDetail.eventDetail_event_zipcode];
    
    eventDetail.fullAddress_Unformated = [EventDetail getFullAddressUnformated:eventDetail.eventDetail_event_address
                                                           withCity:eventDetail.eventDetail_event_city
                                                          withState:eventDetail.eventDetail_event_state
                                                             andZip:eventDetail.eventDetail_event_zipcode];
    
    eventDetail.eventDetail_start_date_converted = [EventDetail getEventDateFromDate:eventDetail.eventDetail_start_date];
    eventDetail.eventDetail_end_date_converted = [EventDetail getEventDateFromDate:eventDetail.eventDetail_end_date];
    
    eventDetail.eventDetail_OrganizedDate = [NSString stringWithFormat:@"%@ To %@",eventDetail.eventDetail_start_date_converted,eventDetail.eventDetail_end_date_converted];

    eventDetail.eventDetail_start_Time_converted = [EventDetail getTweleveHourFormatOfTimeFromDate:eventDetail.eventDetail_start_date];
    eventDetail.eventDetail_end_Time_converted = [EventDetail getTweleveHourFormatOfTimeFromDate:eventDetail.eventDetail_end_date];
     //eventDetail.eventDetail_OrganizedTime = [NSString stringWithFormat:@"%@ To %@",eventDetail.eventDetail_start_Time_converted,eventDetail.eventDetail_end_Time_converted];
    
    return eventDetail;
}

+(NSString *)getFullAddress:(NSString *)address withCity:(NSString *)city withState:(NSString *)state andZip:(NSString *)zip {
    
    NSString *fullAddr = nil;
    
    if ([address length]>0) {
        fullAddr = [NSString stringWithFormat:@"%@",address];
    }
    
    if ([city length] > 0) {
        if ([fullAddr length]>0) {
            fullAddr = [NSString stringWithFormat:@"%@,\n%@",fullAddr,city];
        }
        else {
            fullAddr = city;
        }
    }
    
    if ([state length] > 0) {
        if ([fullAddr length]>0) {
            fullAddr = [NSString stringWithFormat:@"%@,%@",fullAddr,state];
        }
        else {
            fullAddr = state;
        }
    }
    
    if ([zip length] > 0) {
        if ([fullAddr length]>0) {
            fullAddr = [NSString stringWithFormat:@"%@ %@",fullAddr,zip];
        }
        else {
            fullAddr = zip;
        }
    }
    
    
    if (fullAddr == nil) {
        fullAddr = @"";
    }
    
    return fullAddr;
}

+(NSString *)getFullAddressUnformated:(NSString *)address withCity:(NSString *)city withState:(NSString *)state andZip:(NSString *)zip {
    NSString *fullAddr = nil;
    
    if ([address length]>0) {
        fullAddr = [NSString stringWithFormat:@"%@",address];
    }
    
    if ([city length] > 0) {
        if ([fullAddr length]>0) {
            fullAddr = [NSString stringWithFormat:@"%@,%@",fullAddr,city];
        }
        else {
            fullAddr = city;
        }
    }
    
    if ([state length] > 0) {
        if ([fullAddr length]>0) {
            fullAddr = [NSString stringWithFormat:@"%@,%@",fullAddr,state];
        }
        else {
            fullAddr = state;
        }
    }
    
    if ([zip length] > 0) {
        if ([fullAddr length]>0) {
            fullAddr = [NSString stringWithFormat:@"%@ %@",fullAddr,zip];
        }
        else {
            fullAddr = zip;
        }
    }
    
    
    if (fullAddr == nil) {
        fullAddr = @"";
    }
    
    return fullAddr;
}

+(NSString *)getEventDateFromDate:(NSString *)strEventDate {
    NSString *strDate = [CommonUtils getDateFormattedFromStringDate:strEventDate withInputFormat:@"yyyy-MM-dd HH:mm:ss" andOutputFormat:@"MM-dd-yyyy" isString:YES];
    return strDate;
}

+(NSString *)getTweleveHourFormatOfTimeFromDate:(NSString *)strDate{
    
    NSString *strTime = (NSString *)[[strDate componentsSeparatedByString:@" "] lastObject];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"HH:mm:ss";
    NSDate *date = [dateFormatter dateFromString:strTime];
    
    dateFormatter.dateFormat = @"hh:mm a";
    NSString *pmamDateString = [dateFormatter stringFromDate:date];
    
    return pmamDateString;
}
@end
