//
//  SPHKey.h
//  AmericanDiveBars
//
//  Created by spaculus on 5/11/16.
//  Copyright © 2016 spaculus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPHKey : NSObject

@property (strong, nonatomic) NSArray *arySpecialHours;
@property (strong, nonatomic) NSString *sph_day;
@property (strong, nonatomic) NSString *sph_time;


+(SPHKey *)getSpecialHourOfDay:(NSString *)day forTime:(NSString *)time withHours:(NSArray *)arySpecialHours;

@end
