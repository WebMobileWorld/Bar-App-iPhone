//
//  LeftMenuViewController.m
//  PracticeConfidence
//
//  Created by admin on 24/09/14.
//  Copyright (c) 2014 spaculus. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "LoginViewController.h"
#import "HomeViewController.h"
#import "LeftPopupMenuCell.h"
#import "SideMenuTableViewCell.h"
#import "SignUpViewController.h"
#import "DashboardViewController.h"
#import "MyProfileViewController.h"

#import "MyFavoriteBarViewController.h"
#import "MyFavoriteBeerViewController.h"
#import "MyFavoriteCocktailViewController.h"
#import "MyFavoriteLiquorViewController.h"
#import "MyAlbumViewController.h"

#import "PrivacySettingViewController.h"
#import "ChangePasswordViewController.h"

#import "ContactUsViewController.h"
#import "CMSPageViewController.h"

#import "TriviaStartViewController.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>


@interface LeftMenuViewController () <MBProgressHUDDelegate,LoginViewControllerDelegate,SignUpViewControllerDelegate,SideMenuTableViewCellDelegate,DashboardViewControllerDelegate,MyProfileControllerDelegate>
{
    MBProgressHUD *HUD;
    NSInteger index;
    NSString *isLogin;
}
@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) NSURLConnection *connectionLogout;
@end

@implementation LeftMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView setBackgroundColor:[UIColor colorWithRed:76.0/255.0 green:65.0/255.0 blue:41.0/255.0 alpha:1.0]];
    // Do any additional setup after loading the view from its nib.
    
    isLogin = [[NSUserDefaults standardUserDefaults] objectForKey:@"LoggedIn"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sideBarNotification:) name:@"SideBarNotificationTriggered" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homescreen) name:@"HomeScreen" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout) name:@"Logout" object:nil];
    
    self.arrWithoutLogin = [NSArray arrayWithObjects:@"Home",@"Sign In",@"Sign Up",@"Privacy Policy",@"Contact Us",@"Terms Of Use", nil];
    self.arrImagesWithoutLogin = [NSArray arrayWithObjects:@"home-LM.png",@"login-LM.png",@"register-LM.png",@"about-LM.png",@"contact-us-LM.png",@"term-of-use-LM.png",nil];
    self.arrWithLogin = [NSArray arrayWithObjects:@"User",@"Home",@"My Dashboard",@"My Bar List",@"My Beer List",@"My Cocktail List",@"My Liquor List",@"My Albums",@"Articles",@"Bar Trivia Game",@"Privacy Settings",@"Change Password",@"Privacy Policy",@"Contact Us",@"Terms Of Use",@"Log Out", nil];
    self.arrImagesWithLogin = [NSArray arrayWithObjects:@"user-no_image_LM.png",@"home-LM.png",@"dashboard-LM.png",@"bar-LM.png",@"beer-LM.png",@"cocktail-LM.png",@"liquor-LM.png",@"alubm-LM.png",@"article-LM.png",@"bar-trivia-LM.png",@"privacy-LM.png",@"change-pwd-LM.png",@"about-LM.png",@"contact-us-LM.png",@"term-of-use-LM.png",@"logout-LM.png", nil];
}

-(void)homescreen {
    UINavigationController *nvc;
    UIViewController *rootVC;
    rootVC = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    nvc = [[UINavigationController alloc] initWithRootViewController:rootVC];
    [self openContentNavigationController:nvc];
    
    
    [UIView transitionWithView:appDel.window
                      duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:nil
                    completion:nil];
}

