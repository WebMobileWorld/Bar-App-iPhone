//
//  PhotoGalleryDetailViewController.h
//  AmericanDiveBars
//
//  Created by spaculus on 10/1/15.
//  Copyright © 2015 spaculus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"

@interface PhotoGalleryDetailViewController : UIViewController
@property (assign, nonatomic) BOOL isFromProfile;
@property (strong, nonatomic) BarGallery *barGallery;
-(void)selectedTableRow:(NSUInteger)rowNum;

@end
