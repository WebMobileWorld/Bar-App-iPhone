//
//  BeerDirectoryDetailViewController.h
//  AmericanDiveBars
//
//  Created by spaculus on 9/26/15.
//  Copyright (c) 2015 spaculus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"

@interface BeerDirectoryDetailViewController : UIViewController
@property (strong, nonatomic) BeerDirectory *beer;
-(void)selectedTableRow:(NSUInteger)rowNum;
@end
