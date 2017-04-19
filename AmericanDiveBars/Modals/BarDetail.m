//
//  BarDetail.m
//  AmericanDiveBars
//
//  Created by spaculus on 9/16/15.
//  Copyright (c) 2015 spaculus. All rights reserved.
//

#import "BarDetail.h"

@implementation BarDetail
+(instancetype)getBarDetailWithDictionary:(NSDictionary *)dict {
    BarDetail *barDetail = [[BarDetail alloc] init];
    
    barDetail.bar_address = [CommonUtils getNotNullString:[dict valueForKey:@"address"]];
    barDetail.bar_desc = [CommonUtils getNotNullString:[dict valueForKey:@"bar_desc"]];
    barDetail.bar_id = [CommonUtils getNotNullString:[dict valueForKey:@"bar_id"]];
    barDetail.bar_logo = [CommonUtils getNotNullString:[dict valueForKey:@"bar_logo"]];
    barDetail.bar_title = [CommonUtils getNotNullString:[dict valueForKey:@"bar_title"]];
    barDetail.bar_type = [CommonUtils getNotNullString:[dict valueForKey:@"bar_type"]];
    barDetail.bar_city = [CommonUtils getNotNullString:[dict valueForKey:@"city"]];
    barDetail.bar_email = [CommonUtils getNotNullString:[dict valueForKey:@"email"]];
    barDetail.bar_owner_id = [CommonUtils getNotNullString:[dict valueForKey:@"owner_id"]];
    barDetail.bar_phone = [CommonUtils getNotNullString:[dict valueForKey:@"phone"]];
    barDetail.bar_state = [CommonUtils getNotNullString:[dict valueForKey:@"state"]];
    barDetail.bar_total_commnets = [CommonUtils getNotNullString:[dict valueForKey:@"total_commnets"]];
    barDetail.bar_total_rating = [CommonUtils getNotNullString:[dict valueForKey:@"total_rating"]];
    barDetail.bar_zipcode = [CommonUtils getNotNullString:[dict valueForKey:@"zipcode"]];
    
    barDetail.bar_video_link = [CommonUtils getNotNullString:[dict valueForKey:@"bar_video_link"]];
    barDetail.bar_bar_video = [CommonUtils getNotNullString:[dict valueForKey:@"bar_video"]];
    barDetail.bar_twitter_link = [CommonUtils getNotNullString:[dict valueForKey:@"twitter_link"]];
    barDetail.bar_linkedin_link = [CommonUtils getNotNullString:[dict valueForKey:@"linkedin_link"]];
    barDetail.bar_pinterest_link = [CommonUtils getNotNullString:[dict valueForKey:@"pinterest_link"]];
    barDetail.bar_facebook_link = [CommonUtils getNotNullString:[dict valueForKey:@"facebook_link"]];
    barDetail.bar_lat = [CommonUtils getNotNullString:[dict valueForKey:@"lat"]];
    barDetail.bar_lang = [CommonUtils getNotNullString:[dict valueForKey:@"lang"]];
    barDetail.bar_google_plus_link = [CommonUtils getNotNullString:[dict valueForKey:@"google_plus_link"]];
    barDetail.bar_dribble_link = [CommonUtils getNotNullString:[dict valueForKey:@"dribble_link"]];
    barDetail.bar_serve_as = [CommonUtils getNotNullString:[dict valueForKey:@"serve_as"]];
    barDetail.bar_cash_p = [CommonUtils getNotNullString:[dict valueForKey:@"cash_p"]];
    barDetail.bar_master_p = [CommonUtils getNotNullString:[dict valueForKey:@"master_p"]];
    barDetail.bar_american_p = [CommonUtils getNotNullString:[dict valueForKey:@"american_p"]];
    barDetail.bar_visa_p = [CommonUtils getNotNullString:[dict valueForKey:@"visa_p"]];
    barDetail.bar_paypal_p = [CommonUtils getNotNullString:[dict valueForKey:@"paypal_p"]];
    barDetail.bar_bitcoin_p = [CommonUtils getNotNullString:[dict valueForKey:@"bitcoin_p"]];
    barDetail.bar_apple_p = [CommonUtils getNotNullString:[dict valueForKey:@"apple_p"]];
    barDetail.bar_like_bar = [CommonUtils getNotNullString:[dict valueForKey:@"like_bar"]];
    barDetail.bar_fav_bar = [CommonUtils getNotNullString:[dict valueForKey:@"fav_bar"]];
    barDetail.bar_website = [CommonUtils getNotNullString:[dict valueForKey:@"website"]];
    
    barDetail.bar_slug = [CommonUtils getNotNullString:[dict valueForKey:@"bar_slug"]];
    
    
    barDetail.fullAddress = [BarDetail getFullAddress:barDetail.bar_address
                                             withCity:barDetail.bar_city
                                            withState:barDetail.bar_state
                                               andZip:barDetail.bar_zipcode];
    
    barDetail.fullAddress_Unformated = [BarDetail getFullAddressUnformated:barDetail.bar_address
                                                                  withCity:barDetail.bar_city
                                                                 withState:barDetail.bar_state
                                                                    andZip:barDetail.bar_zipcode];
    
    barDetail.aryPaymentTypes_Up = [BarDetail getAryPaymentTypesUpBycash_p:barDetail.bar_cash_p
                                                           master_p:barDetail.bar_master_p
                                                         american_p:barDetail.bar_american_p
                                                             visa_p:barDetail.bar_visa_p];
    
    barDetail.aryPaymentTypes_Down = [BarDetail getAryPaymentDownBypaypal_p:barDetail.bar_paypal_p
                                                                    bitcoin_p:barDetail.bar_bitcoin_p
                                                                     apple_p:barDetail.bar_apple_p];
    
    return barDetail;
}

+(NSArray *)getAryPaymentTypesUpBycash_p:(NSString *)cash_p
                            master_p:(NSString *)master_p
                          american_p:(NSString *)american_p
                              visa_p:(NSString *)visa_p

{
    NSMutableArray *aryTypes = [[NSMutableArray alloc] init];
    
    if ([cash_p isEqualToString:@"1"]) {
        [aryTypes addObject:@"cash_p"];
    }

    if ([master_p isEqualToString:@"1"]) {
        [aryTypes addObject:@"master_p"];
    }

    if ([american_p isEqualToString:@"1"]) {
        [aryTypes addObject:@"american_p"];
    }

    if ([visa_p isEqualToString:@"1"]) {
        [aryTypes addObject:@"visa_p"];
    }

    return aryTypes;
}


+(NSArray *)getAryPaymentDownBypaypal_p:(NSString *)paypal_p
                           bitcoin_p:(NSString *)bitcoin_p
                             apple_p:(NSString *)apple_p
{
    NSMutableArray *aryTypes = [[NSMutableArray alloc] init];
    
    if ([paypal_p isEqualToString:@"1"]) {
        [aryTypes addObject:@"paypal_p"];
    }
    
    if ([bitcoin_p isEqualToString:@"1"]) {
        [aryTypes addObject:@"bitcoin_p"];
    }
    
    if ([apple_p isEqualToString:@"1"]) {
        [aryTypes addObject:@"apple_p"];
    }
    
    return aryTypes;
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
