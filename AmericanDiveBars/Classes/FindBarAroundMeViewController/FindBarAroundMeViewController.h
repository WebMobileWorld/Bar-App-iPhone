//
//  FindBarAroundMeViewController.h
//  AmericanDiveBars
//
//  Created by spaculus on 1/18/16.
//  Copyright © 2016 spaculus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FindBarAroundMeViewController : UIViewController
@property (nonatomic, assign) BOOL isFromHappy;
@property (nonatomic, strong) BarSearchDetail *searchDetail;
@property (strong, nonatomic) IBOutlet UIButton *btnToggle;

-(void)selectedTableRow:(NSUInteger)rowNum;

- (IBAction)btnToggleClicked:(id)sender;

- (IBAction)btnSuggestClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *btnSuggest;

@end
