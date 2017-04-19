//
//  BarDetailFullMugViewController.m
//  AmericanDiveBars
//
//  Created by spaculus on 9/14/15.
//  Copyright (c) 2015 spaculus. All rights reserved.
//

#import "BarDetailFullMugViewController.h"
#import "BarDetailCell.h"
#import "VideoViewController.h"

#import "BarSpecialHoursViewController.h"

#import "EventDetailViewController.h"
#import <Social/Social.h>
#import "EventListViewController.h"
#import "BeerDirectoryDetailViewController.h"
#import "CocktailDirectoryDetailViewController.h"
#import "LiquorDirectoryDetailViewController.h"

#define CLIEND_ID @"990806806578-17af1lspds8m4klq1q2q6mgklfqolmbj.apps.googleusercontent.com"
static NSString *const kClientId = CLIEND_ID;

static NSString * const kPlaceholderText = @"What do you want?";
static NSString * const kDescriptionPlaceholderText = @"Write description here....";
static NSString * const kReviewDescPlaceholderText = @"Review Description";

@interface BarDetailFullMugViewController () <MBProgressHUDDelegate,BarGalleryCellDelegate,ShowMoreViewDelegate,GPPSignInDelegate,FPPopoverControllerDelegate,TTTAttributedLabelDelegate,TakeALookCellDelegate,BarWriteReviewCellDelegate,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
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
@property (strong, nonatomic) IBOutlet TPKeyboardAvoidingTableView *tblView;
@property (strong, nonatomic) NSMutableArray *aryList;

@property (strong, nonatomic) IBOutlet UIView *viewShowMore;


//Pintrest
@property (strong, nonatomic) Pinterest *pinterest;
@end

@implementation BarDetailFullMugViewController

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
    self.navigationItem.titleView = [CommonUtils setTitleLabel:@"FULL MUG BAR"];
    [self configureTopButtons];
    [self setInitialData];
}

-(void)setInitialData {
    commentForGetInTouch = @"";
    nameForGetInTouch = @"";
    phoneForGetInTouch = @"";
    emailForGetInTouch = @"";
    
    reportEmail = @"";
    reportType = @"";
    reportDesc = @"";
    
    reviewTitle = @"";
    reviewDesc = @"";
    ratings = @"";
    
    isFavBar = @"0";
    isLikeThisBar = @"0";
    
    imgTakeLook = nil;
    selectedIndex = 0;
    
    [self configureShowMoreView];
    [self hideShowMoreView];
    
    limit = 3;
    offset = 0;
    
    [self callBarDetailWebservice];

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
    controller.barDetailFullMugDelegate = self;
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
        return 35;
    }
    else {
        return 0;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2) {
        if ([[[fullMugBar sph] aryHours] count]!=0) {
            return [CommonUtils getArrayCountFromArray:[[fullMugBar sph] aryHours]];
        }
        else {
            return 1;
        }
        
    }
    if (section == 10) {
        if ([[fullMugBar aryBarHours] count]!=0) {
            return [CommonUtils getArrayCountFromArray:[fullMugBar aryBarHours]];
        }
        else {
            return 1;
        }
        
    }
    if (section == 14) {
        if ([[fullMugBar aryBarEvents] count]!=0) {
            return [CommonUtils getArrayCountFromArray:[fullMugBar aryBarEvents]];
        }
        else {
            return 1;
        }
        
    }
    if (section == 17) {
        if ([[fullMugBar aryBeerSeved] count]!=0) {
            return [CommonUtils getArrayCountFromArray:[fullMugBar aryBeerSeved]];
        }
        else {
            return 1;
        }
        
    }
    if (section == 20) {
        if ([fullMugBar.barDetail.bar_serve_as isEqualToString:@"liquor"]) {
            if ([[fullMugBar aryLiquorServed] count]!=0) {
                return [CommonUtils getArrayCountFromArray:[fullMugBar aryLiquorServed]];
            }
            else {
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

    if (section == 29) {
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
            return [self TItleCellAtIndexPath:indexPath];
            break;
        case 2:
        {
            if([fullMugBar.sph.aryHours count] != 0)
            {
                return [self BarSpecialHoursCellAtIndexPath:indexPath];
                //return 59;
            }
            else {
                return [self NoDataCellAtIndexPath:indexPath];
            }
            
        }
        
            break;
        case 3:
            return [self DescriptionTitleCellAtIndexPath:indexPath];
            break;
        case 4:
            return [self DescriptionCellAtIndexPath:indexPath];
            break;
        case 5:
            return [self ShowMoreCellAtIndexPath:indexPath];
            break;
        case 6:
            return [self ShareCellAtIndexPath:indexPath];
            break;
        case 7:
            return [self DescriptionTitleCellAtIndexPath:indexPath];
            break;
        case 8:
            {
                if ([fullMugBar.barDetail.aryPaymentTypes_Up count]>0 && [fullMugBar.barDetail.aryPaymentTypes_Down count]>0) {
                    return [self PaymentTypeFullCellAtIndexPath:indexPath];
                }
                else if ([fullMugBar.barDetail.aryPaymentTypes_Up count]>0) {
                    return [self PaymentTypeOnlyUpCellAtIndexPath:indexPath];
                }
                else if ([fullMugBar.barDetail.aryPaymentTypes_Down count]>0){
                    return [self PaymentTypeOnlyDownCellAtIndexPath:indexPath];
                }
                else {
                   return [self PaymentTypeCellAtIndexPath:indexPath];
                }
            }
            break;
        case 9:
            return [self TItleCellAtIndexPath:indexPath];
            break;
        case 10:
        {
            if ([fullMugBar.aryBarHours count]!=0) {
                return [self HoursOpenCellAtIndexPath:indexPath];
            }
            else {
                return [self NoDataCellAtIndexPath:indexPath];
            }
            
        }

            
            break;
        case 11:
            return [self TItleCellAtIndexPath:indexPath];
            break;
        case 12:
            return [self BarGalleryCellAtIndexPath:indexPath];
            break;
        case 13:
            return [self TItleCellAtIndexPath:indexPath];
            break;
        case 14:
        {
            if ([fullMugBar.aryBarEvents count]!=0) {
                return [self BarEventsCellAtIndexPath:indexPath];
            }
            else {
                return [self NoDataCellAtIndexPath:indexPath];
            }
            
        }
            
            break;
        case 15:
            return [self ViewAllCellAtIndexPath:indexPath];
            break;
        case 16:
            return [self TItleCellAtIndexPath:indexPath];
            break;
        case 17:
        {
            if ([fullMugBar.aryBeerSeved count]!=0) {
                return [self BeersServedCellAtIndexPath:indexPath];
            }
            else {
                return [self NoDataCellAtIndexPath:indexPath];
            }
            
        }
            
            break;
        case 18:
            return [self ViewAllBeerServedCellAtIndexPath:indexPath];
            break;
        case 19:
            return [self TItleCellAtIndexPath:indexPath];
            break;
        case 20:
        {
            if ([fullMugBar.barDetail.bar_serve_as isEqualToString:@"liquor"]) {
                if ([fullMugBar.aryLiquorServed count]!=0) {
                    return [self Cocktail_LiquorsCellAtIndexPath:indexPath];
                }
                else {
                    return [self NoDataCellAtIndexPath:indexPath];
                }
            }
            else {
                if ([fullMugBar.aryCocktailServed count]!=0) {
                    return [self Cocktail_LiquorsCellAtIndexPath:indexPath];
                }
                else {
                   return [self NoDataCellAtIndexPath:indexPath];
                }
            }
            
            
        }
            break;
        case 21:
            return [self ViewAllCocktailLiquorServedCellAtIndexPath:indexPath];
            break;
        case 22:
            return [self TItleCellAtIndexPath:indexPath];
            break;
        case 23:
            return [self TakeALookCellAtIndexPath:indexPath];
            break;
        case 24:
            return [self TItleCellAtIndexPath:indexPath];
            break;
        case 25:
            return [self HowToFindUSCellAtIndexPath:indexPath];
            break;
            
        case 26:
            return [self TItleCellAtIndexPath:indexPath];
            break;
        case 27:
        {
            return [self BarWriteReviewCellAtIndexPath:indexPath];
            
        }
        case 28:
            return [self TItleCellAtIndexPath:indexPath];
            break;
        case 29:
        {
            if ([fullMugBar.aryBarReviews count]!=0) {
                return [self RavesAndRentsCellAtIndexPath:indexPath];
            }
            else {
                return [self NoDataCellAtIndexPath:indexPath];
            }
            
        }
            
            break;
        case 30:
            return [self ViewAllCellAtIndexPath:indexPath];
            break;
        case 31:
            return [self TItleCellAtIndexPath:indexPath];
            break;
        case 32:
            return [self GetInTouchCellAtIndexPath:indexPath];
            break;
        case 33:
            return [self TItleCellAtIndexPath:indexPath];
            break;
        case 34:
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
    
    if (indexPath.section == 1) {
        cell.lblTitle.text = @"HAPPY HOURS & SPECIAL";
    }
    
    if (indexPath.section == 9) {
        cell.lblTitle.text = @"HOURS WE ARE OPEN";
    }
    
    if (indexPath.section == 11) {
        cell.lblTitle.text = @"BAR GALLERY";
    }
    if (indexPath.section == 13) {
        cell.lblTitle.text = @"BAR EVENTS";
    }
    if (indexPath.section == 16) {
        cell.lblTitle.text = @"BEER SERVED AT BAR";
    }
    if (indexPath.section == 19) {
        cell.lblTitle.text = @"COCKTAIL / LIQUORS SERVED AT BAR";
    }
    if (indexPath.section == 22) {
        cell.lblTitle.text = @"TAKE A LOOK INSIDE";
    }
    if (indexPath.section == 24) {
        cell.lblTitle.text = @"HOW TO FIND US";
    }
    if (indexPath.section == 26) {
        cell.lblTitle.text = @"WRITE A REVIEW";
    }
    if (indexPath.section == 28) {
        cell.lblTitle.text = @"RANTS & RAVES";
    }
    if (indexPath.section == 31) {
        cell.lblTitle.text = @"GET IN TOUCH!";
    }
    if (indexPath.section == 33) {
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
    
    if (indexPath.section == 2) {
        cell.lblNoData.text = @"This bar has not yet added any information regarding Happy Hours.";
        cell.lblLine.hidden = NO;
    }
    if (indexPath.section == 10) {
        cell.lblNoData.text = @"This bar has not yet added any information regarding Open hours.";
        cell.lblLine.hidden = YES;
    }
    if (indexPath.section == 14) {
        cell.lblNoData.text = @"This bar has not yet added any information regarding Bar Events.";
        cell.lblLine.hidden = YES;
    }
    if (indexPath.section == 17) {
        cell.lblNoData.text = @"This bar has not yet added any information regarding Beers Served.";
        cell.lblLine.hidden = YES;
    }
    if (indexPath.section == 20) {
        cell.lblNoData.text = @"This bar has not yet added any information regarding Cocktails/Liquors Served.";
        cell.lblLine.hidden = YES;
    }
    if (indexPath.section == 29) {
        cell.lblNoData.text = @"This bar does not yet any Rants or Raves! Be the first to cotribute.";
        cell.lblLine.hidden = YES;
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    //
    //
    // This bar has not yet added any information regarding Bar Gallery.
    //
    //
    //
    //
    return cell;
    
}

#pragma mark
#pragma mark BarSpecialHourButtonCell Cell Configuration
- (BarSpecialHourButtonCell *)BarSpecialHourButtonCellAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"BarSpecialHourButtonCell";
    
    BarSpecialHourButtonCell *cell = (BarSpecialHourButtonCell *)[self.tblView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib;
        if([CommonUtils isiPad])
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"BarSpecialHourButtonCell" owner:self options:nil];
        }
        else
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"BarSpecialHourButtonCell" owner:self options:nil];
        }
        cell = [nib objectAtIndex:0];
    }
    
    [cell.btnSpecialHours addTarget:self action:@selector(btnSpecialHours_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(void)btnSpecialHours_Clicked:(UIButton *)btnSpecialHours {
    
    if([fullMugBar.arySpecialHours count]!=0) {
        NSLog(@"Special Hours");
        BarSpecialHoursViewController *specialHour = [[BarSpecialHoursViewController alloc] initWithNibName:@"BarSpecialHoursViewController" bundle:nil];
        specialHour.arySpecialHours = fullMugBar.arySpecialHours;
        [self.navigationController pushViewController:specialHour animated:YES];
    }
    else {
        ShowAlert(AlertTitle, @"No Bar special Hours are available");
    }
    
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
    
    //[self urlencode:[NSString stringWithFormat:@"http://maps.apple.com/?address=%@",fullMugBar.barDetail.fullAddress]];
    
    //    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
    //                                                                                  NULL,
    //                                                                                  (CFStringRef)urladdress,
    //                                                                                  NULL,
    //                                                                                  (CFStringRef)@"!*'();:@&=+$,/?%#[]",
    //                                                                                  kCFStringEncodingUTF8 ));
    
    NSURL *url = [NSURL URLWithString:urladdress];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
    }

    
//    http://maps.apple.com/?q=
//    GetDirectionsViewController *getDirection = [[GetDirectionsViewController alloc] initWithNibName:@"GetDirectionsViewController" bundle:nil];
//    getDirection.isFromGetDirection = YES;
//    getDirection.lat = [NSString stringWithFormat:@"%@",fullMugBar.barDetail.bar_lat];
//    getDirection.lng = [NSString stringWithFormat:@"%@",fullMugBar.barDetail.bar_lang];
//    getDirection.address_Unformated = fullMugBar.barDetail.fullAddress_Unformated;
//    getDirection.address_Formated = fullMugBar.barDetail.fullAddress;
//    [self.navigationController pushViewController:getDirection animated:YES];
}

- (NSString *)urlencode:(NSString *)urlAddress {
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[urlAddress UTF8String];
    int sourceLen = (int)strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
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
    
    BarWriteReviewCell *cell = (BarWriteReviewCell *)[self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:27]];
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
#pragma mark GetInTouchCell Cell Configuration
- (GetInTouchCell *)GetInTouchCellAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"GetInTouchCell";
    
    GetInTouchCell *cell = (GetInTouchCell *)[self.tblView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib;
        if([CommonUtils isiPad])
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"GetInTouchCell" owner:self options:nil];
        }
        else
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"GetInTouchCell" owner:self options:nil];
        }
        cell = [nib objectAtIndex:0];
    }
    
    [cell configureCellUI];
    cell.txtName.text = nameForGetInTouch;
    cell.txtPhone.text = phoneForGetInTouch;
    cell.txtEmail.text = emailForGetInTouch;
    
    [self configureTextView:cell];
    [cell.btnSubmit addTarget:self action:@selector(btnGetInTouchSubmit_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    
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
-(void)btnGetInTouchSubmit_Clicked:(UIButton *)btnSubmit {
    [self.view endEditing:YES];
    
    GetInTouchCell *cell = (GetInTouchCell *)[self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:32]];
    [cell.txtName resignFirstResponder];
    [cell.txtPhone resignFirstResponder];
    [cell.txtEmail resignFirstResponder];
    
    BOOL isValidEmail = [CommonUtils IsValidEmail:emailForGetInTouch];
    
    if ([nameForGetInTouch isEqualToString:@""])
    {
        ShowAlert(AlertTitle, @"Please enter Name.");
        nameForGetInTouch = @"";
        [cell.txtName becomeFirstResponder];
    }
    else if ([phoneForGetInTouch isEqualToString:@""])
    {
        ShowAlert(AlertTitle, @"Please enter phone number.");
        phoneForGetInTouch = @"";
        [cell.txtPhone becomeFirstResponder];
    }
    else if([emailForGetInTouch isEqualToString:@""])
    {
        ShowAlert(AlertTitle, @"Please enter Email.");
        emailForGetInTouch = @"";
        [cell.txtEmail becomeFirstResponder];
    }
    else if(!isValidEmail)
    {
        ShowAlert(AlertTitle, @"Please enter a valid Email Address.");
        [cell.txtEmail becomeFirstResponder];
    }
    else if ([commentForGetInTouch isEqualToString:@""]) {
        ShowAlert(AlertTitle, @"Please enter comment.");
        [cell.txtComment becomeFirstResponder];
    }
    else
    {
        [self callGetInTouchWebservice];
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
    
    ReportBarCell *cell = (ReportBarCell *)[self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:34]];
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
    ReportBarCell *cell = (ReportBarCell *)[self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:34]];
    
    
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
#pragma mark TakeALookCell Cell Configuration
- (TakeALookCell *)TakeALookCellAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"TakeALookCell";
    
    TakeALookCell *cell = (TakeALookCell *)[self.tblView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib;
        if([CommonUtils isiPad])
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"TakeALookCell-ipad" owner:self options:nil];
        }
        else
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"TakeALookCell" owner:self options:nil];
        }
        cell = [nib objectAtIndex:0];
    }
    
    cell.delegate = self;
    
    NSString *bar_video_link = fullMugBar.barDetail.bar_video_link;

    cell.imgYoutubeThumbnail.hidden = NO;
    cell.playerView.hidden = YES;

    if ([bar_video_link length]!=0) {
        NSURL *url = [NSURL URLWithString:bar_video_link];
        NSString *youtubeID = [HCYoutubeParser youtubeIDFromYoutubeURL:url];
        
        [cell.imgYoutubeThumbnail sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"waitvideo.png"]];
        
        cell.bar_video_link = bar_video_link;
        cell.youtubeID = youtubeID;
        
        [cell configureCellForYoutube];
    }
    else {
        [cell.imgYoutubeThumbnail setImage:[UIImage imageNamed:@"novideo.png"]];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
}

