//
//  BarDetailHalfMugViewController.m
//  AmericanDiveBars
//
//  Created by spaculus on 9/26/15.
//  Copyright (c) 2015 spaculus. All rights reserved.
//

#import "BarDetailHalfMugViewController.h"
#import "BarDetailCell.h"
#import "EventDetailViewController.h"
#import <Social/Social.h>
#import "EventListViewController.h"
#import "BeerDirectoryDetailViewController.h"

#define CLIEND_ID @"990806806578-17af1lspds8m4klq1q2q6mgklfqolmbj.apps.googleusercontent.com"
static NSString *const kClientId = CLIEND_ID;

static NSString * const kPlaceholderText = @"Insert Comment Here...";

static NSString * const kDescriptionPlaceholderText = @"Write description here....";
static NSString * const kReviewDescPlaceholderText = @"Review Description";

@interface BarDetailHalfMugViewController () <MBProgressHUDDelegate,ShowMoreViewDelegate,GPPSignInDelegate,TTTAttributedLabelDelegate,UITableViewDataSource,UITableViewDelegate,FPPopoverControllerDelegate,BarWriteReviewCellDelegate,UIActionSheetDelegate>
{
    MBProgressHUD *HUD;
    
    //POPOVER
    FPPopoverController *popover;
    
    //LOAD MORE
    NSInteger offset;
    NSInteger limit;
    
    BOOL isWSStatus;
    
    FullMugBar *fullMugBar;
    
    //Take a Look Cell Image
    UIImage *imgTakeLook;
    
    //BAR GALLERY
    NSInteger selectedIndex;
    
    // Get In Touch
    BOOL showingPlaceholder;
    NSString *nameForGetInTouch;
    NSString *phoneForGetInTouch;
    NSString *emailForGetInTouch;
    NSString *commentForGetInTouch;
    
   
    // Report Bar
    BOOL showingDescriptionPlaceHolder;
    NSString *reportEmail;
    NSString *reportType;
    NSString *reportDesc;
    
    
    // Review Bar
    BOOL showingReviewDescPlaceHolder;
    NSString *reviewTitle;
    NSString *reviewDesc;
    NSString *ratings;
    
    //Google Plus SDK
    GPPSignIn *signIn;
    
    //Favourite Bar
    NSString *isFavBar;
    NSString *isLikeThisBar;
}

//Main Table
@property (strong, nonatomic) IBOutlet UITableView *tblView;
@property (strong, nonatomic) NSMutableArray *aryList;

@property (strong, nonatomic) IBOutlet UIView *viewShowMore;


//Pintrest
@property (strong, nonatomic) Pinterest *pinterest;
@end

@implementation BarDetailHalfMugViewController

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (!self) {
        return nil;
    }
    else {
        
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [CommonUtils setTitleLabel:@"HALF MUG BAR"];
    [self configureTopButtons];
    [self setInitialData];
}

-(void)setInitialData {
    commentForGetInTouch = @"";
    nameForGetInTouch = @"";
    phoneForGetInTouch = @"";
    emailForGetInTouch = @"";
    isFavBar = @"0";
    isLikeThisBar = @"0";
    
    
    reportEmail = @"";
    reportType = @"";
    reportDesc = @"";
    
    reviewTitle = @"";
    reviewDesc = @"";
    ratings = @"";
    
    imgTakeLook = nil;
    selectedIndex = 0;
    
    [self configureShowMoreView];
    [self hideShowMoreView];
    
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
    self.navigationController.navigationBar.topItem.title = @" ";
    [self setStatusBarVisibility];
    
    limit = 3;
    offset = 0;
    
    [self callBarDetailWebservice];
    
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
    [self.navigationController popToRootViewControllerAnimated:YES];
    // FindBarViewController *findBar = [[FindBarViewController alloc] initWithNibName:@"FindBarViewController" bundle:nil];
    // [self.navigationController pushViewController:findBar animated:YES];
}


-(void)openRightMenu_Clicked:(UIButton *)btnRightMenu {
    [self btnFilterClicked:btnRightMenu];
}

