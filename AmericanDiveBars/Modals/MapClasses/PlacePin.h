//
//  PlacePin.h
//  MauiRealEstate
//
//  Created by ripal on 5/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface PlacePin : NSObject<MKAnnotation> {
    CLLocationCoordinate2D coordinate; 
	NSString *title; 
	NSString *subtitle;
    int nTag;
    BOOL isEvent;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy, readonly) NSString *image;
@property (nonatomic,copy) NSString *title; 
@property (nonatomic,copy) NSString *subtitle;
@property (nonatomic) int nTag;
@property (nonatomic,assign) BOOL isEvent;

- (id)initWithLocation:(CLLocationCoordinate2D)coord;
- (id)initWithLocation:(CLLocationCoordinate2D)coord image:(NSString *)paramImage;

@end