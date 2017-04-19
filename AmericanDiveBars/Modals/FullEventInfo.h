//
//  FullEventInfo.h
//  AmericanDiveBars
//
//  Created by spaculus on 9/23/15.
//  Copyright (c) 2015 spaculus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FullEventInfo : NSObject
@property (strong, nonatomic) EventDetail *eventDetail;
@property (strong, nonatomic) NSArray *aryEventGallery;
@property (strong, nonatomic) NSArray *aryEventTime;
@property (strong, nonatomic) NSString *strEventTime;
+(instancetype)getFullEventInfoWithDictionary:(NSDictionary *)dict;
@end