-(void)btnFilterClicked:(id)sender
{
    LeftMenu_Popup *controller = [[LeftMenu_Popup alloc] initWithStyle:UITableViewStylePlain];
    controller.barDetailHalfMugDelegate = self;
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
#pragma mark - TextField

#pragma mark Textfield Delegates
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField.tag == 601) {
        reviewTitle = textField.text;
    }
    else {
        reportEmail = textField.text;
    }
    
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - TEXT VIEW
-(void)configureWriteReviewTextView:(BarWriteReviewCell *)cell
{
    
    showingReviewDescPlaceHolder = YES;
    if ([reviewDesc length]==0)
    {
        [cell.txtReviewDesc setText:kReviewDescPlaceholderText];
        [cell.txtReviewDesc setTextColor:[UIColor colorWithRed:146.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0]];
    }
    else
    {
        [cell.txtReviewDesc setText:reviewDesc];
        [cell.txtReviewDesc setTextColor:[UIColor whiteColor]];
        showingReviewDescPlaceHolder = NO;
    }
}
-(void)configureReportTextView:(ReportBarCell *)cell
{
    
    showingDescriptionPlaceHolder = YES;
    if ([reportDesc length]==0)
    {
        [cell.txtOtherDesc setText:kDescriptionPlaceholderText];
        [cell.txtOtherDesc setTextColor:[UIColor colorWithRed:146.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0]];
    }
    else
    {
        [cell.txtOtherDesc setText:reportDesc];
        [cell.txtOtherDesc setTextColor:[UIColor whiteColor]];
        showingDescriptionPlaceHolder = NO;
    }
}
#pragma mark UITextView Delegate Methods
-(void)textViewDidBeginEditing:(UITextView *)textView {
    
    // Check if it's showing a placeholder, remove it if so
    
    if(textView.tag == 401) {
        if(showingDescriptionPlaceHolder) {
            [textView setText:@""];
            [textView setTextColor:[UIColor colorWithRed:146.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0]];
            
            showingDescriptionPlaceHolder = NO;
        }
    }
    else {
        if(showingReviewDescPlaceHolder) {
            [textView setText:@""];
            [textView setTextColor:[UIColor colorWithRed:146.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0]];
            
            showingReviewDescPlaceHolder = NO;
        }
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView {
    
    
    if (textView.tag == 401) {
        if([[textView text] length] == 0 && !showingDescriptionPlaceHolder) {
            [textView setText:kDescriptionPlaceholderText];
            [textView setTextColor:[UIColor colorWithRed:146.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0]];
            
            showingDescriptionPlaceHolder = YES;
        }
        else
        {
            NSLog(@"%@",textView.text);
            reportDesc = textView.text;
        }
    }
    else {
        if([[textView text] length] == 0 && !showingReviewDescPlaceHolder) {
            [textView setText:kReviewDescPlaceholderText];
            [textView setTextColor:[UIColor colorWithRed:146.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0]];
            
            showingReviewDescPlaceHolder = YES;
        }
        else
        {
            NSLog(@"%@",textView.text);
            reviewDesc = textView.text;
        }
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES ;
}

#pragma mark - Table View
-(void)registerCell
{
    [self.tblView registerNib:[UINib nibWithNibName:Nib_BasicCell bundle:nil] forCellReuseIdentifier:BasicCellIdentifier];
    [self.tblView registerNib:[UINib nibWithNibName:Nib_DescriptionCell bundle:nil] forCellReuseIdentifier:DescriptionCellIdentifier];
    
    [self.tblView registerNib:[UINib nibWithNibName:Nib_BarEventsCell bundle:nil] forCellReuseIdentifier:BarEventsCellIdentifier];
    [self.tblView registerNib:[UINib nibWithNibName:Nib_BeersServedCell bundle:nil] forCellReuseIdentifier:BeersServedCellIdentifier];
    [self.tblView registerNib:[UINib nibWithNibName:Nib_Cocktail_LiquorsCell bundle:nil] forCellReuseIdentifier:Cocktail_LiquorsCellIdentifier];
    
    [self.tblView registerNib:[UINib nibWithNibName:Nib_RavesAndRentsCell bundle:nil] forCellReuseIdentifier:RavesAndRentsCellIdentifier];
}

#pragma mark TableView Datasource and Delegates
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (isWSStatus) {
                    //        if([fullMugBar.aryBarReviews count]>0) {
                    //            return 17;
                    //        }
                    //        else {
                    //            return 17;
                    //        }
        
        return 20;
        
        
    }
    else {
        return 0;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    if (section == 6) {
        if ([[fullMugBar aryBeerSeved] count]!=0) {
            return [CommonUtils getArrayCountFromArray:[fullMugBar aryBeerSeved]];
        }
        else {
            return 1;
        }
        
    }
    if (section == 9) {
        if ([fullMugBar.barDetail.bar_serve_as isEqualToString:@"liquor"]) {
            if ([[fullMugBar aryLiquorServed] count]!=0) {
                 return [CommonUtils getArrayCountFromArray:[fullMugBar aryLiquorServed]];
            }
            else {
                return 1;
            }
           
        }
        else {
            if ([[fullMugBar aryCocktailServed] count]!=0) {
                return [CommonUtils getArrayCountFromArray:[fullMugBar aryCocktailServed]];
            }
            else {
                return 1;
            }
            
        }
    }
    
    if (section == 16) {
        if ([[fullMugBar aryBarReviews] count]!=0) {
            return [CommonUtils getArrayCountFromArray:[fullMugBar aryBarReviews]];
        }
        else {
            return 1;
        }
        
    }
    return 1;
}

#pragma mark Cell For Row
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return [self BasicCellAtIndexPath:indexPath];
            break;
        case 1:
            return [self DescriptionTitleCellAtIndexPath:indexPath];
            break;
        case 2:
            return [self DescriptionCellAtIndexPath:indexPath];
            break;
        case 3:
            return [self ShowMoreCellAtIndexPath:indexPath];
            break;
        case 4:
            return [self ShareCellAtIndexPath:indexPath];
            break;
        case 5:
            return [self TItleCellAtIndexPath:indexPath];
            break;
        case 6:
            if ([[fullMugBar aryBeerSeved] count]!=0) {
                 return [self BeersServedCellAtIndexPath:indexPath];
            }
            else {
                 return [self NoDataCellAtIndexPath:indexPath];
            }
           
            break;
        case 7:
            return [self ViewAllBeerServedCellAtIndexPath:indexPath];
            break;
        case 8:
            return [self TItleCellAtIndexPath:indexPath];
            break;
        case 9:
            if ([fullMugBar.barDetail.bar_serve_as isEqualToString:@"liquor"]) {
                if ([[fullMugBar aryLiquorServed] count]!=0) {
                    return [self Cocktail_LiquorsCellAtIndexPath:indexPath];
                }
                else {
                    return [self NoDataCellAtIndexPath:indexPath];
                }
                
            }
            else {
                if ([[fullMugBar aryCocktailServed] count]!=0) {
                    return [self Cocktail_LiquorsCellAtIndexPath:indexPath];
                }
                else {
                    return [self NoDataCellAtIndexPath:indexPath];
                }
            }
            
            break;
        case 10:
            return [self ViewAllCocktailLiquorServedCellAtIndexPath:indexPath];
            break;
       case 11:
            return [self TItleCellAtIndexPath:indexPath];
            break;
        case 12:
            return [self HowToFindUSCellAtIndexPath:indexPath];
            break;
        /*case 13:
            return [self TItleCellAtIndexPath:indexPath];
            break;
        case 14:
            if ([[fullMugBar aryBarReviews] count]!=0) {
                return [self RavesAndRentsCellAtIndexPath:indexPath];
            }
            else {
                return [self NoDataCellAtIndexPath:indexPath];
            }

            break;*/
            
        case 13:
            return [self TItleCellAtIndexPath:indexPath];
            break;
        case 14:
        {
            return [self BarWriteReviewCellAtIndexPath:indexPath];
            
        }
        case 15:
            return [self TItleCellAtIndexPath:indexPath];
            break;
        case 16:
        {
            if ([fullMugBar.aryBarReviews count]!=0) {
                return [self RavesAndRentsCellAtIndexPath:indexPath];
            }
            else {
                return [self NoDataCellAtIndexPath:indexPath];
            }
            
        }
            
            break;
        case 17:
            return [self ViewAllCellAtIndexPath:indexPath];
            break;
            
            
        case 18:
            return [self TItleCellAtIndexPath:indexPath];
            break;
        case 19:
            return [self ReportBarCellAtIndexPath:indexPath];
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
    
    if (indexPath.section == 5) {
        cell.lblTitle.text = @"BEER SERVED AT BAR";
    }
    if (indexPath.section == 8) {
        cell.lblTitle.text = @"COCKTAIL / LIQUORS SERVED AT BAR";
    }
    if (indexPath.section == 11) {
        cell.lblTitle.text = @"HOW TO FIND US";
    }
    
    if (indexPath.section == 13) {
        cell.lblTitle.text = @"WRITE A REVIEW";
    }
    
    if (indexPath.section == 15) {
        cell.lblTitle.text = @"RANTS & RAVES";
    }
    
    if (indexPath.section == 18) {
        cell.lblTitle.text = @"REPORT THIS BAR";
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
}

#pragma mark
#pragma mark NoDataCell Cell Configuration
- (NoDataCell *)NoDataCellAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"NoDataCell";
    NoDataCell *cell = (NoDataCell *)[self.tblView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib;
        if([CommonUtils isiPad])
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"NoDataCell" owner:self options:nil];
        }
        else
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"NoDataCell" owner:self options:nil];
        }
        cell = [nib objectAtIndex:0];
    }
    
    if (indexPath.section == 6) {
        cell.lblNoData.text = @"This bar has not yet added any information regarding Beers Served.";
        cell.lblLine.hidden = YES;
    }
    if (indexPath.section == 9) {
        cell.lblNoData.text = @"This bar has not yet added any information regarding Cocktails/Liquors Served.";
        cell.lblLine.hidden = YES;
    }
    if (indexPath.section == 16) {
        cell.lblNoData.text = @"This bar does not yet any Rants or Raves! Be the first to cotribute.";
        cell.lblLine.hidden = YES;
    }

    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
}

#pragma mark
#pragma mark BarWriteReviewCell Cell Configuration
- (BarWriteReviewCell *)BarWriteReviewCellAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"BarWriteReviewCell";
    
    BarWriteReviewCell *cell = (BarWriteReviewCell *)[self.tblView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib;
        if([CommonUtils isiPad])
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"BarWriteReviewCell" owner:self options:nil];
            cell = [nib objectAtIndex:1];
        }
        else
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"BarWriteReviewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
    }
    
    cell.delegate = self;
    
    cell.txtReviewTitle.text = reviewTitle;
    
    [self configureWriteReviewTextView:cell];
    [cell.btnSubmit addTarget:self action:@selector(btnSubmitReview:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
}
-(void)cell:(BarWriteReviewCell *)cell forRatings:(int)rating {
    ratings = [NSString stringWithFormat:@"%d",rating];
    NSLog(@"%@",ratings);
}

-(void)btnSubmitReview:(UIButton *)btnSubmit {
    [self.view endEditing:YES];
    
    BarWriteReviewCell *cell = (BarWriteReviewCell *)[self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:14]];
    [cell.txtReviewTitle resignFirstResponder];
    [cell.txtReviewDesc resignFirstResponder];
    
    
    
    if ([reviewTitle isEqualToString:@""])
    {
        ShowAlert(AlertTitle, @"Please enter Title for Review.");
        reviewTitle = @"";
        [cell.txtReviewTitle becomeFirstResponder];
    }
    else if ([reviewDesc isEqualToString:@""])
    {
        ShowAlert(AlertTitle, @"Please enter review description.");
        reviewDesc = @"";
        [cell.txtReviewDesc becomeFirstResponder];
    }
    else
    {
        
        [self callAddBarCommentservice];
    }
}