-(void)tapYoutubeVideo:(NSString *)videoURL
{
    VideoViewController *videoView;
    if([CommonUtils isiPad])
    {
        videoView = [[VideoViewController alloc] initWithNibName:@"VideoViewController_iPad" bundle:nil];
    }
    else
    {
        videoView = [[VideoViewController alloc] initWithNibName:@"VideoViewController" bundle:nil];
    }
    
    videoView.VideoUrl = videoURL;//[dictGroupDetails valueForKey:@"video_link"];
    [self.navigationController pushViewController:videoView animated:YES];
}


//-(void)setYouTubeThumbnailImage {
//    
//    TakeALookCell *cell = (TakeALookCell *)[self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:21]];
//
//    
//    if (!imgTakeLook) {
//        
//       
//        
//        [cell.imgYoutubeThumbnail sd_setImageWithURL:thumbURL placeholderImage:nil];
////
////        [HCYoutubeParser thumbnailForYoutubeURL:url thumbnailSize:YouTubeThumbnailDefaultHighQuality completeBlock:^(UIImage *image, NSError *error) {
////            
////            if (!error) {
////                //[_playButton setBackgroundImage:image forState:UIControlStateNormal];
////                
////                [HCYoutubeParser h264videosWithYoutubeURL:url completeBlock:^(NSDictionary *videoDictionary, NSError *error) {
////                    
////                    NSDictionary *qualities = videoDictionary;
////                    
////                    NSString *URLString = nil;
////                    if ([qualities objectForKey:@"small"] != nil) {
////                        URLString = [qualities objectForKey:@"small"];
////                    }
////                    else if ([qualities objectForKey:@"live"] != nil) {
////                        URLString = [qualities objectForKey:@"live"];
////                    }
////                    else {
////                        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Couldn't find youtube video" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil] show];
////                        return;
////                    }
////                    imgTakeLook = image;
////                    [cell.imgYoutubeThumbnail ];
////                    //[_playButton setImage:[UIImage imageNamed:@"play_button"] forState:UIControlStateNormal];
////                }];
////            }
////            else {
////                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
////                [alert show];
////            }
////        }];
//
//    }
//    else {
//        [cell.imgYoutubeThumbnail setImage:imgTakeLook];
//    }
//    
//    
//}

#pragma mark
#pragma mark BarGalleryCell Cell Configuration
- (BarGalleryCell *)BarGalleryCellAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"BarGalleryCell";
    
    BarGalleryCell *cell = (BarGalleryCell *)[self.tblView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib;
        if([CommonUtils isiPad])
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"BarGalleryCell-ipad" owner:self options:nil];
        }
        else
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"BarGalleryCell" owner:self options:nil];
        }
        
        
        cell = [nib objectAtIndex:0];
    }
    cell.delegate = self;
    
    if(fullMugBar.aryBarGallery.count>0) {
        BarGallery *barGallery = [fullMugBar.aryBarGallery objectAtIndex:selectedIndex];
        NSString *bargal_title = [barGallery bargal_title];
        cell.lblBarTitle.text = bargal_title;
        
        NSString *bargal_image_name = [barGallery bargal_image_name];
        NSString *strImgURL = [NSString stringWithFormat:@"%@%@%@",WEBIMAGE_URL,BARGALLARY_LARGE,bargal_image_name];
        NSURL *imgURL = [NSURL URLWithString:strImgURL];
        [cell.imgBarLarge sd_setImageWithURL:imgURL placeholderImage:[UIImage imageNamed:@"bar-gallery-large-placeholder.png"]];
        
        [cell configureBarGalleryThumbnailCellWith:fullMugBar.aryBarGallery withOriginalImageURL:barGallery.bargal_OriginalImageURL forImageType:BARGALLARY_SMALL];
        cell.lblNoData.hidden = YES;
    }
    else {
        cell.lblBarTitle.hidden = YES;
        cell.viewShadow.hidden = YES;
        [cell.imgBarLarge sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"bar-gallery-placeholder.png"]];
        cell.imgBarLarge.hidden = YES;
        cell.lblNoData.hidden = NO;
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
}

#pragma mark BarGalleryCell Delegates
-(void)presentImageViewController:(JTSImageViewController *)jtvc
{
    //isPictureClicked = YES;
    [jtvc showFromViewController:self transition:JTSImageViewControllerTransition_FromOriginalPosition];
}

-(void)didSelectThumbnailImage:(UIImage *)img AtIndexPath:(NSIndexPath *)indexPath forCell:(BarGalleryCell *)cell {
    if(fullMugBar.aryBarGallery.count>0) {
        selectedIndex = indexPath.item;
        
        BarGallery *barGallery = [fullMugBar.aryBarGallery objectAtIndex:selectedIndex];
        
        NSString *bargal_image_name = [barGallery bargal_image_name];
        NSString *strImgURL = [NSString stringWithFormat:@"%@%@%@",WEBIMAGE_URL,BARGALLARY_LARGE,bargal_image_name];
        NSURL *imgURL = [NSURL URLWithString:strImgURL];
        
        
        
        //BarGalleryCell *cell = (BarGalleryCell *)[self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:10]];
        [cell.imgBarLarge sd_setImageWithURL:imgURL placeholderImage:[UIImage imageNamed:@"bar-gallery-large-placeholder.png"]];

    }
}