#pragma mark SideBarNotification
-(void)sideBarNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"SideBarNotificationTriggered"])
    {
        isLogin = [[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedIn"];
        [self.tableView reloadData];
    }
}

#pragma mark - TableView Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([isLogin isEqualToString:@"0"])
    {
        return [self.arrWithoutLogin count];
    }
    else
    {
        return [self.arrWithLogin count];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *menuIdentifier = @"SideMenuTableViewCell";
    SideMenuTableViewCell *cell = (SideMenuTableViewCell *)[tableView dequeueReusableCellWithIdentifier:menuIdentifier];
    if (cell == nil)
    {
        NSArray *nib;
        nib = [[NSBundle mainBundle] loadNibNamed:@"SideMenuTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        //cell.imgMenu.image = [UIImage imageNamed:[aryMenuImages objectAtIndex:indexPath.row]];
        cell.contentView.backgroundColor = [UIColor colorWithRed:76.0/255.0 green:65.0/255.0 blue:41.0/255.0 alpha:1.0];
        cell.backgroundColor = [UIColor colorWithRed:76.0/255.0 green:65.0/255.0 blue:41.0/255.0 alpha:1.0];
    }
    cell.viewTap.tag = indexPath.row;
    cell.delegate = self;
    if([isLogin isEqualToString:@"0"])
    {
        cell.viewTap.hidden = YES;
        cell.lblMenuName.text = [self.arrWithoutLogin objectAtIndex:indexPath.row];
        cell.imgMenu.image = [UIImage imageNamed:[self.arrImagesWithoutLogin objectAtIndex:indexPath.row]];
    }
    else
    {
        if (indexPath.row == 0) {
            cell.viewTap.hidden = NO;
        }
        else {
            cell.viewTap.hidden = YES;
        }
        
        
        
        if(indexPath.row == 0)
        {
            if ([CommonUtils isLoggedIn]) {
                User *user = [CommonUtils getUserLoginDetails];
                if ([user.user_image length]==0) {
                   
                    cell.imgMenu.image = [UIImage imageNamed:[self.arrImagesWithLogin objectAtIndex:indexPath.row]];
                    cell.lblMenuName.text = [self.arrWithLogin objectAtIndex:indexPath.row];
                    cell.imgMenu.layer.cornerRadius = 0;
                    cell.imgMenu.layer.masksToBounds = YES;
                }
                else {
                    NSString *strImgURL = [[NSString stringWithFormat:@"%@%@%@",WEBIMAGE_URL,USER_PROFILE_IMAGE,user.user_image] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    NSURL *imgURL = [NSURL URLWithString:strImgURL];
                    
                    [cell.imgMenu sd_setImageWithURL:imgURL placeholderImage:[UIImage imageNamed:[self.arrImagesWithLogin objectAtIndex:indexPath.row]]];
                    cell.lblMenuName.text = user.user_name;
                    
                    cell.imgMenu.layer.cornerRadius = cell.imgMenu.frame.size.height /2;
                    cell.imgMenu.layer.masksToBounds = YES;
                }
                
            }
            else {
                cell.imgMenu.image = [UIImage imageNamed:[self.arrImagesWithLogin objectAtIndex:indexPath.row]];
                cell.lblMenuName.text = [self.arrWithLogin objectAtIndex:indexPath.row];
                cell.imgMenu.layer.cornerRadius = 0;
                cell.imgMenu.layer.masksToBounds = YES;
            }
            
        }
        else {
            cell.imgMenu.image = [UIImage imageNamed:[self.arrImagesWithLogin objectAtIndex:indexPath.row]];
            cell.lblMenuName.text = [self.arrWithLogin objectAtIndex:indexPath.row];
            cell.imgMenu.layer.cornerRadius = 0;
            cell.imgMenu.layer.masksToBounds = YES;
        }
    }

    cell.contentView.backgroundColor = [UIColor colorWithRed:76.0/255.0 green:65.0/255.0 blue:41.0/255.0 alpha:1.0];
    cell.backgroundColor = [UIColor colorWithRed:76.0/255.0 green:65.0/255.0 blue:41.0/255.0 alpha:1.0];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

-(void)openMyProfileView:(id)sender {
    if ([sender tag]==0) {
        UINavigationController *nvc;
        UIViewController *rootVC;
        index = [sender tag];
        MyProfileViewController *myProfile = (MyProfileViewController *)rootVC;
        myProfile = [[MyProfileViewController alloc] initWithNibName:@"MyProfileViewController" bundle:nil];
        myProfile.delegate = self;
        myProfile.isMyProfileFromMenu = YES;
        nvc = [[UINavigationController alloc] initWithRootViewController:myProfile];
        [self openContentNavigationController:nvc];
    }
}

#pragma mark - TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UINavigationController *nvc;
    UIViewController *rootVC;
    if([isLogin isEqualToString:@"0"])
    {
        if (indexPath.row == 0)
        {
            index = indexPath.row;
            rootVC = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
            nvc = [[UINavigationController alloc] initWithRootViewController:rootVC];
            [self openContentNavigationController:nvc];
        }
        else if (indexPath.row == 1)
        {
            LoginViewController *login = (LoginViewController *)rootVC;
            login = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
            login.delegate = self;
            login.isLoginFromMenu = YES;
            nvc = [[UINavigationController alloc] initWithRootViewController:login];
            [self openContentNavigationController:nvc];
        }
        else if (indexPath.row == 2) {
            index = indexPath.row;
            SignUpViewController *signup = (SignUpViewController *)rootVC;
            signup = [[SignUpViewController alloc] initWithNibName:@"SignUpViewController" bundle:nil];
            signup.delegate = self;
            signup.isFromLeftMenu = YES;
            nvc = [[UINavigationController alloc] initWithRootViewController:signup];
            [self openContentNavigationController:nvc];
        }
        else if (indexPath.row == 4) {
            index = indexPath.row;
            rootVC = [[ContactUsViewController alloc] initWithNibName:@"ContactUsViewController" bundle:nil];
            nvc = [[UINavigationController alloc] initWithRootViewController:rootVC];
            [self openContentNavigationController:nvc];
        }
        else if (indexPath.row == 3 || indexPath.row == 5) {
                index = indexPath.row;
                CMSPageViewController *cmsPage = (CMSPageViewController *)rootVC;
                cmsPage = [[CMSPageViewController alloc] initWithNibName:@"CMSPageViewController" bundle:nil];
                if (indexPath.row == 3) {
                    cmsPage.topTitle = @"PRIVACY POLICY";
                    cmsPage.cmsPageSlug = @"privacy-policy";
                }
                else {
                    cmsPage.topTitle = @"TERMS OF USE";
                    cmsPage.cmsPageSlug = @"terms-of-use";
                }
                nvc = [[UINavigationController alloc] initWithRootViewController:cmsPage];
                [self openContentNavigationController:nvc];
        }
    }
    else
    {
        if (indexPath.row == 0)
        {
            index = indexPath.row;
            rootVC = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
            nvc = [[UINavigationController alloc] initWithRootViewController:rootVC];
            [self openContentNavigationController:nvc];
        }
        else if (indexPath.row == 1)
        {
            index = indexPath.row;
            rootVC = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
            nvc = [[UINavigationController alloc] initWithRootViewController:rootVC];
            [self openContentNavigationController:nvc];
        }
        else if (indexPath.row == 2)
        {
            index = indexPath.row;
            DashboardViewController *dashBoard = (DashboardViewController *)rootVC;
            dashBoard = [[DashboardViewController alloc] initWithNibName:@"DashboardViewController" bundle:nil];
            dashBoard.delegate = self;
            dashBoard.isLoggoutFromDashBoard = YES;
            nvc = [[UINavigationController alloc] initWithRootViewController:dashBoard];
            [self openContentNavigationController:nvc];
        }
        else if (indexPath.row == 3)
        {
            index = indexPath.row;
            rootVC = [[MyFavoriteBarViewController alloc] initWithNibName:@"MyFavoriteBarViewController" bundle:nil];
            nvc = [[UINavigationController alloc] initWithRootViewController:rootVC];
            [self openContentNavigationController:nvc];
        }
        else if (indexPath.row == 4)
        {
            index = indexPath.row;
            rootVC = [[MyFavoriteBeerViewController alloc] initWithNibName:@"MyFavoriteBeerViewController" bundle:nil];
            nvc = [[UINavigationController alloc] initWithRootViewController:rootVC];
            [self openContentNavigationController:nvc];
        }
        else if (indexPath.row == 5)
        {
            index = indexPath.row;
            rootVC = [[MyFavoriteCocktailViewController alloc] initWithNibName:@"MyFavoriteCocktailViewController" bundle:nil];
            nvc = [[UINavigationController alloc] initWithRootViewController:rootVC];
            [self openContentNavigationController:nvc];
        }
        else if (indexPath.row == 6)
        {
            index = indexPath.row;
            rootVC = [[MyFavoriteLiquorViewController alloc] initWithNibName:@"MyFavoriteLiquorViewController" bundle:nil];
            nvc = [[UINavigationController alloc] initWithRootViewController:rootVC];
            [self openContentNavigationController:nvc];
        }
        else if (indexPath.row == 7)
        {
            index = indexPath.row;
            rootVC = [[MyAlbumViewController alloc] initWithNibName:@"MyAlbumViewController" bundle:nil];
            nvc = [[UINavigationController alloc] initWithRootViewController:rootVC];
            [self openContentNavigationController:nvc];
        }
        else if (indexPath.row == 8){
            index = indexPath.row;
            rootVC = [[ArticleViewController alloc] initWithNibName:@"ArticleViewController" bundle:nil];
            nvc = [[UINavigationController alloc] initWithRootViewController:rootVC];
            [self openContentNavigationController:nvc];
            
                //            ArticleViewController *article = [[ArticleViewController alloc]  initWithNibName:@"ArticleViewController" bundle:nil];
                //            [self.navigationController pushViewController:article animated:YES];
        }
        else if (indexPath.row == 9)
        {
            TriviaStartViewController *game = (TriviaStartViewController *)rootVC;
            game = [[TriviaStartViewController alloc] initWithNibName:@"TriviaStartViewController" bundle:nil];
            nvc = [[UINavigationController alloc] initWithRootViewController:game];
            [self openContentNavigationController:nvc];
        }
        else if (indexPath.row == 10)
        {
            index = indexPath.row;
            rootVC = [[PrivacySettingViewController alloc] initWithNibName:@"PrivacySettingViewController" bundle:nil];
            nvc = [[UINavigationController alloc] initWithRootViewController:rootVC];
            [self openContentNavigationController:nvc];
        }
        else if (indexPath.row == 11)
        {
            index = indexPath.row;
            rootVC = [[ChangePasswordViewController alloc] initWithNibName:@"ChangePasswordViewController" bundle:nil];
            nvc = [[UINavigationController alloc] initWithRootViewController:rootVC];
            [self openContentNavigationController:nvc];
        }
        else if (indexPath.row == 12 || indexPath.row == 14) {
            index = indexPath.row;
            CMSPageViewController *cmsPage = (CMSPageViewController *)rootVC;
            cmsPage = [[CMSPageViewController alloc] initWithNibName:@"CMSPageViewController" bundle:nil];
            if (indexPath.row == 11) {
                cmsPage.topTitle = @"PRIVACY POLICY";
                cmsPage.cmsPageSlug = @"privacy-policy";
            }
            else {
                cmsPage.topTitle = @"TERMS OF USE";
                cmsPage.cmsPageSlug = @"terms-of-use";
            }
            nvc = [[UINavigationController alloc] initWithRootViewController:cmsPage];
            [self openContentNavigationController:nvc];
        }
        else if (indexPath.row == 13) {
            index = indexPath.row;
            rootVC = [[ContactUsViewController alloc] initWithNibName:@"ContactUsViewController" bundle:nil];
            nvc = [[UINavigationController alloc] initWithRootViewController:rootVC];
            [self openContentNavigationController:nvc];
        }
        else if (indexPath.row == 15)
        {
            [CommonUtils alertViewDelegateWithTitle:AlertTitle withMessage:@"Are you sure you want to logout?" andTarget:self forCancelString:@"YES" forOtherButtonString:@"NO" withTag:100];
        }
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)removeLogin
{
    UINavigationController *nvc;
    UIViewController *rootVC;
    rootVC = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    nvc = [[UINavigationController alloc] initWithRootViewController:rootVC];
    [self openContentNavigationController:nvc];
    
    
    [UIView transitionWithView:appDel.window
                      duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:nil
                    completion:nil];
    /*if (index == 0)
    {
        rootVC = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
        nvc = [[UINavigationController alloc] initWithRootViewController:rootVC];
        [self openContentNavigationController:nvc];
    }
    else if (index == 2)
    {
        
    }*/
}


-(void)removeDashboard {
    UINavigationController *nvc;
    UIViewController *rootVC;
    rootVC = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    nvc = [[UINavigationController alloc] initWithRootViewController:rootVC];
    [self openContentNavigationController:nvc];
}

-(void)removeMyProfile {
    UINavigationController *nvc;
    UIViewController *rootVC;
    rootVC = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    nvc = [[UINavigationController alloc] initWithRootViewController:rootVC];
    [self openContentNavigationController:nvc];
}
#pragma mark Alertview Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 100)
    {
        if (buttonIndex == 0)
        {
            [CommonUtils callWebservice:@selector(logoutService) forTarget:self];
        }
    }
}

#pragma mark -- Webservice Request
-(void)logoutService
{
    NSString *deviceId  = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceId"];
    NSString *userId  = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    NSString *unique_code  = [[NSUserDefaults standardUserDefaults] objectForKey:@"uniqueCode"];

    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.mode = MBProgressHUDModeIndeterminate;
    
    //192.168.1.27/ADB/api/user_logout
    NSString *myURL = [NSString stringWithFormat:@"%@user_logout",WEBSERVICE_URL];
    NSMutableURLRequest *Request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: myURL]];
    NSString *params = [NSString stringWithFormat:@"user_id=%@&unique_code=%@&device_id=%@",userId,unique_code,deviceId];
    [Request setHTTPMethod:@"POST"];
    [Request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    self.connectionLogout = [[NSURLConnection alloc] initWithRequest:Request delegate:self];
    
    if(self.connectionLogout)
    {
        _responseData = [NSMutableData data];
    }
    else
    {
        NSLog(@"connectionLogout is NULL");
    }
}

#pragma mark Webservice Response
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.responseData setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.responseData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"connectionDidFinishLoading");
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    NSString *stringResponse = [[NSString alloc]initWithData:self.responseData encoding:NSUTF8StringEncoding];
    NSLog(@"Response : %@",stringResponse);
    
    if (self.responseData == nil)
    {
        ShowAlert(AlertTitle, MSG_SERVER_NOT_REACHABLE);
        return;
    }
    
    NSError *jsonParsingError = nil;
    NSDictionary *tempDict = [NSJSONSerialization JSONObjectWithData:self.responseData options:0 error:&jsonParsingError];
    
    if(connection == self.connectionLogout)
    {
        NSString *signupStatus = [tempDict objectForKey:@"status"];
        if([signupStatus isEqualToString:@"success"])
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"LoggedIn"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            // UIViewController *rootVC = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
            // UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:rootVC];
            
            
            [[NSUserDefaults standardUserDefaults] setObject:@"Sign In" forKey:@"user_name"];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"user_image"];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"user_id"];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"device_id"];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"unique_code"];
            //[[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"storedEmail"];