#pragma mark
#pragma mark ReportBarCell Cell Configuration
- (ReportBarCell *)ReportBarCellAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ReportBarCellIdentifier = @"ReportBarCell";
    
    ReportBarCell *cell = (ReportBarCell *)[self.tblView dequeueReusableCellWithIdentifier:ReportBarCellIdentifier];
    if (cell == nil)
    {
        NSArray *nib;
        if([CommonUtils isiPad])
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"ReportBarCell" owner:self options:nil];
            cell = [nib objectAtIndex:1];
        }
        else
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"ReportBarCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
    }
    
    cell.txtEmail.text = reportEmail;
    
    if ([reportType isEqualToString:@"4"]) {
        
        [cell.btnOther setImage:[UIImage imageNamed:@"radio-on.png"] forState:UIControlStateNormal];
        [cell.btnIsClosed setImage:[UIImage imageNamed:@"radio-off.png"] forState:UIControlStateNormal];
        [cell.btnHasWrong setImage:[UIImage imageNamed:@"radio-off.png"] forState:UIControlStateNormal];
        [cell.btnIsNot setImage:[UIImage imageNamed:@"radio-off.png"] forState:UIControlStateNormal];
        
        cell.heightTxtOtherDesc.constant = 84;
        [cell.txtOtherDesc setNeedsUpdateConstraints];
        [cell.txtOtherDesc layoutIfNeeded];
        
    }
    else {
        
        if ([reportType isEqualToString:@"1"]) {
            [cell.btnIsClosed setImage:[UIImage imageNamed:@"radio-on.png"] forState:UIControlStateNormal];
            [cell.btnHasWrong setImage:[UIImage imageNamed:@"radio-off.png"] forState:UIControlStateNormal];
            [cell.btnIsNot setImage:[UIImage imageNamed:@"radio-off.png"] forState:UIControlStateNormal];
            [cell.btnOther setImage:[UIImage imageNamed:@"radio-off.png"] forState:UIControlStateNormal];
        }
        if ([reportType isEqualToString:@"2"]) {
            [cell.btnHasWrong setImage:[UIImage imageNamed:@"radio-on.png"] forState:UIControlStateNormal];
            [cell.btnIsClosed setImage:[UIImage imageNamed:@"radio-off.png"] forState:UIControlStateNormal];
            [cell.btnIsNot setImage:[UIImage imageNamed:@"radio-off.png"] forState:UIControlStateNormal];
            [cell.btnOther setImage:[UIImage imageNamed:@"radio-off.png"] forState:UIControlStateNormal];
        }
        if ([reportType isEqualToString:@"3"]) {
            [cell.btnIsNot setImage:[UIImage imageNamed:@"radio-on.png"] forState:UIControlStateNormal];
            [cell.btnIsClosed setImage:[UIImage imageNamed:@"radio-off.png"] forState:UIControlStateNormal];
            [cell.btnHasWrong setImage:[UIImage imageNamed:@"radio-off.png"] forState:UIControlStateNormal];
            [cell.btnOther setImage:[UIImage imageNamed:@"radio-off.png"] forState:UIControlStateNormal];
        }
        
        cell.heightTxtOtherDesc.constant = 0;
        [cell.txtOtherDesc setNeedsUpdateConstraints];
        [cell.txtOtherDesc layoutIfNeeded];
    }
    
    [self configureReportTextView:cell];
    
    
    [cell.btnIsClosed addTarget:self action:@selector(radioButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnHasWrong addTarget:self action:@selector(radioButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnIsNot addTarget:self action:@selector(radioButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnOther addTarget:self action:@selector(radioButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.btnSubmit addTarget:self action:@selector(btnSubmitReport:) forControlEvents:UIControlEventTouchUpInside];
    
    //    if ([cell.txtComment.text isEqualToString:kPlaceholderText]) {
    //        [cell.txtComment setTextColor:[UIColor colorWithRed:146.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0]];
    //    }
    //    else {
    //        cell.txtComment.text = commentForGetInTouch;
    //        [cell.txtComment setTextColor:[UIColor whiteColor]];
    //    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
}

-(void)btnSubmitReport:(UIButton *)btnSubmit {
    [self.view endEditing:YES];
    
    ReportBarCell *cell = (ReportBarCell *)[self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:19]];
    [cell.txtEmail resignFirstResponder];
    [cell.txtOtherDesc resignFirstResponder];
    
    BOOL isValidEmail = [CommonUtils IsValidEmail:reportEmail];
    
    if ([reportEmail isEqualToString:@""])
    {
        ShowAlert(AlertTitle, @"Please enter email.");
        reportEmail = @"";
        [cell.txtEmail becomeFirstResponder];
    }
    else if ([reportType isEqualToString:@""])
    {
        ShowAlert(AlertTitle, @"Please select region to close.");
        reportType = @"";
    }
    else if(!isValidEmail)
    {
        ShowAlert(AlertTitle, @"Please enter a valid Email Address.");
        [cell.txtEmail becomeFirstResponder];
    }
    else
    {
         [self callAddReportWebservice];
    }
    
}


-(void)radioButtonTapped:(ADBRadioButton *)btnRadio {
    ReportBarCell *cell = (ReportBarCell *)[self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:19]];
    
    
    switch (btnRadio.tag) {
        case 1:
        {
            if ([reportType isEqualToString:@"Closed"]) {
                return;
            }
            reportType = @"Closed";
            [cell.btnIsClosed setImage:[UIImage imageNamed:@"radio-on.png"] forState:UIControlStateNormal];
            [cell.btnHasWrong setImage:[UIImage imageNamed:@"radio-off.png"] forState:UIControlStateNormal];
            [cell.btnIsNot setImage:[UIImage imageNamed:@"radio-off.png"] forState:UIControlStateNormal];
            [cell.btnOther setImage:[UIImage imageNamed:@"radio-off.png"] forState:UIControlStateNormal];
            [self hideTextView:cell forType:reportType];
        }
            
            
            break;
        case 2:
        {
            if ([reportType isEqualToString:@"Has the Wrong Address"]) {
                return;
            }
            reportType = @"Has the Wrong Address";
            [cell.btnHasWrong setImage:[UIImage imageNamed:@"radio-on.png"] forState:UIControlStateNormal];
            [cell.btnIsClosed setImage:[UIImage imageNamed:@"radio-off.png"] forState:UIControlStateNormal];
            [cell.btnIsNot setImage:[UIImage imageNamed:@"radio-off.png"] forState:UIControlStateNormal];
            [cell.btnOther setImage:[UIImage imageNamed:@"radio-off.png"] forState:UIControlStateNormal];
            [self hideTextView:cell forType:reportType];
        }
            
            
            break;
        case 3:
        {
            if ([reportType isEqualToString:@"Is not a Bar"]) {
                return;
            }
            reportType = @"Is not a Bar";
            [cell.btnIsNot setImage:[UIImage imageNamed:@"radio-on.png"] forState:UIControlStateNormal];
            [cell.btnIsClosed setImage:[UIImage imageNamed:@"radio-off.png"] forState:UIControlStateNormal];
            [cell.btnHasWrong setImage:[UIImage imageNamed:@"radio-off.png"] forState:UIControlStateNormal];
            [cell.btnOther setImage:[UIImage imageNamed:@"radio-off.png"] forState:UIControlStateNormal];
            [self hideTextView:cell forType:reportType];
        }
            
            
            break;
        case 4:
        {
            if ([reportType isEqualToString:@"Other"]) {
                return;
            }
            reportType = @"Other";
            [cell.btnOther setImage:[UIImage imageNamed:@"radio-on.png"] forState:UIControlStateNormal];
            [cell.btnIsClosed setImage:[UIImage imageNamed:@"radio-off.png"] forState:UIControlStateNormal];
            [cell.btnHasWrong setImage:[UIImage imageNamed:@"radio-off.png"] forState:UIControlStateNormal];
            [cell.btnIsNot setImage:[UIImage imageNamed:@"radio-off.png"] forState:UIControlStateNormal];
            [self showTextView:cell forType:reportType];
        }
            
            
            break;
            
        default:
            
            break;
    }
}


-(void)showTextView:(ReportBarCell *)cell forType:(NSString *)type {
    cell.heightTxtOtherDesc.constant = 84;
    [cell.txtOtherDesc setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.3 animations:^{
        
        [cell.txtOtherDesc layoutIfNeeded];
        cell.btnSubmit.frame = CGRectMake(cell.btnSubmit.frame.origin.x, 290, cell.btnSubmit.frame.size.width, cell.btnSubmit.frame.size.height);
        
    } completion:^(BOOL finished) {
        if (finished) {
        }
        
    }];
}

-(void)hideTextView:(ReportBarCell *)cell forType:(NSString *)type {
    
    cell.heightTxtOtherDesc.constant = 0;
    [cell.txtOtherDesc setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        [cell.txtOtherDesc layoutIfNeeded];
        cell.btnSubmit.frame = CGRectMake(cell.btnSubmit.frame.origin.x, 206, cell.btnSubmit.frame.size.width, cell.btnSubmit.frame.size.height);
        
    } completion:^(BOOL finished) {
        if (finished) {
        }
        
    }];
}




