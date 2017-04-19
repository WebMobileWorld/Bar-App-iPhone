//
//  FindBarViewController.m
//  AmericanDiveBars
//
//  Created by spaculus on 1/18/16.
//  Copyright © 2016 spaculus. All rights reserved.
//

#import "FindBarViewController.h"
#import "BarSearchViewController.h"
#import "BarSearchHappyHoursViewController.h"
#import "FindBarAroundMeViewController.h"

#import "FindBarOptionCell.h"

@interface FindBarViewController ()<MBProgressHUDDelegate,FPPopoverControllerDelegate>
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

@property (strong, nonatomic) IBOutlet TPKeyboardAvoidingTableView *tblView;

#pragma mark -
@property (strong, nonatomic) IBOutlet UIImageView *bg;
@end

@implementation FindBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = [CommonUtils setTitleLabel:@"FIND BAR"];
    [self configureTopButtons];
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
    controller.findBarDelegate = self;
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
    return 1;
    
}

#pragma mark Cell for Row
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        static NSString *simpleTableIdentifier = @"FindBarOptionCell";
        
        FindBarOptionCell *cell = (FindBarOptionCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            NSArray *nib;
            if([CommonUtils isiPad])
            {
                nib = [[NSBundle mainBundle] loadNibNamed:@"FindBarOptionCell-ipad" owner:self options:nil];
            }
            else
            {
                nib = [[NSBundle mainBundle] loadNibNamed:@"FindBarOptionCell" owner:self options:nil];
            }
            cell = [nib objectAtIndex:0];
        }
    
      [cell configureCellUI];
        
      [cell.btnSearchAroundMe addTarget:self action:@selector(btnSearchAroundMe_Clicked) forControlEvents:UIControlEventTouchUpInside];
      [cell.btnSearchAnotherArea addTarget:self action:@selector(btnSearchAnotherArea_Clicked) forControlEvents:UIControlEventTouchUpInside];
      [cell.btnLocAroundMe addTarget:self action:@selector(btnLocAroundMe_Clicked) forControlEvents:UIControlEventTouchUpInside];
      [cell.btnLocAnotherArea addTarget:self action:@selector(btnLocAnotherArea_Clicked) forControlEvents:UIControlEventTouchUpInside];
    
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
}

-(IBAction) btnSearchAroundMe_Clicked {
    FindBarAroundMeViewController *aroundMe  = [[FindBarAroundMeViewController alloc] initWithNibName:@"FindBarAroundMeViewController" bundle:nil];
    [self.navigationController pushViewController:aroundMe animated:YES];
}

-(IBAction)btnSearchAnotherArea_Clicked {
    BarSearchViewController *barSearch  = [[BarSearchViewController alloc] initWithNibName:@"BarSearchViewController" bundle:nil];
    [self.navigationController pushViewController:barSearch animated:YES];

}

-(IBAction)btnLocAroundMe_Clicked {
    NSString *strDay = [self getDayFromCurrentDate];
    BarSearchDetail *searchDetail = [BarSearchDetail getDetailSearchByName:searchByName searchByState:@"" searchByCity:@"" searchByZip:@"" forDays:strDay happyAddress:@""];
    FindBarAroundMeViewController *aroundMe  = [[FindBarAroundMeViewController alloc] initWithNibName:@"FindBarAroundMeViewController" bundle:nil];
    aroundMe.isFromHappy = YES;
    aroundMe.searchDetail = searchDetail;
    [self.navigationController pushViewController:aroundMe animated:YES];
}

-(NSString *)getDayFromCurrentDate {
    NSDate *now = [NSDate date];
    NSDateFormatter *weekday = [[NSDateFormatter alloc] init];
    [weekday setDateFormat: @"EEEE"];
    NSString *weekDay = [CommonUtils getNotNullString:[weekday stringFromDate:now]];
    NSLog(@"The day of the week is: %@", [weekday stringFromDate:now]);

    return weekDay;
}

-(IBAction)btnLocAnotherArea_Clicked {
    BarSearchHappyHoursViewController *happyHours  = [[BarSearchHappyHoursViewController alloc] initWithNibName:@"BarSearchHappyHoursViewController" bundle:nil];
    happyHours.is_cur_loc = NO;
    [self.navigationController pushViewController:happyHours animated:YES];

}


#pragma mark Cell Height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
     return 288;
    
}

#pragma mark did Select Row
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
