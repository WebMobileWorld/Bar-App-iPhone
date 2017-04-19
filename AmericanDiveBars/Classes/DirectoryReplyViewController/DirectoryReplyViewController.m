//
//  DirectoryReplyViewController.m
//  AmericanDiveBars
//
//  Created by spaculus on 4/14/16.
//  Copyright © 2016 spaculus. All rights reserved.
//

#import "DirectoryReplyViewController.h"


#import "ReplyCommentCell.h"

#import "BarHeaderView.h"

#import "BarDetailCell.h"

static NSString * const kLeaveCommentPlaceholderText = @"Write Here...";

static NSString * const ReplyCommentCellIdentifier = @"ReplyCommentCell";

@interface DirectoryReplyViewController () <MBProgressHUDDelegate,FPPopoverControllerDelegate>
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
    NSInteger deleteCommentIndex;

    
    //SORT BY TYPE
    NSString *order_by;
    
    
    // Leave A Comment
    BOOL showingLeaveCommentPlaceholder;
    NSString *comment;
    
    BOOL temp;
}

//CUSTOM POPUP TABLE VIEW
@property (strong, nonatomic) LGFilterView  *filterView;
@property (strong, nonatomic) NSArray   *titlesArray;

//Main Table
@property (strong, nonatomic) IBOutlet UITableView *tblView;
@property (strong, nonatomic) NSMutableArray *aryList;


// Write Review View
@property (strong, nonatomic) IBOutlet UITextView *txtReviewDesc;
@property (strong, nonatomic) IBOutlet UIButton *btnSubmit;

@property (strong, nonatomic) IBOutlet UIView * viewWriteReview;

@end



@implementation DirectoryReplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self configureTopButtons];
    //[self configureBarTableView];
    
    [self initializeDataStructure];
    
    [self configureWriteReview];
    
    if ([self.type isEqualToString:@"beer"]) {
        // Call Web service beer_comments
        self.navigationItem.titleView = [CommonUtils setTitleLabel:@"Beer comment replies"];
        [self callBeerSubCommentWebservice];
    }
    else if([self.type isEqualToString:@"cocktail"]) {
        // Call Web service cocktail_comments
        self.navigationItem.titleView = [CommonUtils setTitleLabel:@"Cocktail comment replies"];
        [self callCocktailSubCommentWebservice];
    }
    else {
        // Call Web service liquor_comments
        self.navigationItem.titleView = [CommonUtils setTitleLabel:@"Liquor comment replies"];
        [self callLiquorSubCommentWebservice];
    }
    
}

-(void)initializeDataStructure {
    self.aryList = [[NSMutableArray alloc]  init];
    limit = 10;
    offset = 0;
    totalRecords = 0;
    
    comment = @"";
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
    controller.replyDelegate = self;
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
    
    [self.txtReviewDesc setTextColor:[UIColor colorWithRed:146.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0]];
    
    [self.txtReviewDesc setContentInset:UIEdgeInsetsMake(-2, 0, 0, 0)];
    
    [self setBorderAndCornerRadius_WhileNoEditing];
    
    [self configureWriteReviewTextView];
}

-(void)setBorderAndCornerRadius_WhileNoEditing {
    self.txtReviewDesc.layer.borderWidth = 0.8;
    self.txtReviewDesc.layer.borderColor = [[UIColor colorWithRed:146.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0] CGColor];
    self.txtReviewDesc.layer.cornerRadius = 5;
    self.txtReviewDesc.layer.masksToBounds = YES;
}

#pragma mark - TEXT VIEW

