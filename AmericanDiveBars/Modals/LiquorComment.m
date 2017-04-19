//
//  LiquorComment.m
//  AmericanDiveBars
//
//  Created by spaculus on 9/30/15.
//  Copyright © 2015 spaculus. All rights reserved.
//

#import "LiquorComment.h"

@implementation LiquorComment
+(instancetype)getLiquorCommentWithDictionary:(NSDictionary *)dict {
    LiquorComment *liquorComment = [[LiquorComment alloc] init];
    
    liquorComment.liquor_comment_id = [CommonUtils getNotNullString:[dict valueForKey:@"cocktail_comment_id"]];
    liquorComment.liquor_id = [CommonUtils getNotNullString:[dict valueForKey:@"cocktail_id"]];
    liquorComment.liquor_comment = [CommonUtils getNotNullString:[dict valueForKey:@"comment"]];
    liquorComment.liquor_comment_title = [CommonUtils getNotNullString:[dict valueForKey:@"comment_title"]];
    liquorComment.liquor_date_added = [CommonUtils getNotNullString:[dict valueForKey:@"date_added"]];
    liquorComment.liquor_first_name = [CommonUtils getNotNullString:[dict valueForKey:@"first_name"]];
    liquorComment.liquor_last_name = [CommonUtils getNotNullString:[dict valueForKey:@"last_name"]];
    liquorComment.liquor_is_like = [CommonUtils getNotNullString:[dict valueForKey:@"is_like"]];
    liquorComment.liquor_total_like = [CommonUtils getNotNullString:[dict valueForKey:@"total_like"]];

    liquorComment.liquor_master_comment_id = [CommonUtils getNotNullString:[dict valueForKey:@"master_comment_id"]];
    liquorComment.liquor_profile_image = [[CommonUtils getNotNullString:[dict valueForKey:@"profile_image"]] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    liquorComment.liquor_user_id = [CommonUtils getNotNullString:[dict valueForKey:@"user_id"]];
    
    liquorComment.liquor_fullName = [LiquorComment getFullNameFromFirstName:liquorComment.liquor_first_name andLastName:liquorComment.liquor_last_name];
    
    return liquorComment;
}

+(NSString *)getFullNameFromFirstName:(NSString *)fname andLastName:(NSString *)lname {
    NSString *fullName = nil;
    
    if ([fname length]>0) {
        fullName = [NSString stringWithFormat:@"%@",fname];
    }
    
    if ([lname length] > 0) {
        if ([fullName length]>0) {
            fullName = [NSString stringWithFormat:@"%@, %@",fullName,lname];
        }
        else {
            fullName = lname;
        }
    }
    if (fullName == nil) {
        fullName = @"";
    }
    return fullName;
    
}

@end
