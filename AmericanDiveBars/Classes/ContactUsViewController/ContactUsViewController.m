//
//  ContactUsViewController.m
//  AmericanDiveBars
//
//  Created by spaculus on 10/21/15.
//  Copyright © 2015 spaculus. All rights reserved.
//

#import "ContactUsViewController.h"
#import "MapViewController.h"
#import "ContactUsCells.h"
#import "BarDetailCell.h"



static NSString * const kPlaceholderText = @"Type Your Query Here...";

@interface ContactUsViewController () <MBProgressHUDDelegate,FPPopoverControllerDelegate,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
{
    MBProgressHUD *HUD;
    
    //POPOVER
    FPPopoverController *popover;
    
    //LOAD MORE
    NSInteger offset;
    NSInteger limit;
    
    BOOL isWSStatus;
    
    // Get In Touch
    BOOL showingPlaceholder;
    NSString *nameForContactUS;
    NSString *emailForContactUS;
    NSString *subjectForContactUS;
    NSString *commentForContactUS;
    
    ContactUS *contactToUS;

}

//Main Table
@property (strong, nonatomic) IBOutlet TPKeyboardAvoidingTableView *tblView;
@property (strong, nonatomic) NSMutableArray *aryList;


@end

@implementation ContactUsViewController

-(void)awakeFromNib {
    [super awakeFromNib];

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [CommonUtils setTitleLabel:@"CONTACT US"];
    [self configureTopButtons];
    [self setInitialData];
    [self callgetContactUsInfoWebservice];
    
}

-(void)setInitialData {
    nameForContactUS = @"";
    emailForContactUS = @"";
    subjectForContactUS = @"";
    commentForContactUS = @"";
    
    isWSStatus = NO;
    
    limit = 3;
    offset = 0;
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
    [self setStatusBarVisibility];
    self.navigationController.navigationBar.topItem.title = @" ";
    CGSize blankImageSize = CGSizeMake(self.view.bounds.size.width, 64);
    UIImage *blank = [CommonUtils imageFromColor:[UIColor colorWithRed:187.0/255.0 green:124.0/255.0 blue:37.0/255.0 alpha:1.0] forSize:blankImageSize withCornerRadius:0.0];
    [CommonUtils setNavigationBarImage:blank forNavigationBar:self.navigationController.navigationBar];
    
    [self registerCell];
    [self.tblView reloadData];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HomeScreen" object:nil];
    // [self.navigationController popToRootViewControllerAnimated:YES];
    // FindBarViewController *findBar = [[FindBarViewController alloc] initWithNibName:@"FindBarViewController" bundle:nil];
    // [self.navigationController pushViewController:findBar animated:YES];
}

-(void)openRightMenu_Clicked:(UIButton *)btnRightMenu {
    [self btnFilterClicked:btnRightMenu];
}

-(void)btnFilterClicked:(id)sender
{
    LeftMenu_Popup *controller = [[LeftMenu_Popup alloc] initWithStyle:UITableViewStylePlain];
    controller.contactUsDelegate = self;
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
                MyProfileViewController *profile = [[MyProfileViewController alloc]  initWithNibName:@"MyProfileViewController" bundle:nil];
                [self.navigationController pushViewController:profile animated:YES];
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


/**************/
#pragma mark - Table View
-(void)registerCell
{
    [self.tblView registerNib:[UINib nibWithNibName:Nib_ContactUsCell bundle:nil] forCellReuseIdentifier:ContactUsCellIdentifier];
    [self.tblView registerNib:[UINib nibWithNibName:Nib_ContactUsDescriptionCell bundle:nil] forCellReuseIdentifier:ContactUsDescriptionCellIdentifier];
}

#pragma mark TableView Datasource and Delegates
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (isWSStatus) {
        return 4;
    }
    else {
        return 0;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        
        return 1;//[CommonUtils getArrayCountFromArray:[fullMugBar aryBarHours]];
    }
    if (section == 1) {
        return 4;//[CommonUtils getArrayCountFromArray:[fullMugBar aryBarEvents]];
    }
    if (section == 2) {
        return 1;//[CommonUtils getArrayCountFromArray:[fullMugBar aryBeerSeved]];
    }
    if (section == 3) {
        return 1;
    }
    
    return 1;
}



