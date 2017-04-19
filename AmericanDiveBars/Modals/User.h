//
//  User.h
//  VoteJoin
//
//  Created by spaculus on 1/20/15.
//  Copyright (c) 2015 spaculus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
@property (strong, nonatomic) NSString *user_id;
@property (strong, nonatomic) NSString *device_id;
@property (strong, nonatomic) NSString *unique_code;
@property (strong, nonatomic) NSString *user_name;
@property (strong, nonatomic) NSString *user_image;
@property (strong, nonatomic) NSString *user_email;

@end
