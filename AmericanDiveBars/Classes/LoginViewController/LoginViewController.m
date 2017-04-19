//
//  LoginViewController.m
//  AmericanDiveBars
//
//  Created by spaculus on 8/27/15.
//  Copyright (c) 2015 spaculus. All rights reserved.
//

#import "LoginViewController.h"
#import "ForgotPasswordViewController.h"
#import "SignUpViewController.h"
#import "MainMenuViewController.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "LoginCell.h"
#import "ForgotCell.h"
#import "SIgnUpCell.h"

@interface LoginViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    
    NSString *strEmail;
    NSString *strPassword;
    
    NSString *fbFirstName;
    NSString *fbLastName;
    NSString *fbEmail;
    NSString *fbUserId;
    NSString *fb_img;
    
    BOOL isRemembered;
}
@property (nonatomic, strong) IBOutlet TPKeyboardAvoidingTableView *tblLogin;
@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) NSURLConnection *connectionLogin;
@property (strong, nonatomic) IBOutlet UIImageView *bg;
@property (strong, nonatomic) IBOutlet UIImageView *logo;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.titleView = [CommonUtils setTitleLabel:@"SIGN IN"];

    isRemembered = [[NSUserDefaults standardUserDefaults] boolForKey:@"RememberMe"];
    if(isRemembered)
    {
        strEmail = [[NSUserDefaults standardUserDefaults] objectForKey:@"storedEmail"];
        strPassword = [[NSUserDefaults standardUserDefaults] objectForKey:@"storedPassword"];
    }
}

-(void)viewDidLayoutSubviews {
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        
        if (![CommonUtils isiPad]) {
            
            if ([CommonUtils isIPhone4_Landscape]) {
                self.bg.image = [UIImage imageNamed:@"login-signup-bg-iphone-L.png"];
                self.logo.image = [UIImage imageNamed:@"header-logo-iphone-L.png"];
            }
            else if ([CommonUtils isIPhone5_Landscape]) {
                self.bg.image = [UIImage imageNamed:@"login-signup-bg-iphone-L.png"];
                self.logo.image = [UIImage imageNamed:@"header-logo-iphone-L.png"];
            }
            else if ([CommonUtils isIPhone6_Landscape]) {
                self.bg.image = [UIImage imageNamed:@"login-signup-bg-iphone-L.png"];
                self.logo.image = [UIImage imageNamed:@"header-logo-iphone-L.png"];
                
            }
            else {
                self.bg.image = [UIImage imageNamed:@"login-signup-bg-iphone-L.png"];
                self.logo.image = [UIImage imageNamed:@"header-logo-iphone-L.png"];
            }
        }
        else {
            self.bg.image = [UIImage imageNamed:@"login-signup-bg-ipad-L.png"];
            self.logo.image = [UIImage imageNamed:@"header-logo-ipad-L.png"];
        }

    }
    else {
        if (![CommonUtils isiPad]) {
            
            
            if ([CommonUtils isIPhone4]) {
                self.bg.image = [UIImage imageNamed:@"login-signup-bg-iphone.png"];
                self.logo.image = [UIImage imageNamed:@"header-logo-iphone.png"];
            }
            else if ([CommonUtils isIPhone5]) {
                self.bg.image = [UIImage imageNamed:@"login-signup-bg-iphone.png"];
                self.logo.image = [UIImage imageNamed:@"header-logo-iphone.png"];
            }
            else if ([CommonUtils isIPhone6]) {
                self.bg.image = [UIImage imageNamed:@"login-signup-bg-iphone.png"];
                self.logo.image = [UIImage imageNamed:@"header-logo-iphone.png"];
            }
            else {
                self.bg.image = [UIImage imageNamed:@"login-signup-bg-iphone.png"];
                self.logo.image = [UIImage imageNamed:@"header-logo-iphone.png"];
            }
            
            
        }
        else {
            self.bg.image = [UIImage imageNamed:@"login-signup-bg-ipad.png"];
            self.logo.image = [UIImage imageNamed:@"header-logo-ipad.png"];
        }
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    CGSize blankImageSize = CGSizeMake(self.view.bounds.size.width, 64);
    UIImage *blank = [CommonUtils imageFromColor:[UIColor colorWithRed:187.0/255.0 green:124.0/255.0 blue:37.0/255.0 alpha:1.0] forSize:blankImageSize withCornerRadius:0.0];
    [CommonUtils setNavigationBarImage:blank forNavigationBar:self.navigationController.navigationBar];
}

