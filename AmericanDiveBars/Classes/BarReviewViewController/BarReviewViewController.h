//
//  BarReviewViewController.h
//  AmericanDiveBars
//
//  Created by spaculus on 4/13/16.
//  Copyright © 2016 spaculus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BarReviewViewController : UIViewController

@property (nonatomic, strong) NSString * bar_id;

-(void)selectedTableRow:(NSUInteger)rowNum;
-(IBAction)btnSubmitReview:(UIButton *)btnSubmit;
@end
