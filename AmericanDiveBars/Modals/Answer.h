//
//  Answer.h
//  AmericanDiveBars
//
//  Created by spaculus on 4/27/16.
//  Copyright © 2016 spaculus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Answer : NSObject

@property (nonatomic, strong) NSString *ans;
@property (nonatomic, assign) BOOL isRight;
@property (nonatomic, strong) UIColor *color;


- (id)initWithAnswer:(NSString *)ans forColor:(UIColor *)color isRight:(BOOL)isRight;
+ (id)dataObjectWithAnswer:(NSString *)ans forColor:(UIColor *)color isRight:(BOOL)isRight;

@end
