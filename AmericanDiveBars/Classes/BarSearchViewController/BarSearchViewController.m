//
//  BarSearchViewController.m
//  AmericanDiveBars
//
//  Created by spaculus on 8/31/15.
//  Copyright (c) 2015 spaculus. All rights reserved.
//

#import "BarSearchViewController.h"
#import "SearchTitleCell.h"
#import "BarSearchCell.h"


@interface BarSearchViewController ()<MBProgressHUDDelegate,SearchTableViewDelegate,FPPopoverControllerDelegate>
{
    MBProgressHUD *HUD;
    
    FPPopoverController *popover;
    
    //Bar Search View
    NSString *searchByName;
    NSString *searchByState;
    NSString *searchByCity;
    NSString *searchByZip;
    
    //Search View
    NSString *searchText;
    NSMutableArray *aryFiltered;
    BOOL hasFound;
}

@property (strong, nonatomic) NSMutableArray * aryTitles;
@property (strong, nonatomic) IBOutlet TPKeyboardAvoidingTableView *tblView;
@property (nonatomic, strong) IBOutlet UIView *searchView;

#pragma mark - SEARCH VIEW REFERENCES

@property (strong, nonatomic) IBOutlet UITableView *tblTitles;

@property (strong, nonatomic) IBOutlet UIView *viewShadow;
@property (strong, nonatomic) IBOutlet UIView *viewTitleSearch;

@property (strong, nonatomic) IBOutlet UIButton *btnCancel;
@property (strong, nonatomic) IBOutlet UIButton *btnDone;

@property (strong, nonatomic) IBOutlet UITextField *txtSearch;
@property (strong, nonatomic) IBOutlet UIImageView *imgSearch;
@property (strong, nonatomic) IBOutlet UIView *viewSearchBar;

#pragma mark -
@property (strong, nonatomic) IBOutlet UIImageView *bg;
@end

