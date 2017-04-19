//
//  BarDetailFullMugViewController.h
//  AmericanDiveBars
//
//  Created by spaculus on 9/14/15.
//  Copyright (c) 2015 spaculus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"

@interface BarDetailFullMugViewController : UIViewController
@property (strong, nonatomic) Bar *bar;
-(void)selectedTableRow:(NSUInteger)rowNum;
@end
