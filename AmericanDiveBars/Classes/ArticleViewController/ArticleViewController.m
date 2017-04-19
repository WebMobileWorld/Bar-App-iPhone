//
//  ArticleViewController.m
//  AmericanDiveBars
//
//  Created by spaculus on 4/18/16.
//  Copyright © 2016 spaculus. All rights reserved.
//

#import "ArticleViewController.h"

#import "DirectoryCommentCell.h"
#import "BarHeaderView.h"

#import "ArticleCell.h"

static NSString * const kLeaveCommentPlaceholderText = @"Insert Comment Here...";

static NSString * const ArticleCellIdentifier = @"ArticleCell";

@interface ArticleViewController () <MBProgressHUDDelegate,FPPopoverControllerDelegate>
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
    
    
    // Leave A Comment
    BOOL showingLeaveCommentPlaceholder;
    NSString *commentTitle;
    NSString *comment;
    
    
    NSString *searchText;
    
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

@property (strong, nonatomic) IBOutlet UIView * viewWriteReview;

@end



@implementation ArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [CommonUtils setTitleLabel:@"ARTICLES"];
    
    [self configureTopButtons];
    //[self configureBarTableView];
    
    [self initializeDataStructure];
    
    [self configureWriteReview];
    
    [self callListArticleWebservice];
}

-(void)initializeDataStructure {
    [self configureFavHeaderView:@"Search an Article"];
    self.aryList = [[NSMutableArray alloc]  init];
    limit = 10;
    offset = 0;
    totalRecords = 0;
    
    comment = @"";
    commentTitle = @"";
    searchText = @"";
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setNavImage];
    self.navigationController.navigationBar.topItem.title = @" ";
    temp = YES;
    [self registerCell];
    [self.tblView reloadData];
}


