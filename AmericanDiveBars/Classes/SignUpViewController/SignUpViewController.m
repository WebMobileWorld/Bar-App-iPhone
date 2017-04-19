//
//  LoginViewController.m
//  AmericanDiveBars
//
//  Created by spaculus on 8/27/15.
//  Copyright (c) 2015 spaculus. All rights reserved.
//

#import "SignUpViewController.h"
#import "RadioButton.h"
#import "SignUpCell.h"
#import "AMPopTip.h"

static NSString *menuIdentifier = @"SIgnUpCell";

@interface SignUpViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    
    NSString *strNickName,
    *strFName,
    *strLName,
    *strEmail,
    *strMobile,
    *strPassword,
    *strConfirmPassword,
    *strBirthDay,
    *strGender,
    *strMonth,
    *strDay,
    *strYear;
    
    NSDate *tempDate;
    
    BOOL isChecked;
    
    
    NSInteger txtTag;
}
// Third Party Tool Tip
@property (nonatomic, strong) AMPopTip *popTip;

//
@property (nonatomic, strong) IBOutlet TPKeyboardAvoidingTableView *tblSignUp;
@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) NSURLConnection *connectionSignUp;
@property (nonatomic, strong) NSDate *selectedDate;

@property (strong, nonatomic) IBOutlet UIImageView *bg;


@end

@implementation SignUpViewController

#pragma mark - ViewLifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.titleView = [CommonUtils setTitleLabel:@"SIGN UP"];
    
    [self clearAllData];
    [self toolTip];
}

