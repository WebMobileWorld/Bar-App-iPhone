//
//  FullMugBar.m
//  AmericanDiveBars
//
//  Created by spaculus on 9/16/15.
//  Copyright (c) 2015 spaculus. All rights reserved.
//

#import "FullMugBar.h"

@implementation FullMugBar
+(instancetype)getFullMugBarWithDictionary:(NSDictionary *)dict {
    FullMugBar *fullMug = [[FullMugBar alloc] init];
    
    BarDetail *barDetail = [BarDetail getBarDetailWithDictionary:[[[dict valueForKey:@"bardetails"] valueForKey:@"result"] objectAtIndex:0]];
    
    fullMug.barDetail = barDetail;
    fullMug.aryBarReviews = [FullMugBar getBarReviews:[[dict valueForKey:@"barreview"] valueForKey:@"result"]];
    fullMug.aryBeerSeved = [FullMugBar getBeerServed:[[dict valueForKey:@"beerserved"] valueForKey:@"result"]];
    fullMug.aryCocktailServed = [FullMugBar getCocktailServed:[[dict valueForKey:@"cocktailserved"] valueForKey:@"result"]];
    fullMug.aryLiquorServed = [FullMugBar getLiquorServed:[[dict valueForKey:@"liquorserved"] valueForKey:@"result"]];
    fullMug.aryBarHours = [FullMugBar getBarHours:[[dict valueForKey:@"barhours"] valueForKey:@"result"]];
    fullMug.aryBarEvents = [FullMugBar getBarEvents:[[dict valueForKey:@"barevent"] valueForKey:@"result"]];
    fullMug.aryBarGallery = [FullMugBar getBarGallery:[[dict valueForKey:@"getbargallery"] valueForKey:@"result"]];
    
    fullMug.sph = [SpecialHour getSpecialHoursFromDict:dict];
        
   // fullMug.arySpecialHours = [FullMugBar getBarSpecialHours:[dict valueForKey:@"get_bar_hour"]];
    
    fullMug.beerServedCount = fullMug.aryBeerSeved.count;
    fullMug.cocktailServedCount = fullMug.aryCocktailServed.count;
    fullMug.liquorServedCount = fullMug.aryLiquorServed.count;
    fullMug.eventServedCount = fullMug.aryBarEvents.count;
    
    return fullMug;
}

+(NSArray *)getBarSpecialHours:(NSArray *)aryBarSpecialHours {
    NSMutableArray *arySpecialHours = [@[] mutableCopy];
    if ([arySpecialHours count]>0) {
        [arySpecialHours removeAllObjects];
    }
    
    for (NSDictionary *dict in aryBarSpecialHours) {
        BarSpecialHour *specialHour = [BarSpecialHour getBarSpecialHourWithDictionary:dict];
        [arySpecialHours addObject:specialHour];
    }
    return arySpecialHours;
}

+(NSArray *)getBarGallery:(NSArray *)aryBarGallery_ {
    NSMutableArray *aryImages = [@[] mutableCopy];
    if ([aryImages count]>0) {
        [aryImages removeAllObjects];
    }
    
    for (NSDictionary *dict in aryBarGallery_) {
        BarGallery *barGallery = [BarGallery getBarGalleryWithDictionary:dict];
        [aryImages addObject:barGallery];
    }
    return aryImages;
}


+(NSArray *)getBarReviews:(NSArray *)aryResultReviews {
    NSMutableArray *aryReviews = [@[] mutableCopy];
    if ([aryReviews count]>0) {
        [aryReviews removeAllObjects];
    }
    
    for (NSDictionary *dict in aryResultReviews) {
        BarReview *barReview = [BarReview getBarReviewWithDictionary:dict];
        [aryReviews addObject:barReview];
    }
    return aryReviews;
}

+(NSArray *)getBeerServed:(NSArray *)aryResultBeers {
    NSMutableArray *aryBeers = [@[] mutableCopy];
    if ([aryBeers count]>0) {
        [aryBeers removeAllObjects];
    }
    
    for (NSDictionary *dict in aryResultBeers) {
        BeerServed *beerServed = [BeerServed getBeerServedWithDictionary:dict];
        [aryBeers addObject:beerServed];
    }
    return aryBeers;
}

+(NSArray *)getCocktailServed:(NSArray *)aryResultCocktails {
    NSMutableArray *aryCocktails = [@[] mutableCopy];
    if ([aryCocktails count]>0) {
        [aryCocktails removeAllObjects];
    }
    
    for (NSDictionary *dict in aryResultCocktails) {
        CocktailServed *cocktailServed = [CocktailServed getCocktailServedWithDictionary:dict];
        [aryCocktails addObject:cocktailServed];
    }
    return aryCocktails;
}

+(NSArray *)getLiquorServed:(NSArray *)aryResultLiquors {
    NSMutableArray *aryLiquors = [@[] mutableCopy];
    if ([aryLiquors count]>0) {
        [aryLiquors removeAllObjects];
    }
    
    for (NSDictionary *dict in aryResultLiquors) {
        LiquorServed *liquorServed = [LiquorServed getLiquorServedWithDictionary:dict];
        [aryLiquors addObject:liquorServed];
    }
    return aryLiquors;
}

+(NSArray *)getBarHours:(NSArray *)aryResultBarHours {
    NSMutableArray *aryBarHours = [@[] mutableCopy];
    if ([aryBarHours count]>0) {
        [aryBarHours removeAllObjects];
    }
    
    for (NSDictionary *dict in aryResultBarHours) {
        BarHour *barHour = [BarHour getBarHourWithDictionary:dict];
        [aryBarHours addObject:barHour];
    }
    return aryBarHours;
}

+(NSArray *)getBarEvents:(NSArray *)aryResultBarEvents {
    NSMutableArray *aryBarEvents = [@[] mutableCopy];
    if ([aryBarEvents count]>0) {
        [aryBarEvents removeAllObjects];
    }
    
    for (NSDictionary *dict in aryResultBarEvents) {
        BarEvent *barEvent = [BarEvent getBarEventWithDictionary:dict];
        [aryBarEvents addObject:barEvent];
    }
    return aryBarEvents;
}

@end