#pragma mark
#pragma mark HowToFindUS Cell Configuration
- (HowToFindUSCell *)HowToFindUSCellAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"HowToFindUSCell";
    
    HowToFindUSCell *cell = (HowToFindUSCell *)[self.tblView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib;
        if([CommonUtils isiPad])
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"HowToFindUSCell" owner:self options:nil];
        }
        else
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"HowToFindUSCell" owner:self options:nil];
        }
        cell = [nib objectAtIndex:0];
    }

    [cell configureMapInFullMugBar:fullMugBar];
    [cell.btnGetDirections addTarget:self action:@selector(btnGetDirections_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
}

-(void)btnGetDirections_Clicked:(UIButton *)btnGetDirection {
    NSString *urladdress = [[NSString stringWithFormat:@"http://maps.apple.com/?address=%@",fullMugBar.barDetail.fullAddress] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:urladdress];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
//    GetDirectionsViewController *getDirection = [[GetDirectionsViewController alloc] initWithNibName:@"GetDirectionsViewController" bundle:nil];
//    getDirection.isFromGetDirection = YES;
//    getDirection.lat = [NSString stringWithFormat:@"%@",fullMugBar.barDetail.bar_lat];
//    getDirection.lng = [NSString stringWithFormat:@"%@",fullMugBar.barDetail.bar_lang];
//    getDirection.address_Unformated = fullMugBar.barDetail.fullAddress_Unformated;
//    getDirection.address_Formated = fullMugBar.barDetail.fullAddress;
//    [self.navigationController pushViewController:getDirection animated:YES];
}

#pragma mark
#pragma mark ShareCell Cell Configuration
- (ShareCell *)ShareCellAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"ShareCell";
    
    ShareCell *cell = (ShareCell *)[self.tblView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib;
        if([CommonUtils isiPad])
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"ShareCell" owner:self options:nil];
        }
        else
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"ShareCell" owner:self options:nil];
        }
        cell = [nib objectAtIndex:0];
    }
    
    if ([isFavBar isEqualToString:@"1"]) {
        [cell.btnAddToFav setTitle:@"Remove from List" forState:UIControlStateNormal];
    }
    else {
        [cell.btnAddToFav setTitle:@"Add to My Bar List" forState:UIControlStateNormal];
    }
    
    if ([isLikeThisBar isEqualToString:@"1"]) {
        [cell.btnLikeThisBar setTitle:@"Already Liked" forState:UIControlStateNormal];
    }
    else {
        [cell.btnLikeThisBar setTitle:@"Like This Bar" forState:UIControlStateNormal];
    }
    
    cell.btnFb.hidden = YES;
    cell.btnTwitter.hidden = YES;
    cell.btnLinkedIn.hidden = YES;
    cell.btnGooglePlus.hidden = YES;
    cell.btnDribble.hidden = YES;
    cell.btnPintrest.hidden = YES;
    
    [cell.btnShare addTarget:self action:@selector(btnShare_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.btnAddToFav addTarget:self action:@selector(btnAddToFav_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnLikeThisBar addTarget:self action:@selector(btnLikeThisBar_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
}

-(void)btnAddToFav_Clicked:(UIButton *)btnShare {
    if ([CommonUtils isLoggedIn]) {
        [self callBarFavoriteWebservice];
    }
    else {
        [CommonUtils redirectToLoginScreenWithTarget:self];
    }
    
}

-(void)btnLikeThisBar_Clicked:(UIButton *)btnShare {
    if ([CommonUtils isLoggedIn]) {
        [self callBarLikesWebservice];
    }
    else {
        [CommonUtils redirectToLoginScreenWithTarget:self];
    }
}

-(void)btnShare_Clicked:(UIButton *)btnShare {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Share Via" delegate:self cancelButtonTitle:@"Cancel"destructiveButtonTitle:nil otherButtonTitles:@"Facebook",@"Twitter", @"Google+",@"Pintrest",nil];
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
        {
            [self shareWithFaceBook];
            break;
        }
            
            
        case 1:
        {
            [self shareWithTwitter];
            break;
        }
            
            
        case 2:
        {
            [self shareWithGooglePlus];
            break;
        }
            
        case 3:
        {
            [self shareWithPintrest];
            break;
        }
            
        default:
            break;
    }
}



-(void)shareWithFaceBook {
    NSLog(@"FB");
    
    SLComposeViewController *composeController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    //http://192.168.1.27/ADB/
    //http://americanbars.com/bar/details/%@
    //NSString *strURL = [NSString stringWithFormat:@"192.168.1.27/ADB/bar/details/%@",fullMugBar.barDetail.bar_slug];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",SHARE_URL,@"bar/details/",fullMugBar.barDetail.bar_slug]];
    [composeController setInitialText:fullMugBar.barDetail.bar_title];
    [composeController addURL:url];
    //[composeController addImage:[UIImage imageNamed:@"logo_home_page.png"]];
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self presentViewController:composeController animated:YES completion:nil];
        SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result)
        {
            if (result == SLComposeViewControllerResultCancelled)
            {
                NSLog(@"Failure in Posting to Facebook");
            }
            else
            {
                NSLog(@"Successfully Posted to Facebook");
            }
        };
        composeController.completionHandler = myBlock;
        
    }];
    
    
    
    
}

-(void)shareWithTwitter {
    NSLog(@"Twit");
    SLComposeViewController *composeController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    NSString *strURL = [NSString stringWithFormat:@"%@%@%@",SHARE_URL,@"bar/details/",fullMugBar.barDetail.bar_slug];
    NSURL *url = [NSURL URLWithString:strURL];
    [composeController setInitialText:fullMugBar.barDetail.bar_title];
    
    [composeController addURL:url];
    //[composeController addImage:[UIImage imageNamed:@"logo_home_page.png"]];
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self presentViewController:composeController animated:YES completion:nil];
        
        SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result)
        {
            if (result == SLComposeViewControllerResultCancelled)
            {
                NSLog(@"Failure in Posting to Twitter");
            }
            else
            {
                NSLog(@"Successfully Posted to Twitter");
            }
        };
        composeController.completionHandler =myBlock;
    }];
}


-(void)shareWithGooglePlus {
    NSLog(@"G+");
    
    if([signIn trySilentAuthentication] == YES)
    {
        id<GPPNativeShareBuilder> shareBuilder = [[GPPShare sharedInstance] nativeShareDialog];
        
        NSString *productURL = [NSString stringWithFormat:@"%@%@%@",SHARE_URL,@"bar/details/",fullMugBar.barDetail.bar_slug];
        NSURL *shareUrl = [NSURL URLWithString:productURL];
        
        [shareBuilder setURLToShare:shareUrl];
        [shareBuilder setPrefillText:fullMugBar.barDetail.bar_title];
        
        [shareBuilder open];
    }
    else
    {
        UIAlertView *failLogin = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please sign in to share on your Google Plus account." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [failLogin setTag:156];
        [failLogin show];
    }
}

- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth error: (NSError *) error
{
    NSLog(@"Received error %@ and auth object %@",error, auth);
    if (error != nil)
    {
        // if there is an error, notify the user and end the activity
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was an error loggin in." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        NSLog(@"%@ %@",[GPPSignIn sharedInstance].userEmail, [GPPSignIn sharedInstance].userID);
    }
}

-(void)shareWithPintrest {
    NSLog(@"Pi");
    [self configurePintrest];
    [_pinterest createPinWithImageURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",WEBIMAGE_URL,BAR_ICON_LOGO,[fullMugBar.barDetail bar_logo]]]
                            sourceURL:[NSURL URLWithString:@"http://placekitten.com"]
                          description:@"Pinning from Pin It Demo"];
}

-(void)configurePintrest {
    _pinterest = [[Pinterest alloc] initWithClientId:@"4799816673504799498" urlSchemeSuffix:@"prod"];
}

#pragma mark
#pragma mark ViewAllBeerServedCell Cell Configuration
- (ViewAllBeerServedCell *)ViewAllBeerServedCellAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"ViewAllBeerServedCell";
    
    ViewAllBeerServedCell *cell = (ViewAllBeerServedCell *)[self.tblView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib;
        if([CommonUtils isiPad])
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"ViewAllBeerServedCell" owner:self options:nil];
        }
        else
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"ViewAllBeerServedCell" owner:self options:nil];
        }
        cell = [nib objectAtIndex:0];
    }
    if (fullMugBar.beerServedCount>0) {
        cell.lblMore.text = @"View All";
        cell.lblUnderline.backgroundColor = [UIColor colorWithRed:187.0/255.0 green:124.0/255.0 blue:37.0/255.0 alpha:1.0];
        
    }
    else {
        cell.lblMore.text = @"";
        cell.lblUnderline.backgroundColor = [UIColor clearColor];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
}

#pragma mark
#pragma mark ViewAllCocktailLiquorServedCell Cell Configuration
- (ViewAllCocktailLiquorServedCell *)ViewAllCocktailLiquorServedCellAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"ViewAllCocktailLiquorServedCell";
    
    ViewAllCocktailLiquorServedCell *cell = (ViewAllCocktailLiquorServedCell *)[self.tblView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib;
        if([CommonUtils isiPad])
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"ViewAllCocktailLiquorServedCell" owner:self options:nil];
        }
        else
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"ViewAllCocktailLiquorServedCell" owner:self options:nil];
        }
        cell = [nib objectAtIndex:0];
    }
    
    
    if ([fullMugBar.barDetail.bar_serve_as isEqualToString:@"liquor"]) {
        if (fullMugBar.liquorServedCount>0) {
            cell.lblMore.text = @"View All";
            cell.lblUnderline.backgroundColor = [UIColor colorWithRed:187.0/255.0 green:124.0/255.0 blue:37.0/255.0 alpha:1.0];
            
        }
        else {
            cell.lblMore.text = @"";
            cell.lblUnderline.backgroundColor = [UIColor clearColor];
        }
    }
    else {
        if (fullMugBar.cocktailServedCount>0) {
            cell.lblMore.text = @"View All";
            cell.lblUnderline.backgroundColor = [UIColor colorWithRed:187.0/255.0 green:124.0/255.0 blue:37.0/255.0 alpha:1.0];
            
        }
        else {
            cell.lblMore.text = @"";
            cell.lblUnderline.backgroundColor = [UIColor clearColor];
        }
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
}


#pragma mark
#pragma mark ViewAllCell Cell Configuration
- (ViewAllCell *)ViewAllCellAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"ViewAllCell";
    
    ViewAllCell *cell = (ViewAllCell *)[self.tblView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib;
        if([CommonUtils isiPad])
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"ViewAllCell" owner:self options:nil];
        }
        else
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"ViewAllCell" owner:self options:nil];
        }
        cell = [nib objectAtIndex:0];
    }
    
    if (fullMugBar.eventServedCount>0) {
        cell.lblMore.text = @"View All";
        cell.lblUnderline.backgroundColor = [UIColor colorWithRed:187.0/255.0 green:124.0/255.0 blue:37.0/255.0 alpha:1.0];
        
    }
    else if ([fullMugBar.aryBarReviews count]>0) {
        cell.lblMore.text = @"View All";
        cell.lblUnderline.backgroundColor = [UIColor colorWithRed:187.0/255.0 green:124.0/255.0 blue:37.0/255.0 alpha:1.0];
    }
    else {
        cell.lblMore.text = @"";
        cell.lblUnderline.backgroundColor = [UIColor clearColor];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
}