-(void)configureWriteReviewTextView
{
    
    showingLeaveCommentPlaceholder = YES;
    if ([comment length]==0)
    {
        [self.txtReviewDesc setText:kLeaveCommentPlaceholderText];
        [self.txtReviewDesc setTextColor:[UIColor colorWithRed:146.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0]];
    }
    else
    {
        [self.txtReviewDesc setText:comment];
        [self.txtReviewDesc setTextColor:[UIColor whiteColor]];
        showingLeaveCommentPlaceholder = NO;
    }
}
#pragma mark UITextView Delegate Methods
-(void)textViewDidBeginEditing:(UITextView *)textView {
    if(showingLeaveCommentPlaceholder) {
        [textView setText:@""];
        [textView setTextColor:[UIColor whiteColor]];
        
        showingLeaveCommentPlaceholder = NO;
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView {
    if([[textView text] length] == 0 && !showingLeaveCommentPlaceholder) {
        [textView setText:kLeaveCommentPlaceholderText];
        [textView setTextColor:[UIColor colorWithRed:146.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0]];
        
        showingLeaveCommentPlaceholder = YES;
    }
    else
    {
        NSLog(@"%@",textView.text);
        comment = textView.text;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES ;
}


#pragma mark - Table View
-(void)registerCell
{
    [self.tblView registerNib:[UINib nibWithNibName:@"ReplyCommentCell" bundle:nil] forCellReuseIdentifier:ReplyCommentCellIdentifier];
}

#pragma mark Number of Section
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
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
    /*if (temp) {
        return 10;
    }
    else {
        return 0;
    }*/
    
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
            return [self ReplyCommentCellAtIndexPath:indexPath];
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
                    if ([self.type isEqualToString:@"beer"]) {
                        // Call Web service beer_comments
                        [self callBeerSubCommentWebservice_LOAD_MORE];
                    }
                    else if([self.type isEqualToString:@"cocktail"]) {
                        // Call Web service cocktail_comments
                        [self callCocktailSubCommentWebservice_LOAD_MORE];
                    }
                    else {
                        // Call Web service liquor_comments
                        [self callLiquorSubCommentWebservice_LOAD_MORE];
                    }
                    
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
        /*{
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
                    /// [self callBarListWebservice_LOAD_MORE];
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
        }*/
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
#pragma mark ReplyCommentCell Cell Configuration
- (ReplyCommentCell *)ReplyCommentCellAtIndexPath:(NSIndexPath *)indexPath
{
    static ReplyCommentCell *cell = nil;
    cell = [self.tblView dequeueReusableCellWithIdentifier:ReplyCommentCellIdentifier];
    [self configureReplyCommentCell:cell atIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)configureReplyCommentCell:(ReplyCommentCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self.type isEqualToString:@"beer"]) {
        BeerComment *cmt = [self.aryList objectAtIndex:indexPath.row];
        
        if ([cmt.beerComment_user_id isEqualToString:@"0"]) {
            cell.lblUserName.text = @"ADB";
        }
        else {
            cell.lblUserName.text = [CommonUtils removeHTMLFromString:cmt.beerComment_fullName];
        }
        cell.lblDesc.text = [CommonUtils removeHTMLFromString:cmt.beerComment_comment];
        
        NSString *strDuration = cmt.beerComment_date_added;
        
        //[[CommonUtils getDateFromString:beerComment.beerComment_date_added withFormat:@"yyyy-MM-dd HH:mm:ss"] formattedAsTimeAgo];
        
        cell.lblTimeAgo.text = strDuration;
        
        NSString *profile_image = [cmt beerComment_profile_image];
        NSString *strImgURL = [NSString stringWithFormat:@"%@%@%@",WEBIMAGE_URL,USERPROFILEIMAGE_COMMENT,profile_image];
        NSURL *imgURL = [NSURL URLWithString:strImgURL];
        
        [cell.imgUser sd_setImageWithURL:imgURL placeholderImage:[UIImage imageNamed:@"user-no_image_RM.png"]];
        
        cell.btnDelete.tag = indexPath.row;
        
        User *user = [CommonUtils getUserLoginDetails];
        NSString *user_id = [user user_id];
        
        if ([cmt.beerComment_user_id isEqualToString:user_id]) {
            cell.btnDelete.hidden = NO;
        }
        else {
            cell.btnDelete.hidden = YES;
        }
        [cell.btnDelete addTarget:self action:@selector(deleteComment:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if([self.type isEqualToString:@"cocktail"]) {
        CocktailComment *cmt = [self.aryList objectAtIndex:indexPath.row];
        
        if ([cmt.cocktail_user_id isEqualToString:@"0"]) {
            cell.lblUserName.text = @"ADB";
        }
        else {
            cell.lblUserName.text = [CommonUtils removeHTMLFromString:cmt.cocktail_fullName];
        }
        
        cell.lblDesc.text = [CommonUtils removeHTMLFromString:cmt.cocktail_comment];
        
        NSString *strDuration = cmt.cocktail_date_added;
        
        //[[CommonUtils getDateFromString:beerComment.beerComment_date_added withFormat:@"yyyy-MM-dd HH:mm:ss"] formattedAsTimeAgo];
        
        cell.lblTimeAgo.text = strDuration;
        
        NSString *profile_image = [cmt cocktail_profile_image];
        NSString *strImgURL = [NSString stringWithFormat:@"%@%@%@",WEBIMAGE_URL,USERPROFILEIMAGE_COMMENT,profile_image];
        NSURL *imgURL = [NSURL URLWithString:strImgURL];
        
        [cell.imgUser sd_setImageWithURL:imgURL placeholderImage:[UIImage imageNamed:@"user-no_image_RM.png"]];
        
        cell.btnDelete.tag = indexPath.row;
        
        User *user = [CommonUtils getUserLoginDetails];
        NSString *user_id = [user user_id];
        
        if ([cmt.cocktail_user_id isEqualToString:user_id]) {
            cell.btnDelete.hidden = YES;
        }
        else {
            cell.btnDelete.hidden = YES;
        }
        [cell.btnDelete addTarget:self action:@selector(deleteComment:) forControlEvents:UIControlEventTouchUpInside];
    }
    else {
        LiquorComment *cmt = [self.aryList objectAtIndex:indexPath.row];
        
        if ([cmt.liquor_user_id isEqualToString:@"0"]) {
            cell.lblUserName.text = @"ADB";
        }
        else {
            cell.lblUserName.text = [CommonUtils removeHTMLFromString:cmt.liquor_fullName];
        }
        
        cell.lblDesc.text = [CommonUtils removeHTMLFromString:cmt.liquor_comment];
        
        NSString *strDuration = cmt.liquor_date_added;
        
        //[[CommonUtils getDateFromString:beerComment.beerComment_date_added withFormat:@"yyyy-MM-dd HH:mm:ss"] formattedAsTimeAgo];
        
        cell.lblTimeAgo.text = strDuration;
        
        NSString *profile_image = [cmt liquor_profile_image];
        NSString *strImgURL = [NSString stringWithFormat:@"%@%@%@",WEBIMAGE_URL,USERPROFILEIMAGE_COMMENT,profile_image];
        NSURL *imgURL = [NSURL URLWithString:strImgURL];
        
        [cell.imgUser sd_setImageWithURL:imgURL placeholderImage:[UIImage imageNamed:@"user-no_image_RM.png"]];

        cell.btnDelete.tag = indexPath.row;
        
        User *user = [CommonUtils getUserLoginDetails];
        NSString *user_id = [user user_id];
        
        if ([cmt.liquor_user_id isEqualToString:user_id]) {
            cell.btnDelete.hidden = YES;
        }
        else {
            cell.btnDelete.hidden = YES;
        }
        [cell.btnDelete addTarget:self action:@selector(deleteComment:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    //    cell.btnReply.tag = indexPath.row;
    //    cell.btnLike.tag = indexPath.row;
    //
    //    [cell.btnReply addTarget:self action:@selector(replyOnComment:) forControlEvents:UIControlEventTouchUpInside];
    //    [cell.btnLike addTarget:self action:@selector(likeComment:) forControlEvents:UIControlEventTouchUpInside];
    //
    //    [cell.btnLike setImage:[UIImage imageNamed:@"thumb_default.png"] forState:UIControlStateNormal];
    
}

-(void)deleteComment:(UIButton *)btnDelete {
    deleteCommentIndex = btnDelete.tag;
    [self callRemoveComment];
}

-(IBAction)btnSubmitReview:(UIButton *)btnSubmit {
    [self.view endEditing:YES];
    [self.txtReviewDesc resignFirstResponder];
    if ([comment isEqualToString:@""])
    {
        ShowAlert(AlertTitle, @"Please enter title of comment.");
        comment = @"";
        [self.txtReviewDesc becomeFirstResponder];
    }
    else
    {
        
        [self callAddSubComment];
    }
}

#pragma mark Height For Row

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.section)
    {
        case 0:
        {
            CGFloat cellHeight = [self heightForReplyCommentCellAtIndexPath:indexPath];
            return cellHeight;
        }
            break;
            
            // View All Cell
        case 1:
            return 30;
            break;
            
        default:
        {
            return 0;
        }
    }
}

#pragma mark
#pragma mark ReplyCommentCell Cell With Height Configuration
- (CGFloat)heightForReplyCommentCellAtIndexPath:(NSIndexPath *)indexPath
{
    static ReplyCommentCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tblView dequeueReusableCellWithIdentifier:ReplyCommentCellIdentifier];
    });
    
    [self configureReplyCommentCell:sizingCell atIndexPath:indexPath];
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
            //DirectoryCommentCell
        case 0:
            return 113;
            break;
            
            // ViewAllCell
        case 1:
            return 30;
            break;
        default:
            return 0;
    }
    
}
#pragma mark Did Select Row
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - Webservice Call
-(void)callBeerSubCommentWebservice {
    [CommonUtils callWebservice:@selector(beer_subcomments) forTarget:self];
}

-(void)callBeerSubCommentWebservice_LOAD_MORE {
    [CommonUtils callWebservice:@selector(beer_subcomments_LOAD_MORE) forTarget:self];
}

-(void)callCocktailSubCommentWebservice {
    [CommonUtils callWebservice:@selector(cocktail_subcomments) forTarget:self];
}

-(void)callCocktailSubCommentWebservice_LOAD_MORE {
    [CommonUtils callWebservice:@selector(cocktail_subcomments_LOAD_MORE) forTarget:self];
}

-(void)callLiquorSubCommentWebservice {
    [CommonUtils callWebservice:@selector(liquor_subcomments) forTarget:self];
}

-(void)callLiquorSubCommentWebservice_LOAD_MORE {
    [CommonUtils callWebservice:@selector(liquor_subcomments_LOAD_MORE) forTarget:self];
}

-(void)callRemoveComment {
    [CommonUtils callWebservice:@selector(removeComment) forTarget:self];
}

-(void)callAddSubComment {
    [CommonUtils callWebservice:@selector(add_subcomment) forTarget:self];
}


#pragma mark - Webservice
#pragma mark beer_subcomments
-(void)beer_subcomments
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.mode = MBProgressHUDModeIndeterminate;
    
    User *user = [CommonUtils getUserLoginDetails];
    NSString *user_id = [user user_id];
    NSString *device_id = [user device_id];
    NSString *unique_code =[user unique_code];
    
    //192.168.1.27/ADB/api/beer_comments
    NSString *myURL = [NSString stringWithFormat:@"%@beer_subcomments",WEBSERVICE_URL];
    NSMutableURLRequest *Request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: myURL]];
    
    NSString *params = [NSString stringWithFormat:@"user_id=%@&device_id=%@&unique_code=%@&limit=%ld&offset=%ld&master_comment_id=%@",user_id,device_id,unique_code,(long)limit,(long)offset,self.masterCommentID];
    
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
                totalRecords = [[CommonUtils getNotNullString:[tempDict valueForKey:@"beer_subcomment_total"]] integerValue];
                offset = offset + limit;
                NSArray *aryBarList = [tempDict valueForKey:@"beer_subcomment"];
                self.aryList = [self getBeerComments:aryBarList];
                [self registerCell];
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
        [self.tblView reloadData];
    }];
    
}

