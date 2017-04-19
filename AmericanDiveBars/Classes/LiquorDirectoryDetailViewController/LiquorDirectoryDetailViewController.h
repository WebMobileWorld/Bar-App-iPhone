//
//  LiquorDirectoryDetailViewController.h
//  AmericanDiveBars
//
//  Created by spaculus on 9/30/15.
//  Copyright © 2015 spaculus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"

@interface LiquorDirectoryDetailViewController : UIViewController
@property (strong, nonatomic) LiquorDirectory *liquor;
-(void)selectedTableRow:(NSUInteger)rowNum;
@end
