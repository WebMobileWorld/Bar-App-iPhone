//
//  TriviaGame.m
//  AmericanDiveBars
//
//  Created by spaculus on 4/27/16.
//  Copyright © 2016 spaculus. All rights reserved.
//

#import "TriviaGame.h"

@implementation TriviaGame
+(instancetype)getTriviaGameWithDictionary:(NSDictionary *)dict{
    
    TriviaGame *game = [[TriviaGame alloc] init];
    
    game.gameImageName = [CommonUtils getNotNullString:[[dict valueForKey: @"imagedate"] valueForKey:@"find_trivia_app"]];
    
    NSArray *aryResult = [dict valueForKey:@"result"];
    game.aryQuestions = [TriviaGame getQuestionsFromResult:aryResult];
    
    return game;
}

 +(NSMutableArray *)getQuestionsFromResult:(NSArray *)aryQuestionList
{
    NSMutableArray *aryQues = [@[] mutableCopy];
    if ([aryQues count]>0) {
        [aryQues removeAllObjects];
    }
    
    for (NSDictionary *dict in aryQuestionList) {
        Question *question = [Question getQuestionWithDictionary:dict];
        [aryQues addObject:question];
    }
    return aryQues;
}

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