#pragma mark
#pragma mark ShowMoreCell Cell Configuration
- (ShowMoreCell *)ShowMoreCellAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"ShowMoreCell";
    
    ShowMoreCell *cell = (ShowMoreCell *)[self.tblView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib;
        if([CommonUtils isiPad])
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"ShowMoreCell" owner:self options:nil];
        }
        else
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"ShowMoreCell" owner:self options:nil];
        }
        cell = [nib objectAtIndex:0];
    }
    if (fullMugBar.barDetail.bar_desc.length>0) {
        cell.lblMore.text = @"Show More";
        cell.lblUnderline.backgroundColor = [UIColor colorWithRed:187.0/255.0 green:124.0/255.0 blue:37.0/255.0 alpha:1.0];
        
    }
    else {
        cell.lblMore.text = @"";
        cell.lblUnderline.backgroundColor = [UIColor clearColor];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
}



#pragma mark
#pragma mark DescriptionTitleCell Cell Configuration
- (DescriptionTitleCell *)DescriptionTitleCellAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"DescriptionTitleCell";
    
    DescriptionTitleCell *cell = (DescriptionTitleCell *)[self.tblView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib;
        if([CommonUtils isiPad])
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"DescriptionTitleCell" owner:self options:nil];
        }
        else
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"DescriptionTitleCell" owner:self options:nil];
        }
        cell = [nib objectAtIndex:0];
    }
    
    if (indexPath.section == 1) {
        cell.lblTitle.text = @"Description :";
    }
   
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
}


#pragma mark
#pragma mark DescriptionCell Cell Configuration
- (DescriptionCell *)DescriptionCellAtIndexPath:(NSIndexPath *)indexPath
{
    static DescriptionCell *cell = nil;
    cell = [self.tblView dequeueReusableCellWithIdentifier:DescriptionCellIdentifier];
    [self configureDescriptionCell:cell atIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)configureDescriptionCell:(DescriptionCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    BarDetail *bar = [fullMugBar barDetail];
    cell.lblDesc.text = [CommonUtils removeHTMLFromString:bar.bar_desc];
}

#pragma mark
#pragma mark BasicCell Cell Configuration
- (BasicCell *)BasicCellAtIndexPath:(NSIndexPath *)indexPath
{
    static BasicCell *cell = nil;
    cell = [self.tblView dequeueReusableCellWithIdentifier:BasicCellIdentifier];
    [self configureBasicCell:cell atIndexPath:indexPath];
    //cell.delegate = self;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)configureBasicCell:(BasicCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    BarDetail *bar = [fullMugBar barDetail];
    cell.lblBarTitle.text = [CommonUtils removeHTMLFromString:bar.bar_title];
    cell.lblPhone.text = [CommonUtils removeHTMLFromString:bar.bar_phone];
    cell.lblWebSite.text = [CommonUtils removeHTMLFromString:bar.bar_website];
    
    NSString *fullAddress = bar.fullAddress;
    cell.lblAddress.text = fullAddress;
    
    cell.lblAddress.textColor = [UIColor colorWithRed:189.0/255.0 green:127.0/255.0 blue:52.0/255.0 alpha:1.0];
    cell.lblPhone.textColor = [UIColor colorWithRed:189.0/255.0 green:127.0/255.0 blue:52.0/255.0 alpha:1.0];
    
    cell.lblAddress.textColor = [UIColor colorWithRed:189.0/255.0 green:127.0/255.0 blue:52.0/255.0 alpha:1.0];
    [self setAddressLabel:cell.lblAddress withColor:[UIColor colorWithRed:189.0/255.0 green:127.0/255.0 blue:52.0/255.0 alpha:1.0]];
    
    NSRange phone_range = [cell.lblPhone.text rangeOfString:cell.lblPhone.text];
    [cell.lblPhone addLinkToPhoneNumber:nil withRange:phone_range];
    
    NSRange whiteRange = [cell.lblWebSite.text rangeOfString:cell.lblWebSite.text];
    [cell.lblWebSite addLinkToURL:[NSURL URLWithString:cell.lblWebSite.text] withRange:whiteRange];
    
    cell.lblAddress.delegate = self;
    cell.lblAddress.enabledTextCheckingTypes = NSTextCheckingTypeAddress;
    cell.lblPhone.delegate = self;
    cell.lblWebSite.delegate = self;
    cell.lblPhone.enabledTextCheckingTypes = NSTextCheckingTypePhoneNumber;
    
    int total_rating = [[bar bar_total_rating] intValue];
    int total_commnets = [[bar bar_total_commnets] intValue];
    
    [cell setBarRatingsBy:total_rating andComments:total_commnets];
    
    if ([[bar bar_type] isEqualToString:@"full_mug"]) {
        cell.imgBarType.image = [UIImage imageNamed:@"full-mug.png"];
    }
    else {
        cell.imgBarType.image = [UIImage imageNamed:@"half-mug.png"];
    }
    
    NSString *bar_logo = [bar bar_logo];
    NSString *strImgURL = [NSString stringWithFormat:@"%@%@%@",WEBIMAGE_URL,BAR_ICON_LOGO,bar_logo];
    NSURL *imgURL = [NSURL URLWithString:strImgURL];
    
    [cell.imgBarLogo sd_setImageWithURL:imgURL placeholderImage:[UIImage imageNamed:@"bar-no-image.jpg"]];
    
}

-(NSAttributedString *)setTextColorInLabelText:(NSString *)text withColor:(UIColor *)color{
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:text
                                                                    attributes:@{
                                                                                 (id)kCTForegroundColorAttributeName : (id)color.CGColor,
                                                                                 NSFontAttributeName : [UIFont fontWithName:@"Verdana" size:14.0],
                                                                                 NSKernAttributeName : [NSNull null]
                                                                                 }];
    return attString;
}

#pragma mark TTTAttributedLabel Delegate

-(void)setAddressLabel:(TTTAttributedLabel *)lbl withColor:(UIColor *)color{
    
    NSMutableDictionary *mutableActiveLinkAttributes = [NSMutableDictionary dictionary];
    [mutableActiveLinkAttributes setObject:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
    [mutableActiveLinkAttributes setObject:color forKey:(NSString *)kCTForegroundColorAttributeName];
    lbl.activeLinkAttributes = [NSDictionary dictionaryWithDictionary:mutableActiveLinkAttributes];
    
    
    NSRange address_range = [lbl.text rangeOfString:lbl.text];
    [lbl addLinkToAddress:mutableActiveLinkAttributes withRange:address_range];
}

- (void)attributedLabel:(TTTAttributedLabel *)label
didSelectLinkWithAddress:(NSDictionary *)addressComponents {
    if ([label.text length]==0) {
        ShowAlert(AlertTitle, @"No address found");
        return;
    }
    
    NSString *urladdress = [[NSString stringWithFormat:@"http://maps.apple.com/?address=%@",fullMugBar.barDetail.fullAddress] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urladdress];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
    
    //    GetDirectionsViewController *getDirection = [[GetDirectionsViewController alloc] initWithNibName:@"GetDirectionsViewController" bundle:nil];
    //    getDirection.isFromGetDirection = NO;
    //    getDirection.lat = [NSString stringWithFormat:@"%@",fullMugBar.barDetail.bar_lat];
    //    getDirection.lng = [NSString stringWithFormat:@"%@",fullMugBar.barDetail.bar_lang];
    //    getDirection.address_Unformated = fullMugBar.barDetail.fullAddress_Unformated;
    //    getDirection.address_Formated = fullMugBar.barDetail.fullAddress;
    //    [self.navigationController pushViewController:getDirection animated:YES];
    NSLog(@"%@",label.text);
}

- (void)attributedLabel:(TTTAttributedLabel *)label
didSelectLinkWithPhoneNumber:(NSString *)phoneNumber {
    NSLog(@"Phone Number Selected : %@",phoneNumber);
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"] ) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",label.text]]];
    } else {
        UIAlertView *Notpermitted=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your device doesn't support this feature." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [Notpermitted show];
    }
}

