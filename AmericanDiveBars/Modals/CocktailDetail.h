//
//  CocktailDetail.h
//  AmericanDiveBars
//
//  Created by spaculus on 9/30/15.
//  Copyright © 2015 spaculus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CocktailDetail : NSObject
@property (strong, nonatomic) NSString *cocktail_base_spirit;
@property (strong, nonatomic) NSString *cocktail_cocktail_id;
@property (strong, nonatomic) NSString *cocktail_cocktail_image;
@property (strong, nonatomic) NSString *cocktail_cocktail_name;
@property (strong, nonatomic) NSString *cocktail_difficulty;
@property (strong, nonatomic) NSString *cocktail_fav_cocktail;
@property (strong, nonatomic) NSString *cocktail_how_to_make_it;
@property (strong, nonatomic) NSString *cocktail_image_default;
@property (strong, nonatomic) NSString *cocktail_like_cocktail;
@property (strong, nonatomic) NSString *cocktail_ingredients;
@property (strong, nonatomic) NSString *cocktail_served;
@property (strong, nonatomic) NSString *cocktail_strength;
@property (strong, nonatomic) NSString *cocktail_type;
@property (strong, nonatomic) NSString *cocktail_upload_type;
@property (strong, nonatomic) NSString *cocktail_video_link;
@property (strong, nonatomic) NSString *cocktail_status;
@property (strong, nonatomic) NSString *cocktail_slug;

+(instancetype)getCocktailDetailWithDictionary:(NSDictionary *)dict;

@end
