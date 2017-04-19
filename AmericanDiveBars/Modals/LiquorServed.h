//
//  LiquorServed.h
//  AmericanDiveBars
//
//  Created by spaculus on 9/16/15.
//  Copyright (c) 2015 spaculus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LiquorServed : NSObject
@property (strong, nonatomic) NSString *liquor_id;
@property (strong, nonatomic) NSString *liquor_image;
@property (strong, nonatomic) NSString *liquor_title;
@property (strong, nonatomic) NSString *liquor_producer;
@property (strong, nonatomic) NSString *liquor_proof;
@property (strong, nonatomic) NSString *liquor_type;

+(instancetype)getLiquorServedWithDictionary:(NSDictionary *)dict;
@end
