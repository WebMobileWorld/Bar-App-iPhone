//
//  BarReview.h
//  AmericanDiveBars
//
//  Created by spaculus on 9/16/15.
//  Copyright (c) 2015 spaculus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BarReview : NSObject

@property (strong, nonatomic) NSString *review_bar_comment_id;
@property (strong, nonatomic) NSString *review_bar_id;
@property (strong, nonatomic) NSString *review_user_id;
@property (strong, nonatomic) NSString *review_comment_title;
@property (strong, nonatomic) NSString *review_comment;
@property (strong, nonatomic) NSString *review_bar_rating;
@property (strong, nonatomic) NSString *review_status;
@property (strong, nonatomic) NSString *review_is_deleted;
@property (strong, nonatomic) NSString *review_date_added;
@property (strong, nonatomic) NSString *review_profile_image;
@property (strong, nonatomic) NSString *review_first_name;
@property (strong, nonatomic) NSString *review_last_name;

+(instancetype)getBarReviewWithDictionary:(NSDictionary *)dict;
@end
