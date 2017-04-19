//
//  FullEventInfo.m
//  AmericanDiveBars
//
//  Created by spaculus on 9/23/15.
//  Copyright (c) 2015 spaculus. All rights reserved.
//

#import "FullEventInfo.h"

@implementation FullEventInfo

+(instancetype)getFullEventInfoWithDictionary:(NSDictionary *)dict {
    FullEventInfo *eventInfo = [[FullEventInfo alloc] init];
    
    EventDetail *eventDetail = [EventDetail getEventDetailWithDictionary:[dict valueForKey:@"event_detail"]];
    eventInfo.eventDetail = eventDetail;
    eventInfo.aryEventGallery = [FullEventInfo getEventGallery:[dict valueForKey:@"event_gallery"]];
    eventInfo.aryEventTime = [dict valueForKey:@"eventtime"];
    eventInfo.strEventTime = @"";
    
    for(int i=0; i<[eventInfo.aryEventTime count]; i++)
    {
        NSString *dateString = [[eventInfo.aryEventTime objectAtIndex:i] valueForKey:@"eventdate"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *date = [[NSDate alloc] init];
        date = [dateFormatter dateFromString:dateString];
        [dateFormatter setDateFormat:@"EEEE, MMM dd, yyyy"];
        NSString *reqDateString = [dateFormatter stringFromDate:date];
        NSLog(@"date is %@", reqDateString);
        
        NSString *startTime = [[eventInfo.aryEventTime objectAtIndex:i] valueForKey:@"eventstarttime"];
        NSString *endTime = [[eventInfo.aryEventTime objectAtIndex:i] valueForKey:@"eventendtime"];
        
        if(i == [eventInfo.aryEventTime count] - 1)
        {
            eventInfo.strEventTime = [eventInfo.strEventTime stringByAppendingString:[NSString stringWithFormat:@"%@\n%@ - %@",reqDateString,startTime,endTime]];
        }
        else
        {
            eventInfo.strEventTime = [eventInfo.strEventTime stringByAppendingString:[NSString stringWithFormat:@"%@\n%@ - %@\n\n",reqDateString,startTime,endTime]];
        }
    }
    
    NSLog(@"eventInfo.strEventTime -%@", eventInfo.strEventTime);
    
    return eventInfo;
}

+(NSArray *)getEventGallery:(NSArray *)aryEventGallery_ {
    NSMutableArray *aryImages = [@[] mutableCopy];
    if ([aryImages count]>0) {
        [aryImages removeAllObjects];
    }
    
    for (NSDictionary *dict in aryEventGallery_) {
        EventGallery *eventGallery = [EventGallery getEventGalleryWithDictionary:dict];
        [aryImages addObject:eventGallery];
    }
    return aryImages;
}

@end
