//
//  TaxiDirectoryDetailViewController.h
//  AmericanDiveBars
//
//  Created by spaculus on 10/1/15.
//  Copyright © 2015 spaculus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"

@interface TaxiDirectoryDetailViewController : UIViewController
@property (strong, nonatomic) TaxiDirectory *taxi;
-(void)selectedTableRow:(NSUInteger)rowNum;
@end
