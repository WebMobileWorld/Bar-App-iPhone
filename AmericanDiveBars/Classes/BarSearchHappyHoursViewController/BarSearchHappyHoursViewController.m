//
//  BarSearchHappyHoursViewController.m
//  AmericanDiveBars
//
//  Created by spaculus on 1/18/16.
//  Copyright © 2016 spaculus. All rights reserved.
//

#import "BarSearchHappyHoursViewController.h"
#import "FindBarAroundMeViewController.h"

#import "SearchTitleCell.h"

#import "BarSearchHappyHourAroundMeCell.h"
#import "BarSearchHappyHourCell.h"

#import "BarSearchCell.h"

#import "ActionSheetStringPicker.h"

@interface BarSearchHappyHoursViewController ()<MBProgressHUDDelegate,SearchTableViewDelegate,FPPopoverControllerDelegate,BarSearchHappyHourAroundMeCellDelegate,BarSearchHappyHourCellDelegate>
{
    MBProgressHUD *HUD;
    
    FPPopoverController *popover;
    
    //Bar Search View
    NSString *searchByName;
    NSString *searchByDay;
    NSString *searchByCity;
    NSString *searchByAddress;
    NSString *searchByHappyAddress;
    
    //Search View
    NSString *searchText;
    NSMutableArray *aryFiltered;
    BOOL hasFound;
    
    NSArray *aryDays;
}

@property (nonatomic, assign) NSInteger daySelectedIndex;

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

