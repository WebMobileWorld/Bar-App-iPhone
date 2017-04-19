//
//  MyFavoriteCocktailViewController.m
//  AmericanDiveBars
//
//  Created by spaculus on 10/6/15.
//  Copyright © 2015 spaculus. All rights reserved.
//

#import "MyFavoriteCocktailViewController.h"
#import "CocktailDirectoryDetailViewController.h"
#import "MyFavCell.h"

@interface MyFavoriteCocktailViewController () <MBProgressHUDDelegate,FavHeaderViewDelegate,FPPopoverControllerDelegate>
{
    //HUD
    MBProgressHUD *HUD;
    
    //POPOVER
    FPPopoverController *popover;
    
    //TABLE HEADER
    FavHeaderView *favHeaderView;
    
    //LOAD MORE
    NSInteger offset;
    NSInteger limit;
    NSInteger totalRecords;
    
    //SEARCH LABEL TEXT IN HEADER VIEW
    NSString *keyWord;
    
    //Table Selected Cell
    BOOL allSelected;
    NSString *delCocktailId;
    NSMutableArray *aryDelIndexpaths;
    NSInteger selIndex;
    
}

//Main Table
@property (strong, nonatomic) IBOutlet UITableView *tblView;
@property (strong, nonatomic) NSMutableArray *aryList;
@property (strong, nonatomic) IBOutlet UILabel *lblNoRecord;

@end



@implementation MyFavoriteCocktailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [CommonUtils setTitleLabel:@"MY COCKTAIL LIST"];
    [self configureTopButtons];
    [self configureFavTableView];
    [self initializeDataStructure];
    [self callFavCocktailWebservice];
}

-(void)initializeDataStructure {
    self.aryList = [[NSMutableArray alloc]  init];
    aryDelIndexpaths = [[NSMutableArray alloc] init];
    keyWord = @"";
    delCocktailId = @"0";
    selIndex = -1;
    
    limit = 10;
    offset = 0;
    totalRecords = 0;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setNavImage];
    self.navigationController.navigationBar.topItem.title = @" ";
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
    btnTopSearch = [CommonUtils barItemWithImage:[UIImage imageNamed:@"top-home.png"] highlightedImage:nil xOffset:-5 target:self action:@selector(btnTopSearch_Clicked:)];
    
    self.navigationItem.rightBarButtonItems = @[btnFilter,btnTopSearch];
}



-(void)btnTopSearch_Clicked:(UIButton *)btnTopSearch {
    [self btnTopSearchClicked:btnTopSearch];
}

-(void)btnTopSearchClicked:(UIButton *)btnTopSearch {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HomeScreen" object:nil];
//    [self.navigationController popToRootViewControllerAnimated:YES];
//    FindBarViewController *findBar = [[FindBarViewController alloc] initWithNibName:@"FindBarViewController" bundle:nil];
//    [self.navigationController pushViewController:findBar animated:YES];
}


-(void)openRightMenu_Clicked:(UIButton *)btnRightMenu {
    [self btnFilterClicked:btnRightMenu];
}