#pragma mark Tableview Delegates
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 337.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *menuIdentifier = @"LoginCell";
    LoginCell *cell = (LoginCell *)[tableView dequeueReusableCellWithIdentifier:menuIdentifier];
    if (cell == nil)
    {
        NSArray *nib;
        if([CommonUtils isiPad])
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"LoginCell_iPad" owner:self options:nil];
        }
        else
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"LoginCell" owner:self options:nil];
        }
        cell = [nib objectAtIndex:0];
    }
    
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    
    [CommonUtils setLeftPadding:8 andTextField:cell.txtEmail];
    [CommonUtils setLeftPadding:8 andTextField:cell.txtPassword];
    
    [CommonUtils setLeftImageToTextField:cell.txtEmail andImage:@"email" andImgWidth:25 andImgHeight:25 withPadding:35];
    [CommonUtils setLeftImageToTextField:cell.txtPassword andImage:@"password" andImgWidth:25 andImgHeight:25 withPadding:35];
    
    if(isRemembered == YES)
    {
        cell.txtEmail.text = strEmail;
        cell.txtPassword.text = strPassword;
        [cell.btnRememberMe setBackgroundImage:[UIImage imageNamed:@"check-on.png"] forState:UIControlStateNormal];
    }
    else
    {
        [cell.btnRememberMe setBackgroundImage:[UIImage imageNamed:@"check-off.png"] forState:UIControlStateNormal];
    }
    
    [cell.txtEmail setValue:[UIColor colorWithRed:146.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];
    [cell.txtPassword setValue:[UIColor colorWithRed:146.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];
    
    [cell.btnSignIn addTarget:self action:@selector(btnSignInClick) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnRememberMe addTarget:self action:@selector(btnRememberMeClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnForgotPass addTarget:self action:@selector(btnForgotPassClick) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnSignUp addTarget:self action:@selector(btnSignUpClick) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnFacebookLogin addTarget:self action:@selector(btnFacebookClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

#pragma mark TextField Delegates
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField.tag == 10)
    {
        strEmail = textField.text;
    }
    else
    {
        strPassword = textField.text;
    }
}

#pragma mark Button Click
-(void)btnSignInClick
{
   // [self.view endEditing:YES];
    LoginCell *cell = (LoginCell *)[self.tblLogin cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell.txtEmail resignFirstResponder];
    [cell.txtPassword resignFirstResponder];
    
    strEmail = cell.txtEmail.text;
    strPassword = cell.txtPassword.text;
    
    BOOL isValidEmail = [CommonUtils IsValidEmail:strEmail];
    
    if([strEmail isEqualToString:@""] || [strPassword isEqualToString:@""])
    {
        if([strEmail isEqualToString:@""])
        {
            ShowAlert(AlertTitle, @"Please enter email address.");
        }
        else
        {
            ShowAlert(AlertTitle, @"Please enter password.");
        }
    }
    else if(!isValidEmail)
    {
        ShowAlert(AlertTitle, @"Please enter a valid email address.");
    }
    else
    {
        BOOL hasConnected = [CommonUtils connected];
        if (hasConnected)
        {
            [self performSelector:@selector(loginService) withObject:nil afterDelay:0.0001];
        }
        else
        {
            ShowAlert(AlertTitle, MSG_NO_INTERNET_CONNECTION);
        }
    }
}

-(void)btnRememberMeClick:(UIButton *)button
{
    if(isRemembered == YES)
    {
        isRemembered = NO;
        [button setBackgroundImage:[UIImage imageNamed:@"check-off.png"] forState:UIControlStateNormal];
    }
    else
    {
        isRemembered = YES;
        [button setBackgroundImage:[UIImage imageNamed:@"check-on.png"] forState:UIControlStateNormal];
    }
}

-(void)btnForgotPassClick
{
    ForgotPasswordViewController *forgotVC = [[ForgotPasswordViewController alloc]initWithNibName:@"ForgotPasswordViewController" bundle:nil];
    [self.navigationController pushViewController:forgotVC animated:YES];
}

-(void)btnSignUpClick
{
    SignUpViewController *signUpVC = [[SignUpViewController alloc]initWithNibName:@"SignUpViewController" bundle:nil];
    [self.navigationController pushViewController:signUpVC animated:YES];
}

-(void)btnFacebookClicked:(id)sender
{
    [self.view endEditing:YES];
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    login.loginBehavior = FBSDKLoginBehaviorBrowser;
    //[login logOut];
    [login logInWithReadPermissions: @[@"public_profile",@"email"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
     {
         if (error)
         {
             NSLog(@"Process error");
         }
         else if (result.isCancelled)
         {
             NSLog(@"Cancelled");
         }
         else
         {
             NSLog(@"Logged in");
             
             if ([FBSDKAccessToken currentAccessToken])
             {
                 [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields":@"first_name,last_name,email,picture"}]
                  startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
                  {
                      if (!error)
                      {
                          NSLog(@"fetched user:%@", result);
                          fbUserId = [CommonUtils getNotNullString:[result valueForKey:@"id"]];
                          fbFirstName = [CommonUtils getNotNullString:[result valueForKey:@"first_name"]];
                          fbLastName = [CommonUtils getNotNullString:[result valueForKey:@"last_name"]];
                          fbEmail = [result valueForKey:@"email"];//[CommonUtils getNotNullString:[result valueForKey:@"email"]];
                          fb_img = [[[result objectForKey:@"picture"] objectForKey:@"data"] valueForKey:@"url"];
                          
                          
                          [self performSelector:@selector(fb_register) withObject:nil afterDelay:0.0001];
                      }
                  }];
             }
         }
     }];
}
/*{
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.mode = MBProgressHUDModeIndeterminate;
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        ACAccountStore *accountStore = [[ACAccountStore alloc] init];
        ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
        NSDictionary *options = @{ACFacebookAppIdKey : FACEBOOK_APP_ID,
                                  ACFacebookPermissionsKey : @[@"public_profile"]
                                  };
        [accountStore requestAccessToAccountsWithType:accountType
                                              options:options
                                           completion:^(BOOL granted, NSError *error)
         {
             
             if(granted)
             {
                 
                 SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                                         requestMethod:SLRequestMethodGET
                                                                   URL:[NSURL URLWithString:@"https://graph.facebook.com/me"]
                                                            parameters:nil];
                 
                 
                 NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
                 ACAccount *facebook = [accountsArray objectAtIndex:0];
                 
                 request.account = facebook; // This is the _account from your code
                 [request performRequestWithHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                     if (error == nil && ((NSHTTPURLResponse *)response).statusCode == 200) {
                         NSError *deserializationError;
                         NSDictionary *userData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&deserializationError];
                         
                         if (userData != nil && deserializationError == nil) {
                             NSString *email = userData[@"email"];
                             fbEmail = [CommonUtils getNotNullString:[userData valueForKey:@"email"]];
                             fbUserId = [CommonUtils getNotNullString:userData[@"id"]];
                             fbFirstName = [CommonUtils getNotNullString:[userData valueForKey:@"first_name"]];
                             fbLastName = [CommonUtils getNotNullString:[userData valueForKey:@"last_name"]];
                             fb_img = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large",fbUserId];
                             
                             NSLog(@"%@", email);
                         }
                         [MBProgressHUD hideHUDForView:self.view animated:YES];
                         [self performSelectorOnMainThread:@selector(fb_register) withObject:nil waitUntilDone:YES];
                     }
                     
                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                 }];
             }
             else
             {
                 NSLog(@"%@", [error description]);
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                 ShowAlert(AlertTitle, @"Permission not granted");
             }
         }];
    }
    else
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        ShowAlert(AlertTitle, @"Please sign into your Facebook account from Settings->Facebook.");
    }
    
}*/






#pragma mark -- Webservice Request

-(void)fb_register {
    NSString *deviceId  = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    [[NSUserDefaults standardUserDefaults] setObject:deviceId forKey:@"device_id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.mode = MBProgressHUDModeIndeterminate;
    
    //192.168.1.27/ADB/api/checklogin
    NSString *myURL = [NSString stringWithFormat:@"%@fb_register",WEBSERVICE_URL];
    NSMutableURLRequest *Request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: myURL]];
    NSString *params = [NSString stringWithFormat:@"first_name=%@&last_name=%@&fb_id=%@&email=%@&fb_img=%@&device_id=%@",fbFirstName,fbLastName,fbUserId,fbEmail,fb_img,deviceId];
    
    [Request setHTTPMethod:@"POST"];
    [Request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    self.connectionLogin = [[NSURLConnection alloc] initWithRequest:Request delegate:self];
    
    if(self.connectionLogin)
    {
        _responseData = [NSMutableData data];
    }
    else
    {
        NSLog(@"connectionLogin is NULL");
    }
}

-(void)loginService
{
    NSString *deviceId  = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    [[NSUserDefaults standardUserDefaults] setObject:deviceId forKey:@"device_id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.mode = MBProgressHUDModeIndeterminate;
    
    //192.168.1.27/ADB/api/checklogin
    NSString *myURL = [NSString stringWithFormat:@"%@checklogin",WEBSERVICE_URL];
    NSMutableURLRequest *Request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: myURL]];
    NSString *params = [NSString stringWithFormat:@"email=%@&password=%@&device_id=%@",strEmail,strPassword,deviceId];
    [Request setHTTPMethod:@"POST"];
    [Request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    self.connectionLogin = [[NSURLConnection alloc] initWithRequest:Request delegate:self];
    
    if(self.connectionLogin)
    {
        _responseData = [NSMutableData data];
    }
    else
    {
        NSLog(@"connectionLogin is NULL");
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
    
    if(connection == self.connectionLogin)
    {
        NSString *signupStatus = [tempDict objectForKey:@"status"];
        if([signupStatus isEqualToString:@"success"])
        {
            if(isRemembered == YES)
            {
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"RememberMe"];
                NSLog(@"email = %@",strEmail);
                NSLog(@"password = %@",strPassword);
                [[NSUserDefaults standardUserDefaults] setObject:strEmail forKey:@"storedEmail"];
                [[NSUserDefaults standardUserDefaults] setObject:strPassword forKey:@"storedPassword"];
            }
            else
            {
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"RememberMe"];
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"storedEmail"];
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"storedPassword"];
            }
            
            NSString *fname = [CommonUtils getNotNullString:[tempDict valueForKey:@"first_name"]];
            NSString *lname = [CommonUtils getNotNullString:[tempDict valueForKey:@"last_name"]];
            if ([lname isEqualToString:@"0"]) {
                lname = @"";
            }
            NSString *fullname = [self getFullNameFromFirstName:fname andLastName:lname];
            
            NSString *imagename = [CommonUtils getNotNullString:[tempDict valueForKey:@"image"]];
            
            [[NSUserDefaults standardUserDefaults] setObject:fullname forKey:@"user_name"];
            [[NSUserDefaults standardUserDefaults] setObject:imagename forKey:@"user_image"];
            [[NSUserDefaults standardUserDefaults] setObject:[tempDict valueForKey:@"user_id"] forKey:@"user_id"];
            [[NSUserDefaults standardUserDefaults] setObject:[tempDict valueForKey:@"unique_code"] forKey:@"unique_code"];
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"LoggedIn"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            //ShowAlert(AlertTitle, @"Login Successfully !");
            
            MainMenuViewController *mainView = [[MainMenuViewController alloc] init];
            appDel.navController = [[UINavigationController alloc] initWithRootViewController:mainView];
            appDel.window.rootViewController = appDel.navController;
            
            [UIView transitionWithView:appDel.window
                              duration:0.3
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:nil
                            completion:nil];
            
            /*if (self.isLoginFromMenu)
            {
                self.isLoginFromMenu = NO;
                [[self delegate] removeLogin];
            }
            else
            {
                [self.navigationController popViewControllerAnimated:YES];
            }*/
        }
        else if([signupStatus isEqualToString:@"inactive"])
        {
            ShowAlert(AlertTitle, @"Your account is not activated. Please activate your account first.");
        }
        else if ([signupStatus isEqualToString:@"not_registered"]) {
            ShowAlert(AlertTitle, @"This email address is not registered with the application.");
        }
        else
        {
            ShowAlert(@"Invalid Credentials", @"Please enter valid email address or password");
        }
    }
}

-(NSString *)getFullNameFromFirstName:(NSString *)fname andLastName:(NSString *)lname {
    NSString *fullName = nil;
    
    if ([fname length]>0) {
        fullName = [NSString stringWithFormat:@"%@",fname];
    }
    
    if ([lname length] > 0) {
        if ([fullName length]>0) {
            fullName = [NSString stringWithFormat:@"%@ %@",fullName,lname];
        }
        else {
            fullName = lname;
        }
    }
    if (fullName == nil) {
        fullName = @"";
    }
    return fullName;
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"")
                                message:[error localizedDescription]
                               delegate:nil
                      cancelButtonTitle:NSLocalizedString(@"OK", @"")
                      otherButtonTitles:nil] show];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Oriantation
