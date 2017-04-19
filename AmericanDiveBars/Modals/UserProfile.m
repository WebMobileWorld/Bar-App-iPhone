//
//  UserProfile.m
//  AmericanDiveBars
//
//  Created by spaculus on 10/3/15.
//  Copyright © 2015 spaculus. All rights reserved.
//

#import "UserProfile.h"

@implementation UserProfile
+(instancetype)getUserProfileWithDictionary:(NSDictionary *)dict {
    UserProfile *profile = [[UserProfile alloc] init];
    profile.profile_first_name = [CommonUtils getNotNullString:[dict valueForKey:@"first_name"]];
    profile.profile_last_name = [CommonUtils getNotNullString:[dict valueForKey:@"last_name"]];
    profile.profile_nick_name = [CommonUtils getNotNullString:[dict valueForKey:@"nick_name"]];//User Name
    profile.profile_gender = [CommonUtils getNotNullString:[dict valueForKey:@"gender"]];
    profile.profile_email = [CommonUtils getNotNullString:[dict valueForKey:@"email"]];
    profile.profile_about_user = [CommonUtils getNotNullString:[dict valueForKey:@"about_user"]];
    profile.profile_address = [CommonUtils getNotNullString:[dict valueForKey:@"address"]];
    profile.profile_user_city = [CommonUtils getNotNullString:[dict valueForKey:@"user_city"]];
    profile.profile_user_state = [CommonUtils getNotNullString:[dict valueForKey:@"user_state"]];
    profile.profile_user_zip = [CommonUtils getNotNullString:[dict valueForKey:@"user_zip"]];
    profile.profile_mobile_no = [CommonUtils getNotNullString:[dict valueForKey:@"mobile_no"]];
    profile.profile_fb_link = [CommonUtils getNotNullString:[dict valueForKey:@"fb_link"]];
    profile.profile_gplus_link = [CommonUtils getNotNullString:[dict valueForKey:@"gplus_link"]];
    profile.profile_twitter_link = [CommonUtils getNotNullString:[dict valueForKey:@"twitter_link"]];
    profile.profile_linkedin_link = [CommonUtils getNotNullString:[dict valueForKey:@"linkedin_link"]];
    profile.profile_pinterest_link = [CommonUtils getNotNullString:[dict valueForKey:@"pinterest_link"]];
    profile.profile_instagram_link = [CommonUtils getNotNullString:[dict valueForKey:@"instagram_link"]];
    profile.profile_profile_image = [CommonUtils getNotNullString:[dict valueForKey:@"profile_image"]];
    profile.pre_profile_image = profile.profile_profile_image;
    profile.profile_birthdate = [CommonUtils getNotNullString:[dict valueForKey:@"birthdate"]];
    profile.profile_password = [CommonUtils getNotNullString:[dict valueForKey:@"password"]];
    profile.profile_phone_no = [CommonUtils getNotNullString:[dict valueForKey:@"phone_no"]];
    profile.profile_status = [CommonUtils getNotNullString:[dict valueForKey:@"status"]];
    profile.profile_user_banner = [CommonUtils getNotNullString:[dict valueForKey:@"user_banner"]];
    profile.profile_user_id = [CommonUtils getNotNullString:[dict valueForKey:@"user_id"]];
    profile.profile_user_type = [CommonUtils getNotNullString:[dict valueForKey:@"user_type"]];
    
    return profile;
}

//first_name
//nick_name
//last_name
//address
//about_user
//email
//user_city
//user_state
//user_zip
//fb_link
//gplus_link
//twitter_link
//linkedin_link
//pinterest_link
//instagram_link
//mobile_no
@end
