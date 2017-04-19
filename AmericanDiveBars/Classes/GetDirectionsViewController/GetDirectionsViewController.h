//
//  GetDirectionsViewController.h
//  GetDirections
//
//  Created by spaculus on 10/29/15.
//  Copyright © 2015 spaculus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GetDirectionsViewController : UIViewController
@property (nonatomic, strong) NSString *lat;
@property (nonatomic, strong) NSString *lng;
@property (nonatomic, strong) NSString *address_Unformated;
@property (nonatomic, strong) NSString *address_Formated;
@property (nonatomic, assign) BOOL isFromGetDirection;

-(void)selectedTableRow:(NSUInteger)rowNum;
@end