#pragma mark
#pragma mark HoursOpenCell Cell Configuration
- (HoursOpenCell *)HoursOpenCellAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"HoursOpenCell";
    
    HoursOpenCell *cell = (HoursOpenCell *)[self.tblView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib;
        if([CommonUtils isiPad])
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"HoursOpenCell" owner:self options:nil];
        }
        else
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"HoursOpenCell" owner:self options:nil];
        }
        cell = [nib objectAtIndex:0];
    }
    BarHour *barHour = [[fullMugBar aryBarHours] objectAtIndex:indexPath.row];
    
    cell.lblDay.text = barHour.barHour_days;
    
    if ([barHour.barHour_is_closed isEqualToString:@"yes"]) {
        cell.lblTime.text = @"Closed";
    }
    else {
        cell.lblTime.text = [NSString stringWithFormat:@"%@-%@",[barHour.barHour_start_from lowercaseString],[barHour.barHour_start_to lowercaseString]];
    }
    
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
}

#pragma mark
#pragma mark PaymentTypeOnlyUpCell Cell Configuration
- (PaymentTypeOnlyUpCell *)PaymentTypeOnlyUpCellAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"PaymentTypeOnlyUpCell";
    
    PaymentTypeOnlyUpCell *cell = (PaymentTypeOnlyUpCell *)[self.tblView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib;
        if([CommonUtils isiPad])
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"PaymentTypeOnlyUpCell" owner:self options:nil];
        }
        else
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"PaymentTypeOnlyUpCell" owner:self options:nil];
        }
        cell = [nib objectAtIndex:0];
    }
    [cell configurePaymentUpCellWith:fullMugBar.barDetail.aryPaymentTypes_Up];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}


#pragma mark
#pragma mark PaymentTypeOnlyDownCell Cell Configuration
- (PaymentTypeOnlyDownCell *)PaymentTypeOnlyDownCellAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"PaymentTypeOnlyDownCell";
    
    PaymentTypeOnlyDownCell *cell = (PaymentTypeOnlyDownCell *)[self.tblView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib;
        if([CommonUtils isiPad])
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"PaymentTypeOnlyDownCell" owner:self options:nil];
        }
        else
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"PaymentTypeOnlyDownCell" owner:self options:nil];
        }
        cell = [nib objectAtIndex:0];
    }
    [cell configurePaymentDownCellWith:fullMugBar.barDetail.aryPaymentTypes_Down];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
}


#pragma mark
#pragma mark PaymentTypeFullCell Cell Configuration
- (PaymentTypeFullCell *)PaymentTypeFullCellAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"PaymentTypeFullCell";
    
    PaymentTypeFullCell *cell = (PaymentTypeFullCell *)[self.tblView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib;
        if([CommonUtils isiPad])
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"PaymentTypeFullCell" owner:self options:nil];
        }
        else
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"PaymentTypeFullCell" owner:self options:nil];
        }
        cell = [nib objectAtIndex:0];
    }
    [cell configurePaymentCellWith:fullMugBar.barDetail.aryPaymentTypes_Up and:fullMugBar.barDetail.aryPaymentTypes_Down];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
}

