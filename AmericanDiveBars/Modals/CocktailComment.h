//
//  CocktailComment.h
//  AmericanDiveBars
//
//  Created by spaculus on 9/30/15.
//  Copyright © 2015 spaculus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CocktailComment : NSObject
@property (strong, nonatomic) NSString *cocktail_comment_id;
@property (strong, nonatomic) NSString *cocktail_id;
@property (strong, nonatomic) NSString *cocktail_comment;
@property (strong, nonatomic) NSString *cocktail_comment_title;
@property (strong, nonatomic) NSString *cocktail_date_added;
@property (strong, nonatomic) NSString *cocktail_first_name;
@property (strong, nonatomic) NSString *cocktail_last_name;
@property (strong, nonatomic) NSString *cocktail_profile_image;
@property (strong, nonatomic) NSString *cocktail_user_id;
@property (strong, nonatomic) NSString *cocktail_fullName;
@property (strong, nonatomic) NSString *cocktail_is_like;
@property (strong, nonatomic) NSString *cocktail_total_like;
@property (strong, nonatomic) NSString *cocktail_master_comment_id;
+(instancetype)getCocktailCommentWithDictionary:(NSDictionary *)dict;
@end