-(void)setStatusBarVisibility {
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

-(void)viewDidLayoutSubviews {
    [self setStatusBarVisibility];
    popover.contentSize = CGSizeMake(150, self.view.bounds.size.height-20);
}

-(void)setNavImage{
    CGSize blankImageSize = CGSizeMake(self.view.bounds.size.width, 64);
    UIImage *blank = [CommonUtils imageFromColor:[UIColor colorWithRed:187.0/255.0 green:124.0/255.0 blue:37.0/255.0 alpha:1.0] forSize:blankImageSize withCornerRadius:0.0];
    [CommonUtils setNavigationBarImage:blank forNavigationBar:self.navigationController.navigationBar];
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


#pragma mark - Header View

-(void)configureFavHeaderView:(NSString *)placeHolderText {
    searchText = @"";
    self.txtSearch.placeholder = placeHolderText;
    self.txtSearch.text = @"";
    [self.txtSearch setValue:[UIColor colorWithRed:121.0/255.0 green:121.0/255.0 blue:121.0/255.0 alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];
    
    [CommonUtils setBorderAndCorner_ForTextField:self.txtSearch forCornerRadius:2.0 forBorderWidth:0.8 withPadding:10 andColor:[[UIColor colorWithRed:59.0/255.0 green:58.0/255.0 blue:53.0/255.0 alpha:1.0] CGColor]];
    
    self.btnReset.layer.borderColor = [[UIColor colorWithRed:59.0/255.0 green:58.0/255.0 blue:53.0/255.0 alpha:1.0] CGColor];
    self.btnReset.layer.borderWidth = 1.0f;
    
    [CommonUtils setRightImageToTextField:self.txtSearch withImage:@"search-by-name.png" withPadding:35 withWidth:25 withHeight:25 forSelector:@selector(searchTapped) forTarget:self];
}


-(void)searchTapped {
    [self.txtSearch resignFirstResponder];
    
    if ([searchText length]!=0) {
        if ([self.aryList count]!=0) {
            [self.aryList removeAllObjects];
        }
        limit = 10;
        offset = 0;
        totalRecords = 0;
        
        [self callListArticleWebservice];
    }
    else {
        if ([self.aryList count]!=0) {
            [self.aryList removeAllObjects];
        }
        
        [self configureFavHeaderView:@"Search an Article"];
        limit = 10;
        offset = 0;
        totalRecords = 0;
        
        comment = @"";
        commentTitle = @"";
        searchText = @"";

        [self callListArticleWebservice];
    }
}


- (IBAction)btnReset_Clicked:(id)sender {
    [self.txtSearch resignFirstResponder];
    if ([self.aryList count]!=0) {
        [self.aryList removeAllObjects];
    }
    
    [self configureFavHeaderView:@"Search an Article"];
    limit = 10;
    offset = 0;
    totalRecords = 0;
    
    comment = @"";
    commentTitle = @"";
    searchText = @"";
    
    [self callListArticleWebservice];
}

#pragma mark - TEXT FIELD DELEGATES
#pragma mark - TextField

#pragma mark Textfield Delegates

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    searchText = textField.text;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    searchText = newString;
    return YES;
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if ([searchText length]!=0) {
        if ([self.aryList count]!=0) {
            [self.aryList removeAllObjects];
        }
        limit = 10;
        offset = 0;
        totalRecords = 0;
        
        [self callListArticleWebservice];
    }
    else {
        if ([self.aryList count]!=0) {
            [self.aryList removeAllObjects];
        }
        
        [self configureFavHeaderView:@"Search an Article"];
        limit = 10;
        offset = 0;
        totalRecords = 0;
        
        comment = @"";
        commentTitle = @"";
        searchText = @"";
        
        [self callListArticleWebservice];
    }
    return YES;
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
    controller.articleDelegate = self;
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
    [self.tblView registerNib:[UINib nibWithNibName:@"ArticleCell" bundle:nil] forCellReuseIdentifier:ArticleCellIdentifier];
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
            return [self ArticleCellAtIndexPath:indexPath];
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
                    [self callListArticleWebservice_LOAD_MORE];
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
#pragma mark ArticleCell Cell Configuration
- (ArticleCell *)ArticleCellAtIndexPath:(NSIndexPath *)indexPath
{
    static ArticleCell *cell = nil;
    cell = [self.tblView dequeueReusableCellWithIdentifier:ArticleCellIdentifier];
    [self configureArticleCell:cell atIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)configureArticleCell:(ArticleCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    
    Article *article = [self.aryList objectAtIndex:indexPath.row];
    cell.lblTitle.text = [article blog_title];
    cell.lblArticle.text = [article blog_description];//[CommonUtils removeHTMLFromString:[article blog_description]];
    
    NSString *blog_image = [article blog_image];
    NSString *strImgURL = [NSString stringWithFormat:@"%@%@%@",WEBIMAGE_URL,IMAGETHUMB_BLOG,blog_image]; 
    NSURL *imgArticle = [NSURL URLWithString:strImgURL];
    
    [cell.imgArticle sd_setImageWithURL:imgArticle placeholderImage:[UIImage imageNamed:@"no-article.png"]];
    
    /*LiquorComment  *liquorComment = [[fullLiquorDetail aryLiquorComments] objectAtIndex:indexPath.row];
     
     if ([liquorComment.liquor_user_id isEqualToString:@"0"]) {
     cell.lblUserName.text = @"ADB";
     }
     else {
     cell.lblUserName.text = [CommonUtils removeHTMLFromString:liquorComment.liquor_fullName];
     }
     
     
     cell.lblTitle.text = [CommonUtils removeHTMLFromString:liquorComment.liquor_comment_title];
     cell.lblDesc.text = [CommonUtils removeHTMLFromString:liquorComment.liquor_comment];
     
     NSString *strDuration = liquorComment.liquor_date_added; //[[CommonUtils getDateFromString:liquorComment.liquor_date_added withFormat:@"yyyy-MM-dd HH:mm:ss"] formattedAsTimeAgo];
     cell.lblTimeAgo.text = strDuration;
     
     NSString *profile_image = [liquorComment liquor_profile_image];
     NSString *strImgURL = [NSString stringWithFormat:@"%@%@%@",WEBIMAGE_URL,USERPROFILEIMAGE_COMMENT,profile_image];
     NSURL *imgURL = [NSURL URLWithString:strImgURL];
     
     [cell.imgUser sd_setImageWithURL:imgURL placeholderImage:[UIImage imageNamed:@"user-no_image_RM.png"]];*/
    
//    cell.btnReply.tag = indexPath.row;
//    cell.btnLike.tag = indexPath.row;
//    
//    [cell.btnReply addTarget:self action:@selector(replyOnComment:) forControlEvents:UIControlEventTouchUpInside];
//    [cell.btnLike addTarget:self action:@selector(likeComment:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [cell.btnLike setImage:[UIImage imageNamed:@"thumb_default.png"] forState:UIControlStateNormal];
    
}

-(void)replyOnComment:(UIButton *)btnReply {
    DirectoryReplyViewController *replyVC = [[DirectoryReplyViewController alloc] initWithNibName:@"DirectoryReplyViewController" bundle:nil];
    [self.navigationController pushViewController:replyVC animated:YES];
}

-(void)likeComment:(UIButton *)btnLike {
    [btnLike setImage:[UIImage imageNamed:@"thumb_up.png"] forState:UIControlStateNormal];
    
}
#pragma mark Height For Row

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.section)
    {
        case 0:
        {
            CGFloat cellHeight = [self heightForArticleCellAtIndexPath:indexPath];
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
#pragma mark ArticleCell Cell With Height Configuration
- (CGFloat)heightForArticleCellAtIndexPath:(NSIndexPath *)indexPath
{
    static ArticleCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tblView dequeueReusableCellWithIdentifier:ArticleCellIdentifier];
    });
    
    [self configureArticleCell:sizingCell atIndexPath:indexPath];
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
            return 119;
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
    Article *article = [self.aryList objectAtIndex:indexPath.row];
    ArticleDetailViewController *detail = [[ArticleDetailViewController alloc] initWithNibName:@"ArticleDetailViewController" bundle:nil];
    detail.article = article;
    [self.navigationController pushViewController:detail animated:YES];
}





#pragma mark - Webservice Call
-(void)callListArticleWebservice {
    
    [CommonUtils callWebservice:@selector(listarticle) forTarget:self];
    
}

-(void)callListArticleWebservice_LOAD_MORE {
    [CommonUtils callWebservice:@selector(listarticle_LOAD_MORE) forTarget:self];
}

#pragma mark - Webservice
#pragma mark listarticle
 -(void)listarticle
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
     NSString *myURL = [NSString stringWithFormat:@"%@listarticle",WEBSERVICE_URL];
     NSMutableURLRequest *Request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: myURL]];
     
     // NSString *params = [NSString stringWithFormat:@"user_id=%@&device_id=%@&unique_code=%@&limit=%ld&offset=%ld&state=%@&city=%@&zipcode=%@&title=%@&order_by=%@",user_id,device_id,unique_code,(long)limit,(long)offset,state,city,zip,name,order_by];
     
     NSString *params = [NSString stringWithFormat:@"user_id=%@&device_id=%@&unique_code=%@&limit=%ld&offset=%ld&keyword=%@",user_id,device_id,unique_code,(long)limit,(long)offset,searchText];
     
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
             totalRecords = [[CommonUtils getNotNullString:[tempDict valueForKey:@"article_total"]] integerValue];
             offset = offset + limit;
             NSArray *aryArticleList = [tempDict valueForKey:@"result"];
             self.aryList = [self getArticlesFromResult:aryArticleList];
             
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             
             [self.tblView reloadData];
         }
     }
     else {
     }
     if([self.aryList count]==0){
            //         AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            //         [appDelegate.window makeToast:@"No records found" duration:4.0 position:CSToastPositionBottom];
            //         self.btnSuggest.hidden = NO;
     }
     else {
            //         self.btnSuggest.hidden = YES;
     }
     }];
}

