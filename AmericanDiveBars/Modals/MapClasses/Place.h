//
//  Place.h
//  voice
//
//  Created by Hightech on 8/5/14.
//  Copyright (c) 2014 Hightech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Place : NSObject
@property (nonatomic, strong) NSString *lat;
@property (nonatomic, strong) NSString *lng;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *addrs;
@property (nonatomic, strong) NSString *imgURL;
@property (nonatomic, strong) NSString *pinType;
@property (nonatomic, strong) NSString *isSource;
@property (nonatomic, strong) NSString *isDestination;
@property (nonatomic, strong) NSString *openDays;
@property (nonatomic, strong) NSString *bar_type;
@property (nonatomic, assign) BOOL isEvent;

@end
