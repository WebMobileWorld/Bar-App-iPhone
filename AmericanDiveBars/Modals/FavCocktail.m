//
//  FavCocktail.m
//  AmericanDiveBars
//
//  Created by spaculus on 10/6/15.
//  Copyright © 2015 spaculus. All rights reserved.
//

#import "FavCocktail.h"

@implementation FavCocktail
+(instancetype)getFavCocktailWithDictionary:(NSDictionary *)dict {
    FavCocktail *favCocktail = [[FavCocktail alloc] init];
    favCocktail.fav_cocktail_id = [CommonUtils getNotNullString:[dict valueForKey:@"cocktail_id"]];
    favCocktail.fav_cocktail_name = [CommonUtils getNotNullString:[dict valueForKey:@"cocktail_name"]];
    favCocktail.fav_cocktail_type = [CommonUtils getNotNullString:[dict valueForKey:@"type"]];
    favCocktail.fav_date_added = [CommonUtils getNotNullString:[dict valueForKey:@"date_added"]];
    favCocktail.fav_cocktail_image = [CommonUtils getNotNullString:[dict valueForKey:@"cocktail_image"]];
    favCocktail.fav_checked = @"0";
    favCocktail.indexPath = nil;
    return favCocktail;
}

@end