-(NSMutableArray *)getBeerComments:(NSArray *)aryBeerComments_ {
    NSMutableArray *aryComments = [@[] mutableCopy];
    if ([aryComments count]>0) {
        [aryComments removeAllObjects];
    }
    
    for (NSDictionary *dict in aryBeerComments_) {
        BeerComment *beerComment = [BeerComment getBeerCommentWithDictionary:dict];
        [aryComments addObject:beerComment];
    }
    return aryComments;
}

#pragma mark beer_comments WITH LOAD MORE
-(void)beer_subcomments_LOAD_MORE
{
    User *user = [CommonUtils getUserLoginDetails];
    NSString *user_id = [user user_id];
    NSString *device_id = [user device_id];
    NSString *unique_code =[user unique_code];
    
    //192.168.1.27/ADB/api/beer_comments
    NSString *myURL = [NSString stringWithFormat:@"%@beer_subcomments",WEBSERVICE_URL];
    NSMutableURLRequest *Request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: myURL]];
    
    NSString *params = [NSString stringWithFormat:@"user_id=%@&device_id=%@&unique_code=%@&limit=%ld&offset=%ld&master_comment_id=%@",user_id,device_id,unique_code,(long)limit,(long)offset,self.masterCommentID];
    
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
                
                NSArray *aryBarList = [tempDict valueForKey:@"beer_subcomment"];
                [self getMoreBeerCommentsFromResult:aryBarList];
            }
            
            [self registerCell];
            
        }
        else {
            
        }
        [self.tblView reloadData];
    }];
    
}

