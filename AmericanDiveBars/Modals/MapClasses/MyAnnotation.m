//
//  MyAnnotation.m
//  voice
//
//  Created by Hightech on 8/5/14.
//  Copyright (c) 2014 Hightech. All rights reserved.
//

#import "MyAnnotation.h"

@implementation MyAnnotation
@synthesize coordinate;

@synthesize title;

@synthesize time;

@synthesize subTitle;

-(id)initWithCoordinate:(CLLocationCoordinate2D) c title:(NSString *) t subTitle:(NSString *)timed time:(NSString *)tim

{
    
    self.coordinate=c;
    
    self.time=tim;
    
    self.subTitle=timed;
    
    self.title=t;
    
    return self;
    
}

-(id)initWithCoordinate:(CLLocationCoordinate2D) c title:(NSString *)tit

{
    
    self.coordinate=c;
    
    self.title=tit;
    
    return self;
    
}

@end
