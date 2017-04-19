//
//  ResetPasswordViewController.m
//  AmericanDiveBars
//
//  Created by spaculus on 9/9/15.
//  Copyright (c) 2015 spaculus. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "ResetPasswordCell.h"

@interface ResetPasswordViewController () <MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    
    NSString *strCode,*strPassword,*strConfirmPassword;
    
}

//Webservice Handle
@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) NSURLConnection *connectionReset;

@property (strong, nonatomic) IBOutlet TPKeyboardAvoidingTableView *tblVIew;
@property (strong, nonatomic) IBOutlet UIImageView *bg;
@property (strong, nonatomic) IBOutlet UIImageView *logo;
@end

@implementation ResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [CommonUtils setTitleLabel:@"RESET PASSWORD"];
    [self clearAllData];
    // Do any additional setup after loading the view from its nib.
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  Clear All Data
-(void)clearAllData
{
    strCode = @"";
    strPassword = @"";
    strConfirmPassword = @"";
}


#pragma mark Number of Section
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

#pragma mark Number of Row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
    
#pragma mark Cell for Row
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"ResetPasswordCell";
    
    ResetPasswordCell *cell = (ResetPasswordCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib;
        if([CommonUtils isiPad])
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"ResetPasswordCell_iPad" owner:self options:nil];
        }
        else
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"ResetPasswordCell" owner:self options:nil];
        }
        cell = [nib objectAtIndex:0];
    }
    
    [cell configureCellUI];
    
    cell.txtVarifCode.text = strCode;
    cell.txtNewPassword.text = strPassword;
    cell.txtConfirmNewPassword.text = strConfirmPassword;

    [cell.btnResetPassword addTarget:self action:@selector(btnResetPassword_Clicked) forControlEvents:UIControlEventTouchUpInside];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

-(void)btnResetPassword_Clicked {
    [self.view endEditing:YES];
    
    ResetPasswordCell *cell = (ResetPasswordCell *)[self.tblVIew cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    BOOL isValidPassword = [CommonUtils validatePassword:strPassword];
    
    if ([strCode isEqualToString:@""])
    {
        ShowAlert(AlertTitle, @"Please enter Verification Code.");
        strCode = @"";
        [cell.txtVarifCode becomeFirstResponder];
    }
    else if ([strPassword isEqualToString:@""])
    {
        ShowAlert(AlertTitle, @"Please enter Your New Password.");
        strPassword = @"";
        [cell.txtNewPassword becomeFirstResponder];
    }
    else if ([strConfirmPassword isEqualToString:@""])
    {
        ShowAlert(AlertTitle, @"Please enter Confirmation Password.");
        strConfirmPassword = @"";
        [cell.txtConfirmNewPassword becomeFirstResponder];
    }
    else if (!isValidPassword || strPassword.length < 8 || strPassword.length > 16)
    {
        ShowAlert(AlertTitle, @"Provide atleast 1 Number, 1 Special character,1 Alphabet and between 8 to 16 characters.");
        [cell.txtNewPassword becomeFirstResponder];
    }
    else if (![strPassword isEqualToString:strConfirmPassword])
    {
        ShowAlert(AlertTitle, @"Password and Confirm Password must be same.");
        [cell.txtConfirmNewPassword becomeFirstResponder];
    }
    else
    {
        [self callResetPasswordWebservice];
    }

}

#pragma mark Cell Height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 307;
}

#pragma mark did Select Row
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark - TextField Delegates
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 10) {
        // Verification Code
        strCode = textField.text;
    }
    else if (textField.tag == 20) {
        // Password
        strPassword = textField.text;
    }
    else if (textField.tag == 30) {
        // Confirm Password
        strConfirmPassword = textField.text;
    }
    
    [self.tblVIew reloadData];
}


#pragma mark Webservice Call
-(void)callResetPasswordWebservice {
    [CommonUtils callWebservice:@selector(resetPasswordService) forTarget:self];
}

#pragma mark -- Webservice Request
-(void)resetPasswordService
{
    NSString *deviceId  = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    [[NSUserDefaults standardUserDefaults] setObject:deviceId forKey:@"device_id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.mode = MBProgressHUDModeIndeterminate;
    
    //192.168.1.27/ADB/api/reset_password
    NSString *myURL = [NSString stringWithFormat:@"%@reset_password",WEBSERVICE_URL];
    NSMutableURLRequest *Request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: myURL]];
    NSString *params = [NSString stringWithFormat:@"forget_password_code=%@&password=%@",strCode,strPassword];
    [Request setHTTPMethod:@"POST"];
    [Request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    self.connectionReset = [[NSURLConnection alloc] initWithRequest:Request delegate:self];
    
    if(self.connectionReset)
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
    
    if(connection == self.connectionReset)
    {
        NSString *status = [tempDict objectForKey:@"status"];
        if([status isEqualToString:@"success"])
        {
            ShowAlert(AlertTitle, @"Password has been changed succsessfully");
            [self.navigationController popToRootViewControllerAnimated:YES];
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
