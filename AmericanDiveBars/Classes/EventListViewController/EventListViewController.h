//
//  EventListViewController.h
//  AmericanDiveBars
//
//  Created by spaculus on 9/26/15.
//  Copyright (c) 2015 spaculus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BarDetail.h"

@interface EventListViewController : UIViewController
@property (strong, nonatomic) BarDetail *barDetail;
-(void)selectedTableRow:(NSUInteger)rowNum;

@end