- (void)attributedLabel:(__unused TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    [[[UIActionSheet alloc] initWithTitle:[url absoluteString] delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Open Link in Safari", nil), nil] showInView:self.view];
}


#pragma mark
#pragma mark BeersServedCell Cell Configuration
- (BeersServedCell *)BeersServedCellAtIndexPath:(NSIndexPath *)indexPath
{
    static BeersServedCell *cell = nil;
    cell = [self.tblView dequeueReusableCellWithIdentifier:BeersServedCellIdentifier];
    [self configureBeersServedCell:cell atIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)configureBeersServedCell:(BeersServedCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    BeerServed *beerServed = [[fullMugBar aryBeerSeved] objectAtIndex:indexPath.row];
    
    cell.lblBeerServedTitle.text = [CommonUtils removeHTMLFromString:beerServed.beer_name];
    cell.lblBeerServedDesc.text = [NSString stringWithFormat:@"%@\n%@\n%@ %@",
                                   [CommonUtils removeHTMLFromString:beerServed.beer_type],
                                   [CommonUtils removeHTMLFromString:beerServed.beer_producer],
                                   [CommonUtils removeHTMLFromString:beerServed.beer_city_produced],
                                   [CommonUtils removeHTMLFromString:beerServed.beer_state]];
    cell.lblBeerServedDateTime.text = @"";
    
    NSString *beer_logo = [beerServed beer_image];
    NSString *strImgURL = [NSString stringWithFormat:@"%@%@%@",WEBIMAGE_URL,BAR_BEER_SERVED,beer_logo];
    NSURL *imgURL = [NSURL URLWithString:strImgURL];
    
    [cell.imgBeerServed sd_setImageWithURL:imgURL placeholderImage:[UIImage imageNamed:@"beer-served.png"]];
}

#pragma mark
#pragma mark Cocktail_LiquorsCell Cell Configuration
- (Cocktail_LiquorsCell *)Cocktail_LiquorsCellAtIndexPath:(NSIndexPath *)indexPath
{
    static Cocktail_LiquorsCell *cell = nil;
    cell = [self.tblView dequeueReusableCellWithIdentifier:Cocktail_LiquorsCellIdentifier];
    [self configureCocktail_LiquorsCell:cell atIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)configureCocktail_LiquorsCell:(Cocktail_LiquorsCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if ([fullMugBar.barDetail.bar_serve_as isEqualToString:@"liquor"]) {
        LiquorServed *liquorServed = [[fullMugBar aryLiquorServed] objectAtIndex:indexPath.row];
        cell.lblServedTitle.text = [CommonUtils removeHTMLFromString:liquorServed.liquor_title];
        cell.lblServedDesc.text = [NSString stringWithFormat:@"%@\n%@\n%@",
                                   [CommonUtils removeHTMLFromString:liquorServed.liquor_type],
                                   [CommonUtils removeHTMLFromString:liquorServed.liquor_producer],
                                   [CommonUtils removeHTMLFromString:liquorServed.liquor_proof]];
        
        NSString *liquor_logo = [liquorServed liquor_image];
        NSString *strImgURL = [NSString stringWithFormat:@"%@%@%@",WEBIMAGE_URL,BAR_LIQUOR_SERVED,liquor_logo];
        NSURL *imgURL = [NSURL URLWithString:strImgURL];
        
        [cell.imgServed sd_setImageWithURL:imgURL placeholderImage:[UIImage imageNamed:@"liquor-cocktail-served.png"]];
        
    }
    else {
        CocktailServed *cocktailServed = [[fullMugBar aryCocktailServed] objectAtIndex:indexPath.row];
        cell.lblServedTitle.text = [CommonUtils removeHTMLFromString:cocktailServed.cocktail_name];
        cell.lblServedDesc.text = [NSString stringWithFormat:@"%@\n%@\n%@",
                                   [CommonUtils removeHTMLFromString:cocktailServed.cocktail_type],
                                   [CommonUtils removeHTMLFromString:cocktailServed.cocktail_served],
                                   [CommonUtils removeHTMLFromString:cocktailServed.cocktail_strength]];
        
        NSString *cocktail_logo = [cocktailServed cocktail_image];
        NSString *strImgURL = [NSString stringWithFormat:@"%@%@%@",WEBIMAGE_URL,BAR_COCKTAIL_SERVED,cocktail_logo];
        NSURL *imgURL = [NSURL URLWithString:strImgURL];
        
        [cell.imgServed sd_setImageWithURL:imgURL placeholderImage:[UIImage imageNamed:@"liquor-cocktail-served.png"]];
        
    }
}


#pragma mark
#pragma mark RavesAndRentsCell Cell Configuration
- (RavesAndRentsCell *)RavesAndRentsCellAtIndexPath:(NSIndexPath *)indexPath
{
    static RavesAndRentsCell *cell = nil;
    cell = [self.tblView dequeueReusableCellWithIdentifier:RavesAndRentsCellIdentifier];
    [self configureRavesAndRentsCell:cell atIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)configureRavesAndRentsCell:(RavesAndRentsCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    BarReview *barReview = [[fullMugBar aryBarReviews] objectAtIndex:indexPath.row];
    int rate = [barReview.review_bar_rating intValue];
    
    cell.lblComment.text = [CommonUtils removeHTMLFromString:barReview.review_comment];
    cell.lblReviewTitle.text = [CommonUtils removeHTMLFromString:barReview.review_comment_title];
    cell.lblDateTime.text = [CommonUtils removeHTMLFromString:barReview.review_date_added];
    cell.lblPostedBy.text = [NSString stringWithFormat:@"%@ %@",
                             [CommonUtils removeHTMLFromString:barReview.review_first_name],
                             [CommonUtils removeHTMLFromString:barReview.review_last_name]];
    
    NSString *strDuration = [[CommonUtils getDateFromString:barReview.review_date_added withFormat:@"yyyy-MM-dd HH:mm:ss"] formattedAsTimeAgo];
    cell.lblDuration.text = strDuration;
    
    [cell setBarRatingsBy:rate];
}


#pragma mark Height For Row

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
            //BasicCell
        case 0:
        {
            CGFloat cellHeight = [self heightForBasicCellAtIndexPath:indexPath];
            return cellHeight;
        }
            break;
            
            //DescriptionTitleCell
        case 1:
            return 30;
            break;
            
            //DescriptionCell
        case 2:
        {
            CGFloat cellHeight = [self heightForDescriptionCellAtIndexPath:indexPath];
            return cellHeight;
        }
            break;
            
            //ShowMoreCell
        case 3:
            return 25;
            break;
            
            //ShareCell
        case 4:
            return 109;
            break;
            
            
            //TItleCell
        case 5:
            return 50;
            break;
            
            //BeersServedCell
        case 6:
        {
            if ([fullMugBar.aryBeerSeved count]!=0) {
                CGFloat cellHeight = [self heightForBeersServedCellAtIndexPath:indexPath];
                return cellHeight;
            }
            else {
                return 71;
            }
            
        }
        
            break;
            
            
            //ViewAllBeerServedCell
        case 7:
            return 25;
            break;
            
            
            //TItleCell
        case 8:
            return 50;
            break;
            
            //Cocktail_LiquorsCell
        case 9:
        {
            if ([fullMugBar.barDetail.bar_serve_as isEqualToString:@"liquor"]) {
                if ([fullMugBar.aryLiquorServed count]!=0) {
                    CGFloat cellHeight = [self heightForCocktail_LiquorsCellAtIndexPath:indexPath];
                    return cellHeight;
                }
                else {
                    return 71;
                }
            }
            else {
                if ([fullMugBar.aryCocktailServed count]!=0) {
                    CGFloat cellHeight = [self heightForCocktail_LiquorsCellAtIndexPath:indexPath];
                    return cellHeight;
                }
                else {
                    return 71;
                }
            }
        }
        
            break;
            
            //ViewAllCocktailLiquorServedCell
        case 10:
            return 25;
            break;
            
            
            //TItleCell
        case 11:
            return 50;
            break;
            
            //HowToFindUSCell
        case 12:
            return 238;
            break;
            
                    //            //TItleCell
                    //        case 13:
                    //            return 50;
                    //            break;
                    //            
                    //            //RavesAndRentsCell
                    //        case 14:
                    //        {
                    //            if ([fullMugBar.aryBarReviews count]!=0) {
                    //                CGFloat cellHeight = [self heightForRavesAndRentsCellAtIndexPath:indexPath];
                    //                return cellHeight;
                    //            }
                    //            else {
                    //                return 71;
                    //            }
                    //        }
                    //        
                    //            break;
                    //            
                    //            //TItleCell
                    //        case 15:
                    //            return 50;
                    //            break;
                    //            
                    //            //ReportBarCell
                    //        case 16:
                    //            return 333;
                    //            break;
            
            
            //TItleCell
        case 13:
            return 50;
            break;
            
            //BarWriteReviewCell
        case 14:
            return 209;
            break;
            
            //TItleCell
        case 15:
            return 50;
            break;
            
            //RavesAndRentsCell
        case 16:
        {
            if ([fullMugBar.aryBarReviews count]!=0) {
                CGFloat cellHeight = [self heightForRavesAndRentsCellAtIndexPath:indexPath];
                return cellHeight;
            }
            else {
                return 71;
            }
        }
            break;
            
            //ViewAllCell
        case 17:
            return 25;
            break;
            //TItleCell
        case 18:
            return 50;
            break;
            
            //ReportBarCell
        case 19:
            return 333;
            break;
            
            
            
        default:
        {
            return 0;
        }
    }
    
}

#pragma mark
#pragma mark RavesAndRentsCell Cell With Height Configuration
- (CGFloat)heightForRavesAndRentsCellAtIndexPath:(NSIndexPath *)indexPath
{
    static RavesAndRentsCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tblView dequeueReusableCellWithIdentifier:RavesAndRentsCellIdentifier];
    });
    
    [self configureRavesAndRentsCell:sizingCell atIndexPath:indexPath];
    return [self calculateHeightForConfiguredSizingCell:sizingCell];
}