@implementation BarSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = [CommonUtils setTitleLabel:@"ADVANCED BAR SEARCH"];
    [self configureTopButtons];
    [self initializeSearchView];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setStatusBarVisibility];
    self.navigationController.navigationBar.topItem.title = @" ";
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
    
    
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        
        if (![CommonUtils isiPad]) {
            
            if ([CommonUtils isIPhone4_Landscape]) {
                self.bg.image = [UIImage imageNamed:@"barsearch-bg-iphone-L.png"];
            }
            else if ([CommonUtils isIPhone5_Landscape]) {
                self.bg.image = [UIImage imageNamed:@"barsearch-bg-iphone-L.png"];
            }
            else if ([CommonUtils isIPhone6_Landscape]) {
                self.bg.image = [UIImage imageNamed:@"barsearch-bg-iphone-L.png"];
                
            }
            else {
                self.bg.image = [UIImage imageNamed:@"barsearch-bg-iphone-L.png"];
            }
        }
        else {
            self.bg.image = [UIImage imageNamed:@"barsearch-bg-iphone-ipad-L.png"];
        }
        
    }
    else {
        if (![CommonUtils isiPad]) {
            
            
            if ([CommonUtils isIPhone4]) {
                self.bg.image = [UIImage imageNamed:@"barsearch-bg-iphone.png"];
            }
            else if ([CommonUtils isIPhone5]) {
                self.bg.image = [UIImage imageNamed:@"barsearch-bg-iphone.png"];
            }
            else if ([CommonUtils isIPhone6]) {
                self.bg.image = [UIImage imageNamed:@"barsearch-bg-iphone.png"];
            }
            else {
                self.bg.image = [UIImage imageNamed:@"barsearch-bg-iphone.png"];
            }
            
            
        }
        else {
            self.bg.image = [UIImage imageNamed:@"barsearch-bg-iphone-ipad.png"];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    //[UIColor colorWithRed:187.0/255.0 green:124.0/255.0 blue:37.0/255.0 alpha:1.0]
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
    
   // self.navigationItem.rightBarButtonItem = btnFilter;
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
    controller.barDelegate = self;
    if ([CommonUtils isLoggedIn]) {
        //Bar Search
        controller.aryItems = @[@{@"image":@"user-no_image_LM.png",@"title":@"User"},
                                 @{@"image":@"dashboard-LM.png",@"title":@"My Dashboard"},
                                 @{@"image":@"beer-LM.png",@"title":@"Beer Directory"},
                                 @{@"image":@"cocktail-LM.png",@"title":@"Cocktail Recipes"},
                                 @{@"image":@"liquor-LM.png",@"title":@"Liquor Directory"},
                                 @{@"image":@"taxi-RM.png",@"title":@"Taxi Directory"},
                                 @{@"image":@"photo-LM.png",@"title":@"Photo Gallery"},
                                @{@"image":@"article-RM.png",@"title":@"Articles"},
                                @{@"image":@"bar-trivia-RM.png",@"title":@"Bar Trivia Game"}];
        
        /*
        //All
        controller.aryItems = @[@{@"image":@"user-no_image_LM.png",@"title":@"User"},
                                @{@"image":@"dashboard-LM.png",@"title":@"My Dashboard"},
                                 @{@"image":@"bar-LM.png",@"title":@"Bar Search"},
                                 @{@"image":@"beer-LM.png",@"title":@@"Beer Directory"},
                                 @{@"image":@"cocktail-LM.png",@"title":@"Cocktail Search"},
                                 @{@"image":@"liquor-LM.png",@"title":@"Liquor Search"},
                                 @{@"image":@"photo-LM.png",@"title":@"Photo Gallery"}];*/
    }
    else {
        //Bar Search
        controller.aryItems = @[@{@"image":@"login-LM.png",@"title":@"Sign In"},
                                @{@"image":@"register-LM.png",@"title":@"Sign Up"},
                                @{@"image":@"beer-LM.png",@"title":@"Beer Directory"},
                                @{@"image":@"cocktail-LM.png",@"title":@"Cocktail Recipes"},
                                @{@"image":@"liquor-LM.png",@"title":@"Liquor Directory"},
                                @{@"image":@"taxi-RM.png",@"title":@"Taxi Directory"},
                                @{@"image":@"photo-LM.png",@"title":@"Photo Gallery"},
                                @{@"image":@"article-RM.png",@"title":@"Articles"},
                                @{@"image":@"bar-trivia-RM.png",@"title":@"Bar Trivia Game"}];
        
        /*
        
        
        
        
        
        
        
        //All
        controller.aryItems = @[@{@"image":@"login-LM.png",@"title":@"Sign In"},
                                @{@"image":@"register-LM.png",@"title":@"Sign Up"},
                                @{@"image":@"bar-LM.png",@"title":@"Bar Search"},
                                @{@"image":@"beer-LM.png",@"title":@@"Beer Directory"},
                                @{@"image":@"cocktail-LM.png",@"title":@"Cocktail Search"},
                                @{@"image":@"liquor-LM.png",@"title":@"Liquor Search"},
                                @{@"image":@"photo-LM.png",@"title":@"Photo Gallery"}];*/
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
    
    // Bar Search
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
            BeerDirectoryViewController *beer = [[BeerDirectoryViewController alloc] initWithNibName:@"BeerDirectoryViewController" bundle:nil];
            [self.navigationController pushViewController:beer animated:YES];
        }
            break;

        case 3:
        {
            CocktailDirectoryViewController *cocktail = [[CocktailDirectoryViewController alloc] initWithNibName:@"CocktailDirectoryViewController" bundle:nil];
            [self.navigationController pushViewController:cocktail animated:YES];
        }
            break;
        case 4:
        {
            LiquorDirectoryViewController *liquor = [[LiquorDirectoryViewController alloc] initWithNibName:@"LiquorDirectoryViewController" bundle:nil];
            [self.navigationController pushViewController:liquor animated:YES];
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
    
    
    /*    
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
            BarSearchViewController *bar = [[BarSearchViewController alloc] initWithNibName:@"BarSearchViewController" bundle:nil];
            [self.navigationController pushViewController:bar animated:YES];
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
            
        default:
            break;
    }*/
}


#pragma mark - TableView Delegates

#pragma mark Number of Section
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark Number of Row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==self.tblTitles) {
        if (hasFound)
        {
            return [aryFiltered count];
        }
        else
        {
            if (self.aryTitles != nil)
            {
                if ([self.aryTitles count]==0)
                {
                    return 0;
                }else
                {
                    return [self.aryTitles count];
                }
            }else
            {
                return 0;
            }
            
        }
    }
    else
    {
        return 1;
    }
    
}

