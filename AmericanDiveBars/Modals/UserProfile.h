//
//  UserProfile.h
//  AmericanDiveBars
//
//  Created by spaculus on 10/3/15.
//  Copyright © 2015 spaculus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserProfile : NSObject
@property (strong, nonatomic) NSString *profile_first_name;
@property (strong, nonatomic) NSString *profile_last_name;
@property (strong, nonatomic) NSString *profile_nick_name;
@property (strong, nonatomic) NSString *profile_gender;
@property (strong, nonatomic) NSString *profile_email;
@property (strong, nonatomic) NSString *profile_about_user;
@property (strong, nonatomic) NSString *profile_address;
@property (strong, nonatomic) NSString *profile_user_city;
@property (strong, nonatomic) NSString *profile_user_state;
@property (strong, nonatomic) NSString *profile_user_zip;
@property (strong, nonatomic) NSString *profile_mobile_no;
@property (strong, nonatomic) NSString *profile_fb_link;
@property (strong, nonatomic) NSString *profile_gplus_link;
@property (strong, nonatomic) NSString *profile_twitter_link;
@property (strong, nonatomic) NSString *profile_linkedin_link;
@property (strong, nonatomic) NSString *profile_pinterest_link;
@property (strong, nonatomic) NSString *profile_instagram_link;
@property (strong, nonatomic) NSString *profile_profile_image;
@property (strong, nonatomic) NSString *profile_birthdate;
@property (strong, nonatomic) NSString *profile_password;
@property (strong, nonatomic) NSString *profile_phone_no;
@property (strong, nonatomic) NSString *profile_status;
@property (strong, nonatomic) NSString *profile_user_banner;
@property (strong, nonatomic) NSString *profile_user_id;
@property (strong, nonatomic) NSString *profile_user_type;
@property (strong, nonatomic) NSString *pre_profile_image;
+(instancetype)getUserProfileWithDictionary:(NSDictionary *)dict;
@end
