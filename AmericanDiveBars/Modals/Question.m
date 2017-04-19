//
//  Question.m
//  AmericanDiveBars
//
//  Created by spaculus on 4/27/16.
//  Copyright © 2016 spaculus. All rights reserved.
//

#import "Question.h"

@implementation Question

+(instancetype)getQuestionWithDictionary:(NSDictionary *)dict {
    Question *question = [[Question alloc] init];
    
    question.que = [CommonUtils getNotNullString:[dict valueForKey:@"question"]];
    
    question.ans = [CommonUtils getNotNullString:[dict valueForKey:@"answer"]];
    
    question.aryOptions = [Question getAnswers:dict];
    
    return question;
}


+ (NSMutableArray *)getAnswers:(NSDictionary *)dict
{
    NSMutableArray *aryAnswers = [@[] mutableCopy];
    if ([aryAnswers count]>0) {
        [aryAnswers removeAllObjects];
    }
    
    NSString *ansKey = [CommonUtils getNotNullString:[dict valueForKey:@"answer"]];
    
    for (int i = 1; i<5; i++) {
        NSString *key = [NSString stringWithFormat:@"%d",i];
        NSString *ans = [CommonUtils getNotNullString:[dict valueForKey:key]];
        Answer *answer = nil;
        UIColor *color = [UIColor colorWithRed:78.0/255.0 green:74.0/255.0 blue:63.0/255.0 alpha:1.0];
        if ([ansKey isEqualToString:key]) {
            answer  = [Question getAnswerByAnswer:ans forColor:color isRight:YES];
        }
        else {
            answer = [Question getAnswerByAnswer:ans forColor:color isRight:NO];
        }
        
        [aryAnswers addObject:answer];
    }
    
    return aryAnswers;
}

+(Answer *)getAnswerByAnswer:(NSString *)ans forColor:(UIColor *)color isRight:(BOOL)isRight{
    Answer *answer = [Answer dataObjectWithAnswer:ans forColor:color isRight:isRight];
    return answer;
}






@end
