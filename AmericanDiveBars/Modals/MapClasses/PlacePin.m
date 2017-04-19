//
//  PlacePin.m
//  MauiRealEstate
//
//  Created by ripal on 5/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PlacePin.h"


@implementation PlacePin

@synthesize coordinate,title,subtitle;
@synthesize nTag;
@synthesize isEvent;

- (id)initWithLocation:(CLLocationCoordinate2D)coord image:(NSString *)paramImage{
    
    self = [super init];	
    if (self) {			
        coordinate = coord;
        _image = paramImage;
    }
    return self;	
}

- (id)initWithLocation:(CLLocationCoordinate2D)coord
{
    
    self = [super init];
    if (self) {
        coordinate = coord;
    }
    return self;
}


@end