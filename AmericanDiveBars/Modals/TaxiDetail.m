//
//  TaxiDetail.m
//  AmericanDiveBars
//
//  Created by spaculus on 10/1/15.
//  Copyright © 2015 spaculus. All rights reserved.
//

#import "TaxiDetail.h"

@implementation TaxiDetail
+(instancetype)getTaxiDetailWithDictionary:(NSDictionary *)dict {
    TaxiDetail *taxiDetail = [[TaxiDetail alloc] init];
    
    taxiDetail.taxi_address = [CommonUtils getNotNullString:[dict valueForKey:@"address"]];
    taxiDetail.taxi_city = [CommonUtils getNotNullString:[dict valueForKey:@"city"]];

    taxiDetail.taxi_cmpn_website = [CommonUtils getNotNullString:[dict valueForKey:@"cmpn_website"]];
    taxiDetail.taxi_cmpn_zipcode = [CommonUtils getNotNullString:[dict valueForKey:@"cmpn_zipcode"]];
    taxiDetail.taxi_first_name = [CommonUtils getNotNullString:[dict valueForKey:@"first_name"]];
    taxiDetail.taxi_last_name = [CommonUtils getNotNullString:[dict valueForKey:@"last_name"]];
    taxiDetail.taxi_mobile_no = [CommonUtils getNotNullString:[dict valueForKey:@"mobile_no"]];
    taxiDetail.taxi_phone_number = [CommonUtils getNotNullString:[dict valueForKey:@"phone_number"]];
    taxiDetail.taxi_state = [CommonUtils getNotNullString:[dict valueForKey:@"state"]];
    taxiDetail.taxi_taxi_company = [CommonUtils getNotNullString:[dict valueForKey:@"taxi_company"]];
    taxiDetail.taxi_taxi_desc = [CommonUtils getNotNullString:[dict valueForKey:@"taxi_desc"]];
    taxiDetail.taxi_taxi_id = [CommonUtils getNotNullString:[dict valueForKey:@"taxi_id"]];
    taxiDetail.taxi_taxi_image = [CommonUtils getNotNullString:[dict valueForKey:@"taxi_image"]];
    taxiDetail.taxi_taxi_owner_id = [CommonUtils getNotNullString:[dict valueForKey:@"taxi_owner_id"]];
    
    taxiDetail.taxi_fullName = [TaxiDetail getFullNameFromFirstName:taxiDetail.taxi_first_name
                                                                andLastName:taxiDetail.taxi_last_name];
    
    taxiDetail.fullAddress = [TaxiDetail getFullAddress:taxiDetail.taxi_address
                                             withCity:taxiDetail.taxi_city
                                            withState:taxiDetail.taxi_state
                                               andZip:taxiDetail.taxi_cmpn_zipcode];
    
    taxiDetail.fullAddress_Unformated = [TaxiDetail getFullAddressUnformated:taxiDetail.taxi_address
                                                                      withCity:taxiDetail.taxi_city
                                                                     withState:taxiDetail.taxi_state
                                                                        andZip:taxiDetail.taxi_cmpn_zipcode];
    
    return taxiDetail;
}

+(NSString *)getFullNameFromFirstName:(NSString *)fname andLastName:(NSString *)lname {
    NSString *fullName = nil;
    
    if ([fname length]>0) {
        fullName = [NSString stringWithFormat:@"%@",fname];
    }
    
    if ([lname length] > 0) {
        if ([fullName length]>0) {
            fullName = [NSString stringWithFormat:@"%@, %@",fullName,lname];
        }
        else {
            fullName = lname;
        }
    }
    if (fullName == nil) {
        fullName = @"";
    }
    return fullName;
    
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


+(NSString *)getFullAddressUnformated:(NSString *)address withCity:(NSString *)city withState:(NSString *)state andZip:(NSString *)zip {
    NSString *fullAddr = nil;
    
    if ([address length]>0) {
        fullAddr = [NSString stringWithFormat:@"%@",address];
    }
    
    if ([city length] > 0) {
        if ([fullAddr length]>0) {
            fullAddr = [NSString stringWithFormat:@"%@,%@",fullAddr,city];
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
