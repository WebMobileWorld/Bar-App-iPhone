//
//  TriviaGameResultViewController.h
//  AmericanDiveBars
//
//  Created by spaculus on 4/28/16.
//  Copyright © 2016 spaculus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TriviaGameResultViewController : UIViewController

@property (nonatomic, strong) Result *result;
-(void)selectedTableRow:(NSUInteger)rowNum;



@end
