//
//  BeerComment.h
//  AmericanDiveBars
//
//  Created by spaculus on 9/28/15.
//  Copyright (c) 2015 spaculus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BeerComment : NSObject

@property (strong, nonatomic) NSString *beerComment_beer_comment_id;
@property (strong, nonatomic) NSString *beerComment_beer_id;
@property (strong, nonatomic) NSString *beerComment_comment;
@property (strong, nonatomic) NSString *beerComment_comment_title;
@property (strong, nonatomic) NSString *beerComment_date_added;
@property (strong, nonatomic) NSString *beerComment_first_name;
@property (strong, nonatomic) NSString *beerComment_last_name;
@property (strong, nonatomic) NSString *beerComment_profile_image;
@property (strong, nonatomic) NSString *beerComment_user_id;
@property (strong, nonatomic) NSString *beerComment_fullName;
@property (strong, nonatomic) NSString *beerComment_is_like;
@property (strong, nonatomic) NSString *beerComment_total_like;
@property (strong, nonatomic) NSString *beerComment_master_comment_id;
+(instancetype)getBeerCommentWithDictionary:(NSDictionary *)dict;
@end