#pragma mark
#pragma mark PaymentTypeEmptyCell Cell Configuration
- (PaymentTypeCell *)PaymentTypeCellAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"PaymentTypeCell";
    
    PaymentTypeCell *cell = (PaymentTypeCell *)[self.tblView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib;
        if([CommonUtils isiPad])
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"PaymentTypeCell" owner:self options:nil];
        }
        else
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"PaymentTypeCell" owner:self options:nil];
        }
        cell = [nib objectAtIndex:0];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
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

    
    [cell.btnShare addTarget:self action:@selector(btnShare_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.btnFb addTarget:self action:@selector(btnFb_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnTwitter addTarget:self action:@selector(btnTwitter_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnLinkedIn addTarget:self action:@selector(btnLinkedIn_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnGooglePlus addTarget:self action:@selector(btnGooglePlus_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnDribble addTarget:self action:@selector(btnDribble_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnPintrest addTarget:self action:@selector(btnPintrest_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.btnAddToFav addTarget:self action:@selector(btnAddToFav_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnLikeThisBar addTarget:self action:@selector(btnLikeThisBar_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
}

-(void)btnFb_Clicked:(UIButton *)btnShare {
    NSString *strURL = fullMugBar.barDetail.bar_facebook_link;
    NSURL *URL = [NSURL URLWithString:strURL];
    [[UIApplication sharedApplication] openURL:URL];
}
-(void)btnTwitter_Clicked:(UIButton *)btnShare {
    NSString *strURL = fullMugBar.barDetail.bar_twitter_link;
    NSURL *URL = [NSURL URLWithString:strURL];
    [[UIApplication sharedApplication] openURL:URL];
}
-(void)btnLinkedIn_Clicked:(UIButton *)btnShare {
    NSString *strURL = fullMugBar.barDetail.bar_linkedin_link;
    NSURL *URL = [NSURL URLWithString:strURL];
    [[UIApplication sharedApplication] openURL:URL];
}
-(void)btnGooglePlus_Clicked:(UIButton *)btnShare {
    NSString *strURL = fullMugBar.barDetail.bar_google_plus_link;
    NSURL *URL = [NSURL URLWithString:strURL];
    [[UIApplication sharedApplication] openURL:URL];
}
-(void)btnDribble_Clicked:(UIButton *)btnShare {
    NSString *strURL = fullMugBar.barDetail.bar_dribble_link;
    NSURL *URL = [NSURL URLWithString:strURL];
    [[UIApplication sharedApplication] openURL:URL];
}
-(void)btnPintrest_Clicked:(UIButton *)btnShare {
    NSString *strURL = fullMugBar.barDetail.bar_pinterest_link;
    NSURL *URL = [NSURL URLWithString:strURL];
    [[UIApplication sharedApplication] openURL:URL];
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
    else if([fullMugBar.aryBarReviews count] > 0) {
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
    
    if (indexPath.section == 3) {
        cell.lblTitle.text = @"Description :";
    }
    else {
        cell.lblTitle.text = @"Payment Types Accepted :";
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
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    //cell.delegate = self;
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
    GetDirectionsViewController *getDirection = [[GetDirectionsViewController alloc] initWithNibName:@"GetDirectionsViewController" bundle:nil];
    getDirection.isFromGetDirection = NO;
    getDirection.lat = [NSString stringWithFormat:@"%@",fullMugBar.barDetail.bar_lat];
    getDirection.lng = [NSString stringWithFormat:@"%@",fullMugBar.barDetail.bar_lang];
    getDirection.address_Unformated = fullMugBar.barDetail.fullAddress_Unformated;
    getDirection.address_Formated = fullMugBar.barDetail.fullAddress;
    [self.navigationController pushViewController:getDirection animated:YES];
    NSLog(@"%@",label.text);
}

- (void)attributedLabel:(TTTAttributedLabel *)label
didSelectLinkWithPhoneNumber:(NSString *)phoneNumber {
    if ([label.text length]==0) {
        ShowAlert(AlertTitle, @"No phone number found");
        return;
    }
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

#pragma mark Phone Delegate
-(void)phoneTapped:(BasicCell *)cell {
    NSString *phoneNumber = [@"tel://" stringByAppendingString:fullMugBar.barDetail.bar_phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}

#pragma mark
#pragma mark BarEventsCell Cell Configuration
- (BarEventsCell *)BarEventsCellAtIndexPath:(NSIndexPath *)indexPath
{
    static BarEventsCell *cell = nil;
    cell = [self.tblView dequeueReusableCellWithIdentifier:BarEventsCellIdentifier];
    [self configureBarEventsCell:cell atIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)configureBarEventsCell:(BarEventsCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    BarEvent *barEvent = [[fullMugBar aryBarEvents] objectAtIndex:indexPath.row];
    cell.lblEventTitle.text = [CommonUtils removeHTMLFromString:barEvent.barEvent_event_title];
    cell.lblEventDesc.text = [CommonUtils removeHTMLFromString:barEvent.barEvent_event_desc];
    cell.lblEventDateTime.text = [CommonUtils removeHTMLFromString:barEvent.barEvent_start_date];
    
    NSString *event_logo = [barEvent barEvent_event_image];
    NSString *strImgURL = [NSString stringWithFormat:@"%@%@%@",WEBIMAGE_URL,BAR_EVENT,event_logo];
    NSURL *imgURL = [NSURL URLWithString:strImgURL];
    
    [cell.imgBarEvent sd_setImageWithURL:imgURL placeholderImage:[UIImage imageNamed:@"event-placeholder.png"]];
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

- (void)configureRavesAndRentsCell:(RavesAndRentsCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    BarReview *barReview = [[fullMugBar aryBarReviews] objectAtIndex:indexPath.row];
    int rate = [barReview.review_bar_rating intValue];
    
    cell.lblComment.text = [CommonUtils removeHTMLFromString:barReview.review_comment];
    cell.lblReviewTitle.text = [CommonUtils removeHTMLFromString:barReview.review_comment_title];
    cell.lblDateTime.text = [CommonUtils removeHTMLFromString:barReview.review_date_added];
    cell.lblPostedBy.text = [NSString stringWithFormat:@"%@ %@",
                             [CommonUtils removeHTMLFromString:barReview.review_first_name],
                             [CommonUtils removeHTMLFromString:barReview.review_last_name]];
    
    //NSString *strDuration = [[CommonUtils getDateFromString:barReview.review_date_added withFormat:@"yyyy-MM-dd HH:mm:ss"] formattedAsTimeAgo];
    //cell.lblDuration.text = strDuration;
    //cell.lblDateTime.text = strDuration;
    [cell setBarRatingsBy:rate];
}

#pragma mark
#pragma mark BarSpecialHoursCell Cell Configuration
- (BarSpecialHoursCell *)BarSpecialHoursCellAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    switch ([[[fullMugBar.sph.aryHours objectAtIndex:indexPath.row] arySpecialHours] count] - 1)
    {
        case 0:
        {
            static NSString *simpleTableIdentifier = @"BarSpecialHoursCell";
            BarSpecialHoursCell *cell = (BarSpecialHoursCell *)[self.tblView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            
            NSLog(@"case = %ld",[[[fullMugBar.sph.aryHours objectAtIndex:indexPath.row] arySpecialHours] count] - 1);
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BarSpecialHoursCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            cell.lblDay.text = [[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] sph_day];
            cell.lblDuration.text = [[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] sph_time];
            cell.lblName0.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:0] sph_detail] cat];
            cell.lblNameValue0.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:0] sph_detail] detailName];
            cell.lblPrice0.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:0] sph_price];
            
            if([CommonUtils isiPad]) {
                cell.lblDay.font = [UIFont fontWithName:@"Verdana" size:20.0f];
                cell.lblDuration.font = [UIFont fontWithName:@"Verdana" size:20.0f];
            }
            else {
                cell.lblDay.font = [UIFont fontWithName:@"Verdana" size:17.0f];
                cell.lblDuration.font = [UIFont fontWithName:@"Verdana" size:17.0f];
            }
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
            break;
        case 1:
        {
            static NSString *simpleTableIdentifier = @"BarSpecialHoursCell";
            BarSpecialHoursCell *cell = (BarSpecialHoursCell *)[self.tblView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
           NSLog(@"case = %ld",[[[fullMugBar.sph.aryHours objectAtIndex:indexPath.row] arySpecialHours] count] - 1);
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BarSpecialHoursCell1" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            cell.lblDay.text = [[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] sph_day];
            cell.lblDuration.text = [[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] sph_time];
            
            cell.lblName0.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:0] sph_detail] cat];
            cell.lblNameValue0.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:0] sph_detail] detailName];
            cell.lblPrice0.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:0] sph_price];
            
            cell.lblName1.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:1] sph_detail] cat];
            cell.lblNameValue1.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:1] sph_detail] detailName];
            cell.lblPrice1.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:1] sph_price];
            
            if([CommonUtils isiPad]) {
                cell.lblDay.font = [UIFont fontWithName:@"Verdana" size:20.0f];
                cell.lblDuration.font = [UIFont fontWithName:@"Verdana" size:20.0f];
            }
            else {
                cell.lblDay.font = [UIFont fontWithName:@"Verdana" size:17.0f];
                cell.lblDuration.font = [UIFont fontWithName:@"Verdana" size:17.0f];
            }
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
            break;
        case 2:
        {
            static NSString *simpleTableIdentifier = @"BarSpecialHoursCell";
            BarSpecialHoursCell *cell = (BarSpecialHoursCell *)[self.tblView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            NSLog(@"case = %ld",[[[fullMugBar.sph.aryHours objectAtIndex:indexPath.row] arySpecialHours] count] - 1);
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BarSpecialHoursCell2" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            cell.lblDay.text = [[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] sph_day];
            cell.lblDuration.text = [[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] sph_time];
            
            cell.lblName0.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:0] sph_detail] cat];
            cell.lblNameValue0.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:0] sph_detail] detailName];
            cell.lblPrice0.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:0] sph_price];
            
            cell.lblName1.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:1] sph_detail] cat];
            cell.lblNameValue1.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:1] sph_detail] detailName];
            cell.lblPrice1.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:1] sph_price];
            
            cell.lblName2.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:2] sph_detail] cat];
            cell.lblNameValue2.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:2] sph_detail] detailName];
            cell.lblPrice2.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:2] sph_price];
            
            if([CommonUtils isiPad]) {
                cell.lblDay.font = [UIFont fontWithName:@"Verdana" size:20.0f];
                cell.lblDuration.font = [UIFont fontWithName:@"Verdana" size:20.0f];
            }
            else {
                cell.lblDay.font = [UIFont fontWithName:@"Verdana" size:17.0f];
                cell.lblDuration.font = [UIFont fontWithName:@"Verdana" size:17.0f];
            }
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
            break;
        case 3:
        {
            static NSString *simpleTableIdentifier = @"BarSpecialHoursCell";
            BarSpecialHoursCell *cell = (BarSpecialHoursCell *)[self.tblView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            NSLog(@"case = %ld",[[[fullMugBar.sph.aryHours objectAtIndex:indexPath.row] arySpecialHours] count] - 1);
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BarSpecialHoursCell3" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            cell.lblDay.text = [[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] sph_day];
            cell.lblDuration.text = [[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] sph_time];
            
            cell.lblName0.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:0] sph_detail] cat];
            cell.lblNameValue0.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:0] sph_detail] detailName];
            cell.lblPrice0.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:0] sph_price];
            
            cell.lblName1.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:1] sph_detail] cat];
            cell.lblNameValue1.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:1] sph_detail] detailName];
            cell.lblPrice1.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:1] sph_price];
            
            cell.lblName2.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:2] sph_detail] cat];
            cell.lblNameValue2.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:2] sph_detail] detailName];
            cell.lblPrice2.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:2] sph_price];
            
            cell.lblName3.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:3] sph_detail] cat];
            cell.lblNameValue3.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:3] sph_detail] detailName];
            cell.lblPrice3.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:3] sph_price];
            
            if([CommonUtils isiPad]) {
                cell.lblDay.font = [UIFont fontWithName:@"Verdana" size:20.0f];
                cell.lblDuration.font = [UIFont fontWithName:@"Verdana" size:20.0f];
            }
            else {
                cell.lblDay.font = [UIFont fontWithName:@"Verdana" size:17.0f];
                cell.lblDuration.font = [UIFont fontWithName:@"Verdana" size:17.0f];
            }
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
            break;
        case 4:
        {
            static NSString *simpleTableIdentifier = @"BarSpecialHoursCell";
            BarSpecialHoursCell *cell = (BarSpecialHoursCell *)[self.tblView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            NSLog(@"case = %ld",[[[fullMugBar.sph.aryHours objectAtIndex:indexPath.row] arySpecialHours] count] - 1);
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BarSpecialHoursCell4" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            cell.lblDay.text = [[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] sph_day];
            cell.lblDuration.text = [[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] sph_time];
            
            cell.lblName0.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:0] sph_detail] cat];
            cell.lblNameValue0.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:0] sph_detail] detailName];
            cell.lblPrice0.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:0] sph_price];
            
            cell.lblName1.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:1] sph_detail] cat];
            cell.lblNameValue1.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:1] sph_detail] detailName];
            cell.lblPrice1.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:1] sph_price];
            
            cell.lblName2.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:2] sph_detail] cat];
            cell.lblNameValue2.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:2] sph_detail] detailName];
            cell.lblPrice2.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:2] sph_price];
            
            cell.lblName3.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:3] sph_detail] cat];
            cell.lblNameValue3.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:3] sph_detail] detailName];
            cell.lblPrice3.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:3] sph_price];
            
            cell.lblName4.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:4] sph_detail] cat];
            cell.lblNameValue4.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:4] sph_detail] detailName];
            cell.lblPrice4.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:4] sph_price];
            
            if([CommonUtils isiPad]) {
                cell.lblDay.font = [UIFont fontWithName:@"Verdana" size:20.0f];
                cell.lblDuration.font = [UIFont fontWithName:@"Verdana" size:20.0f];
            }
            else {
                cell.lblDay.font = [UIFont fontWithName:@"Verdana" size:17.0f];
                cell.lblDuration.font = [UIFont fontWithName:@"Verdana" size:17.0f];
            }
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
            break;
        case 5:
        {
            static NSString *simpleTableIdentifier = @"BarSpecialHoursCell";
            BarSpecialHoursCell *cell = (BarSpecialHoursCell *)[self.tblView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            NSLog(@"case = %ld",[[[fullMugBar.sph.aryHours objectAtIndex:indexPath.row] arySpecialHours] count] - 1);
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BarSpecialHoursCell5" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            cell.lblDay.text = [[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] sph_day];
            cell.lblDuration.text = [[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] sph_time];
            
            cell.lblName0.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:0] sph_detail] cat];
            cell.lblNameValue0.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:0] sph_detail] detailName];
            cell.lblPrice0.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:0] sph_price];
            
            cell.lblName1.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:1] sph_detail] cat];
            cell.lblNameValue1.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:1] sph_detail] detailName];
            cell.lblPrice1.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:1] sph_price];
            
            cell.lblName2.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:2] sph_detail] cat];
            cell.lblNameValue2.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:2] sph_detail] detailName];
            cell.lblPrice2.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:2] sph_price];
            
            cell.lblName3.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:3] sph_detail] cat];
            cell.lblNameValue3.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:3] sph_detail] detailName];
            cell.lblPrice3.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:3] sph_price];
            
            cell.lblName4.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:4] sph_detail] cat];
            cell.lblNameValue4.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:4] sph_detail] detailName];
            cell.lblPrice4.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:4] sph_price];
            
            cell.lblName5.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:5] sph_detail] cat];
            cell.lblNameValue5.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:5] sph_detail] detailName];
            cell.lblPrice5.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:5] sph_price];
            
            if([CommonUtils isiPad]) {
                cell.lblDay.font = [UIFont fontWithName:@"Verdana" size:20.0f];
                cell.lblDuration.font = [UIFont fontWithName:@"Verdana" size:20.0f];
            }
            else {
                cell.lblDay.font = [UIFont fontWithName:@"Verdana" size:17.0f];
                cell.lblDuration.font = [UIFont fontWithName:@"Verdana" size:17.0f];
            }
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
            break;
        case 6:
        {
            static NSString *simpleTableIdentifier = @"BarSpecialHoursCell";
            BarSpecialHoursCell *cell = (BarSpecialHoursCell *)[self.tblView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            NSLog(@"case = %ld",[[[fullMugBar.sph.aryHours objectAtIndex:indexPath.row] arySpecialHours] count] - 1);
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BarSpecialHoursCell6" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            cell.lblDay.text = [[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] sph_day];
            cell.lblDuration.text = [[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] sph_time];
            
            cell.lblName0.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:0] sph_detail] cat];
            cell.lblNameValue0.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:0] sph_detail] detailName];
            cell.lblPrice0.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:0] sph_price];
            
            cell.lblName1.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:1] sph_detail] cat];
            cell.lblNameValue1.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:1] sph_detail] detailName];
            cell.lblPrice1.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:1] sph_price];
            
            cell.lblName2.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:2] sph_detail] cat];
            cell.lblNameValue2.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:2] sph_detail] detailName];
            cell.lblPrice2.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:2] sph_price];
            
            cell.lblName3.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:3] sph_detail] cat];
            cell.lblNameValue3.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:3] sph_detail] detailName];
            cell.lblPrice3.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:3] sph_price];
            
            cell.lblName4.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:4] sph_detail] cat];
            cell.lblNameValue4.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:4] sph_detail] detailName];
            cell.lblPrice4.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:4] sph_price];
            
            cell.lblName5.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:5] sph_detail] cat];
            cell.lblNameValue5.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:5] sph_detail] detailName];
            cell.lblPrice5.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:5] sph_price];
            
            cell.lblName6.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:6] sph_detail] cat];
            cell.lblNameValue6.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:6] sph_detail] detailName];
            cell.lblPrice6.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:6] sph_price];
            
            if([CommonUtils isiPad]) {
                cell.lblDay.font = [UIFont fontWithName:@"Verdana" size:20.0f];
                cell.lblDuration.font = [UIFont fontWithName:@"Verdana" size:20.0f];
            }
            else {
                cell.lblDay.font = [UIFont fontWithName:@"Verdana" size:17.0f];
                cell.lblDuration.font = [UIFont fontWithName:@"Verdana" size:17.0f];
            }
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
            break;
        case 7:
        {
            static NSString *simpleTableIdentifier = @"BarSpecialHoursCell";
            BarSpecialHoursCell *cell = (BarSpecialHoursCell *)[self.tblView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            NSLog(@"case = %ld",[[[fullMugBar.sph.aryHours objectAtIndex:indexPath.row] arySpecialHours] count] - 1);
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BarSpecialHoursCell7" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            cell.lblDay.text = [[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] sph_day];
            cell.lblDuration.text = [[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] sph_time];
            
            cell.lblName0.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:0] sph_detail] cat];
            cell.lblNameValue0.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:0] sph_detail] detailName];
            cell.lblPrice0.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:0] sph_price];
            
            cell.lblName1.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:1] sph_detail] cat];
            cell.lblNameValue1.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:1] sph_detail] detailName];
            cell.lblPrice1.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:1] sph_price];
            
            cell.lblName2.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:2] sph_detail] cat];
            cell.lblNameValue2.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:2] sph_detail] detailName];
            cell.lblPrice2.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:2] sph_price];
            
            cell.lblName3.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:3] sph_detail] cat];
            cell.lblNameValue3.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:3] sph_detail] detailName];
            cell.lblPrice3.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:3] sph_price];
            
            cell.lblName4.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:4] sph_detail] cat];
            cell.lblNameValue4.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:4] sph_detail] detailName];
            cell.lblPrice4.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:4] sph_price];
            
            cell.lblName5.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:5] sph_detail] cat];
            cell.lblNameValue5.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:5] sph_detail] detailName];
            cell.lblPrice5.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:5] sph_price];
            
            cell.lblName6.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:6] sph_detail] cat];
            cell.lblNameValue6.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:6] sph_detail] detailName];
            cell.lblPrice6.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:6] sph_price];
            
            cell.lblName7.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:7] sph_detail] cat];
            cell.lblNameValue7.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:7] sph_detail] detailName];
            cell.lblPrice7.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:7] sph_price];
            
            if([CommonUtils isiPad]) {
                cell.lblDay.font = [UIFont fontWithName:@"Verdana" size:20.0f];
                cell.lblDuration.font = [UIFont fontWithName:@"Verdana" size:20.0f];
            }
            else {
                cell.lblDay.font = [UIFont fontWithName:@"Verdana" size:17.0f];
                cell.lblDuration.font = [UIFont fontWithName:@"Verdana" size:17.0f];
            }
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
            break;
        case 8:
        {
            static NSString *simpleTableIdentifier = @"BarSpecialHoursCell";
            BarSpecialHoursCell *cell = (BarSpecialHoursCell *)[self.tblView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            NSLog(@"case = %ld",[[[fullMugBar.sph.aryHours objectAtIndex:indexPath.row] arySpecialHours] count] - 1);
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BarSpecialHoursCell8" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            cell.lblDay.text = [[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] sph_day];
            cell.lblDuration.text = [[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] sph_time];
            
            cell.lblName0.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:0] sph_detail] cat];
            cell.lblNameValue0.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:0] sph_detail] detailName];
            cell.lblPrice0.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:0] sph_price];
            
            cell.lblName1.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:1] sph_detail] cat];
            cell.lblNameValue1.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:1] sph_detail] detailName];
            cell.lblPrice1.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:1] sph_price];
            
            cell.lblName2.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:2] sph_detail] cat];
            cell.lblNameValue2.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:2] sph_detail] detailName];
            cell.lblPrice2.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:2] sph_price];
            
            cell.lblName3.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:3] sph_detail] cat];
            cell.lblNameValue3.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:3] sph_detail] detailName];
            cell.lblPrice3.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:3] sph_price];
            
            cell.lblName4.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:4] sph_detail] cat];
            cell.lblNameValue4.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:4] sph_detail] detailName];
            cell.lblPrice4.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:4] sph_price];
            
            cell.lblName5.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:5] sph_detail] cat];
            cell.lblNameValue5.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:5] sph_detail] detailName];
            cell.lblPrice5.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:5] sph_price];
            
            cell.lblName6.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:6] sph_detail] cat];
            cell.lblNameValue6.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:6] sph_detail] detailName];
            cell.lblPrice6.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:6] sph_price];
            
            cell.lblName7.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:7] sph_detail] cat];
            cell.lblNameValue7.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:7] sph_detail] detailName];
            cell.lblPrice7.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:7] sph_price];
            
            cell.lblName8.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:8] sph_detail] cat];
            cell.lblNameValue8.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:8] sph_detail] detailName];
            cell.lblPrice8.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:8] sph_price];
            
            if([CommonUtils isiPad]) {
                cell.lblDay.font = [UIFont fontWithName:@"Verdana" size:20.0f];
                cell.lblDuration.font = [UIFont fontWithName:@"Verdana" size:20.0f];
            }
            else {
                cell.lblDay.font = [UIFont fontWithName:@"Verdana" size:17.0f];
                cell.lblDuration.font = [UIFont fontWithName:@"Verdana" size:17.0f];
            }
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
            break;
        case 9:
        {
            static NSString *simpleTableIdentifier = @"BarSpecialHoursCell";
            BarSpecialHoursCell *cell = (BarSpecialHoursCell *)[self.tblView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            NSLog(@"case = %ld",[[[fullMugBar.sph.aryHours objectAtIndex:indexPath.row] arySpecialHours] count] - 1);
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BarSpecialHoursCell9" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            cell.lblDay.text = [[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] sph_day];
            cell.lblDuration.text = [[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] sph_time];
            
            cell.lblName0.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:0] sph_detail] cat];
            cell.lblNameValue0.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:0] sph_detail] detailName];
            cell.lblPrice0.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:0] sph_price];
            
            cell.lblName1.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:1] sph_detail] cat];
            cell.lblNameValue1.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:1] sph_detail] detailName];
            cell.lblPrice1.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:1] sph_price];
            
            cell.lblName2.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:2] sph_detail] cat];
            cell.lblNameValue2.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:2] sph_detail] detailName];
            cell.lblPrice2.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:2] sph_price];
            
            cell.lblName3.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:3] sph_detail] cat];
            cell.lblNameValue3.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:3] sph_detail] detailName];
            cell.lblPrice3.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:3] sph_price];
            
            cell.lblName4.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:4] sph_detail] cat];
            cell.lblNameValue4.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:4] sph_detail] detailName];
            cell.lblPrice4.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:4] sph_price];
            
            cell.lblName5.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:5] sph_detail] cat];
            cell.lblNameValue5.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:5] sph_detail] detailName];
            cell.lblPrice5.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:5] sph_price];
            
            cell.lblName6.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:6] sph_detail] cat];
            cell.lblNameValue6.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:6] sph_detail] detailName];
            cell.lblPrice6.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:6] sph_price];
            
            cell.lblName7.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:7] sph_detail] cat];
            cell.lblNameValue7.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:7] sph_detail] detailName];
            cell.lblPrice7.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:7] sph_price];
            
            cell.lblName8.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:8] sph_detail] cat];
            cell.lblNameValue8.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:8] sph_detail] detailName];
            cell.lblPrice8.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:8] sph_price];
            
            cell.lblName9.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:9] sph_detail] cat];
            cell.lblNameValue9.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:9] sph_detail] detailName];
            cell.lblPrice9.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:9] sph_price];
            
            if([CommonUtils isiPad]) {
                cell.lblDay.font = [UIFont fontWithName:@"Verdana" size:20.0f];
                cell.lblDuration.font = [UIFont fontWithName:@"Verdana" size:20.0f];
            }
            else {
                cell.lblDay.font = [UIFont fontWithName:@"Verdana" size:17.0f];
                cell.lblDuration.font = [UIFont fontWithName:@"Verdana" size:17.0f];
            }
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
            break;
        case 10:
        {
            static NSString *simpleTableIdentifier = @"BarSpecialHoursCell";
            BarSpecialHoursCell *cell = (BarSpecialHoursCell *)[self.tblView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            NSLog(@"case = %ld",[[[fullMugBar.sph.aryHours objectAtIndex:indexPath.row] arySpecialHours] count] - 1);
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BarSpecialHoursCell" owner:self options:nil];
                cell = [nib objectAtIndex:10];
            }
            
            cell.lblDay.text = [[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] sph_day];
            cell.lblDuration.text = [[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] sph_time];
            
            cell.lblName0.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:0] sph_detail] cat];
            cell.lblNameValue0.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:0] sph_detail] detailName];
            cell.lblPrice0.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:0] sph_price];
            
            cell.lblName1.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:1] sph_detail] cat];
            cell.lblNameValue1.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:1] sph_detail] detailName];
            cell.lblPrice1.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:1] sph_price];
            
            cell.lblName2.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:2] sph_detail] cat];
            cell.lblNameValue2.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:2] sph_detail] detailName];
            cell.lblPrice2.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:2] sph_price];
            
            cell.lblName3.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:3] sph_detail] cat];
            cell.lblNameValue3.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:3] sph_detail] detailName];
            cell.lblPrice3.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:3] sph_price];
            
            cell.lblName4.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:4] sph_detail] cat];
            cell.lblNameValue4.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:4] sph_detail] detailName];
            cell.lblPrice4.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:4] sph_price];
            
            cell.lblName5.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:5] sph_detail] cat];
            cell.lblNameValue5.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:5] sph_detail] detailName];
            cell.lblPrice5.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:5] sph_price];
            
            cell.lblName6.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:6] sph_detail] cat];
            cell.lblNameValue6.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:6] sph_detail] detailName];
            cell.lblPrice6.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:6] sph_price];
            
            cell.lblName7.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:7] sph_detail] cat];
            cell.lblNameValue7.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:7] sph_detail] detailName];
            cell.lblPrice7.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:7] sph_price];
            
            cell.lblName8.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:8] sph_detail] cat];
            cell.lblNameValue8.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:8] sph_detail] detailName];
            cell.lblPrice8.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:8] sph_price];
            
            cell.lblName9.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:9] sph_detail] cat];
            cell.lblNameValue9.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:9] sph_detail] detailName];
            cell.lblPrice9.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:9] sph_price];
            
            cell.lblName10.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:10] sph_detail] cat];
            cell.lblNameValue10.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:10] sph_detail] detailName];
            cell.lblPrice10.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:10] sph_price];
            
            if([CommonUtils isiPad]) {
                cell.lblDay.font = [UIFont fontWithName:@"Verdana" size:20.0f];
                cell.lblDuration.font = [UIFont fontWithName:@"Verdana" size:20.0f];
            }
            else {
                cell.lblDay.font = [UIFont fontWithName:@"Verdana" size:17.0f];
                cell.lblDuration.font = [UIFont fontWithName:@"Verdana" size:17.0f];
            }
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
            break;
        case 11:
        {
            static NSString *simpleTableIdentifier = @"BarSpecialHoursCell";
            BarSpecialHoursCell *cell = (BarSpecialHoursCell *)[self.tblView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            NSLog(@"case = %ld",[[[fullMugBar.sph.aryHours objectAtIndex:indexPath.row] arySpecialHours] count] - 1);
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BarSpecialHoursCell" owner:self options:nil];
                cell = [nib objectAtIndex:11];
            }
            
            cell.lblDay.text = [[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] sph_day];
            cell.lblDuration.text = [[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] sph_time];
            
            cell.lblName0.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:0] sph_detail] cat];
            cell.lblNameValue0.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:0] sph_detail] detailName];
            cell.lblPrice0.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:0] sph_price];
            
            cell.lblName1.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:1] sph_detail] cat];
            cell.lblNameValue1.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:1] sph_detail] detailName];
            cell.lblPrice1.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:1] sph_price];
            
            cell.lblName2.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:2] sph_detail] cat];
            cell.lblNameValue2.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:2] sph_detail] detailName];
            cell.lblPrice2.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:2] sph_price];
            
            cell.lblName3.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:3] sph_detail] cat];
            cell.lblNameValue3.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:3] sph_detail] detailName];
            cell.lblPrice3.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:3] sph_price];
            
            cell.lblName4.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:4] sph_detail] cat];
            cell.lblNameValue4.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:4] sph_detail] detailName];
            cell.lblPrice4.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:4] sph_price];
            
            cell.lblName5.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:5] sph_detail] cat];
            cell.lblNameValue5.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:5] sph_detail] detailName];
            cell.lblPrice5.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:5] sph_price];
            
            cell.lblName6.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:6] sph_detail] cat];
            cell.lblNameValue6.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:6] sph_detail] detailName];
            cell.lblPrice6.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:6] sph_price];
            
            cell.lblName7.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:7] sph_detail] cat];
            cell.lblNameValue7.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:7] sph_detail] detailName];
            cell.lblPrice7.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:7] sph_price];
            
            cell.lblName8.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:8] sph_detail] cat];
            cell.lblNameValue8.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:8] sph_detail] detailName];
            cell.lblPrice8.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:8] sph_price];
            
            cell.lblName9.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:9] sph_detail] cat];
            cell.lblNameValue9.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:9] sph_detail] detailName];
            cell.lblPrice9.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:9] sph_price];
            
            cell.lblName10.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:10] sph_detail] cat];
            cell.lblNameValue10.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:10] sph_detail] detailName];
            cell.lblPrice10.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:10] sph_price];
            
            cell.lblName11.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:11] sph_detail] cat];
            cell.lblNameValue11.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:11] sph_detail] detailName];
            cell.lblPrice11.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:11] sph_price];
            
            if([CommonUtils isiPad]) {
                cell.lblDay.font = [UIFont fontWithName:@"Verdana" size:20.0f];
                cell.lblDuration.font = [UIFont fontWithName:@"Verdana" size:20.0f];
            }
            else {
                cell.lblDay.font = [UIFont fontWithName:@"Verdana" size:17.0f];
                cell.lblDuration.font = [UIFont fontWithName:@"Verdana" size:17.0f];
            }
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
            
        }
            break;
        case 12:
        {
            static NSString *simpleTableIdentifier = @"BarSpecialHoursCell";
            BarSpecialHoursCell *cell = (BarSpecialHoursCell *)[self.tblView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            NSLog(@"case = %ld",[[[fullMugBar.sph.aryHours objectAtIndex:indexPath.row] arySpecialHours] count] - 1);
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BarSpecialHoursCell" owner:self options:nil];
                cell = [nib objectAtIndex:12];
            }
            
            cell.lblDay.text = [[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] sph_day];
            cell.lblDuration.text = [[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] sph_time];
            
            cell.lblName0.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:0] sph_detail] cat];
            cell.lblNameValue0.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:0] sph_detail] detailName];
            cell.lblPrice0.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:0] sph_price];
            
            cell.lblName1.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:1] sph_detail] cat];
            cell.lblNameValue1.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:1] sph_detail] detailName];
            cell.lblPrice1.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:1] sph_price];
            
            cell.lblName2.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:2] sph_detail] cat];
            cell.lblNameValue2.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:2] sph_detail] detailName];
            cell.lblPrice2.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:2] sph_price];
            
            cell.lblName3.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:3] sph_detail] cat];
            cell.lblNameValue3.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:3] sph_detail] detailName];
            cell.lblPrice3.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:3] sph_price];
            
            cell.lblName4.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:4] sph_detail] cat];
            cell.lblNameValue4.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:4] sph_detail] detailName];
            cell.lblPrice4.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:4] sph_price];
            
            cell.lblName5.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:5] sph_detail] cat];
            cell.lblNameValue5.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:5] sph_detail] detailName];
            cell.lblPrice5.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:5] sph_price];
            
            cell.lblName6.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:6] sph_detail] cat];
            cell.lblNameValue6.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:6] sph_detail] detailName];
            cell.lblPrice6.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:6] sph_price];
            
            cell.lblName7.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:7] sph_detail] cat];
            cell.lblNameValue7.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:7] sph_detail] detailName];
            cell.lblPrice7.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:7] sph_price];
            
            cell.lblName8.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:8] sph_detail] cat];
            cell.lblNameValue8.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:8] sph_detail] detailName];
            cell.lblPrice8.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:8] sph_price];
            
            cell.lblName9.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:9] sph_detail] cat];
            cell.lblNameValue9.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:9] sph_detail] detailName];
            cell.lblPrice9.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:9] sph_price];
            
            cell.lblName10.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:10] sph_detail] cat];
            cell.lblNameValue10.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:10] sph_detail] detailName];
            cell.lblPrice10.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:10] sph_price];
            
            cell.lblName11.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:11] sph_detail] cat];
            cell.lblNameValue11.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:11] sph_detail] detailName];
            cell.lblPrice11.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:11] sph_price];
            
            cell.lblName12.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:12] sph_detail] cat];
            cell.lblNameValue12.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:12] sph_detail] detailName];
            cell.lblPrice12.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:12] sph_price];
            
            if([CommonUtils isiPad]) {
                cell.lblDay.font = [UIFont fontWithName:@"Verdana" size:20.0f];
                cell.lblDuration.font = [UIFont fontWithName:@"Verdana" size:20.0f];
            }
            else {
                cell.lblDay.font = [UIFont fontWithName:@"Verdana" size:17.0f];
                cell.lblDuration.font = [UIFont fontWithName:@"Verdana" size:17.0f];
            }
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
            break;
        case 13:
        {
            static NSString *simpleTableIdentifier = @"BarSpecialHoursCell";
            BarSpecialHoursCell *cell = (BarSpecialHoursCell *)[self.tblView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            NSLog(@"case = %ld",[[[fullMugBar.sph.aryHours objectAtIndex:indexPath.row] arySpecialHours] count] - 1);
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BarSpecialHoursCell" owner:self options:nil];
                cell = [nib objectAtIndex:13];
            }
            
            cell.lblDay.text = [[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] sph_day];
            cell.lblDuration.text = [[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] sph_time];
            
            cell.lblName0.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:0] sph_detail] cat];
            cell.lblNameValue0.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:0] sph_detail] detailName];
            cell.lblPrice0.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:0] sph_price];
            
            cell.lblName1.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:1] sph_detail] cat];
            cell.lblNameValue1.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:1] sph_detail] detailName];
            cell.lblPrice1.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:1] sph_price];
            
            cell.lblName2.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:2] sph_detail] cat];
            cell.lblNameValue2.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:2] sph_detail] detailName];
            cell.lblPrice2.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:2] sph_price];
            
            cell.lblName3.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:3] sph_detail] cat];
            cell.lblNameValue3.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:3] sph_detail] detailName];
            cell.lblPrice3.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:3] sph_price];
            
            cell.lblName4.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:4] sph_detail] cat];
            cell.lblNameValue4.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:4] sph_detail] detailName];
            cell.lblPrice4.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:4] sph_price];
            
            cell.lblName5.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:5] sph_detail] cat];
            cell.lblNameValue5.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:5] sph_detail] detailName];
            cell.lblPrice5.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:5] sph_price];
            
            cell.lblName6.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:6] sph_detail] cat];
            cell.lblNameValue6.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:6] sph_detail] detailName];
            cell.lblPrice6.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:6] sph_price];
            
            cell.lblName7.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:7] sph_detail] cat];
            cell.lblNameValue7.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:7] sph_detail] detailName];
            cell.lblPrice7.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:7] sph_price];
            
            cell.lblName8.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:8] sph_detail] cat];
            cell.lblNameValue8.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:8] sph_detail] detailName];
            cell.lblPrice8.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:8] sph_price];
            
            cell.lblName9.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:9] sph_detail] cat];
            cell.lblNameValue9.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:9] sph_detail] detailName];
            cell.lblPrice9.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:9] sph_price];
            
            cell.lblName10.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:10] sph_detail] cat];
            cell.lblNameValue10.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:10] sph_detail] detailName];
            cell.lblPrice10.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:10] sph_price];
            
            cell.lblName11.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:11] sph_detail] cat];
            cell.lblNameValue11.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:11] sph_detail] detailName];
            cell.lblPrice11.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:11] sph_price];
            
            cell.lblName12.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:12] sph_detail] cat];
            cell.lblNameValue12.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:12] sph_detail] detailName];
            cell.lblPrice12.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:12] sph_price];
            
            cell.lblName13.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:13] sph_detail] cat];
            cell.lblNameValue13.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:13] sph_detail] detailName];
            cell.lblPrice13.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:13] sph_price];
            
            if([CommonUtils isiPad]) {
                cell.lblDay.font = [UIFont fontWithName:@"Verdana" size:20.0f];
                cell.lblDuration.font = [UIFont fontWithName:@"Verdana" size:20.0f];
            }
            else {
                cell.lblDay.font = [UIFont fontWithName:@"Verdana" size:17.0f];
                cell.lblDuration.font = [UIFont fontWithName:@"Verdana" size:17.0f];
            }
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
            
        }
            break;
        case 14:
        {
            static NSString *simpleTableIdentifier = @"BarSpecialHoursCell";
            BarSpecialHoursCell *cell = (BarSpecialHoursCell *)[self.tblView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            NSLog(@"case = %ld",[[[fullMugBar.sph.aryHours objectAtIndex:indexPath.row] arySpecialHours] count] - 1);
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BarSpecialHoursCell" owner:self options:nil];
                cell = [nib objectAtIndex:14];
            }
            
            cell.lblDay.text = [[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] sph_day];
            cell.lblDuration.text = [[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] sph_time];
            
            cell.lblName0.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:0] sph_detail] cat];
            cell.lblNameValue0.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:0] sph_detail] detailName];
            cell.lblPrice0.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:0] sph_price];
            
            cell.lblName1.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:1] sph_detail] cat];
            cell.lblNameValue1.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:1] sph_detail] detailName];
            cell.lblPrice1.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:1] sph_price];
            
            cell.lblName2.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:2] sph_detail] cat];
            cell.lblNameValue2.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:2] sph_detail] detailName];
            cell.lblPrice2.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:2] sph_price];
            
            cell.lblName3.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:3] sph_detail] cat];
            cell.lblNameValue3.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:3] sph_detail] detailName];
            cell.lblPrice3.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:3] sph_price];
            
            cell.lblName4.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:4] sph_detail] cat];
            cell.lblNameValue4.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:4] sph_detail] detailName];
            cell.lblPrice4.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:4] sph_price];
            
            cell.lblName5.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:5] sph_detail] cat];
            cell.lblNameValue5.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:5] sph_detail] detailName];
            cell.lblPrice5.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:5] sph_price];
            
            cell.lblName6.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:6] sph_detail] cat];
            cell.lblNameValue6.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:6] sph_detail] detailName];
            cell.lblPrice6.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:6] sph_price];
            
            cell.lblName7.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:7] sph_detail] cat];
            cell.lblNameValue7.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:7] sph_detail] detailName];
            cell.lblPrice7.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:7] sph_price];
            
            cell.lblName8.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:8] sph_detail] cat];
            cell.lblNameValue8.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:8] sph_detail] detailName];
            cell.lblPrice8.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:8] sph_price];
            
            cell.lblName9.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:9] sph_detail] cat];
            cell.lblNameValue9.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:9] sph_detail] detailName];
            cell.lblPrice9.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:9] sph_price];
            
            cell.lblName10.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:10] sph_detail] cat];
            cell.lblNameValue10.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:10] sph_detail] detailName];
            cell.lblPrice10.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:10] sph_price];
            
            cell.lblName11.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:11] sph_detail] cat];
            cell.lblNameValue11.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:11] sph_detail] detailName];
            cell.lblPrice11.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:11] sph_price];
            
            cell.lblName12.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:12] sph_detail] cat];
            cell.lblNameValue12.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:12] sph_detail] detailName];
            cell.lblPrice12.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:12] sph_price];
            
            cell.lblName13.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:13] sph_detail] cat];
            cell.lblNameValue13.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:13] sph_detail] detailName];
            cell.lblPrice13.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:13] sph_price];
            
            cell.lblName14.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:14] sph_detail] cat];
            cell.lblNameValue14.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:14] sph_detail] detailName];
            cell.lblPrice14.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:14] sph_price];
            
            if([CommonUtils isiPad]) {
                cell.lblDay.font = [UIFont fontWithName:@"Verdana" size:20.0f];
                cell.lblDuration.font = [UIFont fontWithName:@"Verdana" size:20.0f];
            }
            else {
                cell.lblDay.font = [UIFont fontWithName:@"Verdana" size:17.0f];
                cell.lblDuration.font = [UIFont fontWithName:@"Verdana" size:17.0f];
            }
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
            break;
        default:
        {
            static NSString *simpleTableIdentifier = @"BarSpecialHoursCell";
            BarSpecialHoursCell *cell = (BarSpecialHoursCell *)[self.tblView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            NSLog(@"case = %ld",[[[fullMugBar.sph.aryHours objectAtIndex:indexPath.row] arySpecialHours] count] - 1);
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BarSpecialHoursCell" owner:self options:nil];
                cell = [nib objectAtIndex:14];
            }
            
            cell.lblDay.text = [[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] sph_day];
            cell.lblDuration.text = [[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] sph_time];
            
            cell.lblName0.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:0] sph_detail] cat];
            cell.lblNameValue0.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:0] sph_detail] detailName];
            cell.lblPrice0.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:0] sph_price];
            
            cell.lblName1.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:1] sph_detail] cat];
            cell.lblNameValue1.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:1] sph_detail] detailName];
            cell.lblPrice1.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:1] sph_price];
            
            cell.lblName2.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:2] sph_detail] cat];
            cell.lblNameValue2.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:2] sph_detail] detailName];
            cell.lblPrice2.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:2] sph_price];
            
            cell.lblName3.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:3] sph_detail] cat];
            cell.lblNameValue3.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:3] sph_detail] detailName];
            cell.lblPrice3.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:3] sph_price];

            cell.lblName4.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:4] sph_detail] cat];
            cell.lblNameValue4.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:4] sph_detail] detailName];
            cell.lblPrice4.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:4] sph_price];
            
            cell.lblName5.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:5] sph_detail] cat];
            cell.lblNameValue5.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:5] sph_detail] detailName];
            cell.lblPrice5.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:5] sph_price];
            
            cell.lblName6.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:6] sph_detail] cat];
            cell.lblNameValue6.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:6] sph_detail] detailName];
            cell.lblPrice6.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:6] sph_price];

            cell.lblName7.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:7] sph_detail] cat];
            cell.lblNameValue7.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:7] sph_detail] detailName];
            cell.lblPrice7.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:7] sph_price];

            cell.lblName8.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:8] sph_detail] cat];
            cell.lblNameValue8.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:8] sph_detail] detailName];
            cell.lblPrice8.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:8] sph_price];

            cell.lblName9.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:9] sph_detail] cat];
            cell.lblNameValue9.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:9] sph_detail] detailName];
            cell.lblPrice9.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:9] sph_price];

            cell.lblName10.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:10] sph_detail] cat];
            cell.lblNameValue10.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:10] sph_detail] detailName];
            cell.lblPrice10.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:10] sph_price];

            cell.lblName11.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:11] sph_detail] cat];
            cell.lblNameValue11.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:11] sph_detail] detailName];
            cell.lblPrice11.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:11] sph_price];

            cell.lblName12.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:12] sph_detail] cat];
            cell.lblNameValue12.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:12] sph_detail] detailName];
            cell.lblPrice12.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:12] sph_price];
            
            cell.lblName13.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:13] sph_detail] cat];
            cell.lblNameValue13.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:13] sph_detail] detailName];
            cell.lblPrice13.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:13] sph_price];
            
            cell.lblName14.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:14] sph_detail] cat];
            cell.lblNameValue14.text = [[[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:14] sph_detail] detailName];
            cell.lblPrice14.text = [[[[[fullMugBar.sph aryHours] objectAtIndex:indexPath.row] arySpecialHours] objectAtIndex:14] sph_price];
            
            if([CommonUtils isiPad]) {
                cell.lblDay.font = [UIFont fontWithName:@"Verdana" size:20.0f];
                cell.lblDuration.font = [UIFont fontWithName:@"Verdana" size:20.0f];
            }
            else {
                cell.lblDay.font = [UIFont fontWithName:@"Verdana" size:17.0f];
                cell.lblDuration.font = [UIFont fontWithName:@"Verdana" size:17.0f];
            }
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
            break;
    }
    
    
}

