//
//  LeftMenuViewController.h
//  PracticeConfidence
//
//  Created by admin on 24/09/14.
//  Copyright (c) 2014 spaculus. All rights reserved.
//

#import "AMSlideMenuLeftTableViewController.h"

@interface LeftMenuViewController : AMSlideMenuLeftTableViewController

@property (nonatomic, strong) NSArray *arrWithLogin;
@property (nonatomic, strong) NSArray *arrWithoutLogin;

@property (nonatomic, strong) NSArray *arrImagesWithLogin;
@property (nonatomic, strong) NSArray *arrImagesWithoutLogin;

@end
