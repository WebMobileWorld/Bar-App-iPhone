//
//  EventDetail.h
//  AmericanDiveBars
//
//  Created by spaculus on 9/23/15.
//  Copyright (c) 2015 spaculus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventDetail : NSObject
@property (strong, nonatomic) NSString *eventDetail_event_title;
@property (strong, nonatomic) NSString *eventDetail_event_id;
@property (strong, nonatomic) NSString *eventDetail_event_desc;
@property (strong, nonatomic) NSString *eventDetail_start_date;
@property (strong, nonatomic) NSString *eventDetail_event_image;
@property (strong, nonatomic) NSString *eventDetail_bar_title;

@property (strong, nonatomic) NSString *eventDetail_start_date_converted;
@property (strong, nonatomic) NSString *eventDetail_end_date_converted;
@property (strong, nonatomic) NSString *eventDetail_OrganizedDate;
//@property (strong, nonatomic) NSString *eventDetail_OrganizedTime;
@property (strong, nonatomic) NSString *eventDetail_Category;

@property (strong, nonatomic) NSString *eventDetail_start_Time_converted;
@property (strong, nonatomic) NSString *eventDetail_end_Time_converted;


@property (strong, nonatomic) NSString *eventDetail_end_date;
@property (strong, nonatomic) NSString *eventDetail_event_address;
@property (strong, nonatomic) NSString *eventDetail_event_city;
@property (strong, nonatomic) NSString *eventDetail_event_state;
@property (strong, nonatomic) NSString *eventDetail_event_zipcode;
@property (strong, nonatomic) NSString *fullAddress;
@property (strong, nonatomic) NSString *fullAddress_Unformated;
+(instancetype)getEventDetailWithDictionary:(NSDictionary *)dict;
@end
