//
//  PrivacySettings.m
//  AmericanDiveBars
//
//  Created by spaculus on 10/13/15.
//  Copyright © 2015 spaculus. All rights reserved.
//

#import "PrivacySettings.h"

@implementation PrivacySettings
+(instancetype)getPrivacySettingsWithDictionary:(NSDictionary *)dict {
    PrivacySettings *setting = [[PrivacySettings alloc] init];
    
    setting.setting_id = [CommonUtils getNotNullString:[dict valueForKey:@"setting_id"]];
    setting.setting_user_id = [CommonUtils getNotNullString:[dict valueForKey:@"user_id"]];
    setting.setting_fname = [CommonUtils getNotNullString:[dict valueForKey:@"fname"]];
    setting.setting_lname = [CommonUtils getNotNullString:[dict valueForKey:@"lname"]];
    setting.setting_gender1 = [CommonUtils getNotNullString:[dict valueForKey:@"gender1"]];
    setting.setting_address1 = [CommonUtils getNotNullString:[dict valueForKey:@"address1"]];
    setting.setting_abt = [CommonUtils getNotNullString:[dict valueForKey:@"abt"]];
    setting.setting_album = [CommonUtils getNotNullString:[dict valueForKey:@"album"]];

    setting.pre_setting_id = setting.setting_id;
    setting.pre_setting_user_id = setting.setting_user_id;
    setting.pre_setting_fname = setting.setting_fname;
    setting.pre_setting_lname = setting.setting_lname;
    setting.pre_setting_gender1 = setting.setting_gender1;
    setting.pre_setting_address1 = setting.setting_address1;
    setting.pre_setting_abt = setting.setting_abt;
    setting.pre_setting_album = setting.setting_album;
    
    return setting;

}
/*
 {
 "getsetting": {
 "": "16",
 "": "221",
 "": "1",
 "": "1",
 "email1": "",
 "": "1",
 "": "1",
 "mnum": "",
 "": "1",
 "pic": "",
 "": "1"
 },
 "status": "success"
 }
 */
@end
