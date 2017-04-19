//
//  MyProfileViewController.m
//  AmericanDiveBars
//
//  Created by spaculus on 10/2/15.
//  Copyright © 2015 spaculus. All rights reserved.
//

#import "MyProfileViewController.h"
#import "MyProfileCell.h"

static NSString * const kAboutUserPlaceholderText = @"About User";
static NSString * const kAddressPlaceholderText = @"Address";

@interface MyProfileViewController ()<MBProgressHUDDelegate,ShowMoreViewDelegate,UzysAssetsPickerControllerDelegate,FPPopoverControllerDelegate>
{
    MBProgressHUD *HUD;
    
    //POPOVER
    FPPopoverController *popover;
    
    BOOL isWSStatus;
    
    //Cell Editable Or Not
    BOOL editProfile;
    
    //Gender Buttons Check
    NSString *strGender;
    
    //User Profile
    UserProfile *profile;
    
    //Textview placeholder
    BOOL showingAboutUserPlaceholder;
    BOOL showingAddressPlaceholder;
    
    //UZYIMAGE
    BOOL didSelectImage;
    UIImage *selectedImage;

}

@property (strong, nonatomic) NSMutableArray *aryImages;

//Main Table
@property (strong, nonatomic) IBOutlet UITableView *tblView;
@property (strong, nonatomic) NSMutableArray *aryList;

@property (strong, nonatomic) IBOutlet UIView *viewShowMore;
@end

@implementation MyProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [CommonUtils setTitleLabel:@"MY PROFILE"];
    [self configureTopButtons];
    [self setInitialData];
}

-(void)setInitialData {
    didSelectImage = NO;
    isWSStatus = NO;
    strGender = @"male";
    self.aryList = [[NSMutableArray alloc] init];
    self.aryImages = [[NSMutableArray alloc] init];
    [self hideShowMoreView];
     [self callGetUserDashboardByIdWebservice];
   
}

-(void)setStatusBarVisibility {
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

-(void)viewDidLayoutSubviews {
    [self setStatusBarVisibility];
    popover.contentSize = CGSizeMake(150, self.view.bounds.size.height-20);
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setNavImage];
    self.navigationController.navigationBar.topItem.title = @" ";
    [self setStatusBarVisibility];
    
    
    
    
}
-(void)setNavImage{
    CGSize blankImageSize = CGSizeMake(self.view.bounds.size.width, 64);
    UIImage *blank = [CommonUtils imageFromColor:[UIColor colorWithRed:187.0/255.0 green:124.0/255.0 blue:37.0/255.0 alpha:1.0] forSize:blankImageSize withCornerRadius:0.0];
    [CommonUtils setNavigationBarImage:blank forNavigationBar:self.navigationController.navigationBar];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Right Menu

-(void)configureTopButtons {
    UIBarButtonItem *btnFilter;
    btnFilter = [CommonUtils barItemWithImage:[UIImage imageNamed:@"three-dit.png"] highlightedImage:nil xOffset:2 target:self action:@selector(openRightMenu_Clicked:)];
    
    [btnFilter setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                       [UIFont systemFontOfSize:17.0], NSFontAttributeName,
                                       [UIColor lightGrayColor], NSForegroundColorAttributeName,
                                       nil]
                             forState:UIControlStateNormal];
    UIBarButtonItem *btnTopSearch;
    btnTopSearch = [CommonUtils barItemWithImage:[UIImage imageNamed:@"top-home.png"] highlightedImage:nil xOffset:-10 target:self action:@selector(btnTopSearch_Clicked:)];
    
    self.navigationItem.rightBarButtonItems = @[btnFilter,btnTopSearch];
}



-(void)btnTopSearch_Clicked:(UIButton *)btnTopSearch {
    [self btnTopSearchClicked:btnTopSearch];
}