- (void)configureBarSpecialHoursCell:(BarSpecialHoursCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    
//    NSInteger aryCount = [fullMugBar.arySpecialHours count]-1;
//    
//    if (indexPath.row == aryCount) {
//       cell.lblLine.backgroundColor = [UIColor colorWithRed:187.0/255.0 green:124.0/255.0 blue:37.0/255.0 alpha:1.0];
//    }
//    else {
//      cell.lblLine.backgroundColor = [UIColor colorWithRed:59.0/255.0 green:58.0/255.0 blue:53.0/255.0 alpha:1.0];
//    }
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
            
            //BarSpecialHourButtonCell
        case 1:
        {
            return 50;
        }
            break;
            
            // BarSpecialHoursCell
        case 2:
        {
            if([fullMugBar.sph.aryHours count] != 0)
            {
                switch ([[[fullMugBar.sph.aryHours objectAtIndex:indexPath.row] arySpecialHours] count] - 1)
                {
                    case 0:
                        NSLog(@"height case = %ld",[[[fullMugBar.sph.aryHours objectAtIndex:indexPath.row] arySpecialHours] count] - 1);
                        return 98;
                    case 1:
                        NSLog(@"height case = %ld",[[[fullMugBar.sph.aryHours objectAtIndex:indexPath.row] arySpecialHours] count] - 1);
                        return 164;
                    case 2:
                        NSLog(@"height case = %ld",[[[fullMugBar.sph.aryHours objectAtIndex:indexPath.row] arySpecialHours] count] - 1);
                        return 131;
                    case 3:
                        NSLog(@"height case = %ld",[[[fullMugBar.sph.aryHours objectAtIndex:indexPath.row] arySpecialHours] count] - 1);
                        return 297;
                    case 4:
                        NSLog(@"height case = %ld",[[[fullMugBar.sph.aryHours objectAtIndex:indexPath.row] arySpecialHours] count] - 1);
                        return 362;
                    case 5:
                        NSLog(@"height case = %ld",[[[fullMugBar.sph.aryHours objectAtIndex:indexPath.row] arySpecialHours] count] - 1);
                        return 428;
                    case 6:
                        NSLog(@"height case = %ld",[[[fullMugBar.sph.aryHours objectAtIndex:indexPath.row] arySpecialHours] count] - 1);
                        return 424;
                    case 7:
                        NSLog(@"height case = %ld",[[[fullMugBar.sph.aryHours objectAtIndex:indexPath.row] arySpecialHours] count] - 1);
                        return 560;
                    case 8:
                        NSLog(@"height case = %ld",[[[fullMugBar.sph.aryHours objectAtIndex:indexPath.row] arySpecialHours] count] - 1);
                        return 626;
                    case 9:
                        NSLog(@"height case = %ld",[[[fullMugBar.sph.aryHours objectAtIndex:indexPath.row] arySpecialHours] count] - 1);
                        return 692;
                    case 10:
                        NSLog(@"height case = %ld",[[[fullMugBar.sph.aryHours objectAtIndex:indexPath.row] arySpecialHours] count] - 1);
                        return 758;
                    case 11:
                        NSLog(@"height case = %ld",[[[fullMugBar.sph.aryHours objectAtIndex:indexPath.row] arySpecialHours] count] - 1);
                        return 824;
                    case 12:
                        NSLog(@"height case = %ld",[[[fullMugBar.sph.aryHours objectAtIndex:indexPath.row] arySpecialHours] count] - 1);
                        return 890;
                    case 13:
                        NSLog(@"height case = %ld",[[[fullMugBar.sph.aryHours objectAtIndex:indexPath.row] arySpecialHours] count] - 1);
                        return 956;
                    case 14:
                        NSLog(@"height case = %ld",[[[fullMugBar.sph.aryHours objectAtIndex:indexPath.row] arySpecialHours] count] - 1);
                        return 1022;
                        break;
                    default:
                        NSLog(@"height case = %ld",[[[fullMugBar.sph.aryHours objectAtIndex:indexPath.row] arySpecialHours] count] - 1);
                        return 1022;
                        break;
                }
                
                //NSLog(@"Row height for %ld is %ld",(long)indexPath.row, 99 + (([[[fullMugBar.sph.aryHours objectAtIndex:indexPath.row] arySpecialHours] count] - 1) * 66));
                //return 99 + (([[[fullMugBar.sph.aryHours objectAtIndex:indexPath.row] arySpecialHours] count] - 1) * 66);
            }
            else {
                return 71;
            }
            
        }
            break;
           
            
            //DescriptionTitleCell
        case 3:
            return 30;
            break;
            
            //DescriptionCell
        case 4:
            {
                CGFloat cellHeight = [self heightForDescriptionCellAtIndexPath:indexPath];
                return cellHeight;
            }
            break;
            
            //ShowMoreCell
        case 5:
            return 25;
            break;
            
            //ShareCell
        case 6:
            return 109;
            break;
            
            //DescriptionTitleCell
        case 7:
            return 30;
            break;
            
            //PaymentTypeCell
        case 8:
        {
            
            if ([fullMugBar.barDetail.aryPaymentTypes_Up count]>0 && [fullMugBar.barDetail.aryPaymentTypes_Down count]>0) {
                return 92;
                }
                else if ([fullMugBar.barDetail.aryPaymentTypes_Up count]>0) {
                    return 92;
                }
                else if ([fullMugBar.barDetail.aryPaymentTypes_Down count]>0){
                    return 92;
                }
                else {
                    return 4;
                }
            
        }
            break;
            
            //TItleCell
        case 9:
            return 50;
            break;
            
            //HoursOpenCell
        case 10:
        {
            if ([fullMugBar.aryBarHours count]!=0) {
                return 31;
            }
            else {
                return 71;
            }
            
        }
            
            break;
            
            //TItleCell
        case 11:
            return 50;
            break;
            
            //BarGalleryCell
        case 12:
            if ([CommonUtils isiPad]) {
                return 511;
            }
            else {
                return 351;
            }
            
            break;
            
            //TItleCell
        case 13:
            return 50;
            break;
            
            //BarEventsCell
        case 14:
        {
            if ([fullMugBar.aryBarEvents count]!=0) {
                CGFloat cellHeight = [self heightForBarEventsCellAtIndexPath:indexPath];
                return cellHeight;
            }
            else {
                return 71;
            }
            
        }
            break;
          
            //ViewAllCell
        case 15:
            return 25;
//        {
//            if (fullMugBar.eventServedCount>0) {
//                return 25;
//            }
//            else {
//                return 0;
//            }
           break;
//        }
            
            //TItleCell
        case 16:
            return 50;
            break;
            
            //BeersServedCell
        case 17:
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
        case 18:
            return 25;
//        {
//            if (fullMugBar.beerServedCount>0) {
//                return 25;
//            }
//            else {
//                return 0;
//            }
//            break;
//        }
            

            //TItleCell
        case 19:
            return 50;
            break;
            
            //Cocktail_LiquorsCell
        case 20:
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
        case 21:
            return 25;
//        {
//            if ([fullMugBar.barDetail.bar_serve_as isEqualToString:@"liquor"]) {
//                if (fullMugBar.liquorServedCount>0) {
//                    return 25;
//                }
//                else {
//                    return 0;
//                }
//            }
//            else {
//                if (fullMugBar.cocktailServedCount>0) {
//                    return 25;
//                }
//                else {
//                    return 0;
//                }
//            }
//            
//            break;
//        }
            
            //TItleCell
        case 22:
            return 50;
            break;
            
            //TakeALookCell
        case 23:
            if ([CommonUtils isiPad]) {
                return 500;
            }
            else {
                return 200;
            }

            break;
            
            //TItleCell
        case 24:
            return 50;
            break;
            
            //HowToFindUSCell
        case 25:
            return 238;
            break;
            
            //TItleCell
        case 26:
            return 50;
            break;
            
            //BarWriteReviewCell
        case 27:
            return 209;
            break;
            
            //TItleCell
        case 28:
            return 50;
            break;
            
            //RavesAndRentsCell
        case 29:
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
        case 30:
            return 25;
            break;
            
            //TItleCell
        case 31:
            return 50;
            break;

            //GetInTouchCell
        case 32:
            return 231;
            break;

            //TItleCell
        case 33:
            return 50;
            break;
            
            //ReportBarCell
        case 34:
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
#pragma mark BarEventsCell Cell With Height Configuration
- (CGFloat)heightForBarEventsCellAtIndexPath:(NSIndexPath *)indexPath
{
    static BarEventsCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tblView dequeueReusableCellWithIdentifier:BarEventsCellIdentifier];
    });
    
    [self configureBarEventsCell:sizingCell atIndexPath:indexPath];
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


