//
//  LoginViewController.m
//  AmericanDiveBars
//
//  Created by spaculus on 8/27/15.
//  Copyright (c) 2015 spaculus. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "ResetPasswordViewController.h"

#import "ForgotCell.h"

static NSString *menuIdentifier = @"ForgotCell";

@interface ForgotPasswordViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    
    NSString *strEmail;
    
}

@property (nonatomic, strong) IBOutlet TPKeyboardAvoidingTableView *tblForgot;
@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) NSURLConnection *connectionForgot;

@property (strong, nonatomic) IBOutlet UIImageView *bg;
@property (strong, nonatomic) IBOutlet UIImageView *logo;

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.titleView = [CommonUtils setTitleLabel:@"FORGOT PASSWORD"];
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
    self.navigationController.navigationBar.topItem.title = @" ";
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
    return 247.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 247.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ForgotCell *cell = (ForgotCell *)[tableView dequeueReusableCellWithIdentifier:menuIdentifier];
    if (cell == nil)
    {
        NSArray *nib;
        if([CommonUtils isiPad])
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"ForgotCell_iPad" owner:self options:nil];
        }
        else
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"ForgotCell" owner:self options:nil];
        }
        cell = [nib objectAtIndex:0];
    }
    
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    
    [CommonUtils setLeftPadding:8 andTextField:cell.txtEmail];
    
    [CommonUtils setLeftImageToTextField:cell.txtEmail andImage:@"email" andImgWidth:25 andImgHeight:25 withPadding:35];
    
    
    [cell.txtEmail setValue:[UIColor colorWithRed:146.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];
    
    [cell.btnSend addTarget:self action:@selector(btnSendClick) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.btnBack setTitle:@"❮ GO BACK" forState:UIControlStateNormal];
    [cell.btnBack addTarget:self action:@selector(btnBackClick) forControlEvents:UIControlEventTouchUpInside];
    
    
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
    strEmail = textField.text;
}

#pragma mark Button Click
-(void)btnSendClick
{
    [self.view endEditing:YES];
    
    BOOL isValidEmail = [CommonUtils IsValidEmail:strEmail];
    
    if([strEmail isEqualToString:@""])
    {
        ShowAlert(AlertTitle, @"Please enter Email address.");
    }
    else if(!isValidEmail)
    {
        ShowAlert(AlertTitle, @"Please enter a valid Email Address.");
    }
    else
    {
        BOOL hasConnected = [CommonUtils connected];
        if (hasConnected)
        {
            [self performSelector:@selector(forgotService) withObject:nil afterDelay:0.0001];
        }
        else
        {
            ShowAlert(AlertTitle, MSG_NO_INTERNET_CONNECTION);
        }
    }
}

-(void)btnBackClick
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -- Webservice Request
-(void)forgotService
{
    NSString *deviceId  = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    [[NSUserDefaults standardUserDefaults] setObject:deviceId forKey:@"device_id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.mode = MBProgressHUDModeIndeterminate;
    
    //192.168.1.27/ADB/api/forget_password
    NSString *myURL = [NSString stringWithFormat:@"%@forget_password",WEBSERVICE_URL];
    NSMutableURLRequest *Request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: myURL]];
    NSString *params = [NSString stringWithFormat:@"email=%@&device_id=%@",strEmail,deviceId];
    [Request setHTTPMethod:@"POST"];
    [Request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    self.connectionForgot = [[NSURLConnection alloc] initWithRequest:Request delegate:self];
    
    if(self.connectionForgot)
    {
        _responseData = [NSMutableData data];
    }
    else
    {
        NSLog(@"connectionForgot is NULL");
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
    
    if(connection == self.connectionForgot)
    {
        NSString *status = [tempDict objectForKey:@"status"];
        if([status isEqualToString:@"success"])
        {
            ShowAlert(AlertTitle, @"Varification code has been sent successfully on your given email");
            ResetPasswordViewController *reset = [[ResetPasswordViewController alloc] initWithNibName:@"ResetPasswordViewController" bundle:nil];
            [self.navigationController pushViewController:reset animated:YES];
        }
        else if ([status isEqualToString:@"notfound"]) {
            ShowAlert(AlertTitle, @"This Email ID is not registered with the application.");
        }
        else
        {
            ShowAlert(AlertTitle, @"Email Address Not Found.");
        }
    }
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
                         
                         self.navigationController.navigationBar.frame = CGRectMake(0,32, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height+20);
                         
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
