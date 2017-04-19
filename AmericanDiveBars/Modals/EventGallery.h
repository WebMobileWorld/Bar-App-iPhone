//
//  EventGallery.h
//  AmericanDiveBars
//
//  Created by spaculus on 9/23/15.
//  Copyright (c) 2015 spaculus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventGallery : NSObject

@property (strong, nonatomic) NSString *eventGal_bar_eventgallery_id;
@property (strong, nonatomic) NSString *eventGal_event_image_id;
@property (strong, nonatomic) NSString *eventGal_event_image_name;
@property (strong, nonatomic) NSURL *eventGal_OriginalImageURL;

+(instancetype)getEventGalleryWithDictionary:(NSDictionary *)dict;
@end