#pragma mark
#pragma mark BarSpecialHoursCell Cell With Height Configuration
- (CGFloat)heightForBarSpecialHoursCellAtIndexPath:(NSIndexPath *)indexPath
{
    static BarSpecialHoursCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tblView dequeueReusableCellWithIdentifier:BarSpecialHoursCellIdentifier];
    });
    
    [self configureBarSpecialHoursCell:sizingCell atIndexPath:indexPath];
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
            
            // Title Cell
        case 1:
            return 50;
            break;
           
            // BarSpecialHoursCell
        case 2:
            
            if([fullMugBar.sph.aryHours count] != 0)
            {
                switch ([[[fullMugBar.sph.aryHours objectAtIndex:indexPath.row] arySpecialHours] count] - 1)
                {
                    case 0:
                        NSLog(@"Esti height case = %ld",[[[fullMugBar.sph.aryHours objectAtIndex:indexPath.row] arySpecialHours] count] - 1);
                        return 98;
                    case 1:
                        NSLog(@"Esti height case = %ld",[[[fullMugBar.sph.aryHours objectAtIndex:indexPath.row] arySpecialHours] count] - 1);
                        return 164;
                    case 2:
                        NSLog(@"Esti height case = %ld",[[[fullMugBar.sph.aryHours objectAtIndex:indexPath.row] arySpecialHours] count] - 1);
                        return 131;
                    case 3:
                        NSLog(@"Esti height case = %ld",[[[fullMugBar.sph.aryHours objectAtIndex:indexPath.row] arySpecialHours] count] - 1);
                        return 297;
                    case 4:
                        NSLog(@"Esti height case = %ld",[[[fullMugBar.sph.aryHours objectAtIndex:indexPath.row] arySpecialHours] count] - 1);
                        return 362;
                    case 5:
                        NSLog(@"Esti height case = %ld",[[[fullMugBar.sph.aryHours objectAtIndex:indexPath.row] arySpecialHours] count] - 1);
                        return 428;
                    case 6:
                        NSLog(@"Esti height case = %ld",[[[fullMugBar.sph.aryHours objectAtIndex:indexPath.row] arySpecialHours] count] - 1);
                        return 424;
                    case 7:
                        NSLog(@"Esti height case = %ld",[[[fullMugBar.sph.aryHours objectAtIndex:indexPath.row] arySpecialHours] count] - 1);
                        return 560;
                    case 8:
                        NSLog(@"Esti height case = %ld",[[[fullMugBar.sph.aryHours objectAtIndex:indexPath.row] arySpecialHours] count] - 1);
                        return 626;
                    case 9:
                        NSLog(@"Esti height case = %ld",[[[fullMugBar.sph.aryHours objectAtIndex:indexPath.row] arySpecialHours] count] - 1);
                        return 692;
                    case 10:
                        NSLog(@"Esti height case = %ld",[[[fullMugBar.sph.aryHours objectAtIndex:indexPath.row] arySpecialHours] count] - 1);
                        return 758;
                    case 11:
                        NSLog(@"Esti height case = %ld",[[[fullMugBar.sph.aryHours objectAtIndex:indexPath.row] arySpecialHours] count] - 1);
                        return 824;
                    case 12:
                        NSLog(@"Esti height case = %ld",[[[fullMugBar.sph.aryHours objectAtIndex:indexPath.row] arySpecialHours] count] - 1);
                        return 890;
                    case 13:
                        NSLog(@"Esti height case = %ld",[[[fullMugBar.sph.aryHours objectAtIndex:indexPath.row] arySpecialHours] count] - 1);
                        return 956;
                    case 14:
                        NSLog(@"Esti height case = %ld",[[[fullMugBar.sph.aryHours objectAtIndex:indexPath.row] arySpecialHours] count] - 1);
                        return 1022;
                        break;
                    default:
                        NSLog(@"Esti height case = %ld",[[[fullMugBar.sph.aryHours objectAtIndex:indexPath.row] arySpecialHours] count] - 1);
                        return 1022;
                        break;
                }
                
                //NSLog(@"Estimated Row height for %ld is %ld",(long)indexPath.row, 99 + (([[[fullMugBar.sph.aryHours objectAtIndex:indexPath.row] arySpecialHours] count] - 1) * 66));
                //return 99 + (([[[fullMugBar.sph.aryHours objectAtIndex:indexPath.row] arySpecialHours] count] - 1) * 66);
                //return 59;
            }
            else {
                return 71;
            }
            
            break;
            
            //DescriptionTitleCell
        case 3:
            return 30;
            break;
            
            //DescriptionCell
        case 4:
            return 22;
            break;
            
            //ShowMoreCell
        case 5:
            return 25;
            break;
            
            //ShareCell
        case 6:
            return 109;
            break;
            
            //DescriptionTitleCell
        case 7:
            return 30;
            break;
            
            //PaymentTypeCell
        case 8:
        {
            
            if ([fullMugBar.barDetail.aryPaymentTypes_Up count]>0 && [fullMugBar.barDetail.aryPaymentTypes_Down count]>0) {
                return 92;
            }
            else if ([fullMugBar.barDetail.aryPaymentTypes_Up count]>0) {
                return 92;
            }
            else if ([fullMugBar.barDetail.aryPaymentTypes_Down count]>0){
                return 92;
            }
            else {
                return 4;
            }
            
        }
            break;
            
            //TItleCell
        case 9:
            return 50;
            break;
            
            //HoursOpenCell
        case 10:
            if ([fullMugBar.aryBarHours count]!=0) {
                return 31;
            }
            else {
                return 71;
            }
            
            break;
            
            //TItleCell
        case 11:
            return 50;
            break;

            //BarGalleryCell
        case 12:
            if ([CommonUtils isiPad]) {
                return 511;
            }
            else {
                return 351;
            }
            break;
            
            //TItleCell
        case 13:
            return 50;
            break;
            
            //BarEventsCell
        case 14:
            if ([fullMugBar.aryBarEvents count]!=0) {
                return 93;
            }
            else {
                return 71;
            }
            
            break;
            
            //ViewAllCell
        case 15:
            return 25;
            break;
            
            //TItleCell
        case 16:
            return 50;
            break;
            
            //BeersServedCell
        case 17:
            if ([fullMugBar.aryBeerSeved count]!=0) {
                return 93;
            }
            else {
                return 71;
            }
            
            break;
            
            //ViewAllBeerServedCell
        case 18:
            return 25;
            break;
            
            //TItleCell
        case 19:
            return 50;
            break;

            //Cocktail_LiquorsCell
        case 20:
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
        case 21:
            return 25;
            break;
            
            //TItleCell
        case 22:
            return 50;
            break;
            
            //TakeALookCell
        case 23:
            if ([CommonUtils isiPad]) {
                return 500;
            }
            else {
                return 200;
            }
            
            break;
            
            //TItleCell
        case 24:
            return 50;
            break;
            
            //HowToFindUSCell
        case 25:
            return 238;
            break;
            
            //TItleCell
        case 26:
            return 50;
            break;
            
            //BarWriteReviewCell
        case 27:
            return 209;
            break;
            
            //TItleCell
        case 28:
            return 50;
            break;
            
            //RavesAndRentsCell
        case 29:
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
        case 30:
            return 25;
            break;
            
            //TItleCell
        case 31:
            return 50;
            break;
            
            //GetInTouchCell
        case 32:
            return 231;
            break;
            
            //TItleCell
        case 33:
            return 50;
            break;
            
            //ReportBarCell
        case 34:
            return 333;
            break;
            
        default:
            return 0;
    }

}

