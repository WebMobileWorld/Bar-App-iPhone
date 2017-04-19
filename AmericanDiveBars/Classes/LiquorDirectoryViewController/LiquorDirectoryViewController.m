//
//  LiquorDirectoryViewController.m
//  AmericanDiveBars
//
//  Created by spaculus on 8/31/15.
//  Copyright (c) 2015 spaculus. All rights reserved.
//

#import "LiquorDirectoryViewController.h"
#import "LiquorDirectoryCell.h"
#import "LiquorDirectoryDetailViewController.h"
#import "LiquorSuggestViewController.h"

@interface LiquorDirectoryViewController ()<MBProgressHUDDelegate,DirectoryHeaderViewDelegate,AlphabetSearchViewDelegate,TTTAttributedLabelDelegate,FPPopoverControllerDelegate,UIActionSheetDelegate>
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

@implementation LiquorDirectoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [CommonUtils setTitleLabel:@"LIQUOR DIRECTORY"];
    [self configureTopButtons];
    [self initializeDataStructure];
    [self configureHeaderView];
    [self configureAlphabetView];
    [self callLiquorListWebservice];
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

- (IBAction)btnSuggestClicked:(id)sender {
    LiquorSuggestViewController *suggest = [[LiquorSuggestViewController alloc] initWithNibName:@"LiquorSuggestViewController" bundle:nil];
    [self.navigationController pushViewController:suggest animated:YES];
    
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
    controller.liquorDelegate = self;
    if ([CommonUtils isLoggedIn]) {
        //Liquor Search
        controller.aryItems = @[@{@"image":@"user-no_image_LM.png",@"title":@"User"},
                                @{@"image":@"dashboard-LM.png",@"title":@"My Dashboard"},
                                @{@"image":@"bar-LM.png",@"title":@"Find Bar"},
                                @{@"image":@"beer-LM.png",@"title":@"Beer Directory"},
                                @{@"image":@"cocktail-LM.png",@"title":@"Cocktail Recipes"},
                                @{@"image":@"taxi-RM.png",@"title":@"Taxi Directory"},
                                @{@"image":@"photo-LM.png",@"title":@"Photo Gallery"},
                                @{@"image":@"article-RM.png",@"title":@"Articles"},
                                @{@"image":@"bar-trivia-RM.png",@"title":@"Bar Trivia Game"}];
    }
    else {
        //Liquor Search
        controller.aryItems = @[@{@"image":@"login-LM.png",@"title":@"Sign In"},
                                @{@"image":@"register-LM.png",@"title":@"Sign Up"},
                                @{@"image":@"bar-LM.png",@"title":@"Find Bar"},
                                @{@"image":@"beer-LM.png",@"title":@"Beer Directory"},
                                @{@"image":@"cocktail-LM.png",@"title":@"Cocktail Recipes"},
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
    
    //Liquor Search
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
            TaxiDirectoryViewController *taxi = [[TaxiDirectoryViewController alloc] initWithNibName:@"TaxiDirectoryViewController" bundle:nil];
            [self.navigationController pushViewController:taxi animated:YES];
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
        case 8:
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
    [self callLiquorListWebservice];
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
        if ((idx==7) && (constraint.firstAttribute == NSLayoutAttributeTrailing)) {
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
                     @{@"title":@"LIQUOR NAME A-Z",@"value":@"liquor_title#ASC"},
                     @{@"title":@"LIQUOR NAME Z-A",@"value":@"liquor_title#DESC"}
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
                           [self callLiquorListWebservice];
                       }
                   }
                                         cancelHandler:nil];
    _filterView.transitionStyle = style;
    _filterView.numberOfLines = 0;
}

