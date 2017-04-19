//
//  BarSearchDetail.h
//  AmericanDiveBars
//
//  Created by spaculus on 9/4/15.
//  Copyright (c) 2015 spaculus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BarSearchDetail : NSObject
@property (strong, nonatomic) NSString *searchByName;
@property (strong, nonatomic) NSString *searchByState;
@property (strong, nonatomic) NSString *searchByCity;
@property (strong, nonatomic) NSString *searchByZip;
@property (strong, nonatomic) NSString *searchTitle;

@property (strong, nonatomic) NSString *searchLat;
@property (strong, nonatomic) NSString *searchLng;

@property (strong, nonatomic) NSString *searchDays;
@property (strong, nonatomic) NSString *searchAddress;

+(instancetype)getDetailSearchByName:(NSString *)name searchByState:(NSString *)state searchByCity:(NSString *)city searchByZip:(NSString *)zip forDays:(NSString *)days happyAddress:(NSString *)address;

@end
