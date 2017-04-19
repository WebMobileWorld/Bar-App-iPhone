//
//  FullBeerDetail.m
//  AmericanDiveBars
//
//  Created by spaculus on 9/29/15.
//  Copyright (c) 2015 spaculus. All rights reserved.
//

#import "FullBeerDetail.h"

@implementation FullBeerDetail
+(instancetype)getFullBeerDetailWithDictionary:(NSDictionary *)dict {
    FullBeerDetail *fullBeerDetail = [[FullBeerDetail alloc] init];
    
    BeerDetail *beerDetail = [BeerDetail getBeerDetailWithDictionary:[[[dict valueForKey:@"beer_detail"] valueForKey:@"result"] objectAtIndex:0]];
    fullBeerDetail.beerDetail = beerDetail;
    
    fullBeerDetail.aryBeerComments = [self getBeerComments:[[dict valueForKey:@"beercomments"] valueForKey:@"result"]];
    
    return fullBeerDetail;
}

+(NSMutableArray *)getBeerComments:(NSArray *)aryBeerComments_ {
    NSMutableArray *aryComments = [@[] mutableCopy];
    if ([aryComments count]>0) {
        [aryComments removeAllObjects];
    }
    
    for (NSDictionary *dict in aryBeerComments_) {
        BeerComment *beerComment = [BeerComment getBeerCommentWithDictionary:dict];
        [aryComments addObject:beerComment];
    }
    return aryComments;
}

@end

