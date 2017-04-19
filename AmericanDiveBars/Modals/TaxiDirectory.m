//
//  TaxiDirectory.m
//  AmericanDiveBars
//
//  Created by spaculus on 9/12/15.
//  Copyright (c) 2015 spaculus. All rights reserved.
//

#import "TaxiDirectory.h"

@implementation TaxiDirectory
+(instancetype)getTaxiWithDictionary:(NSDictionary *)dict {
    TaxiDirectory *taxi = [[TaxiDirectory alloc] init];
    
    taxi.taxi_address = [CommonUtils getNotNullString:[dict valueForKey:@"address"]];
    taxi.taxi_city = [CommonUtils getNotNullString:[dict valueForKey:@"city"]];
    taxi.taxi_cmpn_zipcode = [CommonUtils getNotNullString:[dict valueForKey:@"cmpn_zipcode"]];
    taxi.taxi_phone_number = [CommonUtils getNotNullString:[dict valueForKey:@"phone_number"]];
    taxi.taxi_state = [CommonUtils getNotNullString:[dict valueForKey:@"state"]];
    taxi.taxi_status = [CommonUtils getNotNullString:[dict valueForKey:@"status"]];
    taxi.taxi_company = [CommonUtils getNotNullString:[dict valueForKey:@"taxi_company"]];
    taxi.taxi_id = [CommonUtils getNotNullString:[dict valueForKey:@"taxi_id"]];
    taxi.taxi_image = [CommonUtils getNotNullString:[dict valueForKey:@"taxi_image"]];
    taxi.taxi_desc = [CommonUtils getNotNullString:[dict valueForKey:@"taxi_desc"]];
    taxi.fulladdress = [TaxiDirectory getFullAddress:taxi.taxi_address withCity:taxi.taxi_city withState:taxi.taxi_state andZip:taxi.taxi_cmpn_zipcode];
    
    return taxi;
}


+(NSString *)getFullAddress:(NSString *)address withCity:(NSString *)city withState:(NSString *)state andZip:(NSString *)zip {
    
    NSString *fullAddr = nil;
    
    if ([address length]>0) {
        fullAddr = [NSString stringWithFormat:@"%@",address];
    }
    
    if ([city length] > 0) {
        if ([fullAddr length]>0) {
            fullAddr = [NSString stringWithFormat:@"%@,\n%@",fullAddr,city];
        }
        else {
            fullAddr = city;
        }
    }
    
    if ([state length] > 0) {
        if ([fullAddr length]>0) {
            fullAddr = [NSString stringWithFormat:@"%@,%@",fullAddr,state];
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