#pragma mark
#pragma mark Cocktail_LiquorsCell Cell With Height Configuration
- (CGFloat)heightForCocktail_LiquorsCellAtIndexPath:(NSIndexPath *)indexPath
{
    static Cocktail_LiquorsCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tblView dequeueReusableCellWithIdentifier:Cocktail_LiquorsCellIdentifier];
    });
    
    [self configureCocktail_LiquorsCell:sizingCell atIndexPath:indexPath];
    return [self calculateHeightForConfiguredSizingCell:sizingCell];
}

#pragma mark
#pragma mark BeersServedCell Cell With Height Configuration
- (CGFloat)heightForBeersServedCellAtIndexPath:(NSIndexPath *)indexPath
{
    static BeersServedCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tblView dequeueReusableCellWithIdentifier:BeersServedCellIdentifier];
    });
    
    [self configureBeersServedCell:sizingCell atIndexPath:indexPath];
    return [self calculateHeightForConfiguredSizingCell:sizingCell];
}


#pragma mark
#pragma mark DescriptionCell Cell With Height Configuration
- (CGFloat)heightForDescriptionCellAtIndexPath:(NSIndexPath *)indexPath
{
    static DescriptionCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tblView dequeueReusableCellWithIdentifier:DescriptionCellIdentifier];
    });
    
    [self configureDescriptionCell:sizingCell atIndexPath:indexPath];
    return [self calculateHeightForConfiguredSizingCell:sizingCell];
}

#pragma mark
#pragma mark BasicCell Cell With Height Configuration
- (CGFloat)heightForBasicCellAtIndexPath:(NSIndexPath *)indexPath
{
    static BasicCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tblView dequeueReusableCellWithIdentifier:BasicCellIdentifier];
    });
    
    [self configureBasicCell:sizingCell atIndexPath:indexPath];
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

#pragma mark Estmated Height For Row
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
            //BasicCell
        case 0:
            return 144;
            break;
            
            //DescriptionTitleCell
        case 1:
            return 30;
            break;
            
            //DescriptionCell
        case 2:
            return 22;
            break;
            
            //ShowMoreCell
        case 3:
            return 25;
            break;
            
            //ShareCell
        case 4:
            return 109;
            break;
            
           
            
            //TItleCell
        case 5:
            return 50;
            break;
            
            //BeersServedCell
        case 6:
            if ([fullMugBar.aryBeerSeved count]!=0) {
                return 93;
            }
            else {
                return 71;
            }
            
            break;
            
            //ViewAllBeerServedCell
        case 7:
            return 25;
            break;
            
            //TItleCell
        case 8:
            return 50;
            break;
            
            //Cocktail_LiquorsCell
        case 9:
            if ([fullMugBar.barDetail.bar_serve_as isEqualToString:@"liquor"]) {
                if ([fullMugBar.aryLiquorServed count]!=0) {
                    return 93;
                }
                else {
                    return 71;
                }
            }
            else {
                if ([fullMugBar.aryCocktailServed count]!=0) {
                    return 93;
                }
                else {
                    return 71;
                }
            }
            
            break;
            
            //ViewAllCocktailLiquorServedCell
        case 10:
            return 25;
            break;
            
            //TItleCell
        case 11:
            return 50;
            break;
            
            //HowToFindUSCell
        case 12:
            return 238;
            break;
            
            //            //TItleCell
            //        case 13:
            //            return 50;
            //            break;
            //            
            //            //RavesAndRentsCell
            //        case 14:
            //            if ([fullMugBar.aryBarReviews count]!=0) {
            //                return 106;
            //            }
            //            else {
            //                return 71;
            //            }
            //            
            //            break;
            //            
            //            //TItleCell
            //        case 15:
            //            return 50;
            //            break;
            //            
            //            //ReportBarCell
            //        case 16:
            //            return 333;
            //            break;
          
            
            //TItleCell
        case 13:
            return 50;
            break;
            
            //BarWriteReviewCell
        case 14:
            return 209;
            break;
            
            //TItleCell
        case 15:
            return 50;
            break;
            
            //RavesAndRentsCell
        case 16:
        {
            if ([fullMugBar.aryBarReviews count]!=0) {
                return 106;
            }
            else {
                return 71;
            }
        }
            break;
            //ViewAllCell
        case 17:
            return 25;
            break;
            //TItleCell
        case 18:
            return 50;
            break;
            
            //ReportBarCell
        case 19:
            return 333;
            break;
            
        default:
            return 0;
    }
    
}

#pragma mark Did Select Row
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 3) {
        [self displayShowMoreView];
    }
    
    if (indexPath.section == 7) {
        if (fullMugBar.beerServedCount>0) {
            BeerDirectoryViewController *beer = [[BeerDirectoryViewController alloc] initWithNibName:@"BeerDirectoryViewController" bundle:nil];
            beer.barDetail = fullMugBar.barDetail;
            [self.navigationController pushViewController:beer animated:YES];
        }
        
    }
    
    if (indexPath.section==6) {
        if ([fullMugBar.aryBeerSeved count]>0) {
            BeerServed *beerServed = [fullMugBar.aryBeerSeved objectAtIndex:indexPath.row];
            BeerDirectory *beer = [self getBeerFromServedBeer:beerServed];
            BeerDirectoryDetailViewController *beerDetail = [[BeerDirectoryDetailViewController alloc] initWithNibName:@"BeerDirectoryDetailViewController" bundle:nil];
            beerDetail.beer = beer;
            [self.navigationController pushViewController:beerDetail animated:YES];

        }
    }
    
    if (indexPath.section==9) {
        if ([fullMugBar.barDetail.bar_serve_as isEqualToString:@"liquor"]) {
            if ([fullMugBar.aryLiquorServed count]>0) {
                LiquorServed *liquorServed = [fullMugBar.aryLiquorServed objectAtIndex:indexPath.row];
                LiquorDirectory *liquor = [self getLiquorFromServedLiquor:liquorServed];
                LiquorDirectoryDetailViewController *liquorDetail = [[LiquorDirectoryDetailViewController alloc] initWithNibName:@"LiquorDirectoryDetailViewController" bundle:nil];
                liquorDetail.liquor = liquor;
                [self.navigationController pushViewController:liquorDetail animated:YES];

            }
        }
        else {
            if ([fullMugBar.aryCocktailServed count]>0) {
                CocktailServed *cocktailServed = [fullMugBar.aryCocktailServed objectAtIndex:indexPath.row];
                CocktailDirectory *cocktail = [self getCocktailFromServedCocktail:cocktailServed];
                CocktailDirectoryDetailViewController *cocktailDetail = [[CocktailDirectoryDetailViewController alloc] initWithNibName:@"CocktailDirectoryDetailViewController" bundle:nil];
                cocktailDetail.cocktail = cocktail;
                [self.navigationController pushViewController:cocktailDetail animated:YES];
            }
            
        }
    }
    
    if (indexPath.section == 10) {
        if ([fullMugBar.barDetail.bar_serve_as isEqualToString:@"liquor"]) {
            if (fullMugBar.liquorServedCount>0) {
                LiquorDirectoryViewController *liquor = [[LiquorDirectoryViewController alloc] initWithNibName:@"LiquorDirectoryViewController" bundle:nil];
                liquor.barDetail = fullMugBar.barDetail;
                [self.navigationController pushViewController:liquor animated:YES];
            }
        }
        else {
            if (fullMugBar.cocktailServedCount>0) {
                CocktailDirectoryViewController *cocktail = [[CocktailDirectoryViewController alloc] initWithNibName:@"CocktailDirectoryViewController" bundle:nil];
                cocktail.barDetail = fullMugBar.barDetail;
                [self.navigationController pushViewController:cocktail animated:YES];
                
            }
        }
        
    }
    
    if (indexPath.section == 17) {
        if ([fullMugBar.aryBarReviews count]>0) {
            BarReviewViewController *barReview = [[BarReviewViewController alloc] initWithNibName:@"BarReviewViewController" bundle:nil];
            barReview.bar_id = self.bar.bar_id;
            [self.navigationController pushViewController:barReview animated:YES];
        }
    }
}

-(BeerDirectory *)getBeerFromServedBeer : (BeerServed *)beerServed {
    BeerDirectory *beer = [[BeerDirectory alloc] init];
    beer.beer_id = [beerServed beer_id];
    beer.beer_image = [beerServed beer_image];
    beer.beer_name = [beerServed beer_name];
    beer.beer_type = [beerServed beer_type];
    beer.beer_website = [beerServed beer_image];
    beer.beer_city_produced = [beerServed beer_city_produced];
    beer.beer_producer = [beerServed beer_producer];
    beer.beer_status = @"";
    return beer;
}

-(CocktailDirectory *)getCocktailFromServedCocktail : (CocktailServed *)cocktailServed {
    CocktailDirectory *cocktail = [[CocktailDirectory alloc] init];
    cocktail.cocktail_id = [cocktailServed cocktail_id];
    cocktail.cocktail_image = [cocktailServed cocktail_image];
    cocktail.cocktail_name = [cocktailServed cocktail_name];
    cocktail.cocktail_difficulty = [cocktailServed cocktail_strength];
    cocktail.cocktail_served = [cocktailServed cocktail_served];
    cocktail.cocktail_type = [cocktailServed cocktail_type];
    return cocktail;
}