-(void)btnTopSearchClicked:(UIButton *)btnTopSearch {
    [self.view endEditing:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HomeScreen" object:nil];
// [self.navigationController popToRootViewControllerAnimated:YES];
//    FindBarViewController *findBar = [[FindBarViewController alloc] initWithNibName:@"FindBarViewController" bundle:nil];
//    [self.navigationController pushViewController:findBar animated:YES];
}


-(void)openRightMenu_Clicked:(UIButton *)btnRightMenu {
    [self.view endEditing:YES];

    [self btnFilterClicked:btnRightMenu];
}

-(void)btnFilterClicked:(id)sender
{
    LeftMenu_Popup *controller = [[LeftMenu_Popup alloc] initWithStyle:UITableViewStylePlain];
    controller.myProfileDelegate = self;
    
    if ([CommonUtils isLoggedIn]) {
        //All
        controller.aryItems = @[@{@"image":@"user-no_image_LM.png",@"title":@"User"},
                                @{@"image":@"dashboard-LM.png",@"title":@"My Dashboard"},
                                @{@"image":@"bar-LM.png",@"title":@"Find Bar"},
                                @{@"image":@"beer-LM.png",@"title":@"Beer Directory"},
                                @{@"image":@"cocktail-LM.png",@"title":@"Cocktail Recipes"},
                                @{@"image":@"liquor-LM.png",@"title":@"Liquor Directory"},
                                @{@"image":@"taxi-RM.png",@"title":@"Taxi Directory"},
                                @{@"image":@"photo-LM.png",@"title":@"Photo Gallery"},
                                @{@"image":@"article-RM.png",@"title":@"Articles"},
                                @{@"image":@"bar-trivia-RM.png",@"title":@"Bar Trivia Game"}];
    }
    else {
        //All
        controller.aryItems = @[@{@"image":@"login-LM.png",@"title":@"Sign In"},
                                @{@"image":@"register-LM.png",@"title":@"Sign Up"},
                                @{@"image":@"bar-LM.png",@"title":@"Find Bar"},
                                @{@"image":@"beer-LM.png",@"title":@"Beer Directory"},
                                @{@"image":@"cocktail-LM.png",@"title":@"Cocktail Recipes"},
                                @{@"image":@"liquor-LM.png",@"title":@"Liquor Directory"},
                                @{@"image":@"taxi-RM.png",@"title":@"Taxi Directory"},
                                @{@"image":@"photo-LM.png",@"title":@"Photo Gallery"},
                                @{@"image":@"article-RM.png",@"title":@"Articles"},
                                @{@"image":@"bar-trivia-RM.png",@"title":@"Bar Trivia Game"}];
    }
    

    popover = [[FPPopoverController alloc] initWithViewController:controller];
    
    popover.contentSize = CGSizeMake(150, self.view.bounds.size.height-20);
    
    popover.arrowDirection = FPPopoverArrowDirectionUp;
    [popover presentPopoverFromView:sender];
    
}

- (void)presentedNewPopoverController:(FPPopoverController *)newPopoverController shouldDismissVisiblePopover:(FPPopoverController*)visiblePopoverController
{
    [visiblePopoverController dismissPopoverAnimated:YES];
}

-(void)selectedTableRow:(NSUInteger)rowNum
{
    [popover dismissPopoverAnimated:YES];
    
    //All
    switch (rowNum) {
        case 0:
            //            if ([CommonUtils isLoggedIn]) {
            //                MyProfileViewController *profile_ = [[MyProfileViewController alloc]  initWithNibName:@"MyProfileViewController" bundle:nil];
            //                [self.navigationController pushViewController:profile_ animated:YES];
            //            }
            //            else {
            //                [CommonUtils redirectToLoginScreenWithTarget:self];
            //            }
            
            break;
            
        case 1:
        {
            if ([CommonUtils isLoggedIn]) {
                DashboardViewController *dashBoard = [[DashboardViewController alloc]  initWithNibName:@"DashboardViewController" bundle:nil];
                dashBoard.isLoggoutFromDashBoard = YES;
                [self.navigationController pushViewController:dashBoard animated:YES];
            }
            else {
                [CommonUtils redirectToLoginScreenWithTarget:self];
            }
        }
            
            break;
            
        case 2:
        {
            FindBarViewController *findBar = [[FindBarViewController alloc] initWithNibName:@"FindBarViewController" bundle:nil];
            [self.navigationController pushViewController:findBar animated:YES];
        }
            break;
            
        case 3:
        {
            BeerDirectoryViewController *beer = [[BeerDirectoryViewController alloc]  initWithNibName:@"BeerDirectoryViewController" bundle:nil];
            [self.navigationController pushViewController:beer animated:YES];
        }
            break;
        case 4:
        {
            CocktailDirectoryViewController *cocktail = [[CocktailDirectoryViewController alloc]  initWithNibName:@"CocktailDirectoryViewController" bundle:nil];
            [self.navigationController pushViewController:cocktail animated:YES];
        }
            break;
            
        case 5:
        {
            LiquorDirectoryViewController *liquor = [[LiquorDirectoryViewController alloc]  initWithNibName:@"LiquorDirectoryViewController" bundle:nil];
            [self.navigationController pushViewController:liquor animated:YES];
        }
            break;
            
        case 6:
        {
            TaxiDirectoryViewController *taxi = [[TaxiDirectoryViewController alloc] initWithNibName:@"TaxiDirectoryViewController" bundle:nil];
            [self.navigationController pushViewController:taxi animated:YES];
        }
            break;
            
        case 7:
        {
            PhotoGalleryViewController *photo = nil;
            if ([CommonUtils isiPad]) {
                photo = [[PhotoGalleryViewController alloc]  initWithNibName:@"PhotoGalleryViewController_iPad" bundle:nil];
            }
            else {
                photo = [[PhotoGalleryViewController alloc]  initWithNibName:@"PhotoGalleryViewController" bundle:nil];
            }
            [self.navigationController pushViewController:photo animated:YES];
        }
            break;
        case 8:
        {
            ArticleViewController *article = [[ArticleViewController alloc]  initWithNibName:@"ArticleViewController" bundle:nil];
            [self.navigationController pushViewController:article animated:YES];
        }
            break;
        case 9:
        {
            TriviaStartViewController *trivia = [[TriviaStartViewController alloc]  initWithNibName:@"TriviaStartViewController" bundle:nil];
            [self.navigationController pushViewController:trivia animated:YES];
            break;
        }
        default:
            break;
    }

}


/**************/


#pragma mark - Table View

#pragma mark TableView Datasource and Delegates
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (isWSStatus) {
        return 2;

    }
    else {
        return 0;

    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isWSStatus) {
        return 1;
        
    }
    else {
        return 0;
        
    }
    
}
#pragma mark Cell For Row
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return [self MyProfileImageCellAtIndexPath:indexPath];
            break;
            
        case 1:
            return [self MyProfileInfoCellAtIndexPath:indexPath];
            break;
        default:
        {
            static NSString * Identifier = @"defaultcell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
            if (cell==nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
            }
            return cell;
        }
            break;
    }
}