-(void)btnFilterClicked:(id)sender
{
    LeftMenu_Popup *controller = [[LeftMenu_Popup alloc] initWithStyle:UITableViewStylePlain];
    controller.myFavCocktailDelegate = self;
    
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

-(void)configureFavTableView  {
    id headerView = [[[NSBundle mainBundle] loadNibNamed:@"FavHeaderView" owner:self options:nil] objectAtIndex:0];
    favHeaderView = (FavHeaderView *)headerView;
    [favHeaderView configureFavHeaderView:@"Search My Cocktails"];
    
    favHeaderView.delegate = self;
}

#pragma mark FavHeaderView Delegate
-(void)resetButtonTapped {
    favHeaderView.txtSearch.text = @"";
    keyWord = @"";
    limit = 10;
    offset = 0;
    [self callFavCocktailWebservice];
}

-(void)selectAllTapped:(UIButton *)btnSelectAll {
    if ([self.aryList count]==0) {
        ShowAlert(AlertTitle, @"My favorite cocktails list is empty");
        return;
    }
    allSelected = !allSelected;
    if (allSelected) {
        [self selectAllFavCocktails];
        [btnSelectAll setTitle:@"Deselect All" forState:UIControlStateNormal];
    }
    else {
        [self deselectAllFavCocktails];
        [btnSelectAll setTitle:@"Select All" forState:UIControlStateNormal];
    }
}

-(void)selectAllFavCocktails {
    if ([aryDelIndexpaths count]>0) {
        [aryDelIndexpaths removeAllObjects];
    }
    for (int i = 0; i<self.aryList.count; i++) {
        FavCocktail*favCocktail= [self.aryList objectAtIndex:i];
        favCocktail.fav_checked = @"1";
        NSIndexPath *delIndePath = [NSIndexPath indexPathForRow:i inSection:0];
        favCocktail.indexPath = delIndePath;
        [self.aryList replaceObjectAtIndex:i withObject:favCocktail];
    }
    [self.tblView reloadData];
}

-(void)deselectAllFavCocktails {
    if ([aryDelIndexpaths count]>0) {
        [aryDelIndexpaths removeAllObjects];
    }
    for (int i = 0; i<self.aryList.count; i++) {
        FavCocktail*favCocktail= [self.aryList objectAtIndex:i];
        favCocktail.fav_checked = @"0";
        favCocktail.indexPath = nil;
        [self.aryList replaceObjectAtIndex:i withObject:favCocktail];
    }
    [self.tblView reloadData];
}


-(void)deleteTapped {
    if ([self.aryList count]==0) {
        ShowAlert(AlertTitle, @"My favorite cocktails list is empty");
        return;
    }

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.fav_checked contains[cd] %@",@"1"];
    NSArray *ary = [self.aryList filteredArrayUsingPredicate:predicate];
    
    NSMutableArray *aryCheckedBars = [@[] mutableCopy];
    for (FavCocktail *favCocktail in ary) {
        if ([favCocktail.fav_checked isEqualToString:@"1"]) {
            [aryCheckedBars addObject:favCocktail.fav_cocktail_id];
            [aryDelIndexpaths addObject:favCocktail.indexPath];
        }
    }
    
    if ([aryDelIndexpaths count]>0) {
        delCocktailId = [aryCheckedBars componentsJoinedByString:@","];
        if ([aryDelIndexpaths count]==1) {
            [CommonUtils alertViewDelegateWithTitle:AlertTitle withMessage:@"Are you sure you want to delete this favorite cocktail ?" andTarget:self forCancelString:@"YES" forOtherButtonString:@"NO" withTag:300];
        }
        else {
            [CommonUtils alertViewDelegateWithTitle:AlertTitle withMessage:@"Are you sure you want to delete selected favorite cocktails ?" andTarget:self forCancelString:@"YES" forOtherButtonString:@"NO" withTag:300];
            
        }
    }
    else
    {
        ShowAlert(AlertTitle, @"Please select a record to delete");
    }
    NSLog(@"Del Bar IDs = %@",delCocktailId);
}

-(void)searchFavByName:(NSString *)name {
    keyWord = name;
    limit = 10;
    offset = 0;
    [self callFavCocktailWebservice];
}

#pragma mark View For Header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        if (allSelected) {
            [favHeaderView.btnSelectAll setTitle:@"Deselect All" forState:UIControlStateNormal];
        }
        else {
            [favHeaderView.btnSelectAll setTitle:@"Select All" forState:UIControlStateNormal];
        }
        return favHeaderView;
    }
    else {
        return nil;
    }
}

