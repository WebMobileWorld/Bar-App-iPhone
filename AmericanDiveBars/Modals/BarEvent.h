//
//  BarEvent.h
//  AmericanDiveBars
//
//  Created by spaculus on 9/16/15.
//  Copyright (c) 2015 spaculus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BarEvent : NSObject
@property (strong, nonatomic) NSString *barEvent_event_title;
@property (strong, nonatomic) NSString *barEvent_event_id;
@property (strong, nonatomic) NSString *barEvent_event_desc;
@property (strong, nonatomic) NSString *barEvent_start_date;
@property (strong, nonatomic) NSString *barEvent_event_image;

@property (strong, nonatomic) NSString *barEvent_event_lat;
@property (strong, nonatomic) NSString *barEvent_event_lng;
@property (strong, nonatomic) NSString *barEvent_venue;

+(instancetype)getBarEventWithDictionary:(NSDictionary *)dict;
@end