-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         CGSize blankImageSize = CGSizeMake(self.view.bounds.size.width, 64);
         UIImage *blank = [CommonUtils imageFromColor:[UIColor colorWithRed:187.0/255.0 green:124.0/255.0 blue:37.0/255.0 alpha:1.0] forSize:blankImageSize withCornerRadius:0.0];
         [CommonUtils setNavigationBarImage:blank forNavigationBar:self.navigationController.navigationBar];
         
         UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
         
         switch (orientation) {
             case UIInterfaceOrientationPortrait:
             case UIInterfaceOrientationPortraitUpsideDown:
                 if (![CommonUtils isiPad]) {
                     
                     
                     if ([CommonUtils isIPhone4]) {
                         self.bg.image = [UIImage imageNamed:@"login-signup-bg-iphone.png"];
                         self.logo.image = [UIImage imageNamed:@"header-logo-iphone.png"];
                     }
                     else if ([CommonUtils isIPhone5]) {
                         self.bg.image = [UIImage imageNamed:@"login-signup-bg-iphone.png"];
                         self.logo.image = [UIImage imageNamed:@"header-logo-iphone.png"];
                     }
                     else if ([CommonUtils isIPhone6]) {
                         self.bg.image = [UIImage imageNamed:@"login-signup-bg-iphone.png"];
                         self.logo.image = [UIImage imageNamed:@"header-logo-iphone.png"];
                     }
                     else {
                         self.bg.image = [UIImage imageNamed:@"login-signup-bg-iphone.png"];
                         self.logo.image = [UIImage imageNamed:@"header-logo-iphone.png"];
                     }
                     
                     
                 }
                 else {
                     self.bg.image = [UIImage imageNamed:@"login-signup-bg-ipad.png"];
                     self.logo.image = [UIImage imageNamed:@"header-logo-ipad.png"];
                 }
                 
                 
                 break;
                 
             case UIInterfaceOrientationLandscapeLeft:
             case UIInterfaceOrientationLandscapeRight:
                 if (![CommonUtils isiPad]) {
                     
                     if ([CommonUtils isIPhone4_Landscape]) {
                         self.bg.image = [UIImage imageNamed:@"login-signup-bg-iphone-L.png"];
                         self.logo.image = [UIImage imageNamed:@"header-logo-iphone-L.png"];                     }
                     else if ([CommonUtils isIPhone5_Landscape]) {
                         self.bg.image = [UIImage imageNamed:@"login-signup-bg-iphone-L.png"];
                         self.logo.image = [UIImage imageNamed:@"header-logo-iphone-L.png"];
                     }
                     else if ([CommonUtils isIPhone6_Landscape]) {
                         self.bg.image = [UIImage imageNamed:@"login-signup-bg-iphone-L.png"];
                         self.logo.image = [UIImage imageNamed:@"header-logo-iphone-L.png"];

                     }
                     else {
                         self.bg.image = [UIImage imageNamed:@"login-signup-bg-iphone-L.png"];
                         self.logo.image = [UIImage imageNamed:@"header-logo-iphone-L.png"];

                       //  self.navigationController.navigationBar.frame = CGRectMake(0,32, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height+20);
                         
                     }
                 }
                 else {
                     self.bg.image = [UIImage imageNamed:@"login-signup-bg-ipad-L.png"];
                     self.logo.image = [UIImage imageNamed:@"header-logo-ipad-L.png"];
                 }
                 break;
                 
             default:
                 break;
         }
         
         
     } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         
     }];
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

@end