#pragma mark Did Select Row
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 15) {
        if (fullMugBar.eventServedCount>0) {
            EventListViewController *event = [[EventListViewController alloc] initWithNibName:@"EventListViewController" bundle:nil];
            event.barDetail = fullMugBar.barDetail;
            [self.navigationController pushViewController:event animated:YES];
        }
    }
    
    if (indexPath.section == 18) {
        if (fullMugBar.beerServedCount>0) {
            BeerDirectoryViewController *beer = [[BeerDirectoryViewController alloc] initWithNibName:@"BeerDirectoryViewController" bundle:nil];
            beer.barDetail = fullMugBar.barDetail;
            [self.navigationController pushViewController:beer animated:YES];
        }

    }
    
    if (indexPath.section == 21) {
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
    
    if (indexPath.section == 5) {
        [self displayShowMoreView];
    }
    if (indexPath.section == 14) {
        if ([fullMugBar.aryBarEvents count]>0) {
            EventDetailViewController *detailVC = [[EventDetailViewController alloc] initWithNibName:@"EventDetailViewController" bundle:nil];
            detailVC.barEvent = [fullMugBar.aryBarEvents objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:detailVC animated:YES];
        }
        
    }
    if (indexPath.section==17) {
        if ([fullMugBar.aryBeerSeved count]>0) {
            BeerServed *beerServed = [fullMugBar.aryBeerSeved objectAtIndex:indexPath.row];
            BeerDirectory *beer = [self getBeerFromServedBeer:beerServed];
            BeerDirectoryDetailViewController *beerDetail = [[BeerDirectoryDetailViewController alloc] initWithNibName:@"BeerDirectoryDetailViewController" bundle:nil];
            beerDetail.beer = beer;
            [self.navigationController pushViewController:beerDetail animated:YES];

        }

    }
    if (indexPath.section==20) {
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
    if (indexPath.section == 23) {

        if ([fullMugBar.barDetail.bar_video_link length]==0) {
            return;
        }
        else {
    //            TakeALookCell *cell = (TakeALookCell *)[tableView cellForRowAtIndexPath:indexPath];
    //            cell.youtubeView.hidden = NO;
    //            cell.imgPlayVideo.hidden = YES;
    //            cell.imgYoutubeThumbnail.hidden = YES;
    //            [cell configureCellForYoutube];
        }
//
//        YoutubePlayerViewController *youTube = [[YoutubePlayerViewController alloc] initWithNibName:@"YoutubePlayerViewController" bundle:nil];
//        [self.navigationController pushViewController:youTube animated:YES];
    }
    
    if (indexPath.section == 30) {
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
#pragma mark - TextField

#pragma mark Textfield Delegates
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 10) {
        nameForGetInTouch = textField.text;
    }

    else if (textField.tag == 20) {
        phoneForGetInTouch = textField.text;
    }
    
    else if (textField.tag == 30) {
        emailForGetInTouch = textField.text;
    }
    
    
    else if (textField.tag == 201) {
        reportEmail = textField.text;
    }
    
    else if (textField.tag == 601) {
        reviewTitle = textField.text;
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

-(void)configureTextView:(GetInTouchCell *)cell
{
    
    showingPlaceholder = YES;
    if ([commentForGetInTouch length]==0)
    {
        [cell.txtComment setText:kPlaceholderText];
        [cell.txtComment setTextColor:[UIColor colorWithRed:146.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0]];
    }
    else
    {
        [cell.txtComment setText:commentForGetInTouch];
        [cell.txtComment setTextColor:[UIColor whiteColor]];
        showingPlaceholder = NO;
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
    else if (textView.tag == 301) {
        if(showingPlaceholder) {
            [textView setText:@""];
            [textView setTextColor:[UIColor colorWithRed:146.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0]];
            
            showingPlaceholder = NO;
        }
    }
    else {
        if(showingReviewDescPlaceHolder) {
            [textView setText:@""];
            [textView setTextColor:[UIColor whiteColor]];
            
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
    else if (textView.tag == 301) {
        // Check the length and if it should add a placeholder
        if([[textView text] length] == 0 && !showingPlaceholder) {
            [textView setText:kPlaceholderText];
            [textView setTextColor:[UIColor colorWithRed:146.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0]];
            
            showingPlaceholder = YES;
        }
        else
        {
            NSLog(@"%@",textView.text);
            commentForGetInTouch = textView.text;
        }
    }
    else {
        // Check the length and if it should add a placeholder
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
                ShowAlert(AlertTitle, @"Your inquiry hae been sent successfully to bar owner.");
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
