//
//  DashboardViewController.m
//  AmericanDiveBars
//
//  Created by spaculus on 10/2/15.
//  Copyright © 2015 spaculus. All rights reserved.
//

#import "DashboardViewController.h"
#import "LoginViewController.h"
#import "UIViewController+AMSlideMenu.h"
#import "HomeCell.h"

#import "BarSearchViewController.h"
#import "MyProfileViewController.h"
#import "CocktailDirectoryViewController.h"
#import "LiquorDirectoryViewController.h"
#import "TaxiDirectoryViewController.h"
#import "PhotoGalleryViewController.h"

#import "MyFavoriteBarViewController.h"
#import "MyFavoriteBeerViewController.h"
#import "MyFavoriteCocktailViewController.h"
#import "MyFavoriteLiquorViewController.h"

#import "MyAlbumViewController.h"
#import "ChangePasswordViewController.h"

#import "HomeViewController.h"


static NSString * const HomeCellIdentifier = @"HomeCellIdentifier";

@interface DashboardViewController ()<MBProgressHUDDelegate,FPPopoverControllerDelegate>
{
    MBProgressHUD *HUD;
    
    NSArray *aryHomeOptions;
    
    //POPOVER
    FPPopoverController *popover;
}


@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) NSURLConnection *connectionLogout;
@end

@implementation DashboardViewController

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self registerCell];
        return self;
    }
    else {
        return nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self setStatusBarVisibility];
    [self configureTopButtons];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.titleView = [CommonUtils setTitleLabel:@"MY DASHBOARD"];
    
    aryHomeOptions = @[@{@"name":@"MY PROFILE",@"image":@"dashboard-my-profile.png"},
                       @{@"name":@"MY ALBUMS",@"image":@"dashboard-my-albums.png"},
                       @{@"name":@"MY BAR LIST",@"image":@"dashboard-bar.png"},
                       @{@"name":@"MY BEER LIST",@"image":@"dashboard-beer.png"},
                       @{@"name":@"MY COCKTAIL LIST",@"image":@"dashboard-cocktail.png"},
                       @{@"name":@"MY LIQUOR LIST",@"image":@"dashboard-liquor.png"},
                       @{@"name":@"TRIVIA GAME",@"image":@"trivia-game_home.png"},
                       @{@"name":@"ARTICLES",@"image":@"article_home.png"},
                       @{@"name":@"HOME",@"image":@"home_home.png"},
                       @{@"name":@"PRIVACY SETTINGS",@"image":@"dashboard-privacy-settings.png"},
                       @{@"name":@"CHANGE PASSWORD",@"image":@"dashboard-change-pwd.png"},
                       @{@"name":@"LOGOUT",@"image":@"dashboard-Logout.png"}];
    [self registerCell];
}


-(void)viewDidLayoutSubviews {
    [self setStatusBarVisibility];
    popover.contentSize = CGSizeMake(150, self.view.bounds.size.height-20);
    CGSize blankImageSize = CGSizeMake(self.view.bounds.size.width, 64);
    UIImage *blank = [CommonUtils imageFromColor:[UIColor colorWithRed:187.0/255.0 green:124.0/255.0 blue:37.0/255.0 alpha:1.0] forSize:blankImageSize withCornerRadius:0.0];
    [CommonUtils setNavigationBarImage:blank forNavigationBar:self.navigationController.navigationBar];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.topItem.title = @" ";
    [self setStatusBarVisibility];
//    CGSize blankImageSize = CGSizeMake(self.view.bounds.size.width, 64);
//    UIImage *blank = [CommonUtils imageFromColor:[UIColor colorWithRed:187.0/255.0 green:124.0/255.0 blue:37.0/255.0 alpha:1.0] forSize:blankImageSize withCornerRadius:0.0];
//    [CommonUtils setNavigationBarImage:blank forNavigationBar:self.navigationController.navigationBar];
}

-(void)setStatusBarVisibility {
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}




-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    CGSize blankImageSize = CGSizeMake(self.view.bounds.size.width, 64);
//    UIImage *blank = [CommonUtils imageFromColor:[UIColor colorWithRed:187.0/255.0 green:124.0/255.0 blue:37.0/255.0 alpha:1.0] forSize:blankImageSize withCornerRadius:0.0];
//    [CommonUtils setNavigationBarImage:blank forNavigationBar:self.navigationController.navigationBar];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HomeScreen" object:nil];
    //[self.navigationController popToRootViewControllerAnimated:YES];
    // FindBarViewController *findBar = [[FindBarViewController alloc] initWithNibName:@"FindBarViewController" bundle:nil];
    // [self.navigationController pushViewController:findBar animated:YES];
}


