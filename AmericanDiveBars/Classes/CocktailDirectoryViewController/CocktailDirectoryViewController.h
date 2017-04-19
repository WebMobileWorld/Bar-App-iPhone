//
//  CocktailDirectoryViewController.h
//  AmericanDiveBars
//
//  Created by spaculus on 8/31/15.
//  Copyright (c) 2015 spaculus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BarDetail.h"

@interface CocktailDirectoryViewController : UIViewController
@property (strong, nonatomic) BarDetail *barDetail;

@property (strong, nonatomic) IBOutlet UIButton *btnSuggest;

- (IBAction)btnSuggestClicked:(id)sender;

-(void)selectedTableRow:(NSUInteger)rowNum;
@end
