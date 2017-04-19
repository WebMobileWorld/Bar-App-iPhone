//
//  MyAnnotation.h
//  voice
//
//  Created by Hightech on 8/5/14.
//  Copyright (c) 2014 Hightech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MyAnnotation : NSObject
{
    
    CLLocationCoordinate2D coordinate;
    
    NSString *title;
    
    NSString *subTitle;
    
    NSString *time;
    
}

@property (nonatomic)CLLocationCoordinate2D coordinate;

@property (nonatomic, retain) NSString *title;

@property (nonatomic, retain) NSString *subTitle;

@property (nonatomic,retain) NSString *time;

-(id)initWithCoordinate:(CLLocationCoordinate2D) c title:(NSString *) t subTitle:(NSString *)timed time:(NSString *)tim;

-(id)initWithCoordinate:(CLLocationCoordinate2D) c title:(NSString *)tit;
@end
