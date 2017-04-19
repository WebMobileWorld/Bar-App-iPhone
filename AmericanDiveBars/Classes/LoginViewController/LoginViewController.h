//
//  LoginViewController.h
//  AmericanDiveBars
//
//  Created by spaculus on 8/27/15.
//  Copyright (c) 2015 spaculus. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginViewControllerDelegate <NSObject>
-(void)removeLogin;
@end

@interface LoginViewController : UIViewController

@property (nonatomic, assign) BOOL isLoginFromMenu;
@property (nonatomic, strong) id<LoginViewControllerDelegate> delegate;

@end
