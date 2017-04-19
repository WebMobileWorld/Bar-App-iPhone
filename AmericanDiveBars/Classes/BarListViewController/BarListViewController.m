//
//  BarListViewController.m
//  AmericanDiveBars
//
//  Created by spaculus on 9/3/15.
//  Copyright (c) 2015 spaculus. All rights reserved.
//

#import "BarListViewController.h"
#import "BarDetailFullMugViewController.h"
#import "BarDetailHalfMugViewController.h"
#import "BarSuggestViewController.h"

#import "BarCell.h"
#import "BarHeaderView.h"

@interface BarListViewController () <MBProgressHUDDelegate,BarHeaderViewDelegate,FPPopoverControllerDelegate>
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
}

//CUSTOM POPUP TABLE VIEW
@property (strong, nonatomic) LGFilterView  *filterView;
@property (strong, nonatomic) NSArray   *titlesArray;

//Main Table
@property (strong, nonatomic) IBOutlet UITableView *tblView;
@property (strong, nonatomic) NSMutableArray *aryList;

@end



@implementation BarListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isFromHappy) {
        self.navigationItem.titleView = [CommonUtils setTitleLabel:@"BARS WITH HAPPY HOURS"];
    }
    else {
        self.navigationItem.titleView = [CommonUtils setTitleLabel:@"BAR"];
    }
    
    [self configureTopButtons];
    [self configureBarTableView];
    [self initializeDataStructure];
    
     [self callBarListWebservice];
}

-(void)initializeDataStructure {
    self.aryList = [[NSMutableArray alloc]  init];
    limit = 10;
    offset = 0;
    totalRecords = 0;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.topItem.title = @" ";
   
}


- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGFloat topInset = self.navigationController.navigationBar.frame.size.height+([UIApplication sharedApplication].isStatusBarHidden ? 0.f : [UIApplication sharedApplication].statusBarFrame.size.height);
    
    if ([UIDevice currentDevice].systemVersion.floatValue < 7.0) topInset = 0.f;
    
    [self updateFilterProperties];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - LG POPUP VIEW 

-(void)setDataStructureForLGView {
    _titlesArray = @[@{@"title":@"Sort By",@"value":@""},
                     @{@"title":@"BAR NAME A-Z",@"value":@"bar_title#ASC"},
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
}


- (IBAction)btnSuggestClicked:(id)sender {
    
    BarSuggestViewController *suggest = [[BarSuggestViewController alloc] initWithNibName:@"BarSuggestViewController" bundle:nil];
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
    controller.barListDelegate = self;
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

#pragma mark - Table View

-(void)configureBarTableView  {
    id headerView = [[[NSBundle mainBundle] loadNibNamed:@"BarHeaderView" owner:self options:nil] objectAtIndex:0];
    barHeaderView = (BarHeaderView *)headerView;
    [barHeaderView configureBarHeaderView];
    barHeaderView.lblSearchTitle.text = [NSString stringWithFormat:@"Search Result for %@",self.searchDetail.searchTitle];
    barHeaderView.lblFilterType.text = @"Sort By";
    order_by = @"";
    barHeaderView.delegate = self;
    [self setDataStructureForLGView];
}

#pragma mark BarHeaderView Delegate
-(void)setSortingType {
    [self filterAction];
}

#pragma mark View For Header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return barHeaderView;
    }
    else {
        return nil;
    }
}

#pragma mark Height For Header
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
            return 50;
    }
    else {
        return 0;
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
                static NSString *simpleTableIdentifier = @"BarCell";
                
                BarCell *cell = (BarCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
                if (cell == nil)
                {
                    NSArray *nib;
                    if([CommonUtils isiPad])
                    {
                        nib = [[NSBundle mainBundle] loadNibNamed:@"BarCell" owner:self options:nil];
                    }
                    else
                    {
                        nib = [[NSBundle mainBundle] loadNibNamed:@"BarCell" owner:self options:nil];
                    }
                    cell = [nib objectAtIndex:0];
                }
                
                Bar *bar = [self.aryList objectAtIndex:indexPath.row];
                cell.lblBarTitle.text = [CommonUtils removeHTMLFromString:bar.bar_title];
                cell.lblPhone.text = [CommonUtils removeHTMLFromString:bar.bar_phone];
                
                NSString *fullAddress = [CommonUtils removeHTMLFromString:bar.fullAddress];//[NSString stringWithFormat:@"%@,%@,%@ %@",bar.bar_address,bar.bar_city,bar.bar_state,bar.bar_zipcode];
                cell.lblAddress.text = fullAddress;
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
                NSString *strImgURL = [NSString stringWithFormat:@"%@%@%@",WEBIMAGE_URL,BARLIST_LOGO,bar_logo];
                NSURL *imgURL = [NSURL URLWithString:strImgURL];
                
                [cell.imgBarLogo sd_setImageWithURL:imgURL placeholderImage:[UIImage imageNamed:@"no_bar.png"]];
                
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
                        [self callBarListWebservice_LOAD_MORE];
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


#pragma mark Cell Height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.section) {
        case 0:
            return 114;
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Bar *bar = [self.aryList objectAtIndex:indexPath.row];
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


#pragma mark - Webservice Call
-(void)callBarListWebservice {
    
    [CommonUtils callWebservice:@selector(bar_lists) forTarget:self];
    
}

-(void)callBarListWebservice_LOAD_MORE {
    [CommonUtils callWebservice:@selector(bar_lists_LOAD_MORE) forTarget:self];
}

#pragma mark - Webservice
#pragma mark bar_lists
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



@end