-(void)openRightMenu_Clicked:(UIButton *)btnRightMenu {
    [self btnFilterClicked:btnRightMenu];
}

-(void)btnFilterClicked:(id)sender
{
    LeftMenu_Popup *controller = [[LeftMenu_Popup alloc] initWithStyle:UITableViewStylePlain];
    controller.dashBoardDelegate = self;
    if ([CommonUtils isLoggedIn]) {
        //Dashboard
        controller.aryItems = @[@{@"image":@"user-no_image_LM.png",@"title":@"User"},
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
        //Dashboard
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
    
    
    //Dashboard
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
            FindBarViewController *findBar = [[FindBarViewController alloc] initWithNibName:@"FindBarViewController" bundle:nil];
            [self.navigationController pushViewController:findBar animated:YES];
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



#pragma mark - Collection View
-(void)registerCell {
    [self.cv registerNib:[UINib nibWithNibName:@"HomeCell" bundle:nil] forCellWithReuseIdentifier:HomeCellIdentifier];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return aryHomeOptions.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    static HomeCell *cell = nil;
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:HomeCellIdentifier forIndexPath:indexPath];
    
    switch (indexPath.item) {
        case 0:
            cell.backgroundColor = [UIColor colorWithRed:187.0/255.0 green:124.0/255.0 blue:37.0/255.0 alpha:1.0];
            break;
        case 1:
            cell.backgroundColor = [UIColor colorWithRed:143.0/255.0 green:98.0/255.0 blue:30.0/255.0 alpha:1.0];
            break;
        case 2:
            cell.backgroundColor = [UIColor colorWithRed:187.0/255.0 green:124.0/255.0 blue:37.0/255.0 alpha:1.0];
            break;
        case 3:
             cell.backgroundColor = [UIColor colorWithRed:143.0/255.0 green:98.0/255.0 blue:30.0/255.0 alpha:1.0];
            break;
        case 4:
            cell.backgroundColor = [UIColor colorWithRed:187.0/255.0 green:124.0/255.0 blue:37.0/255.0 alpha:1.0];
            break;
        case 5:
             cell.backgroundColor = [UIColor colorWithRed:143.0/255.0 green:98.0/255.0 blue:30.0/255.0 alpha:1.0];
            break;
        case 6:
            cell.backgroundColor = [UIColor colorWithRed:187.0/255.0 green:124.0/255.0 blue:37.0/255.0 alpha:1.0];
            break;
        case 7:
             cell.backgroundColor = [UIColor colorWithRed:143.0/255.0 green:98.0/255.0 blue:30.0/255.0 alpha:1.0];
            break;
        case 8:
            cell.backgroundColor = [UIColor colorWithRed:187.0/255.0 green:124.0/255.0 blue:37.0/255.0 alpha:1.0];
            break;
        case 9:
            cell.backgroundColor = [UIColor colorWithRed:143.0/255.0 green:98.0/255.0 blue:30.0/255.0 alpha:1.0];
            break;
        case 10:
            cell.backgroundColor = [UIColor colorWithRed:187.0/255.0 green:124.0/255.0 blue:37.0/255.0 alpha:1.0];
            break;
        case 11:
            cell.backgroundColor = [UIColor colorWithRed:143.0/255.0 green:98.0/255.0 blue:30.0/255.0 alpha:1.0];
            break;
        default:
            break;
    }
    
    NSDictionary *dict = [aryHomeOptions objectAtIndex:indexPath.item];
    cell.lblHome.text = [dict valueForKey:@"name"];
    cell.imgHome.image = [UIImage imageNamed:[dict valueForKey:@"image"]];
    if ([CommonUtils isIPhone4] || [CommonUtils isIPhone5]) {
        cell.lblHome.font = [UIFont fontWithName:@"Verdana-Bold" size:12.0];
    }
    else {
        cell.lblHome.font = [UIFont fontWithName:@"Verdana-Bold" size:14.0];

    }
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    return CGSizeMake(collectionView.frame.size.width/2, collectionView.frame.size.height/3);
    if(![CommonUtils isiPad])
    {
        if([CommonUtils isIPhone6])
        {
            return CGSizeMake(collectionView.frame.size.width/3, 148);//return CGSizeMake(179, 191);
        }
        else if ([CommonUtils isIPhone6Plus])
        {
            return CGSizeMake(collectionView.frame.size.width/3, 167);//CGSizeMake(199, 214);
        }
        else
        {
            return CGSizeMake(collectionView.frame.size.width/3, 121);//CGSizeMake(151, 165);
        }
    }
    else
    {
        return CGSizeMake(collectionView.frame.size.width/3, 243);//CGSizeMake(376, 335);
    }
    /*if(![CommonUtils isiPad])
    {
        if([CommonUtils isIPhone6])
        {
            return CGSizeMake(collectionView.frame.size.width/2, 150);//return CGSizeMake(179, 191);162
        }
        else if ([CommonUtils isIPhone6Plus])
        {
            return CGSizeMake(collectionView.frame.size.width/2, 167);//CGSizeMake(199, 214);179
        }
        else
        {
            return CGSizeMake(collectionView.frame.size.width/2, 121);//CGSizeMake(151, 165);137
        }
    }
    else
    {
        return CGSizeMake(collectionView.frame.size.width/2, 243);//CGSizeMake(376, 335);251
    }*/
    /*if(![CommonUtils isiPad])
    {
        if([CommonUtils isIPhone6])
        {
            return CGSizeMake(collectionView.frame.size.width/3, 194);//return CGSizeMake(179, 191);
        }
        else if ([CommonUtils isIPhone6Plus])
        {
            return CGSizeMake(collectionView.frame.size.width/3, 217);//CGSizeMake(199, 214);
        }
        else
        {
            return CGSizeMake(collectionView.frame.size.width/3, 165);//CGSizeMake(151, 165);
        }
    }
    else
    {
        return CGSizeMake(collectionView.frame.size.width/3, 335);//CGSizeMake(376, 335);
    }*/
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.item) {
        case 0:
        {
            MyProfileViewController *myProfile = [[MyProfileViewController alloc]  initWithNibName:@"MyProfileViewController" bundle:nil];
            [self.navigationController pushViewController:myProfile animated:YES];
        }
            break;
        case 1:
        {
            MyAlbumViewController *album = [[MyAlbumViewController alloc]  initWithNibName:@"MyAlbumViewController" bundle:nil];
            [self.navigationController pushViewController:album animated:YES];
        }
            break;
        case 2:
        {
            MyFavoriteBarViewController *favBar = [[MyFavoriteBarViewController alloc]  initWithNibName:@"MyFavoriteBarViewController" bundle:nil];
            [self.navigationController pushViewController:favBar animated:YES];
        }
            break;
        case 3:
        {
            MyFavoriteBeerViewController *favBeer = [[MyFavoriteBeerViewController alloc]  initWithNibName:@"MyFavoriteBeerViewController" bundle:nil];
            [self.navigationController pushViewController:favBeer animated:YES];
        }
            break;
        case 4:
        {
            MyFavoriteCocktailViewController *favCocktail = [[MyFavoriteCocktailViewController alloc]  initWithNibName:@"MyFavoriteCocktailViewController" bundle:nil];
            [self.navigationController pushViewController:favCocktail animated:YES];
        }
            break;
        case 5:
        {
            MyFavoriteLiquorViewController *favLiquor = [[MyFavoriteLiquorViewController alloc]  initWithNibName:@"MyFavoriteLiquorViewController" bundle:nil];
            [self.navigationController pushViewController:favLiquor animated:YES];
        }
            break;
        
        case 6:
        {
            TriviaStartViewController *triviaStart = [[TriviaStartViewController alloc]  initWithNibName:@"TriviaStartViewController" bundle:nil];
            [self.navigationController pushViewController:triviaStart animated:YES];
        }
            break;
            
        case 7:
        {
            
            ArticleViewController *article = [[ArticleViewController alloc]  initWithNibName:@"ArticleViewController" bundle:nil];
            [self.navigationController pushViewController:article animated:YES];
            
            //                PhotoGalleryViewController *photo = nil;
            //                if ([CommonUtils isiPad]) {
            //                    photo = [[PhotoGalleryViewController alloc]  initWithNibName:@"PhotoGalleryViewController_iPad" bundle:nil];
            //                }
            //                else {
            //                    photo = [[PhotoGalleryViewController alloc]  initWithNibName:@"PhotoGalleryViewController" bundle:nil];
            //                }
            //                [self.navigationController pushViewController:photo animated:YES];
        }
            break;
            
        case 8:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"HomeScreen" object:nil];

        }
            break;
            
        case 9:
        {
            PrivacySettingViewController *setting = [[PrivacySettingViewController alloc]  initWithNibName:@"PrivacySettingViewController" bundle:nil];
            [self.navigationController pushViewController:setting animated:YES];
        }
            break;
            
        case 10:
        {
            ChangePasswordViewController *changePwd = [[ChangePasswordViewController alloc]  initWithNibName:@"ChangePasswordViewController" bundle:nil];
            [self.navigationController pushViewController:changePwd animated:YES];
        }
            break;
            
        case 11:
        {
            [CommonUtils alertViewDelegateWithTitle:AlertTitle withMessage:@"Are you sure you want to logout?" andTarget:self forCancelString:@"YES" forOtherButtonString:@"NO" withTag:100];
            
        }
            break;
        default:
            break;
    }
    
}

