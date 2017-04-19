//
//  ArticleDetailViewController.h
//  AmericanDiveBars
//
//  Created by spaculus on 4/20/16.
//  Copyright © 2016 spaculus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArticleDetailViewController : UIViewController

@property (nonatomic, strong) Article *article;

-(void)selectedTableRow:(NSUInteger)rowNum;

@end
