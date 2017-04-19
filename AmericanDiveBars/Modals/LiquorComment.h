//
//  LiquorComment.h
//  AmericanDiveBars
//
//  Created by spaculus on 9/30/15.
//  Copyright © 2015 spaculus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LiquorComment : NSObject
@property (strong, nonatomic) NSString *liquor_comment_id;
@property (strong, nonatomic) NSString *liquor_id;
@property (strong, nonatomic) NSString *liquor_comment;
@property (strong, nonatomic) NSString *liquor_comment_title;
@property (strong, nonatomic) NSString *liquor_date_added;
@property (strong, nonatomic) NSString *liquor_first_name;
@property (strong, nonatomic) NSString *liquor_last_name;
@property (strong, nonatomic) NSString *liquor_profile_image;
@property (strong, nonatomic) NSString *liquor_user_id;
@property (strong, nonatomic) NSString *liquor_fullName;
@property (strong, nonatomic) NSString *liquor_is_like;
@property (strong, nonatomic) NSString *liquor_total_like;
@property (strong, nonatomic) NSString *liquor_master_comment_id;

+(instancetype)getLiquorCommentWithDictionary:(NSDictionary *)dict;

@end
