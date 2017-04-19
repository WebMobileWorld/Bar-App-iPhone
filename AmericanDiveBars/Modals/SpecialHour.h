//
//  SpecialHour.h
//  AmericanDiveBars
//
//  Created by spaculus on 5/11/16.
//  Copyright © 2016 spaculus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpecialHour : NSObject

@property (strong, nonatomic) NSArray *aryHours;

+(SpecialHour *)getSpecialHoursFromDict:(NSDictionary *)dict;

@end
