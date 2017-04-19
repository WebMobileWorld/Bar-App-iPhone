//
//  FavCocktail.h
//  AmericanDiveBars
//
//  Created by spaculus on 10/6/15.
//  Copyright © 2015 spaculus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FavCocktail : NSObject
@property (strong, nonatomic) NSString *fav_cocktail_id;
@property (strong, nonatomic) NSString *fav_cocktail_name;
@property (strong, nonatomic) NSString *fav_cocktail_type;
@property (strong, nonatomic) NSString *fav_date_added;
@property (strong, nonatomic) NSString *fav_cocktail_image;

@property (strong, nonatomic) NSString *fav_checked;
@property (strong, nonatomic) NSIndexPath *indexPath;
+(instancetype)getFavCocktailWithDictionary:(NSDictionary *)dict;
@end
