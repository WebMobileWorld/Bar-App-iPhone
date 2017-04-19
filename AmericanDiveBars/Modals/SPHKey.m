//
//  SPHKey.m
//  AmericanDiveBars
//
//  Created by spaculus on 5/11/16.
//  Copyright © 2016 spaculus. All rights reserved.
//

#import "SPHKey.h"

@implementation SPHKey
+(SPHKey *)getSpecialHourOfDay:(NSString *)day forTime:(NSString *)time withHours:(NSArray *)arySpecialHours {
    SPHKey *key = [[SPHKey alloc] init];
    
    key.arySpecialHours = arySpecialHours;
    key.sph_day = day;
    key.sph_time = time;
    
    return key;
}

@end
