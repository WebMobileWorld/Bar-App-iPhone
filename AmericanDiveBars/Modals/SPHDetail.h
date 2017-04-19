//
//  SPHDetail.h
//  AmericanDiveBars
//
//  Created by spaculus on 5/11/16.
//  Copyright © 2016 spaculus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPHDetail : NSObject

@property (nonatomic, strong) NSString *detailName;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *cat;

+(SPHDetail *)getSpecialHourDetailFromDict:(NSDictionary *)dict;

@end
