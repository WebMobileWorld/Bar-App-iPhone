//
//  BarDetail.h
//  AmericanDiveBars
//
//  Created by spaculus on 9/16/15.
//  Copyright (c) 2015 spaculus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BarDetail : NSObject

@property (strong, nonatomic) NSString *bar_address;
@property (strong, nonatomic) NSString *bar_desc;
@property (strong, nonatomic) NSString *bar_id;
@property (strong, nonatomic) NSString *bar_logo;
@property (strong, nonatomic) NSString *bar_title;
@property (strong, nonatomic) NSString *bar_type;
@property (strong, nonatomic) NSString *bar_city;
@property (strong, nonatomic) NSString *bar_email;
@property (strong, nonatomic) NSString *bar_owner_id;
@property (strong, nonatomic) NSString *bar_phone;
@property (strong, nonatomic) NSString *bar_state;
@property (strong, nonatomic) NSString *bar_total_commnets;
@property (strong, nonatomic) NSString *bar_total_rating;
@property (strong, nonatomic) NSString *bar_zipcode;

@property (strong, nonatomic) NSString *bar_video_link;
@property (strong, nonatomic) NSString *bar_bar_video;
@property (strong, nonatomic) NSString *bar_twitter_link;
@property (strong, nonatomic) NSString *bar_linkedin_link;
@property (strong, nonatomic) NSString *bar_pinterest_link;
@property (strong, nonatomic) NSString *bar_facebook_link;
@property (strong, nonatomic) NSString *bar_lat;
@property (strong, nonatomic) NSString *bar_lang;
@property (strong, nonatomic) NSString *bar_google_plus_link;
@property (strong, nonatomic) NSString *bar_dribble_link;
@property (strong, nonatomic) NSString *bar_serve_as;
@property (strong, nonatomic) NSString *bar_cash_p;
@property (strong, nonatomic) NSString *bar_master_p;
@property (strong, nonatomic) NSString *bar_american_p;
@property (strong, nonatomic) NSString *bar_visa_p;
@property (strong, nonatomic) NSString *bar_paypal_p;
@property (strong, nonatomic) NSString *bar_bitcoin_p;
@property (strong, nonatomic) NSString *bar_apple_p;
@property (strong, nonatomic) NSString *bar_like_bar;
@property (strong, nonatomic) NSString *bar_fav_bar;
@property (strong, nonatomic) NSString *bar_website;
@property (strong, nonatomic) NSString *bar_slug;

@property (strong, nonatomic) NSArray *aryPaymentTypes_Up;
@property (strong, nonatomic) NSArray *aryPaymentTypes_Down;

@property (strong, nonatomic) NSString *fullAddress;
@property (strong, nonatomic) NSString *fullAddress_Unformated;

+(instancetype)getBarDetailWithDictionary:(NSDictionary *)dict;
@end
