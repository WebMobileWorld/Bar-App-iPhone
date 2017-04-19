//
//  BeerComment.m
//  AmericanDiveBars
//
//  Created by spaculus on 9/28/15.
//  Copyright (c) 2015 spaculus. All rights reserved.
//

#import "BeerComment.h"

@implementation BeerComment
+(instancetype)getBeerCommentWithDictionary:(NSDictionary *)dict {
    BeerComment *beerComment = [[BeerComment alloc] init];
    
    beerComment.beerComment_beer_comment_id = [CommonUtils getNotNullString:[dict valueForKey:@"beer_comment_id"]];
    beerComment.beerComment_beer_id = [CommonUtils getNotNullString:[dict valueForKey:@"beer_id"]];
    beerComment.beerComment_comment = [CommonUtils getNotNullString:[dict valueForKey:@"comment"]];
    beerComment.beerComment_comment_title = [CommonUtils getNotNullString:[dict valueForKey:@"comment_title"]];
    beerComment.beerComment_date_added = [CommonUtils getNotNullString:[dict valueForKey:@"date_added"]];
    beerComment.beerComment_is_like = [CommonUtils getNotNullString:[dict valueForKey:@"is_like"]];
    beerComment.beerComment_total_like = [CommonUtils getNotNullString:[dict valueForKey:@"total_like"]];
    
    beerComment.beerComment_master_comment_id = [CommonUtils getNotNullString:[dict valueForKey:@"master_comment_id"]];
    
    beerComment.beerComment_first_name = [CommonUtils getNotNullString:[dict valueForKey:@"first_name"]];
    beerComment.beerComment_last_name = [CommonUtils getNotNullString:[dict valueForKey:@"last_name"]];
    
    beerComment.beerComment_profile_image = [[CommonUtils getNotNullString:[dict valueForKey:@"profile_image"]] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    beerComment.beerComment_user_id = [CommonUtils getNotNullString:[dict valueForKey:@"user_id"]];
    
    beerComment.beerComment_fullName = [BeerComment getFullNameFromFirstName:beerComment.beerComment_first_name andLastName:beerComment.beerComment_last_name];
    
    return beerComment;
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
