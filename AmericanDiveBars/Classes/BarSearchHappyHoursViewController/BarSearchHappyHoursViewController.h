//
//  BarSearchHappyHoursViewController.h
//  AmericanDiveBars
//
//  Created by spaculus on 1/18/16.
//  Copyright © 2016 spaculus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BarSearchHappyHoursViewController : UIViewController
-(void)selectedTableRow:(NSUInteger)rowNum;
@property (nonatomic, assign) BOOL is_cur_loc;
@end