#pragma mark Height For Header
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 107;
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
            static NSString *simpleTableIdentifier = @"MyFavCell";
            
            MyFavCell *cell = (MyFavCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            if (cell == nil)
            {
                NSArray *nib;
                if([CommonUtils isiPad])
                {
                    nib = [[NSBundle mainBundle] loadNibNamed:@"MyFavCell" owner:self options:nil];
                }
                else
                {
                    nib = [[NSBundle mainBundle] loadNibNamed:@"MyFavCell" owner:self options:nil];
                }
                cell = [nib objectAtIndex:0];
            }
            [cell configureCellUI];
            
            FavCocktail*favCocktail= [self.aryList objectAtIndex:indexPath.row];
            cell.lblTitle.text = favCocktail.fav_cocktail_name;
            cell.lblDate.text = favCocktail.fav_date_added;
            cell.lblType.text = favCocktail.fav_cocktail_type;
            
            if ([favCocktail.fav_checked isEqualToString:@"0"]) {
                [cell.btnCheck setBackgroundImage:[UIImage imageNamed:@"checkbox-fav-off.png"] forState:UIControlStateNormal];
            }
            else {
                [cell.btnCheck setBackgroundImage:[UIImage imageNamed:@"checkbox-fav-on.png"] forState:UIControlStateNormal];
            }
            
            NSString *cocktail_logo = [favCocktail fav_cocktail_image];
            NSString *strImgURL = [NSString stringWithFormat:@"%@%@%@",WEBIMAGE_URL,COCKTAILLOGO,cocktail_logo];
            NSURL *imgURL = [NSURL URLWithString:strImgURL];
            
            [cell.imgFav sd_setImageWithURL:imgURL placeholderImage:[UIImage imageNamed:@"no_cocktail.png"]];
            
            cell.btnCheck.tag = indexPath.row;
            cell.btnDelete.tag = indexPath.row;
            [cell.btnCheck addTarget:self action:@selector(btnCheck_Clicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnDelete addTarget:self action:@selector(btnDelete_Clicked:) forControlEvents:UIControlEventTouchUpInside];
            
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
                    [self callFavCocktailListWebservice_LOAD_MORE];
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

-(void)btnCheck_Clicked:(UIButton *)btnCheck {
    NSInteger tag = btnCheck.tag;
    FavCocktail*favCocktail= [self.aryList objectAtIndex:tag];
    if ([favCocktail.fav_checked isEqualToString:@"0"]) {
        favCocktail.fav_checked = @"1";
        [btnCheck setBackgroundImage:[UIImage imageNamed:@"checkbox-fav-on.png"] forState:UIControlStateNormal];
        NSIndexPath *delIndexPath = [NSIndexPath indexPathForRow:tag inSection:0];
        favCocktail.indexPath = delIndexPath;
    }
    else {
        favCocktail.fav_checked = @"0";
        [btnCheck setBackgroundImage:[UIImage imageNamed:@"checkbox-fav-off.png"] forState:UIControlStateNormal];
        favCocktail.indexPath = nil;
    }
    [self.aryList replaceObjectAtIndex:tag withObject:favCocktail];
    [self isAllFavCocktailChecked];
    [self.tblView reloadData];
}

-(void)isAllFavCocktailChecked {
    BOOL isUnfav = NO;
    for (FavCocktail*favCocktail in self.aryList) {
        if ([favCocktail.fav_checked isEqualToString:@"0"]) {
            isUnfav = YES;
            break;
        }
    }
    if (isUnfav == YES) {
        allSelected = NO;
    }
    else {
        allSelected = YES;
    }
}

-(void)btnDelete_Clicked:(UIButton *)btnDelete {
    NSInteger tag = btnDelete.tag;
    FavCocktail*favCocktail= [self.aryList objectAtIndex:tag];
    delCocktailId = favCocktail.fav_cocktail_id;
    selIndex = tag;
    [CommonUtils alertViewDelegateWithTitle:AlertTitle withMessage:@"Are you sure you want to delete this favorite cocktail ?" andTarget:self forCancelString:@"YES" forOtherButtonString:@"NO" withTag:300];
    NSLog(@"Deleted Bar Id = %@",delCocktailId);
}

#pragma mark Cell Height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.section) {
        case 0:
            return 119;
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
    FavCocktail*favCocktail= [self.aryList objectAtIndex:indexPath.row];
    CocktailDirectory *cocktail = [self getCocktailFromFavCocktail:favCocktail];
    
    CocktailDirectoryDetailViewController *cocktailDetail = [[CocktailDirectoryDetailViewController alloc] initWithNibName:@"CocktailDirectoryDetailViewController" bundle:nil];
    cocktailDetail.cocktail = cocktail;
    [self.navigationController pushViewController:cocktailDetail animated:YES];
    
    
}

-(CocktailDirectory *)getCocktailFromFavCocktail:(FavCocktail*)favCocktail{
    CocktailDirectory *cocktail = [[CocktailDirectory alloc] init];
    cocktail.cocktail_id = favCocktail.fav_cocktail_id;
    cocktail.cocktail_name = favCocktail.fav_cocktail_name;
    cocktail.cocktail_type = favCocktail.fav_cocktail_type;
    return cocktail;
}

#pragma mark - Alert View
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 300) {
        if (buttonIndex == 0) {
            [self callDeleteFavCocktailListWebservice];
        }
    }
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

#pragma mark - Webservice Call
-(void)callFavCocktailWebservice {
    [CommonUtils callWebservice:@selector(favoritecocktail) forTarget:self];
}

-(void)callFavCocktailListWebservice_LOAD_MORE {
    [CommonUtils callWebservice:@selector(favoritecocktail_LOAD_MORE) forTarget:self];
}

-(void)callDeleteFavCocktailListWebservice {
    [CommonUtils callWebservice:@selector(deletefavcocktail) forTarget:self];
}