-(void)viewDidLayoutSubviews {
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        
        if (![CommonUtils isiPad]) {
            
            if ([CommonUtils isIPhone4_Landscape]) {
                self.bg.image = [UIImage imageNamed:@"login-signup-bg-iphone-L.png"];
            }
            else if ([CommonUtils isIPhone5_Landscape]) {
                self.bg.image = [UIImage imageNamed:@"login-signup-bg-iphone-L.png"];
            }
            else if ([CommonUtils isIPhone6_Landscape]) {
                self.bg.image = [UIImage imageNamed:@"login-signup-bg-iphone-L.png"];
                
            }
            else {
                self.bg.image = [UIImage imageNamed:@"login-signup-bg-iphone-L.png"];
            }
        }
        else {
            self.bg.image = [UIImage imageNamed:@"login-signup-bg-ipad-L.png"];
        }
        
    }
    else {
        if (![CommonUtils isiPad]) {
            
            
            if ([CommonUtils isIPhone4]) {
                self.bg.image = [UIImage imageNamed:@"login-signup-bg-iphone.png"];
            }
            else if ([CommonUtils isIPhone5]) {
                self.bg.image = [UIImage imageNamed:@"login-signup-bg-iphone.png"];
            }
            else if ([CommonUtils isIPhone6]) {
                self.bg.image = [UIImage imageNamed:@"login-signup-bg-iphone.png"];
            }
            else {
                self.bg.image = [UIImage imageNamed:@"login-signup-bg-iphone.png"];
            }
            
            
        }
        else {
            self.bg.image = [UIImage imageNamed:@"login-signup-bg-ipad.png"];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Tool Tip
-(void)toolTip {
    [AMPopTip appearance].font = [UIFont systemFontOfSize:15.0];
    
    self.popTip = [AMPopTip popTip];
    self.popTip.shouldDismissOnTap = YES;
    self.popTip.edgeMargin = 5;
    self.popTip.offset = 2;
    self.popTip.edgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    
    self.popTip.tapHandler = ^{
        NSLog(@"Tap!");
    };
    self.popTip.dismissHandler = ^{
        NSLog(@"Dismiss!");
    };
    
}

#pragma mark - Tableview Delegates
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([CommonUtils isiPad]) {
        return 684;
    }
    else {
        return 696;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SignUpCell *cell = (SignUpCell *)[tableView dequeueReusableCellWithIdentifier:menuIdentifier];
    if (cell == nil)
    {
        NSArray *nib;
        if([CommonUtils isiPad])
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"SignUpCell_iPad" owner:self options:nil];
        }
        else
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"SignUpCell" owner:self options:nil];
        }
        cell = [nib objectAtIndex:0];
    }
    
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];

    
    [CommonUtils setLeftImageToTextField:cell.txtNickName andImage:@"name" andImgWidth:25 andImgHeight:25 withPadding:35];
    [CommonUtils setLeftImageToTextField:cell.txtFName andImage:@"name" andImgWidth:25 andImgHeight:25 withPadding:35];
    [CommonUtils setLeftImageToTextField:cell.txtLName andImage:@"name" andImgWidth:25 andImgHeight:25 withPadding:35];
    [CommonUtils setLeftImageToTextField:cell.txtEmail andImage:@"email" andImgWidth:25 andImgHeight:25 withPadding:35];
    [CommonUtils setLeftImageToTextField:cell.txtMobile andImage:@"mobile" andImgWidth:25 andImgHeight:25 withPadding:35];
    [CommonUtils setLeftImageToTextField:cell.txtPassword andImage:@"password" andImgWidth:25 andImgHeight:25 withPadding:35];
    [CommonUtils setLeftImageToTextField:cell.txtConfirmPassword andImage:@"password" andImgWidth:25 andImgHeight:25 withPadding:35];
    [CommonUtils setLeftImageToTextField:cell.txtBirthDay andImage:@"birthday" andImgWidth:25 andImgHeight:25 withPadding:35];
    
    cell.imgGenderIcon.image = [UIImage imageNamed:@"gendar.png"];
    cell.btnFemale.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
    cell.btnMale.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
    
    [CommonUtils setRightImageToTextField:cell.txtMobile withImage:@"mobile-hint" withPadding:35 withWidth:25 withHeight:25 forSelector:@selector(hintOpen:) forTarget:self];
    [CommonUtils setRightImageToTextField:cell.txtBirthDay withImage:@"date-picker" withPadding:35 withWidth:25 withHeight:25 forSelector:@selector(datePickerOpen:) forTarget:self];
    
    [cell.txtNickName setValue:[UIColor colorWithRed:146.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];
    [cell.txtFName setValue:[UIColor colorWithRed:146.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];
    [cell.txtLName setValue:[UIColor colorWithRed:146.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];
    [cell.txtEmail setValue:[UIColor colorWithRed:146.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];
    [cell.txtMobile setValue:[UIColor colorWithRed:146.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];
    [cell.txtPassword setValue:[UIColor colorWithRed:146.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];
    [cell.txtConfirmPassword setValue:[UIColor colorWithRed:146.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];
    [cell.txtBirthDay setValue:[UIColor colorWithRed:146.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];
    
    
    cell.txtNickName.text = strNickName;
    cell.txtFName.text = strFName;
    cell.txtLName.text = strLName;
    cell.txtEmail.text = strEmail;
    cell.txtMobile.text = strMobile;
    cell.txtPassword.text = strPassword;
    cell.txtConfirmPassword.text = strConfirmPassword;
    cell.txtBirthDay.text = strBirthDay;
    
    if([strGender isEqualToString:@""]){
        [cell.btnMale setImage:[UIImage imageNamed:@"radio-off.png"] forState:UIControlStateNormal];
        [cell.btnFemale setImage:[UIImage imageNamed:@"radio-off.png"] forState:UIControlStateNormal];
    }
    else {
        if([strGender isEqualToString:@"Male"]){
            [cell.btnMale setImage:[UIImage imageNamed:@"radio-on.png"] forState:UIControlStateNormal];
            [cell.btnFemale setImage:[UIImage imageNamed:@"radio-off.png"] forState:UIControlStateNormal];
        }
        else {
            [cell.btnMale setImage:[UIImage imageNamed:@"radio-off.png"] forState:UIControlStateNormal];
            [cell.btnFemale setImage:[UIImage imageNamed:@"radio-on.png"] forState:UIControlStateNormal];
        }
    }
    
    [cell.btnSignUp addTarget:self action:@selector(btnSignUpClick) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnFemale addTarget:self action:@selector(btnRadioClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnMale addTarget:self action:@selector(btnRadioClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.btnCheckBox setImage:[UIImage imageNamed:@"check-off-black"] forState:UIControlStateNormal];
    [cell.btnCheckBox setImage:[UIImage imageNamed:@"check-on-black"] forState:UIControlStateSelected];
    [cell.btnCheckBox addTarget:self action:@selector(btnCheckBoxClick) forControlEvents:UIControlEventTouchUpInside];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

-(void)hintOpen:(UITapGestureRecognizer *)tap {
    CGPoint tapLocation = [tap locationInView:self.tblSignUp];
    UIView *view = [tap view];
    
    CGRect touchRect = CGRectMake(tapLocation.x-10, tapLocation.y-10, view.frame.size.width, view.frame.size.height);
    
    
    [self.popTip hide];
    
    if ([self.popTip isVisible])
    {
        return;
    }
    
    self.popTip.shouldDismissOnTap = YES;
    self.popTip.shouldDismissOnTapOutside = YES;
    
    self.popTip.popoverColor = [UIColor colorWithRed:189.0/255.0 green:127.0/255.0 blue:52.0/255.0 alpha:1];
    [self.popTip showText:@"This is not a required field. Please provide your mobile phone information only if you want to receive promotional information via text from American Bars and bars listed in your favorite section." direction:AMPopTipDirectionDown maxWidth:200 inView:self.tblSignUp fromFrame:touchRect];
    
}

-(void)datePickerOpen:(UITapGestureRecognizer *)tap {
    UIView *view = [tap view];
    ActionSheetDatePicker *datePicker = [[ActionSheetDatePicker alloc] initWithTitle:@"Select Date" datePickerMode:UIDatePickerModeDate selectedDate:[NSDate date] target:self action:@selector(dateSelected:element:) origin:view];
    [datePicker showActionSheetPicker];
}

#pragma mark - TextField Delegates
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField.tag == 50)
    {
        NSString *filter = @"(###) ###-####";
        
        if(!filter) return YES; // No filter provided, allow anything
        
        NSString *changedString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        if(range.length == 1 && // Only do for single deletes
           string.length < range.length &&
           [[textField.text substringWithRange:range] rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"0123456789"]].location == NSNotFound)
        {
            // Something was deleted.  Delete past the previous number
            NSInteger location = changedString.length-1;
            if(location > 0)
            {
                for(; location > 0; location--)
                {
                    if(isdigit([changedString characterAtIndex:location]))
                    {
                        break;
                    }
                }
                changedString = [changedString substringToIndex:location];
            }
        }
        
        textField.text = [CommonUtils filteredPhoneStringFromStringWithFilter:changedString andFilter:filter];
        
        if ([textField.text isEqualToString:@"("]) {
            textField.text = @"";
            return NO;
        }
        
        //filteredPhoneStringFromStringWithFilter(changedString, filter);
        return NO;
    }
    return YES;
}






-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    
    // Close the keypad if it is showing
    //[self.view endEditing:YES];
    
    if(textField.tag == 80)
    {
        [self.view endEditing:YES];
      ActionSheetDatePicker *datePicker = [[ActionSheetDatePicker alloc] initWithTitle:@"Select Date" datePickerMode:UIDatePickerModeDate selectedDate:[NSDate date] target:self action:@selector(dateSelected:element:) origin:textField];
        [datePicker showActionSheetPicker];
        
        return  NO;
    }
    else
    {
        return YES;
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    SignUpCell *cell = (SignUpCell *)[self.tblSignUp cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    if (textField.tag == 10) {
        // Nick Name
        strNickName = textField.text;
        
        if ([strNickName isEqualToString:@""])
        {
            cell.txtNickName.layer.borderColor = [UIColor redColor].CGColor;
            cell.txtNickName.layer.borderWidth = 1.5f;
        }
        else {
            cell.txtNickName.layer.borderColor = [UIColor clearColor].CGColor;
            cell.txtNickName.layer.borderWidth = 0.0f;
        }
        
        //txtTag = textField.tag;
    }
    else if (textField.tag == 20) {
        // Fname
        strFName = textField.text;
        if ([strFName isEqualToString:@""])
        {
            cell.txtFName.layer.borderColor = [UIColor redColor].CGColor;
            cell.txtFName.layer.borderWidth = 1.5f;
        }
        else {
            cell.txtFName.layer.borderColor = [UIColor clearColor].CGColor;
            cell.txtFName.layer.borderWidth = 0.0f;
        }

    }
    else if (textField.tag == 30) {
        // Lname
        strLName = textField.text;
        if ([strLName isEqualToString:@""])
        {
            cell.txtLName.layer.borderColor = [UIColor redColor].CGColor;
            cell.txtLName.layer.borderWidth = 1.5f;
        }
        else {
            cell.txtLName.layer.borderColor = [UIColor clearColor].CGColor;
            cell.txtLName.layer.borderWidth = 0.0f;
        }
    }
    else if (textField.tag == 40) {
        // Email
        strEmail = textField.text;
        BOOL isValidEmail = [CommonUtils IsValidEmail:strEmail];
        if(!isValidEmail)
        {
            cell.txtEmail.layer.borderColor = [UIColor redColor].CGColor;
            cell.txtEmail.layer.borderWidth = 1.5f;
        }
        else {
            cell.txtEmail.layer.borderColor = [UIColor clearColor].CGColor;
            cell.txtEmail.layer.borderWidth = 0.0f;
        }
    }
    else if (textField.tag == 50) {
        // Mobile
        strMobile = textField.text;
    }
    else if (textField.tag == 60) {
        // Password
        strPassword = textField.text;
        BOOL isValidPassword = [CommonUtils validatePassword:strPassword];
        if (!isValidPassword || strPassword.length < 8 || strPassword.length > 16)
        {
            cell.txtPassword.layer.borderColor = [UIColor redColor].CGColor;
            cell.txtPassword.layer.borderWidth = 1.5f;
        }
        else {
            cell.txtPassword.layer.borderColor = [UIColor clearColor].CGColor;
            cell.txtPassword.layer.borderWidth = 0.0f;
        }
    }
    else if (textField.tag == 70) {
        // Confirm Passsword
        strConfirmPassword = textField.text;
        
        if (![strPassword isEqualToString:strConfirmPassword])
        {
            cell.txtConfirmPassword.layer.borderColor = [UIColor redColor].CGColor;
            cell.txtConfirmPassword.layer.borderWidth = 1.5f;
        }
        else {
            cell.txtConfirmPassword.layer.borderColor = [UIColor clearColor].CGColor;
            cell.txtConfirmPassword.layer.borderWidth = 0.0f;
        }
    }
    else {
        // BirthDay
        strBirthDay = textField.text;
        if ([strBirthDay isEqualToString:@""])
        {
            cell.txtBirthDay.layer.borderColor = [UIColor redColor].CGColor;
            cell.txtBirthDay.layer.borderWidth = 1.5f;
        }
        else {
            cell.txtBirthDay.layer.borderColor = [UIColor clearColor].CGColor;
            cell.txtBirthDay.layer.borderWidth = 0.0f;
        }
    }
}

#pragma mark - Date Picker Mehotd
- (void)dateSelected:(NSDate *)selectedDate element:(id)element {
    
    SignUpCell *cell = (SignUpCell *)[self.tblSignUp cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    self.selectedDate = selectedDate;
    
    NSString *resultString = (NSString *)[CommonUtils getDateFormattedFromDate:selectedDate withInputFormat:@"MM/dd/yyyy" andOutputFormat:@"MM/dd/yyyy" isString:YES isSameFormat:YES];
    
    cell.txtBirthDay.text = resultString;
    
    strBirthDay = resultString;
    NSArray *dateComps = [resultString componentsSeparatedByString:@"/"];
    strMonth = [dateComps objectAtIndex:0];
    strDay = [dateComps objectAtIndex:1];
    strYear = [dateComps objectAtIndex:2];
}

#pragma mark Button Click
-(void)btnSignUpClick
{
    [self.view endEditing:YES];
    
    SignUpCell *cell = (SignUpCell *)[self.tblSignUp cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell.txtNickName resignFirstResponder];
    [cell.txtFName resignFirstResponder];
    [cell.txtLName resignFirstResponder];
    [cell.txtEmail resignFirstResponder];
    [cell.txtMobile resignFirstResponder];
    [cell.txtPassword resignFirstResponder];
    [cell.txtConfirmPassword resignFirstResponder];
    [cell.txtBirthDay resignFirstResponder];
    
    BOOL isValidEmail = [CommonUtils IsValidEmail:strEmail];
    BOOL isValidPassword = [CommonUtils validatePassword:strPassword];
    
    if ([strNickName isEqualToString:@""])
    {
        ShowAlert(AlertTitle, @"Please enter Username");
        strNickName = @"";
        [cell.txtNickName becomeFirstResponder];
        cell.txtNickName.layer.borderColor = [UIColor redColor].CGColor;
        cell.txtNickName.layer.borderWidth = 1.5f;
    }
    else if ([strFName isEqualToString:@""])
    {
        ShowAlert(AlertTitle, @"Please enter First Name.");
        strFName = @"";
        [cell.txtFName becomeFirstResponder];
        cell.txtFName.layer.borderColor = [UIColor redColor].CGColor;
        cell.txtFName.layer.borderWidth = 1.5f;
    }
    else if ([strLName isEqualToString:@""])
    {
        ShowAlert(AlertTitle, @"Please enter Last Name.");
        strLName = @"";
        [cell.txtLName becomeFirstResponder];
        cell.txtLName.layer.borderColor = [UIColor redColor].CGColor;
        cell.txtLName.layer.borderWidth = 1.5f;
    }
    else if([strEmail isEqualToString:@""])
    {
        ShowAlert(AlertTitle, @"Please enter Email address.");
        strEmail = @"";
        [cell.txtEmail becomeFirstResponder];
        cell.txtEmail.layer.borderColor = [UIColor redColor].CGColor;
        cell.txtEmail.layer.borderWidth = 1.5f;
    }
    else if(!isValidEmail)
    {
        ShowAlert(AlertTitle, @"Please enter a valid Email Address.");
        [cell.txtEmail becomeFirstResponder];
        cell.txtEmail.layer.borderColor = [UIColor redColor].CGColor;
        cell.txtEmail.layer.borderWidth = 1.5f;
    }
    else if ([strPassword isEqualToString:@""])
    {
        ShowAlert(AlertTitle, @"Please enter Password");
        [cell.txtPassword becomeFirstResponder];
        cell.txtPassword.layer.borderColor = [UIColor redColor].CGColor;
        cell.txtPassword.layer.borderWidth = 1.5f;
    }
    else if (!isValidPassword || strPassword.length < 8 || strPassword.length > 16)
    {
        ShowAlert(AlertTitle, @"All passwords must be between 8 and 16 characters and require that you use 1 number and one special character.");//@"Provide atleast 1 Number, 1 Special character,1 Alphabet and between 8 to 16 characters."
        [cell.txtPassword becomeFirstResponder];
        cell.txtPassword.layer.borderColor = [UIColor redColor].CGColor;
        cell.txtPassword.layer.borderWidth = 1.5f;
    }
    else if (![strPassword isEqualToString:strConfirmPassword])
    {
        ShowAlert(AlertTitle, @"Password and Confirm Password must be same.");
        [cell.txtConfirmPassword becomeFirstResponder];
        cell.txtConfirmPassword.layer.borderColor = [UIColor redColor].CGColor;
        cell.txtConfirmPassword.layer.borderWidth = 1.5f;
    }
    else if ([strBirthDay isEqualToString:@""])
    {
        ShowAlert(AlertTitle, @"Please select Birthdate.");
        cell.txtBirthDay.layer.borderColor = [UIColor redColor].CGColor;
        cell.txtBirthDay.layer.borderWidth = 1.5f;
    }
            //    else if ([strGender length]==0) {
            //        ShowAlert(AlertTitle, @"Please select gender");
            //    }
    else if (!isChecked)
    {
        ShowAlert(AlertTitle, @"Please click on the Checkbox to confirm that you are above the age of 21.");
    }
    else
    {
        cell.txtNickName.layer.borderColor = [UIColor clearColor].CGColor;
        cell.txtNickName.layer.borderWidth = 0.0f;
        
        cell.txtFName.layer.borderColor = [UIColor clearColor].CGColor;
        cell.txtFName.layer.borderWidth = 0.0f;
        
        cell.txtLName.layer.borderColor = [UIColor clearColor].CGColor;
        cell.txtLName.layer.borderWidth = 0.0f;
        
        cell.txtEmail.layer.borderColor = [UIColor clearColor].CGColor;
        cell.txtEmail.layer.borderWidth = 0.0f;
        
        cell.txtPassword.layer.borderColor = [UIColor clearColor].CGColor;
        cell.txtPassword.layer.borderWidth = 0.0f;
        
        cell.txtConfirmPassword.layer.borderColor = [UIColor clearColor].CGColor;
        cell.txtConfirmPassword.layer.borderWidth = 0.0f;
        
        cell.txtBirthDay.layer.borderColor = [UIColor clearColor].CGColor;
        cell.txtBirthDay.layer.borderWidth = 0.0f;
        
        [self callSignUpWebservice];
    }
}

-(void)btnCheckBoxClick
{
    SignUpCell *cell = (SignUpCell *)[self.tblSignUp cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    isChecked = !isChecked; /* Toggle */
    [cell.btnCheckBox setSelected:isChecked];
}

-(IBAction)btnRadioClick:(RadioButton*)sender
{
    NSLog(@"Selected: %@", sender.titleLabel.text);
    strGender = sender.titleLabel.text;
    [self.tblSignUp reloadData];
    
}

#pragma mark  Clear All Data
-(void)clearAllData
{
    strNickName = @"";
    strFName = @"";
    strLName = @"";
    strEmail = @"";
    strMobile = @"";
    strPassword = @"";
    strConfirmPassword = @"";
    strBirthDay = @"";
    strGender = @"";
}

#pragma mark Webservice Call
-(void)callSignUpWebservice {
    [CommonUtils callWebservice:@selector(signUpService) forTarget:self];
}


#pragma mark -- Webservice Request
-(void)signUpService
{
    NSString *deviceId  = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    [[NSUserDefaults standardUserDefaults] setObject:deviceId forKey:@"device_id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.mode = MBProgressHUDModeIndeterminate;
    
    //http://192.168.1.27/ADB/api/user_register
    NSString *myURL = [NSString stringWithFormat:@"%@user_register",WEBSERVICE_URL];
    NSMutableURLRequest *Request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: myURL]];
    NSString *params = [NSString stringWithFormat:@"email=%@&first_name=%@&last_name=%@&nick_name=%@&password=%@&mobile_no=%@&month=%@&day=%@&year=%@&gender=%@",strEmail,strFName,strLName,strNickName,strPassword,strMobile,strMonth,strDay,strYear,strGender];
    [Request setHTTPMethod:@"POST"];
    [Request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    self.connectionSignUp = [[NSURLConnection alloc] initWithRequest:Request delegate:self];
    
    if(self.connectionSignUp)
    {
        _responseData = [NSMutableData data];
    }
    else
    {
        NSLog(@"connectionSignUp is NULL");
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
    
    if(connection == self.connectionSignUp)
    {
        NSString *status = [tempDict objectForKey:@"status"];
        if([status isEqualToString:@"success"])
        {
            
            // @"Your account has been successfully activated. Please check your email to confirm."
            ShowAlert(AlertTitle, @"Thank you for registering with American Bars. In order to complete your registration, please check your email and click on the verification link.");
//            if (self.isFromLeftMenu)
//            {
//                self.isFromLeftMenu = NO;
//                [[self delegate] removeLogin];
//            }
//            else
//            {
                [self.navigationController popViewControllerAnimated:YES];
//            }
        }
        else if ([status isEqualToString:@"unique_failed"])
        {
            ShowAlert(AlertTitle, @"Your entered email address is already registered with this application.");
        }
        else if ([status isEqualToString:@"age_failed"]) {
            ShowAlert(AlertTitle, @"Your age must be 21 years or above plese enter proper birth date.");
        }
        else {
            ShowAlert(AlertTitle, @"Your registation with the application is not done. Please try again.");
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
    [self.popTip hide];
    if ([self.popTip isVisible])
    {
        return;
    }
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
                     
                     if ([CommonUtils isIPhone4_Landscape]) {
                         self.bg.image = [UIImage imageNamed:@"login-signup-bg-iphone.png"];
                     }
                     else if ([CommonUtils isIPhone5_Landscape]) {
                         self.bg.image = [UIImage imageNamed:@"login-signup-bg-iphone.png"];
                     }
                     else if ([CommonUtils isIPhone6_Landscape]) {
                         self.bg.image = [UIImage imageNamed:@"login-signup-bg-iphone.png"];
                         
                     }
                     else {
                         self.bg.image = [UIImage imageNamed:@"login-signup-bg-iphone.png"];
                     }
                 }
                 else {
                     self.bg.image = [UIImage imageNamed:@"login-signup-bg-ipad.png"];
                     
                 }
                 
                 break;
                 
             case UIInterfaceOrientationLandscapeLeft:
             case UIInterfaceOrientationLandscapeRight:
                 if (![CommonUtils isiPad]) {
                     
                     if ([CommonUtils isIPhone4_Landscape]) {
                          self.bg.image = [UIImage imageNamed:@"login-signup-bg-iphone-L.png"];
                         
                     }
                     else if ([CommonUtils isIPhone5_Landscape]) {
                          self.bg.image = [UIImage imageNamed:@"login-signup-bg-iphone-L.png"];
                     }
                     else if ([CommonUtils isIPhone6_Landscape]) {
                          self.bg.image = [UIImage imageNamed:@"login-signup-bg-iphone-L.png"];
                     }
                     else {
                         self.bg.image = [UIImage imageNamed:@"login-signup-bg-iphone-L.png"];
                         //self.navigationController.navigationBar.frame = CGRectMake(0,32, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height+20);
                         
                     }
                 }
                 else {
                     self.bg.image = [UIImage imageNamed:@"login-signup-bg-ipad-L.png"];
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