#pragma mark Cell For Row
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return [self ContactUsDescriptionCellAtIndexPath:indexPath];
            break;
        case 1:
            return [self ContactUsCellAtIndexPath:indexPath];
            break;
        case 2:
            return [self TItleCellAtIndexPath:indexPath];
            break;
        case 3:
            return [self ContactUsFormCellAtIndexPath:indexPath];
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
#pragma mark TItleCell Cell Configuration
- (TItleCell *)TItleCellAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"TItleCell";
    
    TItleCell *cell = (TItleCell *)[self.tblView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib;
        if([CommonUtils isiPad])
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"TItleCell" owner:self options:nil];
        }
        else
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"TItleCell" owner:self options:nil];
        }
        cell = [nib objectAtIndex:0];
    }
    
    cell.lblTitle.text = @"CONTACT FORM";
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
}

#pragma mark
#pragma mark ContactUsFormCell Cell Configuration
- (ContactUsFormCell *)ContactUsFormCellAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"ContactUsFormCell";
    
    ContactUsFormCell *cell = (ContactUsFormCell *)[self.tblView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib;
        if([CommonUtils isiPad])
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"ContactUsFormCell" owner:self options:nil];
        }
        else
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"ContactUsFormCell" owner:self options:nil];
        }
        cell = [nib objectAtIndex:0];
    }
    
    [cell configureCellUI];
    cell.txtName.text = nameForContactUS;
    cell.txtEmail.text = emailForContactUS;
    cell.txtSubject.text = subjectForContactUS;
    
    [self configureTextView:cell];
    [cell.btnSubmit addTarget:self action:@selector(btnSubmit_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
}




-(void)btnSubmit_Clicked:(UIButton *)btnSubmit {
    [self.view endEditing:YES];
    
    ContactUsFormCell *cell = (ContactUsFormCell *)[self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:27]];
    [cell.txtName resignFirstResponder];
    [cell.txtEmail resignFirstResponder];
    [cell.txtSubject resignFirstResponder];
    
    BOOL isValidEmail = [CommonUtils IsValidEmail:emailForContactUS];
    
    if ([nameForContactUS isEqualToString:@""])
    {
        ShowAlert(AlertTitle, @"Please enter name.");
        nameForContactUS = @"";
        [cell.txtName becomeFirstResponder];
    }
    
    else if([emailForContactUS isEqualToString:@""])
    {
        ShowAlert(AlertTitle, @"Please enter Email address.");
        emailForContactUS = @"";
        [cell.txtEmail becomeFirstResponder];
    }
    
    else if ([subjectForContactUS isEqualToString:@""])
    {
        ShowAlert(AlertTitle, @"Please enter subject");
        subjectForContactUS = @"";
        [cell.txtSubject becomeFirstResponder];
    }

    else if ([commentForContactUS isEqualToString:@""]) {
        ShowAlert(AlertTitle, @"Please enter a comment.");
        [cell.txtComment becomeFirstResponder];
    }
    
    else if(!isValidEmail)
    {
        ShowAlert(AlertTitle, @"Please enter a valid Email Address.");
        [cell.txtEmail becomeFirstResponder];
    }
    
    
    
    else
    {
        [self callSendInquiryWebservice];
    }
    
}



