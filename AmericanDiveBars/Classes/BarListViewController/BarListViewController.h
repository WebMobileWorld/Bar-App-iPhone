//
//  BarListViewController.h
//  AmericanDiveBars
//
//  Created by spaculus on 9/3/15.
//  Copyright (c) 2015 spaculus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BarSearchDetail.h"

@interface BarListViewController : UIViewController

@property (strong, nonatomic) BarSearchDetail *searchDetail;

@property (nonatomic, assign) BOOL isFromHappy;

@property (strong, nonatomic) IBOutlet UIButton *btnSuggest;

- (IBAction)btnSuggestClicked:(id)sender;

-(void)selectedTableRow:(NSUInteger)rowNum;
@end