//            FBSDKLoginManager *fblogin = [[FBSDKLoginManager alloc] init];
//            fblogin.loginBehavior = FBSDKLoginBehaviorWeb;
//            [fblogin logOut];
            
            [[NSUserDefaults standardUserDefaults] synchronize];            
            
            
            
            LoginViewController *login = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
            appDel.navController = [[UINavigationController alloc] initWithRootViewController:login];
            appDel.window.rootViewController = appDel.navController;
            
            [UIView transitionWithView:appDel.window
                              duration:0.3
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:nil
                            completion:nil];
            
            // [self openContentNavigationController:nvc];
            
            // ShowAlert(AlertTitle, @"Logout Successfully!");
        }
        else
        {
            UIViewController *rootVC = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
            UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:rootVC];
            [self openContentNavigationController:nvc];
            ShowAlert(AlertTitle, @"There is some issue. Please try again.");
        }
    }
}


-(void)logout {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    LoginViewController *login = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    appDel.navController = [[UINavigationController alloc] initWithRootViewController:login];
    appDel.window.rootViewController = appDel.navController;
    
    [UIView transitionWithView:appDel.window
                      duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:nil
                    completion:nil];
    
    // [self openContentNavigationController:nvc];
    
    
    
    // ShowAlert(AlertTitle, @"Logout Successfully!");
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"")
                                message:[error localizedDescription]
                               delegate:nil
                      cancelButtonTitle:NSLocalizedString(@"OK", @"")
                      otherButtonTitles:nil] show];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

@end