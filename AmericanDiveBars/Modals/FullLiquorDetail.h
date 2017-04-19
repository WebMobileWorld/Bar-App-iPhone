//
//  FullLiquorDetail.h
//  AmericanDiveBars
//
//  Created by spaculus on 9/30/15.
//  Copyright © 2015 spaculus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FullLiquorDetail : NSObject

@property (strong, nonatomic) LiquorDetail *liquorDetail;
@property (strong, nonatomic) NSMutableArray *aryLiquorComments;
+(instancetype)getFullLiquorDetailWithDictionary:(NSDictionary *)dict;

@end
