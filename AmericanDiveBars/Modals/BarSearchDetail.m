//
//  BarSearchDetail.m
//  AmericanDiveBars
//
//  Created by spaculus on 9/4/15.
//  Copyright (c) 2015 spaculus. All rights reserved.
//

#import "BarSearchDetail.h"

@implementation BarSearchDetail

+(instancetype)getDetailSearchByName:(NSString *)name searchByState:(NSString *)state searchByCity:(NSString *)city searchByZip:(NSString *)zip forDays:(NSString *)days happyAddress:(NSString *)address {
    BarSearchDetail *searchDetail = [[BarSearchDetail alloc] init];
    
    searchDetail.searchByName = [CommonUtils getNotNullString:name];
    searchDetail.searchByState = [CommonUtils getNotNullString:state];
    searchDetail.searchByCity = [CommonUtils getNotNullString:city];
    searchDetail.searchByZip = [CommonUtils getNotNullString:zip];

    if ([name length]>0) {
        searchDetail.searchTitle = [NSString stringWithFormat:@"%@",name];
    }
    
    if ([state length] > 0) {
        if ([searchDetail.searchTitle length]>0) {
            searchDetail.searchTitle = [NSString stringWithFormat:@"%@, %@",searchDetail.searchTitle,state];
        }
        else {
            searchDetail.searchTitle = state;
        }
    }
    
    if ([city length] > 0) {
        if ([searchDetail.searchTitle length]>0) {
            searchDetail.searchTitle = [NSString stringWithFormat:@"%@, %@",searchDetail.searchTitle,city];
        }
        else {
            searchDetail.searchTitle = city;
        }
    }

    if ([zip length] > 0) {
        if ([searchDetail.searchTitle length]>0) {
            searchDetail.searchTitle = [NSString stringWithFormat:@"%@, %@",searchDetail.searchTitle,zip];
        }
        else {
            searchDetail.searchTitle = zip;
        }
    }


    if (searchDetail.searchTitle == nil) {
        searchDetail.searchTitle = @"";
    }
    
    NSString *strAddress = [CommonUtils getNotNullString:address];
    NSString *strDays = [CommonUtils getNotNullString:days];
    
    searchDetail.searchAddress = strAddress;
    searchDetail.searchDays = strDays;

    return searchDetail;
}

@end