-(void)getMoreBeerCommentsFromResult:(NSArray *)aryBarList {
    for(int i=0; i<[aryBarList count]; i++)
    {
        NSDictionary *dict = [aryBarList objectAtIndex:i];
        BeerComment *beerComment = [BeerComment getBeerCommentWithDictionary:dict];
        [self.aryList addObject:beerComment];
    }
    offset = offset + limit;
    [self.tblView reloadData];
}

#pragma mark cocktail_subcomments
-(void)cocktail_subcomments
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.mode = MBProgressHUDModeIndeterminate;
    
    User *user = [CommonUtils getUserLoginDetails];
    NSString *user_id = [user user_id];
    NSString *device_id = [user device_id];
    NSString *unique_code =[user unique_code];
    
    //192.168.1.27/ADB/api/beer_comments
    NSString *myURL = [NSString stringWithFormat:@"%@cocktail_subcomments",WEBSERVICE_URL];
    NSMutableURLRequest *Request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: myURL]];
    
    NSString *params = [NSString stringWithFormat:@"user_id=%@&device_id=%@&unique_code=%@&limit=%ld&offset=%ld&master_comment_id=%@",user_id,device_id,unique_code,(long)limit,(long)offset,self.masterCommentID];
    
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
                totalRecords = [[CommonUtils getNotNullString:[tempDict valueForKey:@"cocktail_subcomment_total"]] integerValue];
                offset = offset + limit;
                NSArray *aryBarList = [tempDict valueForKey:@"cocktail_subcomment"];
                self.aryList = [self getCocktailComments:aryBarList];
                [self registerCell];
                
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
        [self.tblView reloadData];
    }];
    
}


