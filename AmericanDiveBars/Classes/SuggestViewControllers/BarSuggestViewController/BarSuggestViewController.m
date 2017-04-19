//
//  BarSuggestViewController.m
//  AmericanDiveBars
//
//  Created by spaculus on 4/11/16.
//  Copyright © 2016 spaculus. All rights reserved.
//

#import "BarSuggestViewController.h"
#import "BarSuggestCell.h"

static NSString * const kTextViewPlaceholderText = @"Address";

@interface BarSuggestViewController ()<MBProgressHUDDelegate,UzysAssetsPickerControllerDelegate,FPPopoverControllerDelegate>
{
    MBProgressHUD *HUD;
    
    //POPOVER
    FPPopoverController *popover;
    
    //UZYIMAGE
    BOOL didSelectImage;
    UIImage *selectedImage;
    
    //Textview placeholder
    BOOL showingTextViewPlaceholder;
    
    NSString *barName;
    NSString *street;
    NSString *city;
    NSString *state;
    NSString *phone;
    NSString *zip;
    
}
@property (strong, nonatomic) NSMutableArray *aryImages;

//Main Table
@property (strong, nonatomic) IBOutlet UITableView *tblView;


@end

@implementation BarSuggestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [CommonUtils setTitleLabel:@"BEER SUGGEST"];
    [self configureTopButtons];
    [self setInitialData];
}

-(void)setInitialData {
    
    didSelectImage = NO;
    
    self.aryImages = [[NSMutableArray alloc] init];
    
    barName = @"";
    street = @"";
    city = @"";
    state = @"";
    phone = @"";
    zip = @"";
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
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    // FindBarViewController *findBar = [[FindBarViewController alloc] initWithNibName:@"FindBarViewController" bundle:nil];
    // [self.navigationController pushViewController:findBar animated:YES];
}


-(void)openRightMenu_Clicked:(UIButton *)btnRightMenu {
    [self.view endEditing:YES];
    
    [self btnFilterClicked:btnRightMenu];
}

-(void)btnFilterClicked:(id)sender
{
    LeftMenu_Popup *controller = [[LeftMenu_Popup alloc] initWithStyle:UITableViewStylePlain];
    controller.suggestBarDelegate = self;
    
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
            if ([CommonUtils isLoggedIn]) {
                MyProfileViewController *profile_ = [[MyProfileViewController alloc]  initWithNibName:@"MyProfileViewController" bundle:nil];
                [self.navigationController pushViewController:profile_ animated:YES];
            }
            else {
                [CommonUtils redirectToLoginScreenWithTarget:self];
            }
            
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

#pragma mark - Table View

#pragma mark TableView Datasource and Delegates
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
#pragma mark Cell For Row
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self BarSuggestCellAtIndexPath:indexPath];
}