#pragma mark
#pragma mark MyProfileImageCell Cell Configuration
- (MyProfileImageCell *)MyProfileImageCellAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * const MyProfileImageCellIdentifier = @"MyProfileImageCell";
    
    MyProfileImageCell *cell = (MyProfileImageCell *)[self.tblView dequeueReusableCellWithIdentifier:MyProfileImageCellIdentifier];
    if (cell == nil)
    {
        NSArray *nib;
        if([CommonUtils isiPad])
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"MyProfileImageCell" owner:self options:nil];
        }
        else
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"MyProfileImageCell" owner:self options:nil];
        }
        cell = [nib objectAtIndex:0];
    }
    
    if(didSelectImage == NO)
    {
        NSString *profile_image = [profile profile_profile_image];
        NSString *strImgURL = [[NSString stringWithFormat:@"%@%@%@",WEBIMAGE_URL,USER_PROFILE_IMAGE,profile_image] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSURL *imgURL = [NSURL URLWithString:strImgURL];
        
        [cell.imgUser sd_setImageWithURL:imgURL placeholderImage:[UIImage imageNamed:@"profile-image-placeholder.png"]];
    }
    else
    {
        [cell.imgUser setImage:selectedImage];
    }
    
   
    
    [cell configureCellUI:editProfile];
    [cell.btnEditProfile addTarget:self action:@selector(btnEditProfile_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnSelectImage addTarget:self action:@selector(btnSelectImage_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

-(void)btnEditProfile_Clicked:(UIButton *)btnEditProfile {
    editProfile = !editProfile;
    
    if (editProfile) {
        editProfile = YES;
    }
    else {
        editProfile = NO;
    }
    
    MyProfileInfoCell *cell = (MyProfileInfoCell *)[self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    
    profile.profile_first_name = [(UITextField *)[cell.contentView viewWithTag:101] text];
    profile.profile_last_name = [(UITextField *)[cell.contentView viewWithTag:102] text];
    profile.profile_nick_name = [(UITextField *)[cell.contentView viewWithTag:103] text];
    
    profile.profile_email = [(UITextField *)[cell.contentView viewWithTag:104] text];
    profile.profile_user_city = [(UITextField *)[cell.contentView viewWithTag:105] text];
    profile.profile_user_state = [(UITextField *)[cell.contentView viewWithTag:106] text];
    
    profile.profile_user_zip = [(UITextField *)[cell.contentView viewWithTag:107] text];
    profile.profile_mobile_no = [(UITextField *)[cell.contentView viewWithTag:108] text];
    profile.profile_fb_link = [(UITextField *)[cell.contentView viewWithTag:109] text];
    
    profile.profile_gplus_link = [(UITextField *)[cell.contentView viewWithTag:110] text];
    profile.profile_twitter_link = [(UITextField *)[cell.contentView viewWithTag:111] text];
    profile.profile_linkedin_link = [(UITextField *)[cell.contentView viewWithTag:112] text];
    
    profile.profile_pinterest_link = [(UITextField *)[cell.contentView viewWithTag:113] text];
    profile.profile_instagram_link = [(UITextField *)[cell.contentView viewWithTag:114] text];
    
    profile.profile_about_user = [(UITextView *)[cell.contentView viewWithTag:201] text];
    profile.profile_address = [(UITextView *)[cell.contentView viewWithTag:202] text];

    
    [self.tblView reloadData];
}

-(void)btnSelectImage_Clicked:(UIButton *)btnSelectImage {
    
    MyProfileInfoCell *cell = (MyProfileInfoCell *)[self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    
    profile.profile_first_name = [(UITextField *)[cell.contentView viewWithTag:101] text];
    profile.profile_last_name = [(UITextField *)[cell.contentView viewWithTag:102] text];
    profile.profile_nick_name = [(UITextField *)[cell.contentView viewWithTag:103] text];
    
    profile.profile_email = [(UITextField *)[cell.contentView viewWithTag:104] text];
    profile.profile_user_city = [(UITextField *)[cell.contentView viewWithTag:105] text];
    profile.profile_user_state = [(UITextField *)[cell.contentView viewWithTag:106] text];
    
    profile.profile_user_zip = [(UITextField *)[cell.contentView viewWithTag:107] text];
    profile.profile_mobile_no = [(UITextField *)[cell.contentView viewWithTag:108] text];
    profile.profile_fb_link = [(UITextField *)[cell.contentView viewWithTag:109] text];
    
    profile.profile_gplus_link = [(UITextField *)[cell.contentView viewWithTag:110] text];
    profile.profile_twitter_link = [(UITextField *)[cell.contentView viewWithTag:111] text];
    profile.profile_linkedin_link = [(UITextField *)[cell.contentView viewWithTag:112] text];
    
    profile.profile_pinterest_link = [(UITextField *)[cell.contentView viewWithTag:113] text];
    profile.profile_instagram_link = [(UITextField *)[cell.contentView viewWithTag:114] text];
    
    profile.profile_about_user = [(UITextView *)[cell.contentView viewWithTag:201] text];
    profile.profile_address = [(UITextView *)[cell.contentView viewWithTag:202] text];

    
    //open image picker
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self showImagePicker];
    }];

}

-(void)showImagePicker
{
#if 0
    UzysAppearanceConfig *appearanceConfig = [[UzysAppearanceConfig alloc] init];
    appearanceConfig.finishSelectionButtonColor = [UIColor blueColor];
    appearanceConfig.assetsGroupSelectedImageName = @"checker.png";
    [UzysAssetsPickerController setUpAppearanceConfig:appearanceConfig];
#endif
    
    UzysAssetsPickerController *picker = [[UzysAssetsPickerController alloc] init];
    picker.delegate = self;
    
    picker.maximumNumberOfSelectionVideo = 0;
    picker.maximumNumberOfSelectionPhoto = 1;
    
    [self presentViewController:picker animated:YES completion:^{
    }];
}

#pragma mark
#pragma mark MyProfileInfoCell Cell Configuration
- (MyProfileInfoCell *)MyProfileInfoCellAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * const MyProfileInfoCellIdentifier = @"MyProfileInfoCell";
    
    MyProfileInfoCell *cell = (MyProfileInfoCell *)[self.tblView dequeueReusableCellWithIdentifier:MyProfileInfoCellIdentifier];
    if (cell == nil)
    {
        NSArray *nib;
        if([CommonUtils isiPad])
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"MyProfileInfoCell_iPad" owner:self options:nil];
        }
        else
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"MyProfileInfoCell" owner:self options:nil];
        }
        cell = [nib objectAtIndex:0];
    }
    
    cell.txtFname.text = profile.profile_first_name;
    cell.txtLname.text = profile.profile_last_name;
    cell.txtUsername.text = profile.profile_nick_name;
    cell.txtEmail.text = profile.profile_email;
    cell.txtAboutUser.text = profile.profile_about_user;
    
    cell.txtAddress.text = profile.profile_address;
    cell.txtCity.text = profile.profile_user_city;
    cell.txtState.text = profile.profile_user_state;
    cell.txtZip.text = profile.profile_user_zip;
    cell.txtMobile.text = profile.profile_mobile_no;
    
    cell.txtFbLink.text = profile.profile_fb_link;
    cell.txtGoogleLink.text = profile.profile_gplus_link;
    cell.txtTwitterLink.text = profile.profile_twitter_link;
    cell.txtLinkedInLink.text = profile.profile_linkedin_link;
    cell.txtPinterestLink.text = profile.profile_pinterest_link;
    cell.txtInstagramLink.text = profile.profile_instagram_link;
    
    if ([strGender isEqualToString:@"male"]) {
        [cell.btnMale setImage:[UIImage imageNamed:@"radio-on.png"] forState:UIControlStateNormal];
        [cell.btnFemale setImage:[UIImage imageNamed:@"radio-off.png"] forState:UIControlStateNormal];
    }
    else {
        [cell.btnFemale setImage:[UIImage imageNamed:@"radio-on.png"] forState:UIControlStateNormal];
        [cell.btnMale setImage:[UIImage imageNamed:@"radio-off.png"] forState:UIControlStateNormal];
    }
    
    if (editProfile) {
        [cell configureCellUIWith_Editing];
        [self configureAboutUserTextView:cell withEditable:editProfile];
        [self configureAddressTextView:cell withEditable:editProfile];
        
        [cell.btnMale addTarget:self action:@selector(btnMale_Clicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnFemale addTarget:self action:@selector(btnFemale_Clicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnSave addTarget:self action:@selector(btnSave_Clicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnCancel addTarget:self action:@selector(btnCancel_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    else {
        [cell configureCellUIWith_NoEditing];
        [self configureAboutUserTextView:cell withEditable:editProfile];
        [self configureAddressTextView:cell withEditable:editProfile];

    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

-(void)btnMale_Clicked:(UIButton *)btnMale {
    if (editProfile) {
        strGender = @"male";
    }
    profile.profile_gender = strGender;
    [self.tblView reloadData];
}
-(void)btnFemale_Clicked:(UIButton *)btnFemale {
    if (editProfile) {
        strGender = @"female";
    }
    profile.profile_gender = strGender;
    [self.tblView reloadData];
}

-(void)btnSave_Clicked:(UIButton *)btnSave {
    [self.view endEditing:YES];
    
    MyProfileInfoCell *cell = (MyProfileInfoCell *)[self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    
    profile.profile_first_name = [(UITextField *)[cell.contentView viewWithTag:101] text];
    profile.profile_last_name = [(UITextField *)[cell.contentView viewWithTag:102] text];
    profile.profile_nick_name = [(UITextField *)[cell.contentView viewWithTag:103] text];

    profile.profile_email = [(UITextField *)[cell.contentView viewWithTag:104] text];
    profile.profile_user_city = [(UITextField *)[cell.contentView viewWithTag:105] text];
    profile.profile_user_state = [(UITextField *)[cell.contentView viewWithTag:106] text];
    
    profile.profile_user_zip = [(UITextField *)[cell.contentView viewWithTag:107] text];
    profile.profile_mobile_no = [(UITextField *)[cell.contentView viewWithTag:108] text];
    profile.profile_fb_link = [(UITextField *)[cell.contentView viewWithTag:109] text];
    
    profile.profile_gplus_link = [(UITextField *)[cell.contentView viewWithTag:110] text];
    profile.profile_twitter_link = [(UITextField *)[cell.contentView viewWithTag:111] text];
    profile.profile_linkedin_link = [(UITextField *)[cell.contentView viewWithTag:112] text];
    
    profile.profile_pinterest_link = [(UITextField *)[cell.contentView viewWithTag:113] text];
    profile.profile_instagram_link = [(UITextField *)[cell.contentView viewWithTag:114] text];

    profile.profile_about_user = [(UITextView *)[cell.contentView viewWithTag:201] text];
    profile.profile_address = [(UITextView *)[cell.contentView viewWithTag:202] text];
    
    BOOL isValidEmail = [CommonUtils IsValidEmail:profile.profile_email];
    
    if ([profile.profile_first_name isEqualToString:@""] || [profile.profile_last_name isEqualToString:@""] || [profile.profile_nick_name isEqualToString:@""] ||[profile.profile_gender isEqualToString:@""] || [profile.profile_email isEqualToString:@""] || [profile.profile_about_user isEqualToString:@""]) {
        
        if([profile.profile_first_name isEqualToString:@""])
        {
            ShowAlert(AlertTitle, @"Please enter First name.");
        }
        else if([profile.profile_last_name isEqualToString:@""])
            {
                ShowAlert(AlertTitle, @"Please enter Last name.");
            }
        else if ([profile.profile_nick_name isEqualToString:@""])
            {
                ShowAlert(AlertTitle, @"Please enter your username or nick name.");
            }
        else if ([profile.profile_gender isEqualToString:@""])
        {
            ShowAlert(AlertTitle, @"Please select gender.");
        }
        else if ([profile.profile_email isEqualToString:@""])
        {
            ShowAlert(AlertTitle, @"Please enter email address.");
        }
        else
            {
                ShowAlert(AlertTitle, @"Please mention about user.");
            }
        
    }
    else if (!isValidEmail)
    {
        ShowAlert(AlertTitle, @"Please enter a valid email address.");
    }
    else {
        [self callUserEditByIdWebservice];
    }
    
}

// Manali ma'm e kidhu hatu
-(void)btnCancel_Clicked:(UIButton *)btnCancel {
    
    if (self.isMyProfileFromMenu)
    {
        self.isMyProfileFromMenu = NO;
        [[self delegate] removeMyProfile];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }

    
    
    //    MyProfileInfoCell *cell = (MyProfileInfoCell *)[self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    //    
    //    profile.profile_first_name = [(UITextField *)[cell.contentView viewWithTag:101] text];
    //    profile.profile_last_name = [(UITextField *)[cell.contentView viewWithTag:102] text];
    //    profile.profile_nick_name = [(UITextField *)[cell.contentView viewWithTag:103] text];
    //    
    //    profile.profile_email = [(UITextField *)[cell.contentView viewWithTag:104] text];
    //    profile.profile_user_city = [(UITextField *)[cell.contentView viewWithTag:105] text];
    //    profile.profile_user_state = [(UITextField *)[cell.contentView viewWithTag:106] text];
    //    
    //    profile.profile_user_zip = [(UITextField *)[cell.contentView viewWithTag:107] text];
    //    profile.profile_mobile_no = [(UITextField *)[cell.contentView viewWithTag:108] text];
    //    profile.profile_fb_link = [(UITextField *)[cell.contentView viewWithTag:109] text];
    //    
    //    profile.profile_gplus_link = [(UITextField *)[cell.contentView viewWithTag:110] text];
    //    profile.profile_twitter_link = [(UITextField *)[cell.contentView viewWithTag:111] text];
    //    profile.profile_linkedin_link = [(UITextField *)[cell.contentView viewWithTag:112] text];
    //    
    //    profile.profile_pinterest_link = [(UITextField *)[cell.contentView viewWithTag:113] text];
    //    profile.profile_instagram_link = [(UITextField *)[cell.contentView viewWithTag:114] text];
    //    
    //    profile.profile_about_user = [(UITextView *)[cell.contentView viewWithTag:201] text];
    //    profile.profile_address = [(UITextView *)[cell.contentView viewWithTag:202] text];
    //    [self.tblView reloadData];

}
#pragma mark Height For Row

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
            //MyProfileImageCell
        case 0:
        {
            return 126;
        }
            break;
            
            //MyProfileInfoCell
        case 1:
        {
            if([CommonUtils isiPad])
            {
                return 972;
            }
            else
            {
                return 1060;
            }
        }
            break;
            
        default:
        {
            return 0;
        }
            break;
    }
}


#pragma mark - Show More View
-(void)hideShowMoreView {
    self.viewShowMore.alpha = 1.0;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.viewShowMore.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.viewShowMore setHidden:YES];
    }];
}

-(void)displayShowMoreView {
    [self.viewShowMore setHidden:NO];
    self.viewShowMore.alpha = 0.0;
    [UIView animateWithDuration:0.3 animations:^{
        self.viewShowMore.alpha = 1.0;
        ShowMoreView *showMoreView = (ShowMoreView *)[[self.viewShowMore subviews] objectAtIndex:0];
        [showMoreView reloadShowMoreTable:@[@"Hello"]];
        [self.viewShowMore setHidden:NO];
        
    } completion:^(BOOL finished) {
    }];
}

-(void)configureShowMoreView {
    
    [self.viewShowMore setHidden:NO];
    id view = [[[NSBundle mainBundle] loadNibNamed:@"ShowMoreView" owner:self options:nil] objectAtIndex:0];
    ShowMoreView *showMoreView = (ShowMoreView *)view;
    [showMoreView configureShowMoreView];
    showMoreView.delegate = self;
    [self.viewShowMore addSubview:showMoreView];
    [self.view layoutIfNeeded];
}

-(void)dismissShowMoreView {
    [self hideShowMoreView];
}

#pragma mark - TextField

#pragma mark Textfield Delegates
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField.tag == 101) {
       profile.profile_first_name  = textField.text;
    }
    
    else if (textField.tag == 102) {
       profile.profile_last_name  = textField.text;
    }
    
    else if (textField.tag == 103) {
         profile.profile_nick_name = textField.text;
    }
    if (textField.tag == 104) {
      profile.profile_email  = textField.text;
    }
    
    else if (textField.tag == 105) {
      profile.profile_user_city  = textField.text;
    }
    
    else if (textField.tag == 106) {
       profile.profile_user_state  = textField.text;
    }
    if (textField.tag == 107) {
       profile.profile_user_zip  = textField.text;
    }
    
    else if (textField.tag == 108) {
       profile.profile_mobile_no  = textField.text;
    }
    
    else if (textField.tag == 109) {
       profile.profile_fb_link = textField.text;
    }
    
    if (textField.tag == 110) {
       profile.profile_gplus_link = textField.text;
    }
    
    else if (textField.tag == 111) {
       profile.profile_twitter_link = textField.text;
    }
    
    else if (textField.tag == 112) {
       profile.profile_linkedin_link = textField.text;
    }
    else if (textField.tag == 113) {
       profile.profile_pinterest_link = textField.text;
    }
    
    else if (textField.tag == 114) {
       profile.profile_instagram_link = textField.text;
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField.tag == 108)
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



#pragma mark - TEXT VIEW
-(void)configureAboutUserTextView:(MyProfileInfoCell *)cell withEditable:(BOOL)isEditable
{
    
    showingAboutUserPlaceholder = YES;
    if ([profile.profile_about_user length]==0)
    {
        [cell.txtAboutUser setText:kAboutUserPlaceholderText];
        [cell.txtAboutUser setTextColor:[UIColor colorWithRed:146.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0]];
    }
    else
    {
        [cell.txtAboutUser setText:profile.profile_about_user];
        if (isEditable) {
            [cell.txtAboutUser setTextColor:[UIColor whiteColor]];
        }
        else {
            [cell.txtAboutUser setTextColor:[UIColor colorWithRed:146.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0]];
        }
        showingAboutUserPlaceholder = NO;
    }
}

-(void)configureAddressTextView:(MyProfileInfoCell *)cell withEditable:(BOOL)isEditable
{
    
    showingAddressPlaceholder = YES;
    if ([profile.profile_address length]==0)
    {
        [cell.txtAddress setText:kAddressPlaceholderText];
        [cell.txtAddress setTextColor:[UIColor colorWithRed:146.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0]];
    }
    else
    {
        [cell.txtAddress setText:profile.profile_address];
        if (isEditable) {
            [cell.txtAddress setTextColor:[UIColor whiteColor]];
        }
        else {
            [cell.txtAddress setTextColor:[UIColor colorWithRed:146.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0]];
        }
        
        showingAddressPlaceholder = NO;
    }
}


#pragma mark UITextView Delegate Methods
-(void)textViewDidBeginEditing:(UITextView *)textView {
    
    if (textView.tag == 201) {
        // Check if it's showing a placeholder, remove it if so
        if(showingAboutUserPlaceholder) {
            [textView setText:@""];
            [textView setTextColor:[UIColor whiteColor]];
            
            showingAboutUserPlaceholder = NO;
        }
    }
    else {
        // Check if it's showing a placeholder, remove it if so
        if(showingAddressPlaceholder) {
            [textView setText:@""];
            [textView setTextColor:[UIColor whiteColor]];
            
            showingAddressPlaceholder = NO;
        }
    }
    
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.tag == 201) {
        // Check the length and if it should add a placeholder
        if([[textView text] length] == 0 && !showingAboutUserPlaceholder) {
            [textView setText:kAboutUserPlaceholderText];
            [textView setTextColor:[UIColor colorWithRed:146.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0]];
            
            showingAboutUserPlaceholder = YES;
        }
        else
        {
            NSLog(@"%@",textView.text);
            profile.profile_about_user = textView.text;
        }
    }
    else {
        // Check the length and if it should add a placeholder
        if([[textView text] length] == 0 && !showingAddressPlaceholder) {
            [textView setText:kAddressPlaceholderText];
            [textView setTextColor:[UIColor colorWithRed:146.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0]];
            
            showingAddressPlaceholder = YES;
        }
        else
        {
            NSLog(@"%@",textView.text);
            profile.profile_address = textView.text;
        }
    }
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
       return YES ;
}


#pragma mark - UzysAssetsPickerControllerDelegate methods
- (void)UzysAssetsPickerController:(UzysAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    //self.imageView.backgroundColor = [UIColor clearColor];
    DLog(@"assets %@",assets);
    if(assets.count ==1)
    {
        //self.labelDescription.text = [NSString stringWithFormat:@"%ld asset selected",(unsigned long)assets.count];
    }
    else
    {
        //self.labelDescription.text = [NSString stringWithFormat:@"%ld assets selected",(unsigned long)assets.count];
    }
    
    for (ALAsset *alAsset in assets) {
        if([[alAsset valueForProperty:@"ALAssetPropertyType"] isEqualToString:@"ALAssetTypePhoto"]) //Photo
        {
            selectedImage = [UIImage imageWithCGImage:alAsset.defaultRepresentation.fullResolutionImage
                                               scale:alAsset.defaultRepresentation.scale
                                         orientation:(UIImageOrientation)alAsset.defaultRepresentation.orientation];
            NSLog(@"%@",[[alAsset defaultRepresentation] filename]);
            
            NSDictionary *dictImage = @{@"name":[[alAsset defaultRepresentation] filename],@"image":selectedImage,@"type":@"image",@"filepath":@"",@"doc_id":@""};
            [self.aryImages addObject:dictImage];
            
            NSLog(@"Before Delete Media = %@",dictImage);
            
        }
    }
    didSelectImage = YES;
    
    [self.tblView reloadData];
}

- (void)UzysAssetsPickerControllerDidExceedMaximumNumberOfSelection:(UzysAssetsPickerController *)picker
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:NSLocalizedStringFromTable(@"Exceed Maximum Number Of Selection", @"UzysAssetsPickerController", nil)
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark - Orientation
-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [self setStatusBarVisibility];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
         
         switch (orientation) {
             case UIInterfaceOrientationPortrait:
             case UIInterfaceOrientationPortraitUpsideDown:
                 if (![CommonUtils isiPad]) {
                     
                     
                     if ([CommonUtils isIPhone4]) {
                     }
                     else if ([CommonUtils isIPhone5]) {
                     }
                     else if ([CommonUtils isIPhone6]) {
                     }
                     else {
                     }
                     
                     
                 }
                 else {
                 }
                 
                 
                 break;
                 
             case UIInterfaceOrientationLandscapeLeft:
             case UIInterfaceOrientationLandscapeRight:
                 if (![CommonUtils isiPad]) {
                     
                     if ([CommonUtils isIPhone4_Landscape]) {
                     }
                     else if ([CommonUtils isIPhone5_Landscape]) {
                     }
                     else if ([CommonUtils isIPhone6_Landscape]) {
                     }
                     else {
                         self.navigationController.navigationBar.frame = CGRectMake(0,32, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height+20);
                         
                     }
                 }
                 else {
                 }
                 break;
                 
             default:
                 break;
         }
         // do whatever
     } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         
     }];
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