-(NSMutableArray *)getCocktailComments:(NSArray *)aryCocktailComments_ {
    NSMutableArray *aryComments = [@[] mutableCopy];
    if ([aryComments count]>0) {
        [aryComments removeAllObjects];
    }
    
    for (NSDictionary *dict in aryCocktailComments_) {
        CocktailComment *cocktailComment = [CocktailComment getCocktailCommentWithDictionary:dict];
        [aryComments addObject:cocktailComment];
    }
    return aryComments;
}

#pragma mark cocktail_subcomments WITH LOAD MORE
-(void)cocktail_subcomments_LOAD_MORE
{
    User *user = [CommonUtils getUserLoginDetails];
    NSString *user_id = [user user_id];
    NSString *device_id = [user device_id];
    NSString *unique_code =[user unique_code];
    
    //192.168.1.27/ADB/api/beer_comments
    NSString *myURL = [NSString stringWithFormat:@"%@cocktail_subcomments",WEBSERVICE_URL];
    NSMutableURLRequest *Request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: myURL]];
    
    NSString *params = [NSString stringWithFormat:@"user_id=%@&device_id=%@&unique_code=%@&limit=%ld&offset=%ld&master_comment_id=%@",user_id,device_id,unique_code,(long)limit,(long)offset,self.masterCommentID];
    
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
                
                NSArray *aryBarList = [tempDict valueForKey:@"cocktail_subcomment"];
                [self getMoreCocktailCommentsFromResult:aryBarList];
            }
        }
        else {
            
        }
        
    }];
    
}

-(void)getMoreCocktailCommentsFromResult:(NSArray *)aryBarList {
    for(int i=0; i<[aryBarList count]; i++)
    {
        NSDictionary *dict = [aryBarList objectAtIndex:i];
        CocktailComment *cocktailComment = [CocktailComment getCocktailCommentWithDictionary:dict];
        [self.aryList addObject:cocktailComment];
    }
    offset = offset + limit;
    [self.tblView reloadData];
}

