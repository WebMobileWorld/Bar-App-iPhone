//
//  Question.h
//  AmericanDiveBars
//
//  Created by spaculus on 4/27/16.
//  Copyright © 2016 spaculus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Question : NSObject

@property (strong, nonatomic) NSString *ans;

@property (strong, nonatomic) NSString *que;

@property (strong, nonatomic) NSString *trivia_id;

@property (strong, nonatomic) NSMutableArray *aryOptions;

+(instancetype)getQuestionWithDictionary:(NSDictionary *)dict;

@end
