//
//  EventGallery.m
//  AmericanDiveBars
//
//  Created by spaculus on 9/23/15.
//  Copyright (c) 2015 spaculus. All rights reserved.
//

#import "EventGallery.h"

@implementation EventGallery
+(instancetype)getEventGalleryWithDictionary:(NSDictionary *)dict {
    EventGallery *eventGallery = [[EventGallery alloc] init];
    
    eventGallery.eventGal_bar_eventgallery_id = [CommonUtils getNotNullString:[dict valueForKey:@"bar_eventgallery_id"]];
    eventGallery.eventGal_event_image_id  = [CommonUtils getNotNullString:[dict valueForKey:@"event_image_id"]];
    eventGallery.eventGal_event_image_name = [CommonUtils getNotNullString:[dict valueForKey:@"event_image_name"]];
    eventGallery.eventGal_OriginalImageURL = [EventGallery getOriginalImageURLByName:eventGallery.eventGal_event_image_name];
    return eventGallery;
}
+(NSURL *)getOriginalImageURLByName:(NSString *)imageName {
    NSString *strImgURL = [NSString stringWithFormat:@"%@%@%@",WEBIMAGE_URL,BAR_EVENTGALLERY_ORIGINAL,imageName];
    NSURL *imgURL = [NSURL URLWithString:strImgURL];
    return imgURL;
}
@end