#pragma mark liquor_subcomments
-(void)liquor_subcomments
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.mode = MBProgressHUDModeIndeterminate;
    
    User *user = [CommonUtils getUserLoginDetails];
    NSString *user_id = [user user_id];
    NSString *device_id = [user device_id];
    NSString *unique_code =[user unique_code];
    
    //192.168.1.27/ADB/api/beer_comments
    NSString *myURL = [NSString stringWithFormat:@"%@liquor_subcomments",WEBSERVICE_URL];
    NSMutableURLRequest *Request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: myURL]];
    
    NSString *params = [NSString stringWithFormat:@"user_id=%@&device_id=%@&unique_code=%@&limit=%ld&offset=%ld&master_comment_id=%@",user_id,device_id,unique_code,(long)limit,(long)offset,self.masterCommentID];
    
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
                totalRecords = [[CommonUtils getNotNullString:[tempDict valueForKey:@"liquor_subcomment_total"]] integerValue];
                offset = offset + limit;
                NSArray *aryBarList = [tempDict valueForKey:@"liquor_subcomment"];
                self.aryList = [self getLiquorComments:aryBarList];
                
                [self registerCell];
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
        [self.tblView reloadData];
    }];
    
}
-(NSMutableArray *)getLiquorComments:(NSArray *)aryLiquorComments_ {
    NSMutableArray *aryComments = [@[] mutableCopy];
    if ([aryComments count]>0) {
        [aryComments removeAllObjects];
    }
    
    for (NSDictionary *dict in aryLiquorComments_) {
        LiquorComment *liquorComment = [LiquorComment getLiquorCommentWithDictionary:dict];
        [aryComments addObject:liquorComment];
    }
    return aryComments;
}

#pragma mark liquor_subcomments WITH LOAD MORE
-(void)liquor_subcomments_LOAD_MORE
{
    User *user = [CommonUtils getUserLoginDetails];
    NSString *user_id = [user user_id];
    NSString *device_id = [user device_id];
    NSString *unique_code =[user unique_code];
    
    //192.168.1.27/ADB/api/beer_comments
    NSString *myURL = [NSString stringWithFormat:@"%@liquor_subcomments",WEBSERVICE_URL];
    NSMutableURLRequest *Request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: myURL]];
    
    NSString *params = [NSString stringWithFormat:@"user_id=%@&device_id=%@&unique_code=%@&limit=%ld&offset=%ld&master_comment_id=%@",user_id,device_id,unique_code,(long)limit,(long)offset,self.masterCommentID];
    
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
                
                NSArray *aryBarList = [tempDict valueForKey:@"liquor_subcomment"];
                [self getMoreLiquorCommentsFromResult:aryBarList];
            }
        }
        else {
            
        }
        
    }];
    
}

-(void)getMoreLiquorCommentsFromResult:(NSArray *)aryBarList {
    for(int i=0; i<[aryBarList count]; i++)
    {
        NSDictionary *dict = [aryBarList objectAtIndex:i];
        LiquorComment *liquorComment = [LiquorComment getLiquorCommentWithDictionary:dict];
        [self.aryList addObject:liquorComment];
    }
    offset = offset + limit;
    [self.tblView reloadData];
}





-(void)add_subcomment {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.mode = MBProgressHUDModeIndeterminate;
    
    User *user = [CommonUtils getUserLoginDetails];
    NSString *user_id = [user user_id];
    NSString *device_id = [user device_id];
    NSString *unique_code =[user unique_code];
    
    NSString *myURL = nil;
    NSString *params = nil;
    
    //192.168.1.27/ADB/api/bar_details
    if ([self.type isEqualToString:@"beer"]) {
        // Call Web service beer_comments
        myURL = [NSString stringWithFormat:@"%@add_beer_subcomment",WEBSERVICE_URL];
        params = [NSString stringWithFormat:@"user_id=%@&device_id=%@&unique_code=%@&beer_id=%@&master_comment_id=%@&comment=%@",user_id,device_id,unique_code,self.fullBeerDetail.beerDetail.beer_id,self.masterCommentID,comment];
        
    }
    else if([self.type isEqualToString:@"cocktail"]) {
        // Call Web service cocktail_comments
        myURL = [NSString stringWithFormat:@"%@add_cocktail_comment",WEBSERVICE_URL];
        params = [NSString stringWithFormat:@"user_id=%@&device_id=%@&unique_code=%@&cocktail_id=%@&master_comment_id=%@&comment=%@",user_id,device_id,unique_code,self.fullCocktailDetail.cocktailDetail.cocktail_cocktail_id,self.masterCommentID,comment];
        
    }
    else {
        // Call Web service liquor_comments
        myURL = [NSString stringWithFormat:@"%@add_liquor_comment",WEBSERVICE_URL];
        params = [NSString stringWithFormat:@"user_id=%@&device_id=%@&unique_code=%@&liquor_id=%@&master_comment_id=%@&comment=%@",user_id,device_id,unique_code,self.fullLiquorDetail.liquorDetail.liquor_liquor_id,self.masterCommentID,comment];
        
    }
    NSMutableURLRequest *Request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: myURL]];
    //NSString *params = [NSString stringWithFormat:@"user_id=%@&limit=%ld&offset=%ld&bar_id=%@",user_id,(long)limit,(long)offset,self.bar.bar_id];
    
    
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
                
                ShowAlert(AlertTitle, @"Your comment is added successfully");
                
                [self.aryList removeAllObjects];
                
                limit = 10;
                offset = 0;
                totalRecords = 0;
                
                comment = @"";
                [self configureWriteReviewTextView];
                
                
                showingLeaveCommentPlaceholder = YES;
                
                //192.168.1.27/ADB/api/bar_details
                if ([self.type isEqualToString:@"beer"]) {
                    // Call Web service beer_comments
                    [self callBeerSubCommentWebservice];
                }
                else if([self.type isEqualToString:@"cocktail"]) {
                    // Call Web service cocktail_comments
                    [self callCocktailSubCommentWebservice];
                }
                else {
                    // Call Web service liquor_comments
                    [self callLiquorSubCommentWebservice];
                }
                
                
            }
        }
        else {
        }
        
        // [self.tblView reloadData];
        
    }];
    
}


