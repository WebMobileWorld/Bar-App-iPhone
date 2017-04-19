//
//  BarSpecialHoursViewController.h
//  AmericanDiveBars
//
//  Created by spaculus on 2/24/16.
//  Copyright © 2016 spaculus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BarSpecialHoursViewController : UIViewController

@property (nonatomic, strong) NSArray *arySpecialHours;

-(void)selectedTableRow:(NSUInteger)rowNum;

@end
