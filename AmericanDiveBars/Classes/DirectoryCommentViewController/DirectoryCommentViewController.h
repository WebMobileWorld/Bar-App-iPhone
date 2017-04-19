//
//  DirectoryCommentViewController.h
//  AmericanDiveBars
//
//  Created by spaculus on 4/14/16.
//  Copyright © 2016 spaculus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DirectoryCommentViewController : UIViewController

@property (strong, nonatomic) NSString *type;

@property (strong, nonatomic) FullBeerDetail *fullBeerDetail;
@property (strong, nonatomic) FullCocktailDetail *fullCocktailDetail;
@property (strong, nonatomic) FullLiquorDetail *fullLiquorDetail;

-(void)selectedTableRow:(NSUInteger)rowNum;
-(IBAction)btnSubmitReview:(UIButton *)btnSubmit;
@end