#pragma mark removeComment
-(void)removeComment {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.mode = MBProgressHUDModeIndeterminate;
    
    User *user = [CommonUtils getUserLoginDetails];
    NSString *user_id = [user user_id];
    NSString *device_id = [user device_id];
    NSString *unique_code =[user unique_code];
    
    NSString *myURL = nil;
    NSString *params = nil;
    
    
    id  cmt = [self.aryList objectAtIndex:deleteCommentIndex];
    
    
    //192.168.1.27/ADB/api/bar_details
    if ([self.type isEqualToString:@"beer"]) {
        // Call Web service beer_comments
        BeerComment *beerComment = (BeerComment *)cmt;
        myURL = [NSString stringWithFormat:@"%@remove_beer_comment",WEBSERVICE_URL];
        params = [NSString stringWithFormat:@"user_id=%@&device_id=%@&unique_code=%@&beer_comment_id=%@",user_id,device_id,unique_code,beerComment.beerComment_beer_comment_id];
    }
    else if([self.type isEqualToString:@"cocktail"]) {
        // Call Web service cocktail_comments
        CocktailComment *cocktailComment = (CocktailComment *)cmt;
        myURL = [NSString stringWithFormat:@"%@remove_cocktail_comment",WEBSERVICE_URL];
        params = [NSString stringWithFormat:@"user_id=%@&device_id=%@&unique_code=%@&cocktail_comment_id=%@",user_id,device_id,unique_code,cocktailComment.cocktail_comment_id];
    }
    else {
        // Call Web service liquor_comments
        LiquorComment *liquorComment = (LiquorComment *)cmt;
        myURL = [NSString stringWithFormat:@"%@remove_liquor_comment",WEBSERVICE_URL];
        params = [NSString stringWithFormat:@"user_id=%@&device_id=%@&unique_code=%@&liquor_comment_id=%@",user_id,device_id,unique_code,liquorComment.liquor_comment_id];
    }
    
    
    NSMutableURLRequest *Request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: myURL]];
    //NSString *params = [NSString stringWithFormat:@"user_id=%@&limit=%ld&offset=%ld&bar_id=%@",user_id,(long)limit,(long)offset,self.bar.bar_id];
    
    
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
                
                [self.aryList removeObjectAtIndex:deleteCommentIndex];
                
            }
        }
        else {
        }
        
        [self.tblView reloadData];
        
    }];
    
}

