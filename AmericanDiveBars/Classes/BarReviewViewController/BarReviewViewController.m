//
//  BarReviewViewController.m
//  AmericanDiveBars
//
//  Created by spaculus on 4/13/16.
//  Copyright © 2016 spaculus. All rights reserved.
//

#import "BarReviewViewController.h"
#import "BarDetailFullMugViewController.h"
#import "BarDetailHalfMugViewController.h"
#import "BarSuggestViewController.h"

#import "BarCell.h"
#import "BarHeaderView.h"

#import "BarDetailCell.h"

static NSString * const kReviewDescPlaceholderText = @"Review Description";


@interface BarReviewViewController () <MBProgressHUDDelegate,FPPopoverControllerDelegate,RateViewDelegate>
{
    //HUD
    MBProgressHUD *HUD;
    
    //POPOVER
    FPPopoverController *popover;
    
    //TABLE HEADER
    BarHeaderView *barHeaderView;
    
    //LOAD MORE
    NSInteger offset;
    NSInteger limit;
    NSInteger totalRecords;
    
    //SEARCH LABEL TEXT IN HEADER VIEW
    NSString *searchTitle;
    
    //LGPopUp VIEW
    NSInteger selectedIndex;
    
    //SORT BY TYPE
    NSString *order_by;
    
    
    // Review Bar
    BOOL showingReviewDescPlaceHolder;
    NSString *reviewTitle;
    NSString *reviewDesc;
    NSString *ratings;
    
    BOOL temp;
}

//CUSTOM POPUP TABLE VIEW
@property (strong, nonatomic) LGFilterView  *filterView;
@property (strong, nonatomic) NSArray   *titlesArray;

//Main Table
@property (strong, nonatomic) IBOutlet UITableView *tblView;
@property (strong, nonatomic) NSMutableArray *aryList;


// Write Review View
@property (strong, nonatomic) IBOutlet UITextField *txtReviewTitle;
@property (strong, nonatomic) IBOutlet UITextView *txtReviewDesc;
@property (strong, nonatomic) IBOutlet UIButton *btnSubmit;
@property (strong, nonatomic) IBOutlet RateView *rateView;

@property (strong, nonatomic) IBOutlet UIView * viewWriteReview;

@end



@implementation BarReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [CommonUtils setTitleLabel:@"BAR REVIEWS"];
    
    [self configureTopButtons];
    //[self configureBarTableView];
    
    [self initializeDataStructure];
    
    [self configureWriteReview];

     [self callBarCommentWebservice];
}

-(void)initializeDataStructure {
    self.aryList = [[NSMutableArray alloc]  init];
    limit = 10;
    offset = 0;
    totalRecords = 0;
    
    reviewTitle = @"";
    reviewDesc = @"";
    ratings = @"";
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.topItem.title = @" ";
    temp = YES;
    [self registerCell];
    [self.tblView reloadData];
}


- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGFloat topInset = self.navigationController.navigationBar.frame.size.height+([UIApplication sharedApplication].isStatusBarHidden ? 0.f : [UIApplication sharedApplication].statusBarFrame.size.height);
    
    if ([UIDevice currentDevice].systemVersion.floatValue < 7.0) topInset = 0.f;
    
   // [self updateFilterProperties];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - LG POPUP VIEW