#pragma mark - Table View
-(void)configureHeaderView  {
    id headerView = [[[NSBundle mainBundle] loadNibNamed:@"DirectoryHeaderView" owner:self options:nil] objectAtIndex:0];
    directoryHeaderView = (DirectoryHeaderView *)headerView;
    [directoryHeaderView configureBeerHeaderView:@"Search Liquor by name"];
    directoryHeaderView.lblSearchTitle.text = @"";
    directoryHeaderView.lblFilterType.text = @"Sotred By:";
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
    [self callLiquorListWebservice];
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
            static NSString *simpleTableIdentifier = @"LiquorDirectoryCell";
            
            LiquorDirectoryCell *cell = (LiquorDirectoryCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            if (cell == nil)
            {
                NSArray *nib;
                if([CommonUtils isiPad])
                {
                    nib = [[NSBundle mainBundle] loadNibNamed:@"LiquorDirectoryCell" owner:self options:nil];
                }
                else
                {
                    nib = [[NSBundle mainBundle] loadNibNamed:@"LiquorDirectoryCell" owner:self options:nil];
                }
                cell = [nib objectAtIndex:0];
                [cell configureCell];
            }
            
            LiquorDirectory *liquor = [self.aryList objectAtIndex:indexPath.row];
            
            cell.lblLiquorTitle.text = [CommonUtils removeHTMLFromString:liquor.liquor_title];
            cell.lblType.text = [CommonUtils removeHTMLFromString:liquor.liquor_type];
            cell.lblABV.text = [CommonUtils removeHTMLFromString:liquor.liquor_proof];
            cell.lblProducer.text = [CommonUtils removeHTMLFromString:liquor.liquor_producer];
            
            NSString *liquor_logo = [liquor liquor_image];
            NSString *strImgURL = [NSString stringWithFormat:@"%@%@%@",WEBIMAGE_URL,LIQUORLOGO,liquor_logo];
            NSURL *imgURL = [NSURL URLWithString:strImgURL];
            
            [cell.imgLiquorLogo sd_setImageWithURL:imgURL placeholderImage:[UIImage imageNamed:@"no_liquor.png"]];
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
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
                    [self callLiquorListWebservice_LOAD_MORE];
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

#pragma mark Cell Height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
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
    LiquorDirectory *liquor = [self.aryList objectAtIndex:indexPath.row];
    LiquorDirectoryDetailViewController *liquorDetail = [[LiquorDirectoryDetailViewController alloc] initWithNibName:@"LiquorDirectoryDetailViewController" bundle:nil];
    liquorDetail.liquor = liquor;
    [self.navigationController pushViewController:liquorDetail animated:YES];
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
-(void)callLiquorListWebservice {
    [CommonUtils callWebservice:@selector(liquor_lists) forTarget:self];
}

-(void)callLiquorListWebservice_LOAD_MORE {
    [CommonUtils callWebservice:@selector(liquor_lists_LOAD_MORE) forTarget:self];
}

#pragma mark - Webservice
#pragma mark beer_lists
-(void)liquor_lists
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.mode = MBProgressHUDModeIndeterminate;
    
    User *user = [CommonUtils getUserLoginDetails];
    NSString *user_id = [user user_id];
    NSString *device_id = [user device_id];
    NSString *unique_code =[user unique_code];
    
    NSString *bar_id = [self getBarIdForWebservice];

    //192.168.1.27/ADB/api/liquor_lists
    NSString *myURL = [NSString stringWithFormat:@"%@liquor_lists",WEBSERVICE_URL];
    NSMutableURLRequest *Request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: myURL]];
    NSString *params = [NSString stringWithFormat:@"user_id=%@&device_id=%@&unique_code=%@&limit=%ld&offset=%ld&keyword=%@&alpha=%@&order_by=%@&bar_id=%@",user_id,device_id,unique_code,(long)limit,(long)offset,keyWord,alpha,order_by,bar_id];
    
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
                totalRecords = [[CommonUtils getNotNullString:[tempDict valueForKey:@"liquorlist_total"]] integerValue];
                offset = offset + limit;
                NSArray *aryLiquorList = [[tempDict valueForKey:@"liquorlist"] valueForKey:@"result"];
                self.aryList = [self getLiquorsFromResult:aryLiquorList];
                [self.tblView reloadData];
                if ([self.aryList count]>0) {
                    [self.tblView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                }
            }
            else {
                if([self.aryList count]!=0){
                    totalRecords = 0;
                    [self.aryList removeAllObjects];
                    [self.tblView reloadData];
                }
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
-(NSString *)getBarIdForWebservice {
    NSString *bar_id = nil;
    if (self.barDetail.bar_id == nil) {
        bar_id = @"";
    }
    else {
        bar_id = self.barDetail.bar_id;
    }
    return bar_id;
}
-(NSMutableArray *)getLiquorsFromResult:(NSArray *)aryLiquorList
{
    NSMutableArray *aryLiquors = [@[] mutableCopy];
    if ([aryLiquors count]>0) {
        [aryLiquors removeAllObjects];
    }
    
    for (NSDictionary *dict in aryLiquorList) {
        LiquorDirectory *liquor = [LiquorDirectory getLiquorWithDictionary:dict];
        [aryLiquors addObject:liquor];
    }
    return aryLiquors;
}

#pragma mark bar_lists WITH LOAD MORE
-(void)liquor_lists_LOAD_MORE
{
    User *user = [CommonUtils getUserLoginDetails];
    NSString *user_id = [user user_id];
    NSString *device_id = [user device_id];
    NSString *unique_code =[user unique_code];
    
    //192.168.1.27/ADB/api/beer_lists
    NSString *myURL = [NSString stringWithFormat:@"%@liquor_lists",WEBSERVICE_URL];
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
                
                NSArray *aryLiquorList = [[tempDict valueForKey:@"liquorlist"] valueForKey:@"result"];
                [self getMoreLiquorsFromResult:aryLiquorList];
            }
        }
        else {
            
        }
        
    }];
    
}

-(void)getMoreLiquorsFromResult:(NSArray *)aryLiquorList {
    
    for(int i=0; i<[aryLiquorList count]; i++)
    {
        NSDictionary *dict = [aryLiquorList objectAtIndex:i];
        LiquorDirectory *liquor = [LiquorDirectory getLiquorWithDictionary:dict];
        [self.aryList addObject:liquor];
    }
    offset = offset + limit;
    [self.tblView reloadData];
}


@end