#pragma mark
#pragma mark ContactUsDescriptionCell Cell Configuration
- (ContactUsDescriptionCell *)ContactUsDescriptionCellAtIndexPath:(NSIndexPath *)indexPath
{
    static ContactUsDescriptionCell *cell = nil;
    cell = [self.tblView dequeueReusableCellWithIdentifier:ContactUsDescriptionCellIdentifier];
    [self configureContactUsDescriptionCell:cell atIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)configureContactUsDescriptionCell:(ContactUsDescriptionCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.lblDesc.text = @"Looking to spend some time at the American Bars? We’d love to hear from you! Feel free to contact us at any of the links below, and we will get back to you as soon as possible.";
}


#pragma mark
#pragma mark ContactUsCell Cell Configuration
- (ContactUsCell *)ContactUsCellAtIndexPath:(NSIndexPath *)indexPath
{
    static ContactUsCell *cell = nil;
    cell = [self.tblView dequeueReusableCellWithIdentifier:ContactUsCellIdentifier];
    [self configureContactUsCell:cell atIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)configureContactUsCell:(ContactUsCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            cell.lblTitle.text = @"Address";
            cell.lblValue.text = contactToUS.address;
            cell.imgTitle.image = [UIImage imageNamed:@"contactus_address.png"];
            cell.btnMap.hidden = NO;
            [cell.btnMap addTarget:self action:@selector(btnMap_Clicked:) forControlEvents:UIControlEventTouchUpInside];
            break;

        case 1:
            cell.lblTitle.text = @"Phone";
            cell.lblValue.text = contactToUS.phone;
            cell.imgTitle.image = [UIImage imageNamed:@"contactus_phone.png"];
            cell.btnMap.hidden = YES;
            break;

        case 2:
            cell.lblTitle.text = @"E-mail";
            cell.lblValue.text = contactToUS.email;
            cell.imgTitle.image = [UIImage imageNamed:@"contactus_email.png"];
            cell.btnMap.hidden = YES;
            break;

        case 3:
            cell.lblTitle.text = @"Website";
            cell.lblValue.text = contactToUS.website;
            cell.imgTitle.image = [UIImage imageNamed:@"contactus_website.png"];
            cell.btnMap.hidden = YES;
            break;

        default:
            break;
    }
    
    
}

-(void)btnMap_Clicked:(UIButton *)btnMap {
    MapViewController *map = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
    map.address = contactToUS.address;
    [self.navigationController pushViewController:map animated:YES];
}

#pragma mark Height For Row

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
            //ContactUsDescriptionCell
        case 0:
        {
            CGFloat cellHeight = [self heightForContactUsDescriptionCellAtIndexPath:indexPath];
            return cellHeight;
        }
            break;
            
            //ContactUsCell
        case 1:
        {
            CGFloat cellHeight = [self heightForContactUsCellAtIndexPath:indexPath];
            return cellHeight;
        }
            break;
            
            //TitleCell
        case 2:
        {
           return 50;
        }
            break;
            
            //ContactUsFormCell
        case 3:
            return 231;
            break;
            
        default:
        {
            return 0;
        }
    }
    
}
#pragma mark
#pragma mark ContactUsDescriptionCell Cell With Height Configuration
- (CGFloat)heightForContactUsDescriptionCellAtIndexPath:(NSIndexPath *)indexPath
{
    static ContactUsDescriptionCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tblView dequeueReusableCellWithIdentifier:ContactUsDescriptionCellIdentifier];
    });
    
    [self configureContactUsDescriptionCell:sizingCell atIndexPath:indexPath];
    return [self calculateHeightForConfiguredSizingCell:sizingCell];
}


#pragma mark
#pragma mark ContactUsCell Cell With Height Configuration
- (CGFloat)heightForContactUsCellAtIndexPath:(NSIndexPath *)indexPath
{
    static ContactUsCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tblView dequeueReusableCellWithIdentifier:ContactUsCellIdentifier];
    });
    
    [self configureContactUsCell:sizingCell atIndexPath:indexPath];
    return [self calculateHeightForConfiguredSizingCell:sizingCell];
}
#pragma mark Calculate Height for Cell

- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell
{
    sizingCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tblView.frame), CGRectGetHeight(sizingCell.bounds));
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1.0f; // Add 1.0f for the cell separator height
}


#pragma mark Didselect Row
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            MapViewController *map = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
            map.address = contactToUS.address;
            [self.navigationController pushViewController:map animated:YES];
            
        }
    }
}

#pragma mark Estmated Height For Row
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
            //ContactUsDescriptionCell
        case 0:
            return 43;
            break;
            
            //ContactUsCell
        case 1:
            return 61;
            break;
            
            //Title Cell
        case 2:
            return 50;
            break;
            
            //ContactUsFormCell
        case 3:
            return 231;
            break;
            
        default:
            return 0;
    }
    
}

#pragma mark - TextField

