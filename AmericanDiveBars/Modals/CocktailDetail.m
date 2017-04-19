//
//  CocktailDetail.m
//  AmericanDiveBars
//
//  Created by spaculus on 9/30/15.
//  Copyright © 2015 spaculus. All rights reserved.
//

#import "CocktailDetail.h"

@implementation CocktailDetail
+(instancetype)getCocktailDetailWithDictionary:(NSDictionary *)dict {
    CocktailDetail *cocktailDetail = [[CocktailDetail alloc] init];
    
    cocktailDetail.cocktail_base_spirit = [CommonUtils getNotNullString:[dict valueForKey:@"base_spirit"]];
    cocktailDetail.cocktail_cocktail_id = [CommonUtils getNotNullString:[dict valueForKey:@"cocktail_id"]];
    cocktailDetail.cocktail_cocktail_image = [CommonUtils getNotNullString:[dict valueForKey:@"cocktail_image"]];
    cocktailDetail.cocktail_cocktail_name = [CommonUtils getNotNullString:[dict valueForKey:@"cocktail_name"]];
    cocktailDetail.cocktail_difficulty = [CommonUtils getNotNullString:[dict valueForKey:@"difficulty"]];
    cocktailDetail.cocktail_fav_cocktail = [CommonUtils getNotNullString:[dict valueForKey:@"fav_cocktail"]];
    cocktailDetail.cocktail_how_to_make_it = [CommonUtils getNotNullString:[dict valueForKey:@"how_to_make_it"]];
    cocktailDetail.cocktail_ingredients = [CommonUtils getNotNullString:[dict valueForKey:@"ingredients"]];
    cocktailDetail.cocktail_slug = [CommonUtils getNotNullString:[dict valueForKey:@"cocktail_slug"]];
    
    cocktailDetail.cocktail_image_default =  [CommonUtils getNotNullString:[dict valueForKey:@"image_default"]];
    cocktailDetail.cocktail_like_cocktail = [CommonUtils getNotNullString:[dict valueForKey:@"like_cocktail"]];
    cocktailDetail.cocktail_served = [CommonUtils getNotNullString:[dict valueForKey:@"served"]];
    cocktailDetail.cocktail_strength = [CommonUtils getNotNullString:[dict valueForKey:@"strength"]];
    cocktailDetail.cocktail_type = [CommonUtils getNotNullString:[dict valueForKey:@"type"]];
    cocktailDetail.cocktail_upload_type = [CommonUtils getNotNullString:[dict valueForKey:@"upload_type"]];
    cocktailDetail.cocktail_video_link = [CommonUtils getNotNullString:[dict valueForKey:@"video_link"]];
    
    cocktailDetail.cocktail_status = [CommonUtils getNotNullString:[dict valueForKey:@"status"]];
    
    return cocktailDetail;
}

@end
