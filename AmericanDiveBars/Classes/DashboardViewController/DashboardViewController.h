//
//  DashboardViewController.h
//  AmericanDiveBars
//
//  Created by spaculus on 10/2/15.
//  Copyright © 2015 spaculus. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DashboardViewControllerDelegate <NSObject>
-(void)removeDashboard;
@end

@interface DashboardViewController : UIViewController
@property (nonatomic, assign) BOOL isLoggoutFromDashBoard;
@property (strong, nonatomic) id <DashboardViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UICollectionView *cv;
-(void)selectedTableRow:(NSUInteger)rowNum;
@end
