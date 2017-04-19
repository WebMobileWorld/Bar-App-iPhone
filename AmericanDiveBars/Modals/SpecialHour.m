//
//  SpecialHour.m
//  AmericanDiveBars
//
//  Created by spaculus on 5/11/16.
//  Copyright © 2016 spaculus. All rights reserved.
//

#import "SpecialHour.h"

@implementation SpecialHour
+(SpecialHour *)getSpecialHoursFromDict:(NSDictionary *)dict {
    SpecialHour *sph = [[SpecialHour alloc] init];
    
    if([[dict valueForKey:@"get_bar_hour"] isKindOfClass:[NSDictionary class]])
    {
        NSArray *arySPH_Keys = [[dict valueForKey:@"get_bar_hour"] allKeys];
        sph.aryHours = [SpecialHour getSpecialHoursFromKeyList:arySPH_Keys forMainDict:dict];
    }
    else
    {
        sph.aryHours = @[];
    }
    
    return sph;
}

+(NSArray *)getSpecialHoursFromKeyList:(NSArray *)arySPH_Keys forMainDict:(NSDictionary *)dict{

    NSMutableArray *arySpecialHours = [@[] mutableCopy];
    if ([arySpecialHours count]>0) {
        [arySpecialHours removeAllObjects];
    }
    
    for (NSString *key in arySPH_Keys) {
        NSArray *arySpecialKeys = [[dict valueForKey:@"get_bar_hour"] valueForKey:key];
        
        NSArray *aryBarSpecialHours =[SpecialHour getBarSpecialHours:arySpecialKeys];
        
        NSString *sph_day = @"";
        NSString *sph_time = @"";
        
        if ([aryBarSpecialHours count]!=0) {
            BarSpecialHour *barSpecialHour = [aryBarSpecialHours objectAtIndex:0];
            sph_day = [barSpecialHour sph_days];
            sph_time = [barSpecialHour sph_duration];
        }
        
        SPHKey *key = [SPHKey getSpecialHourOfDay:sph_day forTime:sph_time withHours:aryBarSpecialHours];
        
        [arySpecialHours addObject:key];
        
    }
    
    return arySpecialHours;
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





@end
