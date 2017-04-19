//
//  LoginViewController.h
//  AmericanDiveBars
//
//  Created by spaculus on 8/27/15.
//  Copyright (c) 2015 spaculus. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SignUpViewControllerDelegate <NSObject>
-(void)removeLogin;
@end

@interface SignUpViewController : UIViewController

@property (nonatomic, assign) BOOL isFromLeftMenu;
@property (nonatomic, strong) id<SignUpViewControllerDelegate> delegate;

@end
