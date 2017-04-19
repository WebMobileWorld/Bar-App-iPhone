//
//  CocktailDirectory.m
//  AmericanDiveBars
//
//  Created by spaculus on 9/12/15.
//  Copyright (c) 2015 spaculus. All rights reserved.
//

#import "CocktailDirectory.h"

@implementation CocktailDirectory
+(instancetype)getCocktailWithDictionary:(NSDictionary *)dict {
    CocktailDirectory *cocktail = [[CocktailDirectory alloc] init];
    
    cocktail.cocktail_id = [CommonUtils getNotNullString:[dict valueForKey:@"cocktail_id"]];
    cocktail.cocktail_image = [CommonUtils getNotNullString:[dict valueForKey:@"cocktail_image"]];
    cocktail.cocktail_name = [CommonUtils getNotNullString:[dict valueForKey:@"cocktail_name"]];
    cocktail.cocktail_difficulty = [CommonUtils getNotNullString:[dict valueForKey:@"difficulty"]];
    cocktail.cocktail_ingredients = [CommonUtils getNotNullString:[dict valueForKey:@"ingredients"]];
    cocktail.cocktail_served = [CommonUtils getNotNullString:[dict valueForKey:@"served"]];
    cocktail.cocktail_status = [CommonUtils getNotNullString:[dict valueForKey:@"status"]];
    cocktail.cocktail_type = [CommonUtils getNotNullString:[dict valueForKey:@"type"]];
    
    return cocktail;
}

@end
