//
//  FullCocktailDetail.m
//  AmericanDiveBars
//
//  Created by spaculus on 9/30/15.
//  Copyright © 2015 spaculus. All rights reserved.
//

#import "FullCocktailDetail.h"

@implementation FullCocktailDetail
+(instancetype)getFullCocktailDetailWithDictionary:(NSDictionary *)dict {
    FullCocktailDetail *fullCocktailDetail = [[FullCocktailDetail alloc] init];
    
    CocktailDetail *cocktailDetail = [CocktailDetail getCocktailDetailWithDictionary:[[[dict valueForKey:@"cocktail_detail"] valueForKey:@"result"] objectAtIndex:0]];
    fullCocktailDetail.cocktailDetail = cocktailDetail;
    
    fullCocktailDetail.aryCocktailComments = [self getCocktailComments:[[dict valueForKey:@"cocktailcomments"] valueForKey:@"result"]];
    
    return fullCocktailDetail;
}

+(NSMutableArray *)getCocktailComments:(NSArray *)aryCocktailComments_ {
    NSMutableArray *aryComments = [@[] mutableCopy];
    if ([aryComments count]>0) {
        [aryComments removeAllObjects];
    }
    
    for (NSDictionary *dict in aryCocktailComments_) {
        CocktailComment *cocktailComment = [CocktailComment getCocktailCommentWithDictionary:dict];
        [aryComments addObject:cocktailComment];
    }
    return aryComments;
}

@end
