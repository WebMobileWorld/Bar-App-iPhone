//
//  TaxiDirectoryViewController.m
//  AmericanDiveBars
//
//  Created by spaculus on 8/31/15.
//  Copyright (c) 2015 spaculus. All rights reserved.
//

#import "TaxiDirectoryViewController.h"
#import "TaxiDirectoryCell.h"
#import "TaxiDirectoryDetailViewController.h"

static NSString * const TaxiDirectoryCellIdentifier = @"TaxiDirectoryCell";
#define Nib_TaxiDirectoryCell @"TaxiDirectoryCell"

@interface TaxiDirectoryViewController ()<MBProgressHUDDelegate,DirectoryHeaderViewDelegate,AlphabetSearchViewDelegate,TTTAttributedLabelDelegate,FPPopoverControllerDelegate,UIActionSheetDelegate>
{
    //HUD
    MBProgressHUD *HUD;
    
    //POPOVER
    FPPopoverController *popover;
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
    
    //Header Views
    DirectoryHeaderView *directoryHeaderView;
    
    //ALPHABET SEARCH VIEW
    AlphabetSearchView *alphabetSearchView;
    
    //BEER LIST WEBSERVICE PARAMS
    NSString *keyWord,*alpha;
    
}

//CUSTOM POPUP TABLE VIEW
@property (strong, nonatomic) LGFilterView  *filterView;
@property (strong, nonatomic) NSArray   *titlesArray;

//Main Table
@property (strong, nonatomic) IBOutlet UITableView *tblView;
@property (strong, nonatomic) NSMutableArray *aryList;

//ALPHABET SEARCH VIEW
@property (nonatomic, assign) BOOL containerIsOpen;
@property (strong, nonatomic) IBOutlet UIView *alphabetView;

@end

