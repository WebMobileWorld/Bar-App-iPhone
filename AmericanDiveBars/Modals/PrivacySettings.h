//
//  PrivacySettings.h
//  AmericanDiveBars
//
//  Created by spaculus on 10/13/15.
//  Copyright © 2015 spaculus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PrivacySettings : NSObject
@property (strong, nonatomic) NSString *setting_id;
@property (strong, nonatomic) NSString *setting_user_id;
@property (strong, nonatomic) NSString *setting_fname;
@property (strong, nonatomic) NSString *setting_lname;
@property (strong, nonatomic) NSString *setting_gender1;
@property (strong, nonatomic) NSString *setting_address1;
@property (strong, nonatomic) NSString *setting_abt;
@property (strong, nonatomic) NSString *setting_album;

@property (strong, nonatomic) NSString *pre_setting_id;
@property (strong, nonatomic) NSString *pre_setting_user_id;
@property (strong, nonatomic) NSString *pre_setting_fname;
@property (strong, nonatomic) NSString *pre_setting_lname;
@property (strong, nonatomic) NSString *pre_setting_gender1;
@property (strong, nonatomic) NSString *pre_setting_address1;
@property (strong, nonatomic) NSString *pre_setting_abt;
@property (strong, nonatomic) NSString *pre_setting_album;


+(instancetype)getPrivacySettingsWithDictionary:(NSDictionary *)dict;
@end


/*{
"getsetting": {
"setting_id": "16",
"user_id": "221",
"fname": "1",
"lname": "1",
"email1": "",
"gender1": "1",
"address1": "1",
"mnum": "",
"abt": "1",
"pic": "",
"album": "1"
},
"status": "success"
}
*/