#pragma mark - Webservice Call
-(void)callGetUserDashboardByIdWebservice {
    [CommonUtils callWebservice:@selector(getuserdashboard) forTarget:self];
}

-(void)callUserEditByIdWebservice {
    [CommonUtils callWebservice:@selector(editinfo) forTarget:self];
}

#pragma mark - Webservice
#pragma mark getuserdashboard
-(void)getuserdashboard
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.mode = MBProgressHUDModeIndeterminate;
    
    User *user = [CommonUtils getUserLoginDetails];
    NSString *user_id = [user user_id];
    NSString *device_id = [user device_id];
    NSString *unique_code =[user unique_code];
    
    //192.168.1.27/ADB/api/get_gallery_by_id
    NSString *myURL = [NSString stringWithFormat:@"%@getuserdashboard",WEBSERVICE_URL];
    NSMutableURLRequest *Request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: myURL]];
    //NSString *params = [NSString stringWithFormat:@"user_id=%@&limit=%ld&offset=%ld&bar_id=%@",user_id,(long)limit,(long)offset,self.bar.bar_id];
    NSString *params = [NSString stringWithFormat:@"user_id=%@&device_id=%@&unique_code=%@",user_id,device_id,unique_code];
    
    [Request setHTTPMethod:@"POST"];
    [Request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    [NSURLConnection sendAsynchronousRequest:Request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (connectionError == nil) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            NSString *stringResponse = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"Response : %@",stringResponse);
            if (data == nil)
            {
                ShowAlert(AlertTitle, MSG_SERVER_NOT_REACHABLE);
                return;
            }
            
            NSError *jsonParsingError = nil;
            NSDictionary *tempDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
            NSLog(@"Dict : %@",tempDict);
            
            if ([[tempDict valueForKey:@"status"] isEqualToString:@"success"]) {
                isWSStatus = YES;
                didSelectImage = NO;
                profile = [UserProfile getUserProfileWithDictionary:[tempDict valueForKey:@"getalldata"]];
                strGender = profile.profile_gender;
            }
        }
        else {
            
        }
        
        [self.tblView reloadData];
        
    }];
    
}

