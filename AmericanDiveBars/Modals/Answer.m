//
//  Answer.m
//  AmericanDiveBars
//
//  Created by spaculus on 4/27/16.
//  Copyright © 2016 spaculus. All rights reserved.
//

#import "Answer.h"

@implementation Answer

- (id)initWithAnswer:(NSString *)ans forColor:(UIColor *)color isRight:(BOOL)isRight
{
    self = [super init];
    if (self) {
        self.ans = ans;
        self.isRight = isRight;
        self.color = color;
    }
    return self;
}

+ (id)dataObjectWithAnswer:(NSString *)ans  forColor:(UIColor *)color isRight:(BOOL)isRight
{
    return [[self alloc] initWithAnswer:ans forColor:color isRight:isRight];
}

@end
