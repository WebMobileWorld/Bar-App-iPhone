//
//  FullMugBar.h
//  AmericanDiveBars
//
//  Created by spaculus on 9/16/15.
//  Copyright (c) 2015 spaculus. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SpecialHour;

@interface FullMugBar : NSObject
@property (strong, nonatomic) BarDetail *barDetail;
@property (strong, nonatomic) SpecialHour *sph;
@property (strong, nonatomic) NSArray *aryBarReviews;
@property (strong, nonatomic) NSArray *aryBeerSeved;
@property (strong, nonatomic) NSArray *aryCocktailServed;
@property (strong, nonatomic) NSArray *aryLiquorServed;
@property (strong, nonatomic) NSArray *aryBarGallery;
@property (strong, nonatomic) NSArray *aryBarHours;
@property (strong, nonatomic) NSArray *aryBarEvents;
@property (strong, nonatomic) NSArray *arySpecialHours;

@property (nonatomic, assign) NSInteger beerServedCount;
@property (nonatomic, assign) NSInteger cocktailServedCount;
@property (nonatomic, assign) NSInteger liquorServedCount;
@property (nonatomic, assign) NSInteger eventServedCount;

+(instancetype)getFullMugBarWithDictionary:(NSDictionary *)dict;

@end