-(NSMutableArray *)getArticlesFromResult:(NSArray *)aryArticleList
{
    NSMutableArray *aryArticles = [@[] mutableCopy];
    if ([aryArticles count]>0) {
        [aryArticles removeAllObjects];
    }
    
    for (NSDictionary *dict in aryArticleList) {
        Article *article = [Article getArticleWithDictionary:dict];
        [aryArticles addObject:article];
    }
    return aryArticles;
}
 
 #pragma mark bar_lists WITH LOAD MORE
 -(void)listarticle_LOAD_MORE
 {
     
     User *user = [CommonUtils getUserLoginDetails];
     NSString *user_id = [user user_id];
     NSString *device_id = [user device_id];
     NSString *unique_code =[user unique_code];
     
     //192.168.1.27/ADB/api/bar_lists
     NSString *myURL = [NSString stringWithFormat:@"%@listarticle",WEBSERVICE_URL];
     NSMutableURLRequest *Request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: myURL]];
     
     // NSString *params = [NSString stringWithFormat:@"limit=%ld&offset=%ld&state=%@&city=%@&zipcode=%@&title=%@",(long)limit,(long)offset,state,city,zip,name];
     
      NSString *params = [NSString stringWithFormat:@"user_id=%@&device_id=%@&unique_code=%@&limit=%ld&offset=%ld&keyword=%@",user_id,device_id,unique_code,(long)limit,(long)offset,searchText];
     
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
         
             NSArray *aryArticleList = [tempDict valueForKey:@"result"];
             [self getMoreArticlesFromResult:aryArticleList];
         }
     }
     else {
     
     }
     
     }];
 
 }
 
 -(void)getMoreArticlesFromResult:(NSArray *)aryArticleList {
     
     for(int i=0; i<[aryArticleList count]; i++)
     {
         NSDictionary *dict = [aryArticleList objectAtIndex:i];
         Article *article = [Article getArticleWithDictionary:dict];
         [self.aryList addObject:article];
     }
     offset = offset + limit;
     [self.tblView reloadData];
 }



#pragma mark - Oriantation

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [self setStatusBarVisibility];
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
         
         
         
     } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         
     }];
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}



@end