@implementation BarSearchHappyHoursViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = [CommonUtils setTitleLabel:@"SEARCH FOR HAPPY HOUR"];
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
    controller.barSearchHappyHourDelegate = self;
    if ([CommonUtils isLoggedIn]) {
        //All
        controller.aryItems = @[@{@"image":@"user-no_image_LM.png",@"title":@"User"},
                                @{@"image":@"dashboard-LM.png",@"title":@"My Dashboard"},
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
            BeerDirectoryViewController *beer = [[BeerDirectoryViewController alloc]  initWithNibName:@"BeerDirectoryViewController" bundle:nil];
            [self.navigationController pushViewController:beer animated:YES];
        }
            break;
        case 3:
        {
            CocktailDirectoryViewController *cocktail = [[CocktailDirectoryViewController alloc]  initWithNibName:@"CocktailDirectoryViewController" bundle:nil];
            [self.navigationController pushViewController:cocktail animated:YES];
        }
            break;
            
        case 4:
        {
            LiquorDirectoryViewController *liquor = [[LiquorDirectoryViewController alloc]  initWithNibName:@"LiquorDirectoryViewController" bundle:nil];
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
        if (self.is_cur_loc) {
            
            static NSString *simpleTableIdentifier = @"BarSearchHappyHourAroundMeCell";
            
            BarSearchHappyHourAroundMeCell *cell = (BarSearchHappyHourAroundMeCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            if (cell == nil)
            {
                NSArray *nib;
                if([CommonUtils isiPad])
                {
                    nib = [[NSBundle mainBundle] loadNibNamed:@"BarSearchHappyHourAroundMeCell-ipad" owner:self options:nil];
                }
                else
                {
                    nib = [[NSBundle mainBundle] loadNibNamed:@"BarSearchHappyHourAroundMeCell" owner:self options:nil];
                }
                cell = [nib objectAtIndex:0];
            }
            cell.delegate = self;

            [cell configureCellUI];
            
            
            cell.txtTitle.text = searchByName;
            cell.txtDay.text = searchByDay;
            [cell.btnStartSearch addTarget:self action:@selector(btnStartSearchFromLocation_Clicked) forControlEvents:UIControlEventTouchUpInside];
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;

            
        }
        else {
            
            static NSString *simpleTableIdentifier = @"BarSearchHappyHourCell";
            
            BarSearchHappyHourCell *cell = (BarSearchHappyHourCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            if (cell == nil)
            {
                NSArray *nib;
                if([CommonUtils isiPad])
                {
                    nib = [[NSBundle mainBundle] loadNibNamed:@"BarSearchHappyHourCell-ipad" owner:self options:nil];
                }
                else
                {
                    nib = [[NSBundle mainBundle] loadNibNamed:@"BarSearchHappyHourCell" owner:self options:nil];
                }
                cell = [nib objectAtIndex:0];
            }
            cell.delegate = self;

            [cell configureCellUI];
            
            cell.txtTitle.text = searchByName;
            cell.txtDay.text = searchByDay;
            cell.txtAddress.text = searchByAddress;
            
            [cell configureCellUI];
            
            [cell.btnStartSearch addTarget:self action:@selector(btnStartSearch_Clicked) forControlEvents:UIControlEventTouchUpInside];
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;

        }
    }
}

-(void)openDays {
    BarSearchHappyHourAroundMeCell *cell = (BarSearchHappyHourAroundMeCell *)[self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [ActionSheetStringPicker showPickerWithTitle:@"Select Day" rows:aryDays initialSelection:self.daySelectedIndex target:self successAction:@selector(daySelected:element:) cancelAction:nil origin:cell.txtDay];
}

-(void)openDays1 {
    BarSearchHappyHourCell *cell = (BarSearchHappyHourCell *)[self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [ActionSheetStringPicker showPickerWithTitle:@"Select Day" rows:aryDays initialSelection:self.daySelectedIndex target:self successAction:@selector(daySelected:element:) cancelAction:nil origin:cell.txtDay];
}

-(void)btnStartSearchFromLocation_Clicked {
    [self.view endEditing:YES];
    
    if ([searchByName length]==0 && [searchByDay length] == 0) {
        ShowAlert(AlertTitle, @"Please provide at leaset one field to search");
    }
    else {
        if (self.is_cur_loc) {
            FindBarAroundMeViewController *barAroundMe = [[FindBarAroundMeViewController alloc] initWithNibName:@"FindBarAroundMeViewController" bundle:nil];
            BarSearchDetail *searchDetail = [BarSearchDetail getDetailSearchByName:searchByName searchByState:searchByAddress searchByCity:searchByCity searchByZip:@"" forDays:searchByDay happyAddress:searchByHappyAddress];
            barAroundMe.isFromHappy = YES;
            barAroundMe.searchDetail = searchDetail;
            [self.navigationController pushViewController:barAroundMe animated:YES];
        }
        else {
            BarSearchDetail *searchDetail = [BarSearchDetail getDetailSearchByName:searchByName searchByState:searchByAddress searchByCity:searchByCity searchByZip:@"" forDays:searchByDay happyAddress:searchByHappyAddress];
            BarListViewController *barList = [[BarListViewController alloc] initWithNibName:@"BarListViewController" bundle:nil];
            barList.searchDetail = searchDetail;
            [self.navigationController pushViewController:barList animated:YES];
        }
    }
}


-(void)btnStartSearch_Clicked {
    [self.view endEditing:YES];
    
    if ([searchByName length]==0 && [searchByDay length] == 0) {
        ShowAlert(AlertTitle, @"Please provide atleast one field to search.");
    }
    else {
        if (self.is_cur_loc) {
            FindBarAroundMeViewController *barAroundMe = [[FindBarAroundMeViewController alloc] initWithNibName:@"FindBarAroundMeViewController" bundle:nil];
            [self.navigationController pushViewController:barAroundMe animated:YES];
        }
        else {
            BarSearchDetail *searchDetail = [BarSearchDetail getDetailSearchByName:searchByName searchByState:searchByAddress searchByCity:searchByCity searchByZip:@"" forDays:searchByDay happyAddress:searchByHappyAddress];
            BarListViewController *barList = [[BarListViewController alloc] initWithNibName:@"BarListViewController" bundle:nil];
            barList.isFromHappy = YES;
            barList.searchDetail = searchDetail;
            [self.navigationController pushViewController:barList animated:YES];
        }
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
        if(self.is_cur_loc) {
            return 197;
        }
        else {
            return 258;
        }
        
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
    searchByHappyAddress = @"";
    searchByName = @"";
    searchByDay = @"";
    searchByAddress = @"";
    
    aryDays = @[@"None",@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday",@"Sunday"];
    
    
    
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

#pragma mark Textfield Delegates
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField.tag == 10) {
        [self showSearchView];
        return NO;
    }
    else if (textField.tag == 12) {
        [ActionSheetStringPicker showPickerWithTitle:@"Select a Day" rows:aryDays initialSelection:self.daySelectedIndex target:self successAction:@selector(daySelected:element:) cancelAction:nil origin:textField];
        return NO;
    }
    else {
        return YES;
    }
}

- (void)daySelected:(NSNumber *)selectedIndex element:(id)element
{
    
    if (self.is_cur_loc) {
        BarSearchHappyHourAroundMeCell *cell = (BarSearchHappyHourAroundMeCell *)[self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        self.daySelectedIndex = [selectedIndex intValue];
        cell.txtDay.text = [aryDays objectAtIndex:self.daySelectedIndex];
        searchByDay = cell.txtDay.text;
    }
    else {
        BarSearchHappyHourCell *cell = (BarSearchHappyHourCell *)[self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        self.daySelectedIndex = [selectedIndex intValue];
        
        if([[aryDays objectAtIndex:self.daySelectedIndex] isEqualToString:@"None"]){
            searchByDay = @"";
            cell.txtDay.text = @"";
        }
        else {
            cell.txtDay.text = [aryDays objectAtIndex:self.daySelectedIndex];
            searchByDay = cell.txtDay.text;
        }
        
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 10) {
        searchByName = textField.text;
    }
    else if (textField.tag == 11) {
        searchByHappyAddress = textField.text;
    }
    
    else if (textField.tag == 12) {
        searchByDay = textField.text;
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
