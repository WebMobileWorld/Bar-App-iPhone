//
//  TriviaGame.h
//  AmericanDiveBars
//
//  Created by spaculus on 4/27/16.
//  Copyright © 2016 spaculus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TriviaGame : NSObject


@property (strong, nonatomic) NSString *gameImageName;
@property (strong, nonatomic) NSArray *aryQuestions;

+(instancetype)getTriviaGameWithDictionary:(NSDictionary *)dict;
@end

/*
 {
 1 = "Machine Gun";
 2 = "Trigger Happy";
 3 = "Pretty Boy";
 4 = "Baby Face";
 answer = 4;
 question = "What was US 'Public Enemy' George Nelson's nickname?";
 "trivia_id" = 236;
 },
 */