#pragma mark - Webservice
#pragma mark favoritecocktail
-(void)favoritecocktail
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.mode = MBProgressHUDModeIndeterminate;
    
    User *user = [CommonUtils getUserLoginDetails];
    NSString *user_id = [user user_id];
    NSString *device_id = [user device_id];
    NSString *unique_code =[user unique_code];
    
    
    //192.168.1.27/ADB/api/favoritebar
    NSString *myURL = [NSString stringWithFormat:@"%@favoritecocktail",WEBSERVICE_URL];
    NSMutableURLRequest *Request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: myURL]];
    NSString *params = [NSString stringWithFormat:@"user_id=%@&device_id=%@&unique_code=%@&limit=%ld&offset=%ld&keyword=%@",user_id,device_id,unique_code,(long)limit,(long)offset,keyWord];
    
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
                totalRecords = [[CommonUtils getNotNullString:[tempDict valueForKey:@"favorite_cocktail_list_total"]] integerValue];
                offset = offset + limit;
                NSArray *aryFavCocktailList = [[tempDict valueForKey:@"favorite_cocktail_list"] valueForKey:@"result"];
                self.aryList = [self getFavCocktailsFromResult:aryFavCocktailList];
                if([self.aryList count]==0){
                    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    [appDelegate.window makeToast:@"No Record Found" duration:4.0 position:CSToastPositionBottom];
                }
                [self.tblView reloadData];
            }
        }
        else {
            
        }
        
    }];
    
}

-(NSMutableArray *)getFavCocktailsFromResult:(NSArray *)aryFavCocktailList
{
    NSMutableArray *aryFavCocktails = [@[] mutableCopy];
    if ([aryFavCocktails count]>0) {
        [aryFavCocktails removeAllObjects];
    }
    
    for (NSDictionary *dict in aryFavCocktailList) {
        FavCocktail *favCocktail = [FavCocktail getFavCocktailWithDictionary:dict];
        [aryFavCocktails addObject:favCocktail];
    }
    return aryFavCocktails;
}

#pragma mark favoritecocktail WITH LOAD MORE
-(void)favoritecocktail_LOAD_MORE
{
    
    User *user = [CommonUtils getUserLoginDetails];
    NSString *user_id = [user user_id];
    NSString *device_id = [user device_id];
    NSString *unique_code =[user unique_code];
    
    //192.168.1.27/ADB/api/favoritebar
    NSString *myURL = [NSString stringWithFormat:@"%@favoritecocktail",WEBSERVICE_URL];
    NSMutableURLRequest *Request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: myURL]];
    NSString *params = [NSString stringWithFormat:@"user_id=%@&device_id=%@&unique_code=%@&limit=%ld&offset=%ld&keyword=%@",user_id,device_id,unique_code,(long)limit,(long)offset,keyWord];
    
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
                
                NSArray *aryFavCocktailList = [[tempDict valueForKey:@"favorite_cocktail_list"] valueForKey:@"result"];
                [self getMoreFavCocktailFromResult:aryFavCocktailList];
            }
        }
        else {
            
        }
        
    }];
    
}

-(void)getMoreFavCocktailFromResult:(NSArray *)aryFavCocktailList {
    
    for(int i=0; i<[aryFavCocktailList count]; i++)
    {
        NSDictionary *dict = [aryFavCocktailList objectAtIndex:i];
        FavCocktail *favCocktail = [FavCocktail getFavCocktailWithDictionary:dict];
        [self.aryList addObject:favCocktail];
    }
    offset = offset + limit;
    [self.tblView reloadData];
}

#pragma mark deletefavcocktail
-(void)deletefavcocktail
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.mode = MBProgressHUDModeIndeterminate;
    
    User *user = [CommonUtils getUserLoginDetails];
    NSString *user_id = [user user_id];
    NSString *device_id = [user device_id];
    NSString *unique_code =[user unique_code];
    
    
    //192.168.1.27/ADB/api/favoritebar
    NSString *myURL = [NSString stringWithFormat:@"%@deletefavcocktail",WEBSERVICE_URL];
    NSMutableURLRequest *Request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: myURL]];
    NSString *params = [NSString stringWithFormat:@"user_id=%@&device_id=%@&unique_code=%@&limit=%ld&offset=%ld&cocktail_id=%@",user_id,device_id,unique_code,(long)limit,(long)offset,delCocktailId];
    
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
                if ([aryDelIndexpaths count]>0) {
                    NSMutableIndexSet *discardedItems = [NSMutableIndexSet indexSet];
                    for (NSIndexPath *indexPath in aryDelIndexpaths) {
                        [discardedItems addIndex:indexPath.row];
                    }
                    [self.aryList removeObjectsAtIndexes:discardedItems];
                    [aryDelIndexpaths removeAllObjects];
                }
                else {
                    [self.aryList removeObjectAtIndex:selIndex];
                }
                selIndex = -1;
                [self.tblView reloadData];
            }
        }
        else {
            
        }
        
    }];
    
}



@end