#pragma mark - Oriantation
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}


-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self.cv reloadData];
}
-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [self setStatusBarVisibility];
    [self.cv reloadData];
    
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
         // do whatever
     } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         
     }];
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}



#pragma mark Alertview Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 100)
    {
        if (buttonIndex == 0)
        {
            BOOL hasConnected = [CommonUtils connected];
            if (hasConnected)
            {
                [self performSelector:@selector(logoutService) withObject:nil afterDelay:0.0001];
            }
            else
            {
                ShowAlert(AlertTitle, MSG_NO_INTERNET_CONNECTION);
            }
        }
    }
}
#pragma mark -- Webservice Request
-(void)logoutService
{
    NSString *deviceId  = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceId"];
    NSString *userId  = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    NSString *unique_code  = [[NSUserDefaults standardUserDefaults] objectForKey:@"uniqueCode"];
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.mode = MBProgressHUDModeIndeterminate;
    
    //192.168.1.27/ADB/api/user_logout
    NSString *myURL = [NSString stringWithFormat:@"%@user_logout",WEBSERVICE_URL];
    NSMutableURLRequest *Request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: myURL]];
    NSString *params = [NSString stringWithFormat:@"user_id=%@&unique_code=%@&device_id=%@",userId,unique_code,deviceId];
    [Request setHTTPMethod:@"POST"];
    [Request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    self.connectionLogout = [[NSURLConnection alloc] initWithRequest:Request delegate:self];
    
    if(self.connectionLogout)
    {
        _responseData = [NSMutableData data];
    }
    else
    {
        NSLog(@"connectionLogout is NULL");
    }
}

