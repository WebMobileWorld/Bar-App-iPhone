//
//  CocktailComment.m
//  AmericanDiveBars
//
//  Created by spaculus on 9/30/15.
//  Copyright © 2015 spaculus. All rights reserved.
//

#import "CocktailComment.h"

@implementation CocktailComment
+(instancetype)getCocktailCommentWithDictionary:(NSDictionary *)dict {
    CocktailComment *cocktailComment = [[CocktailComment alloc] init];
    
    cocktailComment.cocktail_comment_id = [CommonUtils getNotNullString:[dict valueForKey:@"cocktail_comment_id"]];
    cocktailComment.cocktail_id = [CommonUtils getNotNullString:[dict valueForKey:@"cocktail_id"]];
    cocktailComment.cocktail_comment = [CommonUtils getNotNullString:[dict valueForKey:@"comment"]];
    cocktailComment.cocktail_comment_title = [CommonUtils getNotNullString:[dict valueForKey:@"comment_title"]];
    cocktailComment.cocktail_date_added = [CommonUtils getNotNullString:[dict valueForKey:@"date_added"]];
    cocktailComment.cocktail_first_name = [CommonUtils getNotNullString:[dict valueForKey:@"first_name"]];
    cocktailComment.cocktail_last_name = [CommonUtils getNotNullString:[dict valueForKey:@"last_name"]];
    cocktailComment.cocktail_is_like = [CommonUtils getNotNullString:[dict valueForKey:@"is_like"]];
    cocktailComment.cocktail_total_like = [CommonUtils getNotNullString:[dict valueForKey:@"total_like"]];
    cocktailComment.cocktail_profile_image = [[CommonUtils getNotNullString:[dict valueForKey:@"profile_image"]] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    cocktailComment.cocktail_master_comment_id = [CommonUtils getNotNullString:[dict valueForKey:@"master_comment_id"]];
    
    cocktailComment.cocktail_user_id = [CommonUtils getNotNullString:[dict valueForKey:@"user_id"]];
    
    cocktailComment.cocktail_fullName = [CocktailComment getFullNameFromFirstName:cocktailComment.cocktail_first_name andLastName:cocktailComment.cocktail_last_name];
    
    return cocktailComment;
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