#pragma mark Cell for Row
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==self.tblTitles) {
        static NSString *simpleTableIdentifier = @"SearchTitleCell";
        
        SearchTitleCell *cell = (SearchTitleCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            NSArray *nib;
            if([CommonUtils isiPad])
            {
                nib = [[NSBundle mainBundle] loadNibNamed:@"SearchTitleCell" owner:self options:nil];
            }
            else
            {
                nib = [[NSBundle mainBundle] loadNibNamed:@"SearchTitleCell" owner:self options:nil];
            }
            cell = [nib objectAtIndex:0];
        }
        NSDictionary *dict = nil;
        if (hasFound) {
            dict = [aryFiltered objectAtIndex:indexPath.row];
        }
        else
        {
            dict = [self.aryTitles objectAtIndex:indexPath.row];
        }
        NSString *title = [CommonUtils getNotNullString:[dict valueForKey:@"state_name"]];
        cell.lblTitle.text = title;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    else
    {
        static NSString *simpleTableIdentifier = @"BarSearchCell";
        
        BarSearchCell *cell = (BarSearchCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            NSArray *nib;
            if([CommonUtils isiPad])
            {
                nib = [[NSBundle mainBundle] loadNibNamed:@"BarSearchCell-ipad" owner:self options:nil];
            }
            else
            {
                nib = [[NSBundle mainBundle] loadNibNamed:@"BarSearchCell" owner:self options:nil];
            }
            cell = [nib objectAtIndex:0];
        }
        [cell configureCellUI];
        
        cell.txtTitle.text = searchByName;
        cell.txtState.text = searchByState;
        cell.txtCity.text = searchByCity;
        cell.txtZip.text = searchByZip;
        
        [cell.btnStartSearch addTarget:self action:@selector(btnStartSearch_Clicked) forControlEvents:UIControlEventTouchUpInside];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
}

-(void)btnStartSearch_Clicked {
    [self.view endEditing:YES];
    BarSearchDetail *searchDetail = [BarSearchDetail getDetailSearchByName:searchByName searchByState:searchByState searchByCity:searchByCity searchByZip:searchByZip forDays:@"" happyAddress:@""];
    if ([[searchDetail searchTitle] length]==0) {
        ShowAlert(AlertTitle, @"Please provide atleast one field to search.");
    }
    else {
        BarListViewController *barList = [[BarListViewController alloc] initWithNibName:@"BarListViewController" bundle:nil];
        barList.isFromHappy = NO;
        barList.searchDetail = searchDetail;
        [self.navigationController pushViewController:barList animated:YES];
    }
    
}


#pragma mark Cell Height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==self.tblTitles) {
        return 54;
    }
    else
    {
        return 319;
    //        if ([CommonUtils isiPad]) {
    //            return 319;
    //        }
    //        else {
    //            return 269;
    //        }
        
    }
}
#pragma mark did Select Row
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==self.tblTitles)
    {
    }
    
    
    [self.tblView reloadData];

}

#pragma mark - Search View

-(void)initializeSearchView {
    searchByName = @"";
    searchByState = @"";
    searchByCity = @"";
    searchByZip = @"";
    
    [self configureSearchView];
}

-(void)configureSearchView {
    id view = [[[NSBundle mainBundle] loadNibNamed:@"SearchTableView" owner:self options:nil] objectAtIndex:0];
    SearchTableView *search = (SearchTableView *)view;
    search.delegate = self;
    [self.searchView addSubview:search];
    [search configureSearchTableView];
    [self.view layoutIfNeeded];
}


#pragma mark Search Table View

#pragma mark Search TableView Delegates
-(void)dismissSearchView {
    //searchByName = @"";
    [self.tblView reloadData];
    [self hideSearchView];
}

-(void)selectSearchedName:(NSString *)name {
    searchByName = name;
    [self.tblView reloadData];
    [self hideSearchView];
}
-(void)hideSearchView
{
    self.searchView.alpha = 1.0;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.searchView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.searchView setHidden:YES];
    }];
}