#pragma mark Webservice Response
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.responseData setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.responseData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"connectionDidFinishLoading");
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    NSString *stringResponse = [[NSString alloc]initWithData:self.responseData encoding:NSUTF8StringEncoding];
    NSLog(@"Response : %@",stringResponse);
    
    if (self.responseData == nil)
    {
        ShowAlert(AlertTitle, MSG_SERVER_NOT_REACHABLE);
        return;
    }
    
    NSError *jsonParsingError = nil;
    NSDictionary *tempDict = [NSJSONSerialization JSONObjectWithData:self.responseData options:0 error:&jsonParsingError];
    
    if(connection == self.connectionLogout)
    {
        NSString *signupStatus = [tempDict objectForKey:@"status"];
        if([signupStatus isEqualToString:@"success"])
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"LoggedIn"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"user_id"];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"device_id"];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"unique_code"];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Logout" object:nil];
            
            //            if (self.isLoggoutFromDashBoard)
            //            {
            //                self.isLoggoutFromDashBoard = NO;
            //                [[self delegate] removeDashboard];
            //            }
        }
        else
        {
            ShowAlert(AlertTitle, @"There is some issue. Please try again.");
        }
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"")
                                message:[error localizedDescription]
                               delegate:nil
                      cancelButtonTitle:NSLocalizedString(@"OK", @"")
                      otherButtonTitles:nil] show];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

@end