#pragma mark
#pragma mark BarSuggestCell Cell Configuration
- (BarSuggestCell *)BarSuggestCellAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * const BarSuggestCellIdentifier = @"BarSuggestCell";
    
    BarSuggestCell *cell = (BarSuggestCell *)[self.tblView dequeueReusableCellWithIdentifier:BarSuggestCellIdentifier];
    if (cell == nil)
    {
        NSArray *nib;
        if([CommonUtils isiPad])
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"BarSuggestCell-ipad" owner:self options:nil];
        }
        else
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"BarSuggestCell" owner:self options:nil];
        }
        cell = [nib objectAtIndex:0];
    }
    
    cell.txtBarName.text = barName;
    cell.txtStreet.text = street;
    cell.txtCity.text = city;
    cell.txtState.text = state;
    
    cell.txtPhone.text = phone;
    cell.txtZip.text = zip;
    
    [cell.btnSave addTarget:self action:@selector(btnSave_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnCancel addTarget:self action:@selector(btnCancel_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self configureTextView:cell withEditable:NO];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}
-(void)btnSave_Clicked:(UIButton *)btnSave {
    [self.view endEditing:YES];
    
    BarSuggestCell *cell = (BarSuggestCell *)[self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    
    if ([barName length]==0) {
        ShowAlert(AlertTitle, @"Please provide the bar name.");
        cell.txtBarName.layer.borderColor = [UIColor redColor].CGColor;
        cell.txtBarName.layer.borderWidth = 0.8f;
        
    }
    else if ([street length] == 0) {
        cell.txtStreet.layer.borderColor = [UIColor redColor].CGColor;
        cell.txtStreet.layer.borderWidth = 0.8f;
        
        ShowAlert(AlertTitle, @"Please provide the address.");
    }
    else if ([city length] == 0) {
        cell.txtCity.layer.borderColor = [UIColor redColor].CGColor;
        cell.txtCity.layer.borderWidth = 0.8f;
        
        ShowAlert(AlertTitle, @"Please provide the city name.");
    }
    else if ([state length] == 0) {
        cell.txtState.layer.borderColor = [UIColor redColor].CGColor;
        cell.txtState.layer.borderWidth = 0.8f;
        
        ShowAlert(AlertTitle, @"Please provide the state name.");
    }
    else if ([phone length] == 0) {
        cell.txtPhone.layer.borderColor = [UIColor redColor].CGColor;
        cell.txtPhone.layer.borderWidth = 0.8f;
        
        ShowAlert(AlertTitle, @"Please provide the phone number.");
    }
    else if ([zip length] == 0) {
        cell.txtZip.layer.borderColor = [UIColor redColor].CGColor;
        cell.txtZip.layer.borderWidth = 0.8f;
        
        ShowAlert(AlertTitle, @"Please provide the zip code.");
    }
    else {
        cell.txtBarName.layer.borderColor = [[UIColor colorWithRed:146.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0] CGColor];
        cell.txtBarName.layer.borderWidth = 0.8f;
        
        cell.txtStreet.layer.borderColor = [[UIColor colorWithRed:146.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0] CGColor];
        cell.txtStreet.layer.borderWidth = 0.8f;
        
        cell.txtCity.layer.borderColor = [[UIColor colorWithRed:146.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0] CGColor];
        cell.txtCity.layer.borderWidth = 0.8f;
        
        cell.txtState.layer.borderColor = [[UIColor colorWithRed:146.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0] CGColor];
        cell.txtState.layer.borderWidth = 0.8f;
        
        cell.txtPhone.layer.borderColor = [[UIColor colorWithRed:146.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0] CGColor];
        cell.txtPhone.layer.borderWidth = 0.8f;
        
        cell.txtZip.layer.borderColor = [[UIColor colorWithRed:146.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0] CGColor];
        cell.txtZip.layer.borderWidth = 0.8f;
        
        [self callSuggestBarWebservice];
        //#warning suggest web service call;
    }
    
    /*BOOL isValidEmail = [CommonUtils IsValidEmail:profile.profile_email];
     if ([profile.profile_first_name isEqualToString:@""] || [profile.profile_last_name isEqualToString:@""] || [profile.profile_nick_name isEqualToString:@""] ||[profile.profile_gender isEqualToString:@""] || [profile.profile_email isEqualToString:@""] || [profile.profile_about_user isEqualToString:@""]) {
     
     if([profile.profile_first_name isEqualToString:@""])
     {
     ShowAlert(AlertTitle, @"Please");
     }
     else if([profile.profile_last_name isEqualToString:@""])
     {
     }
     else if ([profile.profile_nick_name isEqualToString:@""])
     {
     }
     else if ([profile.profile_gender isEqualToString:@""])
     {
     }
     else if ([profile.profile_email isEqualToString:@""])
     {
     }
     else
     {
     }
     
     }
     else if (!isValidEmail)
     {
     }
     else {
     }*/
}


// Manali ma'm e kidhu hatu
-(void)btnCancel_Clicked:(UIButton *)btnCancel {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)btnSelectedImage_Clicked:(UIButton *)btnSelectedImage {
    //open image picker
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self showImagePicker];
    }];
}

#pragma mark Height For Row

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 594;
}




#pragma mark Textfield Delegates
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField.tag == 104)
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



- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField.tag == 101) {
        barName = textField.text;
    }
    
    else if (textField.tag == 102) {
        city = textField.text;
    }
    
    else if (textField.tag == 103) {
        state = textField.text;
    }
    if (textField.tag == 104) {
        phone = textField.text;
    }
    
    else if (textField.tag == 105) {
        zip = textField.text;
    }
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - TEXT VIEW
-(void)configureTextView:(BarSuggestCell *)cell withEditable:(BOOL)isEditable
{
    
    showingTextViewPlaceholder = YES;
    if ([street length]==0)
    {
        [cell.txtStreet setText:kTextViewPlaceholderText];
        [cell.txtStreet setTextColor:[UIColor colorWithRed:146.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0]];
    }
    else
    {
        [cell.txtStreet setText:street];
        if (isEditable) {
            [cell.txtStreet setTextColor:[UIColor whiteColor]];
        }
        else {
            [cell.txtStreet setTextColor:[UIColor whiteColor]];
        }
        showingTextViewPlaceholder = NO;
    }
}




/*
 -(void)configureAddressTextView:(MyProfileInfoCell *)cell withEditable:(BOOL)isEditable
 {
 
 showingAddressPlaceholder = YES;
 if ([profile.profile_address length]==0)
 {
 [cell.txtAddress setText:kd];
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
 */

#pragma mark UITextView Delegate Methods
-(void)textViewDidBeginEditing:(UITextView *)textView {
    
    if (textView.tag == 201) {
        // Check if it's showing a placeholder, remove it if so
        if(showingTextViewPlaceholder) {
            [textView setText:@""];
            [textView setTextColor:[UIColor colorWithRed:146.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0]];
            
            showingTextViewPlaceholder = NO;
        }
    }
    else {
        // Check if it's showing a placeholder, remove it if so
        if(showingTextViewPlaceholder) {
            [textView setText:@""];
            [textView setTextColor:[UIColor colorWithRed:146.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0]];
            
            showingTextViewPlaceholder = NO;
        }
    }
    
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.tag == 201) {
        // Check the length and if it should add a placeholder
        if([[textView text] length] == 0 && !showingTextViewPlaceholder) {
            [textView setText:kTextViewPlaceholderText];
            [textView setTextColor:[UIColor colorWithRed:146.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0]];
            
            showingTextViewPlaceholder = YES;
        }
        else
        {
            NSLog(@"%@",textView.text);
            street = textView.text;
        }
    }
    else {
        // Check the length and if it should add a placeholder
        if([[textView text] length] == 0 && !showingTextViewPlaceholder) {
            [textView setText:kTextViewPlaceholderText];
            [textView setTextColor:[UIColor colorWithRed:146.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0]];
            
            showingTextViewPlaceholder = YES;
        }
        else
        {
            NSLog(@"%@",textView.text);
            street = textView.text;
        }
    }
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES ;
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

#pragma mark - Web service call
-(void)callSuggestBarWebservice {
    [CommonUtils callWebservice:@selector(suggest_bar) forTarget:self];
}

#pragma mark suggest_bar
-(void)suggest_bar
{
    
    User *user = [CommonUtils getUserLoginDetails];
    NSString *user_id = [user user_id];
    NSString *device_id = [user device_id];
    NSString *unique_code =[user unique_code];
    
    //192.168.1.27/ADB/api/bar_lists
    NSString *myURL = [NSString stringWithFormat:@"%@suggest_bar",WEBSERVICE_URL];
    NSMutableURLRequest *Request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: myURL]];
    
    // NSString *params = [NSString stringWithFormat:@"limit=%ld&offset=%ld&state=%@&city=%@&zipcode=%@&title=%@",(long)limit,(long)offset,state,city,zip,name];
    
    NSString *params = [NSString stringWithFormat:@"user_id=%@&device_id=%@&unique_code=%@&bar_name=%@&address=%@&city=%@&state=%@&phone_number=%@&zip_code=%@",user_id,device_id,unique_code,barName,street,city,state,phone,zip];
    
    [Request setHTTPMethod:@"POST"];
    [Request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    [NSURLConnection sendAsynchronousRequest:Request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (connectionError == nil) {
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
            
            NSString *status = [CommonUtils getNotNullString:[tempDict valueForKey:@"status"]];
            
            if ([status isEqualToString:@"success"]) {
                
                [self.navigationController popViewControllerAnimated:YES];
                ShowAlert(AlertTitle, @"Your bar suggestion sent successfully.\nPlease wait for admin approval.");
                
            }
            else {
                ShowAlert(AlertTitle, @"Your bar suggestion is not sent.\nPlease try again.");
            }
        }
        else {
            
        }
        
    }];
    
}

@end
