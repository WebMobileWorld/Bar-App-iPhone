//
//  BarReview.m
//  AmericanDiveBars
//
//  Created by spaculus on 9/16/15.
//  Copyright (c) 2015 spaculus. All rights reserved.
//

#import "BarReview.h"

@implementation BarReview
+(instancetype)getBarReviewWithDictionary:(NSDictionary *)dict {
    BarReview *review = [[BarReview alloc] init];
    
    review.review_bar_comment_id = [CommonUtils getNotNullString:[dict valueForKey:@"bar_comment_id"]];
    review.review_bar_id  = [CommonUtils getNotNullString:[dict valueForKey:@"bar_id"]];
    review.review_user_id = [CommonUtils getNotNullString:[dict valueForKey:@"user_id"]];
    review.review_comment_title = [CommonUtils getNotNullString:[dict valueForKey:@"comment_title"]];
    review.review_comment = [CommonUtils getNotNullString:[dict valueForKey:@"comment"]];
    review.review_bar_rating = [CommonUtils getNotNullString:[dict valueForKey:@"bar_rating"]];
    review.review_status = [CommonUtils getNotNullString:[dict valueForKey:@"status"]];
    review.review_is_deleted = [CommonUtils getNotNullString:[dict valueForKey:@"is_deleted"]];
    review.review_date_added = [CommonUtils getNotNullString:[dict valueForKey:@"date_added"]];
    review.review_profile_image = [CommonUtils getNotNullString:[dict valueForKey:@"profile_image"]];
    review.review_first_name = [CommonUtils getNotNullString:[dict valueForKey:@"first_name"]];
    review.review_last_name = [CommonUtils getNotNullString:[dict valueForKey:@"last_name"]];
    
    return review;
}

@end
