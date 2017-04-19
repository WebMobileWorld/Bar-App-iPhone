//
//  BarEvent.m
//  AmericanDiveBars
//
//  Created by spaculus on 9/16/15.
//  Copyright (c) 2015 spaculus. All rights reserved.
//

#import "BarEvent.h"

@implementation BarEvent
+(instancetype)getBarEventWithDictionary:(NSDictionary *)dict {
    BarEvent *barEvent = [[BarEvent alloc] init];
    
    barEvent.barEvent_event_title = [CommonUtils getNotNullString:[dict valueForKey:@"event_title"]];
    barEvent.barEvent_event_id = [CommonUtils getNotNullString:[dict valueForKey:@"event_id"]];
    barEvent.barEvent_event_desc = [CommonUtils getNotNullString:[dict valueForKey:@"event_desc"]];
    barEvent.barEvent_start_date = [CommonUtils getNotNullString:[dict valueForKey:@"start_date"]];
    barEvent.barEvent_event_image = [CommonUtils getNotNullString:[dict valueForKey:@"event_image"]];
    
    barEvent.barEvent_event_lat = [CommonUtils getNotNullString:[dict valueForKey:@"event_lat"]];
    barEvent.barEvent_event_lng = [CommonUtils getNotNullString:[dict valueForKey:@"event_lng"]];
    barEvent.barEvent_venue = [CommonUtils getNotNullString:[dict valueForKey:@"venue"]];
    
    return barEvent;
}
@end