@implementation TaxiDirectoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [CommonUtils setTitleLabel:@"TAXI DIRECTORY"];
    [self configureTopButtons];
    [self initializeDataStructure];
    [self configureHeaderView];
    [self configureAlphabetView];
    [self callTaxiListWebservice];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.topItem.title = @" ";
    
    
    
    [self setStatusBarVisibility];
    
    
}
-(void)setStatusBarVisibility {
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

-(void)viewDidLayoutSubviews {
    [self setStatusBarVisibility];
    popover.contentSize = CGSizeMake(150, self.view.bounds.size.height-20);
    CGSize blankImageSize = CGSizeMake(self.view.bounds.size.width, 64);
    UIImage *blank = [CommonUtils imageFromColor:[UIColor colorWithRed:187.0/255.0 green:124.0/255.0 blue:37.0/255.0 alpha:1.0] forSize:blankImageSize withCornerRadius:0.0];
    [CommonUtils setNavigationBarImage:blank forNavigationBar:self.navigationController.navigationBar];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)initializeDataStructure {
    self.aryList = [[NSMutableArray alloc]  init];
    keyWord = @"";
    alpha = @"";
    
    limit = 10;
    offset = 0;
    totalRecords = 0;
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
//    FindBarViewController *findBar = [[FindBarViewController alloc] initWithNibName:@"FindBarViewController" bundle:nil];
//    [self.navigationController pushViewController:findBar animated:YES];
}


-(void)openRightMenu_Clicked:(UIButton *)btnRightMenu {
    
    [self btnFilterClicked:btnRightMenu];
}

-(void)btnFilterClicked:(id)sender
{
    LeftMenu_Popup *controller = [[LeftMenu_Popup alloc] initWithStyle:UITableViewStylePlain];
    controller.taxiDelegate = self;
    
    if ([CommonUtils isLoggedIn]) {
        //All
        controller.aryItems = @[@{@"image":@"user-no_image_LM.png",@"title":@"User"},
                                @{@"image":@"dashboard-LM.png",@"title":@"My Dashboard"},
                                @{@"image":@"bar-LM.png",@"title":@"Find Bar"},
                                @{@"image":@"beer-LM.png",@"title":@"Beer Directory"},
                                @{@"image":@"cocktail-LM.png",@"title":@"Cocktail Recipes"},
                                @{@"image":@"liquor-LM.png",@"title":@"Liquor Directory"},
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
            
        case 7:
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

#pragma mark - Alphabet Search View
-(void)configureAlphabetView {
    id view = [[[NSBundle mainBundle] loadNibNamed:@"AlphabetSearchView-ipad" owner:self options:nil] objectAtIndex:0];
    alphabetSearchView = (AlphabetSearchView *)view;
    alphabetSearchView.delegate = self;
    self.containerIsOpen = NO;
    [alphabetSearchView configureAlphabetSearchView];
    [self.alphabetView addSubview:alphabetSearchView];
    [self.view layoutIfNeeded];
}

#pragma mark Alphabet Search View  Delegate
-(void)didSelectCharacter:(NSString *)charecter {
    NSLog(@"%@",charecter);
    [self animateAlphabetView];
    alpha = charecter;
    keyWord = @"";
    [directoryHeaderView setSearchTextfieldClear];
    limit = 10;
    offset = 0;
    [self callTaxiListWebservice];
}

#pragma mark Animate Alphabet Serach View
- (void)animateAlphabetView
{
    if (self.containerIsOpen) {
        [self replaceTopConstraintOnView:self.alphabetView withConstant:-191.0];
    } else {
        [alphabetSearchView reloadCollectionView];
        [self replaceTopConstraintOnView:self.alphabetView withConstant:0.0];
    }
    
    [self animateConstraints];
    self.containerIsOpen = !self.containerIsOpen;
}

#pragma mark Alphabet Search View Helper Methods
- (void)replaceTopConstraintOnView:(UIView *)view withConstant:(float)constant
{
    //NSLog(@"%@",self.view.constraints);
    //Check constraint with : - <NSLayoutConstraint:0x7f86059debb0 H:[UIView:0x7f860720dcd0]-(-160)-|   (Names: '|':UIView:0x7f860720d2d0 )>
    //i.e. :- NSLayoutAttributeTrailing
    [self.view.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
        if ((idx==5) && (constraint.firstAttribute == NSLayoutAttributeTrailing)) {
            constraint.constant = constant;
        }
    }];
}

- (void)animateConstraints
{
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        if (finished) {
        }
    }];
}

#pragma mark - LG POPUP VIEW

-(void)setDataStructureForLGView {
    _titlesArray = @[@{@"title":@"Sort By",@"value":@""},
                     @{@"title":@"Company Name A-Z",@"value":@"taxi_company#ASC"},
                     @{@"title":@"Company Name Z-A",@"value":@"taxi_company#DESC"},
                     @{@"title":@"CITY A-Z",@"value":@"city#ASC"},
                     @{@"title":@"CITY Z-A",@"value":@"city#DESC"},
                     @{@"title":@"STATE A-Z",@"value":@"state#ASC"},
                     @{@"title":@"STATE Z-A",@"value":@"state#DESC"},
                     @{@"title":@"ZIP CODE A-Z",@"value":@"cmpn_zipcode#ASC"},
                     @{@"title":@"ZIP CODE Z-A",@"value":@"cmpn_zipcode#DESC"}
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
                           directoryHeaderView.lblFilterType.text = title;
                           selectedIndex = index;
                           order_by = [[_titlesArray objectAtIndex:index] valueForKey:@"value"];
                           limit = 10;
                           offset = 0;
                           [self callTaxiListWebservice];
                       }
                   }
                                         cancelHandler:nil];
    _filterView.transitionStyle = style;
    _filterView.numberOfLines = 0;
}


#pragma mark - Table View
-(void)registerCell
{
    [self.tblView registerNib:[UINib nibWithNibName:Nib_TaxiDirectoryCell bundle:nil] forCellReuseIdentifier:TaxiDirectoryCellIdentifier];
}

-(void)configureHeaderView  {
    id headerView = [[[NSBundle mainBundle] loadNibNamed:@"DirectoryHeaderView" owner:self options:nil] objectAtIndex:0];
    directoryHeaderView = (DirectoryHeaderView *)headerView;
    [directoryHeaderView configureBeerHeaderView:@"Search by company name"];
    directoryHeaderView.lblSearchTitle.text = @"";
    directoryHeaderView.lblFilterType.text = @"Sort By";
    order_by = @"";
    directoryHeaderView.delegate = self;
    [self setDataStructureForLGView];
}

#pragma mark Header View Delegate
-(void)didShowAlphabetSearchView:(BOOL)open {
    [self animateAlphabetView];
}
-(void)setSortingType {
    if (self.containerIsOpen) {
        [self replaceTopConstraintOnView:self.alphabetView withConstant:-191.0];
        [self animateConstraints];
        self.containerIsOpen = !self.containerIsOpen;
    }
    [self filterAction];
}
-(void)didSearchTapped:(NSString *)typedKeyWord {
    //alphabetSearchView.selectedIndex = -1;
    //alpha = @"";
    keyWord = typedKeyWord;
    limit = 10;
    offset = 0;
    if ([typedKeyWord length]==0) {
        directoryHeaderView.lblSearchTitle.text = @"";
    }
    else {
        directoryHeaderView.lblSearchTitle.text = [NSString stringWithFormat:@"Search Result for %@",typedKeyWord];
    }
    [self callTaxiListWebservice];
}
#pragma mark View For Header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return directoryHeaderView;
    }
    else {
        return nil;
    }
}