/*
-(void)setDataStructureForLGView {
    _titlesArray = @[@{@"title":@"BAR NAME A-Z",@"value":@"bar_title#ASC"},
                     @{@"title":@"BAR NAME Z-A",@"value":@"bar_title#DESC"},
                     @{@"title":@"CITY A-Z",@"value":@"city#ASC"},
                     @{@"title":@"CITY Z-A",@"value":@"city#DESC"},
                     @{@"title":@"STATE A-Z",@"value":@"state#ASC"},
                     @{@"title":@"STATE Z-A",@"value":@"state#DESC"}
                     ];
    selectedIndex = 0;
    [self setupFilterViewsWithTransitionStyle:LGFilterViewTransitionStyleCenter];
    
}

- (void)filterAction
{
    if (!_filterView.isShowing)
    {
        _filterView.selectedIndex = selectedIndex;
        
        [_filterView showInView:self.view animated:YES completionHandler:nil];
    }
    else [_filterView dismissAnimated:YES completionHandler:nil];
}

#pragma mark Appearing



- (void)updateFilterProperties {
    [self setupFilterViewsWithTransitionStyle:LGFilterViewTransitionStyleCenter];
    
    CGFloat topInset = self.navigationController.navigationBar.frame.size.height+([UIApplication sharedApplication].isStatusBarHidden ? 0.f : [UIApplication sharedApplication].statusBarFrame.size.height);
    if ([UIDevice currentDevice].systemVersion.floatValue < 7.0) topInset = 0.f;
    
    if (_filterView.transitionStyle == LGFilterViewTransitionStyleCenter)
    {
        _filterView.offset = CGPointMake(0.f, topInset/2);
        _filterView.contentInset = UIEdgeInsetsZero;
    }
    else if (_filterView.transitionStyle == LGFilterViewTransitionStyleTop)
    {
        _filterView.contentInset = UIEdgeInsetsMake(topInset, 0.f, 0.f, 0.f);
        _filterView.offset = CGPointZero;
    }
}
- (void)setupFilterViewsWithTransitionStyle:(LGFilterViewTransitionStyle)style
{
    __weak typeof(self) wself = self;
    
    _filterView = [[LGFilterView alloc] initWithTitles:_titlesArray
                                         actionHandler:^(LGFilterView *filterView, NSString *title, NSUInteger index)
                   {
                       if (wself)
                       {
                           barHeaderView.lblFilterType.text = title;
                           selectedIndex = index;
                           order_by = [[_titlesArray objectAtIndex:index] valueForKey:@"value"];
                           limit = 10;
                           offset = 0;
                           [self callBarListWebservice];
                       }
                   }
                                         cancelHandler:nil];
    _filterView.transitionStyle = style;
    _filterView.numberOfLines = 0;
}*/


        //- (IBAction)btnSuggestClicked:(id)sender {
        //    
        //    BarSuggestViewController *suggest = [[BarSuggestViewController alloc] initWithNibName:@"BarSuggestViewController" bundle:nil];
        //    [self.navigationController pushViewController:suggest animated:YES];
        //    
        //}
        //
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
    btnTopSearch = [CommonUtils barItemWithImage:[UIImage imageNamed:@"top-home.png"] highlightedImage:nil xOffset:-5 target:self action:@selector(btnTopSearch_Clicked:)];
    
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
    controller.barReviewDelegate = self;
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

#pragma mark - Write Review View

