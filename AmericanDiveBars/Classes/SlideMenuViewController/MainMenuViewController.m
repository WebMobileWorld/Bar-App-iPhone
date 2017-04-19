//
//  MainMenuViewController.m
//  BreetyNetwork
//
//  Created by admin on 24/09/14.
//  Copyright (c) 2014 spaculus. All rights reserved.
//

#import "MainMenuViewController.h"
#import "LeftMenuViewController.h"
#import "AppDelegate.h"

@interface MainMenuViewController ()
{
    //AppDelegate *appDel;
}
@end

@implementation MainMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.leftMenu = [[LeftMenuViewController alloc] initWithNibName:@"LeftMenuViewController" bundle:nil];
   // appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



#pragma mark - Overriding methods
- (void)configureLeftMenuButton:(UIButton *)button
{
    CGRect frame = button.frame;
    frame.origin = (CGPoint){0,0};
    frame.size = (CGSize){40,40};
    button.frame = frame;
    
        [button setImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
    
}

- (BOOL)deepnessForLeftMenu
{
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
