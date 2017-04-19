//
//  FullCocktailDetail.h
//  AmericanDiveBars
//
//  Created by spaculus on 9/30/15.
//  Copyright © 2015 spaculus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FullCocktailDetail : NSObject
@property (strong, nonatomic) CocktailDetail *cocktailDetail;
@property (strong, nonatomic) NSMutableArray *aryCocktailComments;
+(instancetype)getFullCocktailDetailWithDictionary:(NSDictionary *)dict;
@end
