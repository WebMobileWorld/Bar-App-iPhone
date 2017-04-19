//
//  CocktailServed.m
//  AmericanDiveBars
//
//  Created by spaculus on 9/16/15.
//  Copyright (c) 2015 spaculus. All rights reserved.
//

#import "CocktailServed.h"

@implementation CocktailServed
+(instancetype)getCocktailServedWithDictionary:(NSDictionary *)dict {
    CocktailServed *cocktailServed = [[CocktailServed alloc] init];
    
    cocktailServed.cocktail_id = [CommonUtils getNotNullString:[dict valueForKey:@"cocktail_id"]];
    cocktailServed.cocktail_image = [CommonUtils getNotNullString:[dict valueForKey:@"cocktail_image"]];
    cocktailServed.cocktail_name = [CommonUtils getNotNullString:[dict valueForKey:@"cocktail_name"]];
    cocktailServed.cocktail_served = [CommonUtils getNotNullString:[dict valueForKey:@"served"]];
    cocktailServed.cocktail_type = [CommonUtils getNotNullString:[dict valueForKey:@"type"]];
    cocktailServed.cocktail_strength = [CommonUtils getNotNullString:[dict valueForKey:@"strength"]];
    return cocktailServed;
}

@end
