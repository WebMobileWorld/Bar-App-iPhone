//
//  ArticleViewController.h
//  AmericanDiveBars
//
//  Created by spaculus on 4/18/16.
//  Copyright © 2016 spaculus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArticleViewController : UIViewController

-(void)selectedTableRow:(NSUInteger)rowNum;


@property (strong, nonatomic) IBOutlet UITextField *txtSearch;
@property (strong, nonatomic) IBOutlet UIButton *btnReset;
- (IBAction)btnReset_Clicked:(id)sender;

@end
