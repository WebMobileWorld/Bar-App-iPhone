//
//  LiquorDirectory.h
//  AmericanDiveBars
//
//  Created by spaculus on 9/12/15.
//  Copyright (c) 2015 spaculus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LiquorDirectory : NSObject

@property (strong, nonatomic) NSString *liquor_id;
@property (strong, nonatomic) NSString *liquor_image;
@property (strong, nonatomic) NSString *liquor_title;
@property (strong, nonatomic) NSString *liquor_producer;
@property (strong, nonatomic) NSString *liquor_proof;
@property (strong, nonatomic) NSString *liquor_status;
@property (strong, nonatomic) NSString *liquor_type;

+(instancetype)getLiquorWithDictionary:(NSDictionary *)dict;
@end
