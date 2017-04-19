//
//  CocktailDirectoryDetailViewController.h
//  AmericanDiveBars
//
//  Created by spaculus on 9/29/15.
//  Copyright (c) 2015 spaculus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"

@interface CocktailDirectoryDetailViewController : UIViewController
@property (strong, nonatomic) CocktailDirectory *cocktail;
-(void)selectedTableRow:(NSUInteger)rowNum;
@end
