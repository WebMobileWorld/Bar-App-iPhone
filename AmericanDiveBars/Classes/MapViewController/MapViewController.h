//
//  MapViewController.h
//  AmericanDiveBars
//
//  Created by spaculus on 10/23/15.
//  Copyright © 2015 spaculus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapViewController : UIViewController
@property (nonatomic, strong) NSString *address;
-(void)selectedTableRow:(NSUInteger)rowNum;
@end