-(void)didSelectBar:(Bar *)bar {
    if ([[bar bar_type] isEqualToString:@"full_mug"]) {
        BarDetailFullMugViewController *barDetailFullMug = [[BarDetailFullMugViewController alloc] initWithNibName:@"BarDetailFullMugViewController" bundle:nil];
        barDetailFullMug.bar = bar;
        [self.navigationController pushViewController:barDetailFullMug animated:YES];
        
    }
    else {
        BarDetailHalfMugViewController *barDetailHalfMug = [[BarDetailHalfMugViewController alloc] initWithNibName:@"BarDetailHalfMugViewController" bundle:nil];
        barDetailHalfMug.bar = bar;
        [self.navigationController pushViewController:barDetailHalfMug animated:YES];
        
    }
}

-(void)showSearchView
{
    self.searchView.alpha = 0.0;
    [UIView animateWithDuration:0.3 animations:^{
        self.searchView.alpha = 1.0;
        SearchTableView *search = (SearchTableView *)[[self.searchView subviews] objectAtIndex:0];
        [search reloadSearchTableWithText:searchByName];
        [self.searchView setHidden:NO];

    } completion:^(BOOL finished) {
           }];
}



#pragma mark Textfield Delegates
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField.tag == 10) {
        [self showSearchView];
        return NO;
    }
    else {
        return YES;
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 10) {
        searchByName = textField.text;
    }
    else if (textField.tag == 11) {
        searchByState = textField.text;
    }

    else if (textField.tag == 12) {
        searchByCity = textField.text;
    }

    else {
        searchByZip = textField.text;
    }
    

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 13) {
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        return (newString.length<=5);
    }
    else {
        return YES;
    }
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}




#pragma mark - Webservice Call

-(void)auto_suggest_bar
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.mode = MBProgressHUDModeIndeterminate;
    
    //192.168.1.27/ADB/api/checklogin
    NSString *myURL = [NSString stringWithFormat:@"%@auto_suggest_bar",WEBSERVICE_URL];
    NSMutableURLRequest *Request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: myURL]];
    NSString *params = [NSString stringWithFormat:@"term=%@",searchText];
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
            BarListViewController *barList = [[BarListViewController alloc]  initWithNibName:@"BarListViewController" bundle:nil];
            [self.navigationController pushViewController:barList animated:YES];
        }
        else {
        }
    }];
}

#pragma mark - Oriantation

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    
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
                     
                     if ([CommonUtils isIPhone4_Landscape]) {
                         self.bg.image = [UIImage imageNamed:@"barsearch-bg-iphone.png"];
                     }
                     else if ([CommonUtils isIPhone5_Landscape]) {
                         self.bg.image = [UIImage imageNamed:@"barsearch-bg-iphone.png"];
                     }
                     else if ([CommonUtils isIPhone6_Landscape]) {
                         self.bg.image = [UIImage imageNamed:@"barsearch-bg-iphone.png"];
                         
                     }
                     else {
                         self.bg.image = [UIImage imageNamed:@"barsearch-bg-iphone.png"];
                     }
                 }
                 else {
                     self.bg.image = [UIImage imageNamed:@"barsearch-bg-iphone-ipad.png"];
                     
                 }
                 
                 break;
                 
             case UIInterfaceOrientationLandscapeLeft:
             case UIInterfaceOrientationLandscapeRight:
                 if (![CommonUtils isiPad]) {
                     
                     if ([CommonUtils isIPhone4_Landscape]) {
                         self.bg.image = [UIImage imageNamed:@"barsearch-bg-iphone-L.png"];
                         
                     }
                     else if ([CommonUtils isIPhone5_Landscape]) {
                         self.bg.image = [UIImage imageNamed:@"barsearch-bg-iphone-L.png"];
                     }
                     else if ([CommonUtils isIPhone6_Landscape]) {
                         self.bg.image = [UIImage imageNamed:@"barsearch-bg-iphone-L.png"];
                     }
                     else {
                         self.bg.image = [UIImage imageNamed:@"barsearch-bg-iphone-L.png"];
                         self.navigationController.navigationBar.frame = CGRectMake(0,32, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height+20);
                         
                     }
                 }
                 else {
                     self.bg.image = [UIImage imageNamed:@"barsearch-bg-iphone-ipad-L.png"];
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
