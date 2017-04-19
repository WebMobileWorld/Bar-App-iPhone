//
//  AddEditAlbumViewController.h
//  AmericanDiveBars
//
//  Created by spaculus on 10/7/15.
//  Copyright © 2015 spaculus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"

@interface AddEditAlbumViewController : UIViewController
@property (strong, nonatomic) Album *album;
-(void)selectedTableRow:(NSUInteger)rowNum;
@end