#pragma mark Height For Header
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 107;
            break;
            
        default:
            return 0;
            break;
    }
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
            return [self TaxiDirectoryCellAtIndexPath:indexPath];
            
            
                    //            static NSString *simpleTableIdentifier = @"TaxiDirectoryCell";
                    //            
                    //            TaxiDirectoryCell *cell = (TaxiDirectoryCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
                    //            if (cell == nil)
                    //            {
                    //                NSArray *nib;
                    //                if([CommonUtils isiPad])
                    //                {
                    //                    nib = [[NSBundle mainBundle] loadNibNamed:@"TaxiDirectoryCell" owner:self options:nil];
                    //                }
                    //                else
                    //                {
                    //                    nib = [[NSBundle mainBundle] loadNibNamed:@"TaxiDirectoryCell" owner:self options:nil];
                    //                }
                    //                cell = [nib objectAtIndex:0];
                    //                [cell configureCell];
                    //            }
                    //            
                    //            TaxiDirectory *taxi = [self.aryList objectAtIndex:indexPath.row];
                    //            
                    //            cell.lblTaxiTitle.text = [taxi.taxi_company stripHtml];
                    //            cell.lblDesc.text = [taxi.taxi_desc stripHtml];
                    //            cell.lblAddress.text = [taxi.taxi_address stripHtml];
                    //            
                    //            NSString *taxi_logo = [taxi taxi_image];
                    //            NSString *strImgURL = [NSString stringWithFormat:@"%@%@%@",WEBIMAGE_URL,TAXILOGO,taxi_logo];
                    //            NSURL *imgURL = [NSURL URLWithString:strImgURL];
                    //            
                    //            [cell.imgTaxiLogo sd_setImageWithURL:imgURL placeholderImage:[UIImage imageNamed:@"no_taxi.png"]];
                    //            
                    //            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
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
                    [self callTaxiListWebservice_LOAD_MORE];
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

#pragma mark TTTAttributedLabel Delegate
- (void)attributedLabel:(__unused TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    [[[UIActionSheet alloc] initWithTitle:[url absoluteString] delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Open Link in Safari", nil), nil] showInView:self.view];
}



#pragma mark
#pragma mark TaxiDirectoryCell Cell Configuration
- (TaxiDirectoryCell *)TaxiDirectoryCellAtIndexPath:(NSIndexPath *)indexPath
{
    static TaxiDirectoryCell *cell = nil;
    cell = [self.tblView dequeueReusableCellWithIdentifier:TaxiDirectoryCellIdentifier];
    [self configureTaxiDirectoryCell:cell atIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)configureTaxiDirectoryCell:(TaxiDirectoryCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    
    TaxiDirectory *taxi = [self.aryList objectAtIndex:indexPath.row];
    
    cell.lblTaxiTitle.text = [CommonUtils removeHTMLFromString:taxi.taxi_company];
    //cell.lblDesc.text = [taxi.taxi_desc stripHtml];
    cell.lblAddress.text = taxi.fulladdress; //[taxi.taxi_address stripHtml];
    cell.lblPhone.text = taxi.taxi_phone_number;
    
    NSString *taxi_logo = [taxi taxi_image];
    NSString *strImgURL = [NSString stringWithFormat:@"%@%@%@",WEBIMAGE_URL,TAXILOGO,taxi_logo];
    NSURL *imgURL = [NSURL URLWithString:strImgURL];
    
    [cell.imgTaxiLogo sd_setImageWithURL:imgURL placeholderImage:[UIImage imageNamed:@"no_taxi.png"]];
    
}
#pragma mark Height For Row

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
            //DirectoryCell
        case 0:
        {
            CGFloat cellHeight = [self heightForTaxiDirectoryCellAtIndexPath:indexPath];
            return cellHeight;
        }
            break;
            
            //LoadMoreCell
        case 1:
            return 30;
            break;
            
        default:
            return 44;
            break;
    }
    
}

#pragma mark
#pragma mark TaxiDirectoryCell Cell With Height Configuration
- (CGFloat)heightForTaxiDirectoryCellAtIndexPath:(NSIndexPath *)indexPath
{
    static TaxiDirectoryCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tblView dequeueReusableCellWithIdentifier:TaxiDirectoryCellIdentifier];
    });
    
    [self configureTaxiDirectoryCell:sizingCell atIndexPath:indexPath];
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
    switch (indexPath.section) {
        case 0:
            return 144;
            break;
            
        case 1:
            return 30;
            break;
            
        default:
            return 44;
            break;
    }
}

