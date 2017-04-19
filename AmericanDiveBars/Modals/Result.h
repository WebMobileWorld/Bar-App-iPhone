//
//  Result.h
//  AmericanDiveBars
//
//  Created by spaculus on 4/28/16.
//  Copyright © 2016 spaculus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Result : NSObject

@property (strong, nonatomic) NSString *result;
@property (strong, nonatomic) NSString *duration;

+(Result *) getResultWithArray:(NSArray *)aryResult;



@end
