//
//  FindBarViewController.h
//  AmericanDiveBars
//
//  Created by spaculus on 1/18/16.
//  Copyright © 2016 spaculus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FindBarViewController : UIViewController
-(void)selectedTableRow:(NSUInteger)rowNum;

@property (nonatomic, strong) IBOutlet UIButton *btnSearchAroundMe;
@property (nonatomic, strong) IBOutlet UIButton *btnSearchAnotherArea;
@property (nonatomic, strong) IBOutlet UIButton *btnLocAroundMe;
@property (nonatomic, strong) IBOutlet UIButton *btnLocAnotherArea;

@end
