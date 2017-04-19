//
//  FullBeerDetail.h
//  AmericanDiveBars
//
//  Created by spaculus on 9/29/15.
//  Copyright (c) 2015 spaculus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FullBeerDetail : NSObject
@property (strong, nonatomic) BeerDetail *beerDetail;
@property (strong, nonatomic) NSMutableArray *aryBeerComments;

+(instancetype)getFullBeerDetailWithDictionary:(NSDictionary *)dict;
@end
