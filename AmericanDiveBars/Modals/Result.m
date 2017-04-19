//
//  Result.m
//  AmericanDiveBars
//
//  Created by spaculus on 4/28/16.
//  Copyright © 2016 spaculus. All rights reserved.
//

#import "Result.h"

@implementation Result
+(Result *) getResultWithArray:(NSArray *)aryResult {
    Result *result = [[Result alloc] init];
    
    result.result = [Result getResultFromArray:aryResult];
    
    result.duration = [Result getDurationFromArray:aryResult];
    
    return result;
}

+(NSString *)getResultFromArray:(NSArray *)aryResult {
    

    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"result LIKE %@",@"1"];
    NSArray *aryCorrects = [aryResult filteredArrayUsingPredicate:predicate];
    
    NSString *result = [NSString stringWithFormat:@"%ld/%ld",[aryCorrects count],[aryResult count]];
    
    return result;
    
    
}



+(NSString *)getDurationFromArray:(NSArray *)aryResult {
    
    NSArray *aryTimes = [aryResult valueForKey:@"time"];
    
    NSInteger sum = 0;
    
    for (NSNumber *num in aryTimes) {
        NSLog(@"%ld",[num integerValue]);
        sum += [num integerValue];
    }
    
    NSLog(@"total = %ld",sum);
    
    NSString *strSum = [Result timeFormatted:sum];
    
    return strSum;
    
}


+ (NSString *)timeFormatted:(NSInteger)totalSeconds
{
    
    NSInteger seconds = totalSeconds % 60;
    NSInteger minutes = (totalSeconds / 60) % 60;
    NSInteger hours = totalSeconds / 3600;
    
    return [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)hours, (long)minutes, (long)seconds];
}


@end