-(void)configureWriteReview
{
   // self.viewWriteReview.layer.borderWidth = 0.8f;
   // self.viewWriteReview.layer.borderColor = [UIColor colorWithRed:187.0/255.0 green:124.0/255.0 blue:37.0/255.0 alpha:1.0].CGColor;
    
    [CommonUtils setBorderAndCorner_ForTextField:self.txtReviewTitle
                                 forCornerRadius:5
                                  forBorderWidth:0.8f
                                     withPadding:8
                                        andColor:[[UIColor colorWithRed:146.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0] CGColor]];
    
    
    [self.txtReviewTitle setTextColor:[UIColor colorWithRed:146.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0]];
    
    [self.txtReviewDesc setTextColor:[UIColor colorWithRed:146.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0]];
    
    [self.txtReviewTitle setValue:[UIColor colorWithRed:146.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];
    
    [self.txtReviewDesc setContentInset:UIEdgeInsetsMake(-2, 0, 0, 0)];
    
    [self setBorderAndCornerRadius_WhileNoEditing];
    
    [self configRateView];
    
    [self configureWriteReviewTextView];
}

-(void)setBorderAndCornerRadius_WhileNoEditing {
    self.txtReviewDesc.layer.borderWidth = 0.8;
    self.txtReviewDesc.layer.borderColor = [[UIColor colorWithRed:146.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0] CGColor];
    self.txtReviewDesc.layer.cornerRadius = 5;
    self.txtReviewDesc.layer.masksToBounds = YES;
}


-(void) configRateView {
    self.rateView.notSelectedImage  = [UIImage imageNamed:@"no-rating_star.png"];
    //self.rateView.halfSelectedImage = [UIImage imageNamed:@"star-half"];
    self.rateView.fullSelectedImage = [UIImage imageNamed:@"full_star.png"];
    self.rateView.delegate = self;
    
    self.rateView.editable = YES;
    self.rateView.maxRating = 5;
    
    [self.rateView setLeftMargin:0];
    [self.rateView setMidMargin:0];
    [self.rateView setMinImageSize:CGSizeMake(0, 0)];
}

-(void)rateView:(RateView *)rateView ratingDidChange:(float)rating {
    int rate = fabs(rating);
    ratings = [NSString stringWithFormat:@"%d",rate];
}


-(IBAction)btnSubmitReview:(UIButton *)btnSubmit {
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

#pragma mark - TEXT VIEW

-(void)configureWriteReviewTextView
{
    
    showingReviewDescPlaceHolder = YES;
    if ([reviewDesc length]==0)
    {
        [self.txtReviewDesc setText:kReviewDescPlaceholderText];
        [self.txtReviewDesc setTextColor:[UIColor colorWithRed:146.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0]];
    }
    else
    {
        [self.txtReviewDesc setText:reviewDesc];
        [self.txtReviewDesc setTextColor:[UIColor whiteColor]];
        showingReviewDescPlaceHolder = NO;
    }
}
#pragma mark UITextView Delegate Methods
-(void)textViewDidBeginEditing:(UITextView *)textView {
    if(showingReviewDescPlaceHolder) {
        [textView setText:@""];
        [textView setTextColor:[UIColor whiteColor]];
        
        showingReviewDescPlaceHolder = NO;
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView {
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

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES ;
}

#pragma mark - TextField

#pragma mark Textfield Delegates
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    reviewTitle = textField.text;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - Table View
-(void)registerCell
{
    [self.tblView registerNib:[UINib nibWithNibName:Nib_RavesAndRentsCell bundle:nil] forCellReuseIdentifier:RavesAndRentsCellIdentifier];
}

#pragma mark Number of Section
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //return 1;
    if(offset < totalRecords && totalRecords>10) {
        return 2;
    }
    else
    {
        return 1;
    }
    
}

#pragma mark Number of Row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        //    if (temp) {
        //        return 10;
        //    }
        //    else {
        //        return 0;
        //    }
    
    if (section == 0) {
        return [CommonUtils getArrayCountFromArray:self.aryList];
    }
    else {
        return 1;
    }
}

#pragma mark Cell for Row
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.section) {
        case 0:
        {
            return [self RavesAndRentsCellAtIndexPath:indexPath];
        }
            break;
            
        case 1:
        {
            static NSString *simpleTableIdentifier = @"LoadMoreCell";
            
            LoadMoreCell *cell = (LoadMoreCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            if (cell == nil)
            {
                NSArray *nib;
                if([CommonUtils isiPad])
                {
                    nib = [[NSBundle mainBundle] loadNibNamed:@"LoadMoreCell" owner:self options:nil];
                }
                else
                {
                    nib = [[NSBundle mainBundle] loadNibNamed:@"LoadMoreCell" owner:self options:nil];
                }
                cell = [nib objectAtIndex:0];
            }
            
            if(offset < totalRecords && totalRecords>10)
            {
                BOOL hasConnected = [CommonUtils connected];
                if (hasConnected)
                {
                    [self callBarCommentWebservice_LOAD_MORE];
                }
                else
                {
                    cell.lblLoading.text = @"Please Try Again";
                }
            }
            else
            {
                cell.lblLoading.text = @"Please Try Again";
            }
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
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
    cell.lblComment.numberOfLines = 0;
    cell.lblReviewTitle.numberOfLines = 0;
    BarReview *barReview = [self.aryList objectAtIndex:indexPath.row];
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

#pragma mark Calculate Height for Cell

- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell
{
    sizingCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tblView.frame), CGRectGetHeight(sizingCell.bounds));
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1.0f; // Add 1.0f for the cell separator height
}

#pragma mark Cell Height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.section) {
        case 0:
        {CGFloat cellHeight = [self heightForRavesAndRentsCellAtIndexPath:indexPath];
            return cellHeight;}
            //return 93;
            /*if ([fullMugBar.aryBarEvents count]!=0) {
                CGFloat cellHeight = [self heightForBarEventsCellAtIndexPath:indexPath];
                return cellHeight;
            }
            else {
                return 71;
            }*/
            break;
        case 1:
            return 30;
            break;
            
        default:
            return 0;
            break;
    }
}

#pragma mark Estmated Height For Row
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.section) {
        case 0:
            return 106;
            /*if ([fullMugBar.aryBarReviews count]!=0) {
                return 106;
            }
            else {
                return 71;
            }*/
            break;
        case 1:
            return 30;
            break;
            
        default:
            return 0;
            break;
    }
    
    
}

#pragma mark did Select Row
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}


#pragma mark - Webservice Call
-(void)callBarCommentWebservice {
    [CommonUtils callWebservice:@selector(barcomment) forTarget:self];
}

-(void)callBarCommentWebservice_LOAD_MORE {
    [CommonUtils callWebservice:@selector(barcomment_LOAD_MORE) forTarget:self];
}

-(void)callAddBarCommentservice {
    [CommonUtils callWebservice:@selector(add_bar_comment) forTarget:self];
}