-(LiquorDirectory *)getLiquorFromServedLiquor : (LiquorServed *)liquorServed {
    LiquorDirectory *liquor = [[LiquorDirectory alloc] init];
    
    liquor.liquor_id = [liquorServed liquor_id];
    liquor.liquor_image = [liquorServed liquor_image];
    liquor.liquor_title = [liquorServed liquor_title];
    liquor.liquor_producer = [liquorServed liquor_producer];
    liquor.liquor_proof = [liquorServed liquor_proof];
    liquor.liquor_type = [liquorServed liquor_type];
    
    return liquor;
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
        [showMoreView reloadShowMoreTable:@[[CommonUtils removeHTMLFromString:fullMugBar.barDetail.bar_desc]]];
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

#pragma mark - Oriantation
- (BOOL)isLandscapeOrientation {
    return UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation);
}


#pragma mark - Webservice Call
-(void)callBarDetailWebservice {
    [CommonUtils callWebservice:@selector(bar_details) forTarget:self];
}

-(void)callGetInTouchWebservice {
    [CommonUtils callWebservice:@selector(getInTouch) forTarget:self];
}

-(void)callBarFavoriteWebservice {
    [CommonUtils callWebservice:@selector(bar_favorite) forTarget:self];
}

-(void)callBarLikesWebservice {
    [CommonUtils callWebservice:@selector(bar_likes) forTarget:self];
}

-(void)callAddReportWebservice {
    [CommonUtils callWebservice:@selector(add_report_bar) forTarget:self];
}

-(void)callAddBarCommentservice {
    [CommonUtils callWebservice:@selector(add_bar_comment) forTarget:self];
}

#pragma mark - Webservice
#pragma mark bar_details
-(void)bar_details
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
    NSString *myURL = [NSString stringWithFormat:@"%@bar_details",WEBSERVICE_URL];
    NSMutableURLRequest *Request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: myURL]];
    //NSString *params = [NSString stringWithFormat:@"user_id=%@&limit=%ld&offset=%ld&bar_id=%@",user_id,(long)limit,(long)offset,self.bar.bar_id];
    NSString *params = [NSString stringWithFormat:@"user_id=%@&device_id=%@&unique_code=%@&limit=%ld&offset=%ld&bar_id=%@",user_id,device_id,unique_code,(long)limit,(long)offset,self.bar.bar_id];
    
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
                fullMugBar = [FullMugBar getFullMugBarWithDictionary:tempDict];
                if ([fullMugBar.barDetail.bar_fav_bar isEqualToString:@"1"]) {
                    isFavBar = @"1";
                }
                else {
                    isFavBar = @"0";
                }
                
                if ([fullMugBar.barDetail.bar_like_bar isEqualToString:@"1"]) {
                    isLikeThisBar = @"1";
                }
                else {
                    isLikeThisBar = @"0";
                }
                
                isWSStatus = YES;
                User *user = [CommonUtils getUserLoginDetails];
                reportEmail = [user user_email];
                [self registerCell];
            }
        }
        else {
            isWSStatus = NO;
        }
        
        [self.tblView reloadData];
        
    }];
    
}

#pragma mark bar_favorite
-(void)bar_favorite
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
    NSString *myURL = [NSString stringWithFormat:@"%@bar_favorite",WEBSERVICE_URL];
    NSMutableURLRequest *Request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: myURL]];
    //NSString *params = [NSString stringWithFormat:@"user_id=%@&limit=%ld&offset=%ld&bar_id=%@",user_id,(long)limit,(long)offset,self.bar.bar_id];
    NSString *params = [NSString stringWithFormat:@"user_id=%@&device_id=%@&unique_code=%@&bar_id=%@",user_id,device_id,unique_code,self.bar.bar_id];
    
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
                //fullMugBar = [FullMugBar getFullMugBarWithDictionary:tempDict];
                isFavBar = [CommonUtils getNotNullString:[tempDict valueForKey:@"message"]];
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


#pragma mark bar_likes
-(void)bar_likes
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
    NSString *myURL = [NSString stringWithFormat:@"%@bar_likes",WEBSERVICE_URL];
    NSMutableURLRequest *Request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: myURL]];
    //NSString *params = [NSString stringWithFormat:@"user_id=%@&limit=%ld&offset=%ld&bar_id=%@",user_id,(long)limit,(long)offset,self.bar.bar_id];
    NSString *params = [NSString stringWithFormat:@"user_id=%@&device_id=%@&unique_code=%@&bar_id=%@",user_id,device_id,unique_code,self.bar.bar_id];
    
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
                //fullMugBar = [FullMugBar getFullMugBarWithDictionary:tempDict];
                isLikeThisBar = [CommonUtils getNotNullString:[tempDict valueForKey:@"message"]];
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


#pragma mark getInTouch
-(void)getInTouch
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
    NSString *myURL = [NSString stringWithFormat:@"%@getInTouch",WEBSERVICE_URL];
    NSMutableURLRequest *Request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: myURL]];
    //NSString *params = [NSString stringWithFormat:@"user_id=%@&limit=%ld&offset=%ld&bar_id=%@",user_id,(long)limit,(long)offset,self.bar.bar_id];
    NSString *params = [NSString stringWithFormat:@"user_id=%@&device_id=%@&unique_code=%@&bar_id=%@&name=%@&phone=%@&emai_new=%@&desc=%@",user_id,device_id,unique_code,self.bar.bar_id,nameForGetInTouch,phoneForGetInTouch,emailForGetInTouch,commentForGetInTouch];
    
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
                //fullMugBar = [FullMugBar getFullMugBarWithDictionary:tempDict];
                //isLikeThisBar = [CommonUtils getNotNullString:[tempDict valueForKey:@"message"]];
                nameForGetInTouch = @"";
                phoneForGetInTouch = @"";
                emailForGetInTouch = @"";
                commentForGetInTouch = @"";
                ShowAlert(AlertTitle, @"Message Sent Successfully!");
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


#pragma mark add_report_bar
-(void)add_report_bar
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
    NSString *myURL = [NSString stringWithFormat:@"%@add_report_bar",WEBSERVICE_URL];
    NSMutableURLRequest *Request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: myURL]];
    //NSString *params = [NSString stringWithFormat:@"user_id=%@&limit=%ld&offset=%ld&bar_id=%@",user_id,(long)limit,(long)offset,self.bar.bar_id];
    NSString *params = [NSString stringWithFormat:@"user_id=%@&device_id=%@&unique_code=%@&bar_id=%@&email=%@&desc=%@&report_type=%@",user_id,device_id,unique_code,self.bar.bar_id,reportEmail,reportDesc,reportType];
    
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
                //fullMugBar = [FullMugBar getFullMugBarWithDictionary:tempDict];
                //isLikeThisBar = [CommonUtils getNotNullString:[tempDict valueForKey:@"message"]];
                reportType = @"";
                reportDesc = @"";
                //reportEmail = @"";
                showingDescriptionPlaceHolder = YES;
                ShowAlert(AlertTitle, @"Your report hae been sent successfully to bar owner.");
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

#pragma mark add_bar_comment
-(void)add_bar_comment {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.mode = MBProgressHUDModeIndeterminate;
    
    User *user = [CommonUtils getUserLoginDetails];
    NSString *user_id = [user user_id];
    NSString *device_id = [user device_id];
    NSString *unique_code =[user unique_code];
    
    //192.168.1.27/ADB/api/bar_details
    NSString *myURL = [NSString stringWithFormat:@"%@add_bar_comment",WEBSERVICE_URL];
    NSMutableURLRequest *Request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: myURL]];
    //NSString *params = [NSString stringWithFormat:@"user_id=%@&limit=%ld&offset=%ld&bar_id=%@",user_id,(long)limit,(long)offset,self.bar.bar_id];
    NSString *params = [NSString stringWithFormat:@"user_id=%@&device_id=%@&unique_code=%@&bar_id=%@&comment_title=%@&comment=%@&rating=%@",user_id,device_id,unique_code,self.bar.bar_id,reviewTitle,reviewDesc,ratings];
    
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
                
                ShowAlert(AlertTitle, @"Your review is added successfully.");
                
                reviewTitle = @"";
                reviewDesc = @"";
                ratings = @"0";
                showingReviewDescPlaceHolder = YES;
                isWSStatus = YES;
                [self callBarDetailWebservice];
                
            }
        }
        else {
            isWSStatus = NO;
        }
        
        [self.tblView reloadData];
        
    }];
    
}


#pragma mark - Third Party Api
#pragma mark GooglePlus SDK
-(void)configureGooglePlus {
    signIn = [GPPSignIn sharedInstance];
    signIn.shouldFetchGooglePlusUser = YES;
    signIn.shouldFetchGoogleUserEmail = YES;
    signIn.clientID = kClientId;
    signIn.scopes = @[kGTLAuthScopePlusLogin];
    signIn.delegate = self;
    [signIn trySilentAuthentication];
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


@end



