//
//  TriviaGameViewController.h
//  AmericanDiveBars
//
//  Created by spaculus on 4/22/16.
//  Copyright © 2016 spaculus. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TriviaGame;



@interface TriviaGameViewController : UIViewController
-(void)selectedTableRow:(NSUInteger)rowNum;

@property (strong, nonatomic) TriviaGame *game;

@property (strong, nonatomic) IBOutlet UIView *questionCountView;
@property (strong, nonatomic) IBOutlet UIView *timerView;
@property (strong, nonatomic) IBOutlet UILabel *lblQueCount;
@property (strong, nonatomic) IBOutlet UILabel *lblTimer;

@end
