//
//  DirectionListViewController.h
//  AmericanDiveBars
//
//  Created by spaculus on 11/2/15.
//  Copyright © 2015 spaculus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DirectionListViewController : UIViewController
@property (strong, nonatomic) NSArray *aryDirections;
-(void)selectedTableRow:(NSUInteger)rowNum;
@end
