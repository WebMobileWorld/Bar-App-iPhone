//
//  Bar.m
//  AmericanDiveBars
//
//  Created by spaculus on 9/4/15.
//  Copyright (c) 2015 spaculus. All rights reserved.
//

#import "Bar.h"

@implementation Bar

+(instancetype)getBarWithDictionary:(NSDictionary *)dict {
    Bar *bar = [[Bar alloc] init];
    
    bar.bar_address = [CommonUtils getNotNullString:[dict valueForKey:@"address"]];
    bar.bar_desc = [CommonUtils getNotNullString:[dict valueForKey:@"bar_desc"]];
    bar.bar_id = [CommonUtils getNotNullString:[dict valueForKey:@"bar_id"]];
    bar.bar_logo = [CommonUtils getNotNullString:[dict valueForKey:@"bar_logo"]];
    bar.bar_title = [CommonUtils getNotNullString:[dict valueForKey:@"bar_title"]];
    bar.bar_type = [CommonUtils getNotNullString:[dict valueForKey:@"bar_type"]];
    bar.bar_city = [CommonUtils getNotNullString:[dict valueForKey:@"city"]];
    bar.bar_email = [CommonUtils getNotNullString:[dict valueForKey:@"email"]];
    bar.bar_owner_id = [CommonUtils getNotNullString:[dict valueForKey:@"owner_id"]];
    bar.bar_phone = [CommonUtils getNotNullString:[dict valueForKey:@"phone"]];
    bar.bar_state = [CommonUtils getNotNullString:[dict valueForKey:@"state"]];
    bar.bar_total_commnets = [CommonUtils getNotNullString:[dict valueForKey:@"total_commnets"]];
    bar.bar_total_rating = [CommonUtils getNotNullString:[dict valueForKey:@"total_rating"]];
    bar.bar_zipcode = [CommonUtils getNotNullString:[dict valueForKey:@"zipcode"]];

    bar.bar_lat = [CommonUtils getNotNullString:[dict valueForKey:@"lat"]];
    bar.bar_lng = [CommonUtils getNotNullString:[dict valueForKey:@"lang"]];

    bar.bar_sph_duration = @"";
    
    bar.fullAddress = [Bar getFullAddress:bar.bar_address
                                             withCity:bar.bar_city
                                            withState:bar.bar_state
                                               andZip:bar.bar_zipcode];
    return bar;
}

+(NSString *)getFullAddress:(NSString *)address withCity:(NSString *)city withState:(NSString *)state andZip:(NSString *)zip {
    
    NSString *fullAddr = nil;
    
    if ([address length]>0) {
        fullAddr = [NSString stringWithFormat:@"%@",address];
    }
    
    if ([city length] > 0) {
        if ([fullAddr length]>0) {
            fullAddr = [NSString stringWithFormat:@"%@, %@",fullAddr,city];
        }
        else {
            fullAddr = city;
        }
    }
    
    if ([state length] > 0) {
        if ([fullAddr length]>0) {
            fullAddr = [NSString stringWithFormat:@"%@, %@",fullAddr,state];
        }
        else {
            fullAddr = state;
        }
    }
    
    if ([zip length] > 0) {
        if ([fullAddr length]>0) {
            fullAddr = [NSString stringWithFormat:@"%@ %@",fullAddr,zip];
        }
        else {
            fullAddr = zip;
        }
    }
    
    
    if (fullAddr == nil) {
        fullAddr = @"";
    }
    
    return fullAddr;
}


@end