#pragma mark did Select Row
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TaxiDirectory *taxi = [self.aryList objectAtIndex:indexPath.row];
    TaxiDirectoryDetailViewController *taxiDetail = [[TaxiDirectoryDetailViewController alloc] initWithNibName:@"TaxiDirectoryDetailViewController" bundle:nil];
    taxiDetail.taxi = taxi;
    [self.navigationController pushViewController:taxiDetail animated:YES];
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


#pragma mark - Webservice Call
-(void)callTaxiListWebservice {
    [CommonUtils callWebservice:@selector(taxi_lists) forTarget:self];
}

-(void)callTaxiListWebservice_LOAD_MORE {
    [CommonUtils callWebservice:@selector(taxi_lists_LOAD_MORE) forTarget:self];
}

#pragma mark - Webservice
#pragma mark beer_lists
-(void)taxi_lists
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.mode = MBProgressHUDModeIndeterminate;
    
    User *user = [CommonUtils getUserLoginDetails];
    NSString *user_id = [user user_id];
    NSString *device_id = [user device_id];
    NSString *unique_code =[user unique_code];
    
    //192.168.1.27/ADB/api/taxi_lists
    NSString *myURL = [NSString stringWithFormat:@"%@taxi_lists",WEBSERVICE_URL];
    NSMutableURLRequest *Request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: myURL]];
    NSString *params = [NSString stringWithFormat:@"user_id=%@&device_id=%@&unique_code=%@&limit=%ld&offset=%ld&keyword=%@&alpha=%@&order_by=%@",user_id,device_id,unique_code,(long)limit,(long)offset,keyWord,alpha,order_by];
    
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
                totalRecords = [[CommonUtils getNotNullString:[tempDict valueForKey:@"taxilist_total"]] integerValue];
                offset = offset + limit;
                NSArray *aryTaxiList = [[tempDict valueForKey:@"taxilist"] valueForKey:@"result"];
                self.aryList = [self getTaxiesFromResult:aryTaxiList];
                
                
                
                [self registerCell];
                [self.tblView reloadData];
                if ([self.aryList count]>0) {
                    [self.tblView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                }
                
               
            }
        }
        else {
            
        }
        
        if([self.aryList count]==0){
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate.window makeToast:@"No records found" duration:4.0 position:CSToastPositionBottom];
        }
        
    }];
    
}

-(NSMutableArray *)getTaxiesFromResult:(NSArray *)aryTaxiList
{
    NSMutableArray *aryTaxies = [@[] mutableCopy];
    if ([aryTaxies count]>0) {
        [aryTaxies removeAllObjects];
    }
    
    for (NSDictionary *dict in aryTaxiList) {
        TaxiDirectory *taxi = [TaxiDirectory getTaxiWithDictionary:dict];
        [aryTaxies addObject:taxi];
    }
    return aryTaxies;
}

#pragma mark bar_lists WITH LOAD MORE
-(void)taxi_lists_LOAD_MORE
{
    User *user = [CommonUtils getUserLoginDetails];
    NSString *user_id = [user user_id];
    NSString *device_id = [user device_id];
    NSString *unique_code =[user unique_code];
    
    //192.168.1.27/ADB/api/beer_lists
    NSString *myURL = [NSString stringWithFormat:@"%@taxi_lists",WEBSERVICE_URL];
    NSMutableURLRequest *Request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: myURL]];
    NSString *params = [NSString stringWithFormat:@"user_id=%@&device_id=%@&unique_code=%@&limit=%ld&offset=%ld&keyword=%@&alpha=%@&order_by=%@",user_id,device_id,unique_code,(long)limit,(long)offset,keyWord,alpha,order_by];
    
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
                
                NSArray *aryTaxiList = [[tempDict valueForKey:@"taxilist"] valueForKey:@"result"];
                [self getMoreTaxiesFromResult:aryTaxiList];
            }
        }
        else {
            
        }
        
    }];
    
}

-(void)getMoreTaxiesFromResult:(NSArray *)aryTaxiList {
    
    for(int i=0; i<[aryTaxiList count]; i++)
    {
        NSDictionary *dict = [aryTaxiList objectAtIndex:i];
        TaxiDirectory *taxi = [TaxiDirectory getTaxiWithDictionary:dict];
        [self.aryList addObject:taxi];
    }
    offset = offset + limit;
    [self.tblView reloadData];
}




@end