#pragma mark - Webservice
#pragma mark add_bar_comment
-(void)add_bar_comment
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
    NSString *myURL = [NSString stringWithFormat:@"%@add_bar_comment",WEBSERVICE_URL];
    NSMutableURLRequest *Request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: myURL]];
    //NSString *params = [NSString stringWithFormat:@"user_id=%@&limit=%ld&offset=%ld&bar_id=%@",user_id,(long)limit,(long)offset,self.bar.bar_id];
    NSString *params = [NSString stringWithFormat:@"user_id=%@&device_id=%@&unique_code=%@&bar_id=%@&comment_title=%@&comment=%@&rating=%@",user_id,device_id,unique_code,self.bar_id,reviewTitle,reviewDesc,ratings];
    
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
                
                ShowAlert(AlertTitle, @"Your review is added successfully");
                reviewTitle = @"";
                reviewDesc = @"";
                ratings = @"0";
                showingReviewDescPlaceHolder = YES;
                [self callBarCommentWebservice];
                
            }
        }
        else {
        }
        
        [self.tblView reloadData];
        
    }];
    
}


#pragma mark barcomment
-(void)barcomment
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.mode = MBProgressHUDModeIndeterminate;
    
    User *user = [CommonUtils getUserLoginDetails];
    NSString *user_id = [user user_id];
    NSString *device_id = [user device_id];
    NSString *unique_code =[user unique_code];
    
    //192.168.1.27/ADB/api/bar_lists
    NSString *myURL = [NSString stringWithFormat:@"%@barcomment",WEBSERVICE_URL];
    NSMutableURLRequest *Request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: myURL]];
    
    NSString *params = [NSString stringWithFormat:@"user_id=%@&device_id=%@&unique_code=%@&limit=%ld&offset=%ld&bar_id=%@",user_id,device_id,unique_code,(long)limit,(long)offset,self.bar_id];
    
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
                
                limit = 10;
                offset = 0;
                totalRecords = 0;
                
                
                
                totalRecords = [[CommonUtils getNotNullString:[tempDict valueForKey:@"barcomment_total"]] integerValue];
                offset = offset + limit;
                NSArray *aryResultReviews = [tempDict valueForKey:@"barcomment"];
                
                if ([aryResultReviews count]!=0) {
                    if ([self.aryList count]!=0) {
                        [self.aryList removeAllObjects];
                    }
                }
                
                self.aryList = [self getBarReviews:aryResultReviews];
                
                reviewTitle = @"";
                reviewDesc = @"";
                ratings = @"";
                
                self.txtReviewTitle.text = @"";
                [self configureWriteReviewTextView];
                
                [self.tblView reloadData];
            }
        }
        else {
        }
        if([self.aryList count]==0){
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate.window makeToast:@"No records found" duration:4.0 position:CSToastPositionBottom];
        }
        else {
        }
    }];
}

-(NSMutableArray *)getBarReviews:(NSArray *)aryResultReviews {
    NSMutableArray *aryReviews = [@[] mutableCopy];
    if ([aryReviews count]>0) {
        [aryReviews removeAllObjects];
    }
    
    for (NSDictionary *dict in aryResultReviews) {
        BarReview *barReview = [BarReview getBarReviewWithDictionary:dict];
        [aryReviews addObject:barReview];
    }
    return aryReviews;
}

#pragma mark barcomment WITH LOAD MORE
-(void)barcomment_LOAD_MORE
{
    
    User *user = [CommonUtils getUserLoginDetails];
    NSString *user_id = [user user_id];
    NSString *device_id = [user device_id];
    NSString *unique_code =[user unique_code];
    
    //192.168.1.27/ADB/api/bar_lists
    NSString *myURL = [NSString stringWithFormat:@"%@barcomment",WEBSERVICE_URL];
    NSMutableURLRequest *Request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: myURL]];
    
    // NSString *params = [NSString stringWithFormat:@"limit=%ld&offset=%ld&state=%@&city=%@&zipcode=%@&title=%@",(long)limit,(long)offset,state,city,zip,name];
    
    NSString *params = [NSString stringWithFormat:@"user_id=%@&device_id=%@&unique_code=%@&limit=%ld&offset=%ld&bar_id=%@",user_id,device_id,unique_code,(long)limit,(long)offset,self.bar_id];
    
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
            
            if ([[tempDict valueForKey:@"status"] isEqualToString:@"success"]) {
                
                NSArray *aryResultReviews = [tempDict valueForKey:@"barcomment"];
                [self getMoreBarReviewFromResult:aryResultReviews];
            }
        }
        else {
        }
    }];
    
}

-(void)getMoreBarReviewFromResult:(NSArray *)aryResultReviews {
    
    for(int i=0; i<[aryResultReviews count]; i++)
    {
        NSDictionary *dict = [aryResultReviews objectAtIndex:i];
        BarReview *barReview = [BarReview getBarReviewWithDictionary:dict];
        [self.aryList addObject:barReview];
    }
    offset = offset + limit;
    [self.tblView reloadData];
}



@end