#pragma mark user_edit
-(void)editinfo
{
    User *user = [CommonUtils getUserLoginDetails];
    NSString *user_id = [user user_id];
    NSString *device_id = [user device_id];
    NSString *unique_code =[user unique_code];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.mode = MBProgressHUDModeIndeterminate;
    
    //192.168.1.27/ADB/api/editinfo
    NSString *urlString = [NSString stringWithFormat:@"%@editinfo",WEBSERVICE_URL];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    for (int i=0; i<[self.aryImages count]; i++)
    {
        NSString *mediaType = [[self.aryImages objectAtIndex:i] valueForKey:@"type"];
        
        if ([mediaType isEqualToString:@"image"])
        {
            UIImage* image = [[self.aryImages objectAtIndex:i] valueForKey:@"image"];
            NSData *imgData = UIImageJPEGRepresentation(image, 0.1);
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: multipart/form-data; name=\"file_up\"; filename=\"image_%@\"\r\n",[[self.aryImages objectAtIndex:i] valueForKey:@"name"]] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: multipart/form-data\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:imgData];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    
    //user_id
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"user_id"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n",user_id] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //device_id
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"device_id"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n",device_id] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //unique_code
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"unique_code"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n",unique_code] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //first_name
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"first_name"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n",profile.profile_first_name] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //nick_name
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"nick_name"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n",profile.profile_nick_name] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //last_name
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"last_name"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n",profile.profile_last_name] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //address
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"address"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n",profile.profile_address] dataUsingEncoding:NSUTF8StringEncoding]];

    //email
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"email"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n",profile.profile_email] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //about_user
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"about_user"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n",profile.profile_about_user] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //user_city
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"user_city"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n",profile.profile_user_city] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //user_state
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"user_state"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n",profile.profile_user_state] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //user_zip
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"user_zip"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n",profile.profile_user_zip] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //fb_link
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"fb_link"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n",profile.profile_fb_link] dataUsingEncoding:NSUTF8StringEncoding]];

    //gplus_link
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"gplus_link"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n",profile.profile_gplus_link] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //twitter_link
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"twitter_link"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n",profile.profile_twitter_link] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //linkedin_link
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"linkedin_link"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n",profile.profile_linkedin_link] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //pinterest_link
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"pinterest_link"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n",profile.profile_pinterest_link] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //instagram_link
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"instagram_link"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n",profile.profile_instagram_link] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //mobile_no
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"mobile_no"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n",profile.profile_mobile_no] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //pre_profile_image
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"pre_profile_image"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n",profile.pre_profile_image] dataUsingEncoding:NSUTF8StringEncoding]];

    //gender
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"gender"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n",profile.profile_gender] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (connectionError == nil) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            NSString *stringResponse = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"Response : %@",stringResponse);
            if (data == nil)
            {
                ShowAlert(AlertTitle, MSG_SERVER_NOT_REACHABLE);
                return;
            }
            
            NSError *jsonParsingError = nil;
            NSDictionary *tempDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
            NSLog(@"Dict : %@",tempDict);
            
            if ([[tempDict valueForKey:@"status"] isEqualToString:@"success"]) {
//                profile = [UserProfile getUserProfileWithDictionary:[tempDict valueForKey:@"getalldata"]];
//                strGender = profile.profile_gender;
                
                NSString *fullname = [self getFullNameFromFirstName:profile.profile_first_name andLastName:profile.profile_last_name];
                [[NSUserDefaults standardUserDefaults] setValue:fullname forKey:@"user_name"];
                NSString *imagename = [CommonUtils getNotNullString:[[tempDict valueForKey:@"res"] valueForKey:@"imagename"]] ;
                [[NSUserDefaults standardUserDefaults] setValue:imagename forKey:@"user_image"];
                [[NSUserDefaults standardUserDefaults] setValue:profile.profile_email forKey:@"storedEmail"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                ShowAlert(AlertTitle, @"Profile details are updated successfully!");
            }
        }
        else {
        }
        [self.tblView reloadData];
    }];
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
        fullName = @"User";
    }
    return fullName;
    
}

@end
