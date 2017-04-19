//
//  BeerDirectoryViewController.h
//  AmericanDiveBars
//
//  Created by spaculus on 8/31/15.
//  Copyright (c) 2015 spaculus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BarDetail.h"

@interface BeerDirectoryViewController : UIViewController
@property (strong, nonatomic) BarDetail *barDetail;

@property (strong, nonatomic) IBOutlet UIButton *btnSuggest;

-(void)selectedTableRow:(NSUInteger)rowNum;

- (IBAction)btnSuggestClicked:(id)sender;

@end