/*#pragma mark bar_lists
 -(void)bar_lists
 {
 [MBProgressHUD hideHUDForView:self.view animated:YES];
 HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
 HUD.delegate = self;
 HUD.mode = MBProgressHUDModeIndeterminate;
 
 User *user = [CommonUtils getUserLoginDetails];
 NSString *user_id = [user user_id];
 NSString *device_id = [user device_id];
 NSString *unique_code =[user unique_code];
 
 NSString *name,*state,*city,*zip;
 name = self.searchDetail.searchByName;
 state = self.searchDetail.searchByState;
 city = self.searchDetail.searchByCity;
 zip = self.searchDetail.searchByZip;
 
 //192.168.1.27/ADB/api/bar_lists
 NSString *myURL = [NSString stringWithFormat:@"%@bar_lists",WEBSERVICE_URL];
 NSMutableURLRequest *Request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: myURL]];
 
 // NSString *params = [NSString stringWithFormat:@"user_id=%@&device_id=%@&unique_code=%@&limit=%ld&offset=%ld&state=%@&city=%@&zipcode=%@&title=%@&order_by=%@",user_id,device_id,unique_code,(long)limit,(long)offset,state,city,zip,name,order_by];
 
 NSString *params = [NSString stringWithFormat:@"user_id=%@&device_id=%@&unique_code=%@&limit=%ld&offset=%ld&state=%@&city=%@&zipcode=%@&title=%@&order_by=%@&lat=%@&lang=%@&address_j=%@&days=%@",user_id,device_id,unique_code,(long)limit,(long)offset,state,city,zip,name,order_by,@"",@"",self.searchDetail.searchAddress,self.searchDetail.searchDays];
 
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
 totalRecords = [[CommonUtils getNotNullString:[tempDict valueForKey:@"barlist_total"]] integerValue];
 offset = offset + limit;
 NSArray *aryBarList = [[tempDict valueForKey:@"barlist"] valueForKey:@"result"];
 self.aryList = [self getBarsFromResult:aryBarList];
 
 [self.tblView reloadData];
 }
 }
 else {
 }
 if([self.aryList count]==0){
 AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
 [appDelegate.window makeToast:@"No records found" duration:4.0 position:CSToastPositionBottom];
 self.btnSuggest.hidden = NO;
 }
 else {
 self.btnSuggest.hidden = YES;
 }
 }];
 }
 
 -(NSMutableArray *)getBarsFromResult:(NSArray *)aryBarList
 {
 NSMutableArray *aryBars = [@[] mutableCopy];
 if ([aryBars count]>0) {
 [aryBars removeAllObjects];
 }
 
 for (NSDictionary *dict in aryBarList) {
 Bar *bar = [Bar getBarWithDictionary:dict];
 [aryBars addObject:bar];
 }
 return aryBars;
 }
 
 #pragma mark bar_lists WITH LOAD MORE
 -(void)bar_lists_LOAD_MORE
 {
 
 User *user = [CommonUtils getUserLoginDetails];
 NSString *user_id = [user user_id];
 NSString *device_id = [user device_id];
 NSString *unique_code =[user unique_code];
 
 NSString *name,*state,*city,*zip;
 name = self.searchDetail.searchByName;
 state = self.searchDetail.searchByState;
 city = self.searchDetail.searchByCity;
 zip = self.searchDetail.searchByZip;
 
 //192.168.1.27/ADB/api/bar_lists
 NSString *myURL = [NSString stringWithFormat:@"%@bar_lists",WEBSERVICE_URL];
 NSMutableURLRequest *Request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: myURL]];
 
 // NSString *params = [NSString stringWithFormat:@"limit=%ld&offset=%ld&state=%@&city=%@&zipcode=%@&title=%@",(long)limit,(long)offset,state,city,zip,name];
 
 NSString *params = [NSString stringWithFormat:@"user_id=%@&device_id=%@&unique_code=%@&limit=%ld&offset=%ld&state=%@&city=%@&zipcode=%@&title=%@&order_by=%@&lat=%@&lang=%@&address_j=%@&days=%@",user_id,device_id,unique_code,(long)limit,(long)offset,state,city,zip,name,order_by,@"",@"",self.searchDetail.searchAddress,self.searchDetail.searchDays];
 
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
 
 NSArray *aryBarList = [[tempDict valueForKey:@"barlist"] valueForKey:@"result"];
 [self getMoreBarsFromResult:aryBarList];
 }
 }
 else {
 
 }
 
 }];
 
 }
 
 -(void)getMoreBarsFromResult:(NSArray *)aryBarList {
 
 for(int i=0; i<[aryBarList count]; i++)
 {
 NSDictionary *dict = [aryBarList objectAtIndex:i];
 Bar *bar = [Bar getBarWithDictionary:dict];
 [self.aryList addObject:bar];
 }
 offset = offset + limit;
 [self.tblView reloadData];
 }
 
 */




@end
