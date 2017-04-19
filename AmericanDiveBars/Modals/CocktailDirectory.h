//
//  CocktailDirectory.h
//  AmericanDiveBars
//
//  Created by spaculus on 9/12/15.
//  Copyright (c) 2015 spaculus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CocktailDirectory : NSObject

@property (strong, nonatomic) NSString *cocktail_id;
@property (strong, nonatomic) NSString *cocktail_image;
@property (strong, nonatomic) NSString *cocktail_name;
@property (strong, nonatomic) NSString *cocktail_difficulty;
@property (strong, nonatomic) NSString *cocktail_ingredients;
@property (strong, nonatomic) NSString *cocktail_served;
@property (strong, nonatomic) NSString *cocktail_status;
@property (strong, nonatomic) NSString *cocktail_type;

+(instancetype)getCocktailWithDictionary:(NSDictionary *)dict;
@end
