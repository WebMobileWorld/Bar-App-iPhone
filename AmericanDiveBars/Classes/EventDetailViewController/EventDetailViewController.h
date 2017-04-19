//
//  EventDetailViewController.h
//  AmericanDiveBars
//
//  Created by spaculus on 9/23/15.
//  Copyright (c) 2015 spaculus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BarEvent.h"

@interface EventDetailViewController : UIViewController
@property (strong, nonatomic) BarEvent *barEvent;

-(void)selectedTableRow:(NSUInteger)rowNum;
@end