#pragma mark Textfield Delegates
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 10) {
        nameForContactUS = textField.text;
    }
    else if (textField.tag == 20) {
        emailForContactUS = textField.text;
    }
    else if (textField.tag == 30) {
        subjectForContactUS = textField.text;
    }

}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - TEXT VIEW
-(void)configureTextView:(ContactUsFormCell *)cell
{
    
    showingPlaceholder = YES;
    if ([commentForContactUS length]==0)
    {
        [cell.txtComment setText:kPlaceholderText];
        [cell.txtComment setTextColor:[UIColor colorWithRed:146.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0]];
    }
    else
    {
        [cell.txtComment setText:commentForContactUS];
        [cell.txtComment setTextColor:[UIColor whiteColor]];
        showingPlaceholder = NO;
    }
}

#pragma mark UITextView Delegate Methods
-(void)textViewDidBeginEditing:(UITextView *)textView {
    
    // Check if it's showing a placeholder, remove it if so
    if(showingPlaceholder) {
        [textView setText:@""];
        [textView setTextColor:[UIColor whiteColor]];
        
        showingPlaceholder = NO;
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    
    // Check the length and if it should add a placeholder
    if([[textView text] length] == 0 && !showingPlaceholder) {
        [textView setText:kPlaceholderText];
        [textView setTextColor:[UIColor colorWithRed:146.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0]];
        
        showingPlaceholder = YES;
    }
    else
    {
        NSLog(@"%@",textView.text);
        commentForContactUS = textView.text;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    
    //    if (commentForGetInTouch.length==0) {
    //        //
    //        if ([text length]==0) {
    //            return YES;
    //        }else
    //        {
    //            [textView resignFirstResponder];
    //            return NO;
    //        }
    //
    //    }
    return YES ;
}


#pragma mark - Orientation
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}


-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
}
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
-(void)callgetContactUsInfoWebservice {
    [CommonUtils callWebservice:@selector(get_contact_us_info) forTarget:self];
}
 
 
-(void)callSendInquiryWebservice {
    [CommonUtils callWebservice:@selector(send_inquiry) forTarget:self];
}

 #pragma mark - Webservice
 #pragma mark get_contact_us_info
-(void)get_contact_us_info
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.mode = MBProgressHUDModeIndeterminate;

    User *user = [CommonUtils getUserLoginDetails];
    NSString *user_id = [user user_id];
    NSString *device_id = [user device_id];
    NSString *unique_code =[user unique_code];

    //192.168.1.27/ADB/api/bar_details
    NSString *myURL = [NSString stringWithFormat:@"%@get_contact_us_info",WEBSERVICE_URL];
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
                contactToUS = [ContactUS getContactUSWithDictionary:[tempDict valueForKey:@"info"]];
                isWSStatus = YES;
                [self registerCell];
            }
        }
        else {
            isWSStatus = NO;
        }

        [self.tblView reloadData];
    }];
 
}

-(void)send_inquiry
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.mode = MBProgressHUDModeIndeterminate;
    
    User *user = [CommonUtils getUserLoginDetails];
    NSString *user_id = [user user_id];
    NSString *device_id = [user device_id];
    NSString *unique_code =[user unique_code];
    
    //192.168.1.27/ADB/api/bar_details
    NSString *myURL = [NSString stringWithFormat:@"%@send_inquiry",WEBSERVICE_URL];
    NSMutableURLRequest *Request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: myURL]];
    //NSString *params = [NSString stringWithFormat:@"user_id=%@&limit=%ld&offset=%ld&bar_id=%@",user_id,(long)limit,(long)offset,self.bar.bar_id];
    NSString *params = [NSString stringWithFormat:@"user_id=%@&device_id=%@&unique_code=%@&name=%@&email=%@&subject=%@&message=%@",user_id,device_id,unique_code,nameForContactUS,emailForContactUS,subjectForContactUS,commentForContactUS];
    
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
                ShowAlert(AlertTitle, @"Message has been send successfully.");
                //contactToUS = [ContactUS getContactUSWithDictionary:[tempDict valueForKey:@"info"]];
                nameForContactUS = @"";
                emailForContactUS = @"";
                subjectForContactUS = @"";
                commentForContactUS = @"";
                isWSStatus = YES;
                
            }
        }
        else {
            isWSStatus = NO;
        }
        //[self registerCell];
        [self.tblView reloadData];
    }];
    
}

@end
