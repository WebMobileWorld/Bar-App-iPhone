//
//  CocktailServed.h
//  AmericanDiveBars
//
//  Created by spaculus on 9/16/15.
//  Copyright (c) 2015 spaculus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CocktailServed : NSObject
@property (strong, nonatomic) NSString *cocktail_id;
@property (strong, nonatomic) NSString *cocktail_image;
@property (strong, nonatomic) NSString *cocktail_name;
@property (strong, nonatomic) NSString *cocktail_served;
@property (strong, nonatomic) NSString *cocktail_type;
@property (strong, nonatomic) NSString *cocktail_strength;

+(instancetype)getCocktailServedWithDictionary:(NSDictionary *)dict;
@end
