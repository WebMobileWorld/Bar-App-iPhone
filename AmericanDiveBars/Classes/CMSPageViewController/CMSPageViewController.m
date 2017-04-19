//
//  CMSPageViewController.m
//  BreetyNetwork
//
//  Created by admin on 04/03/15.
//  Copyright (c) 2015 spaculus. All rights reserved.
//

#import "CMSPageViewController.h"
#import "AppDelegate.h"

@interface CMSPageViewController ()<FPPopoverControllerDelegate>
{
    //POPOVER
    FPPopoverController *popover;
}


@property (nonatomic, strong) IBOutlet UIWebView *webView;

@end

@implementation CMSPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.titleView = [CommonUtils setTitleLabel:self.topTitle];
    [self configureTopButtons];
    [self loadWebView];
    
}


-(void)setStatusBarVisibility {
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

-(void)viewDidLayoutSubviews {
    [self setStatusBarVisibility];
    popover.contentSize = CGSizeMake(150, self.view.bounds.size.height-20);
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setStatusBarVisibility];
    self.navigationController.navigationBar.topItem.title = @" ";
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
    btnTopSearch = [CommonUtils barItemWithImage:[UIImage imageNamed:@"top-home.png"] highlightedImage:nil xOffset:-10 target:self action:@selector(btnTopSearch_Clicked:)];
    
    self.navigationItem.rightBarButtonItems = @[btnFilter,btnTopSearch];
}



-(void)btnTopSearch_Clicked:(UIButton *)btnTopSearch {
    [self btnTopSearchClicked:btnTopSearch];
}

-(void)btnTopSearchClicked:(UIButton *)btnTopSearch {
    [self.view endEditing:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HomeScreen" object:nil];
    // [self.navigationController popToRootViewControllerAnimated:YES];
    
    // FindBarViewController *findBar = [[FindBarViewController alloc] initWithNibName:@"FindBarViewController" bundle:nil];
    // [self.navigationController pushViewController:findBar animated:YES];
}

-(void)openRightMenu_Clicked:(UIButton *)btnRightMenu {
    [self.view endEditing:YES];
    [self btnFilterClicked:btnRightMenu];
}

-(void)btnFilterClicked:(id)sender
{
    LeftMenu_Popup *controller = [[LeftMenu_Popup alloc] initWithStyle:UITableViewStylePlain];
    controller.cmsPageDelegate = self;
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


#pragma mark - Web view 

-(void)loadWebView {
    [self.webView setOpaque:NO];
    [self.webView setBackgroundColor:[UIColor clearColor]];
    self.webView.scrollView.showsHorizontalScrollIndicator = YES;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://americanbars.com/home/contentView/%@",self.cmsPageSlug]];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    self.webView.scalesPageToFit = YES;
   /* NSString *htmlString =  @"<p>Welcome to Colorado! Now, watch your ash! Boulder County craft breweries are working together to make the public aware about a bug.&nbsp;</p>\n\n<p>\"WATCH YOUR ASH!\" one side of the paper coaster cheerfully warns drinkers from under their glass. The other side encourages people to slow the spread of emerald ash borer by not taking hard wood out of Boulder County and removing affected ash trees.</p>\n\n<p><img alt=\"Emerald Ash Borer\" src=\"https://americanbars.com/upload/barlogo/1460059571_eab_emerging_website.jpg\" style=\"height:378px; width:650px\" /></p>\n\n<p><img alt=\"\" src=\"https://americanbars.com/upload/barlogo/1460059639_Emerald-Ash-borer-damage.jpg\" style=\"height:413px; width:650px\" /></p>\n\n<p>Emerald ash borer has only been confirmed within in Colorado in the city of Boulder, according to the county's Emerald Ash Borer webpage.</p>\n\n<p>Gabi Boerkircher, a communications specialist with the county, came up with the idea for the coasters during one of the monthly meetings the county employees have about emerald ash borer. (hmmm…I wonder where they hold these monthly meetings, eh?)&nbsp;</p>\n\n<p>The goal is to try to reach a lot of the folks who may not be following traditional news outlets,</p>\n\n<p>Yes, there are places in sophisticated places in the nation where people don’t actually look at news. Heavens! Therefore the county used $750 of leftover grant funding to print 5,000 coasters. (Yes, we paused also…Leftover Grant Money? Impossible! And 5,000 coasters in a college town — University of Colorado is located there — that should last, what? About three hours?)</p>\n\n<p><img alt=\"EAB\" src=\"https://americanbars.com/upload/barlogo/1460059718_Still0406_00000_1459981058556_1435821_ver1.0.jpg\" style=\"height:366px; width:650px\" /></p>\n\n<p>And here is the kicker: The coasters went to select bars and pubs in Longmont, Lafayette, Louisville, Erie, Superior, Lyons, Gunbarrel and Niwot. Yes, the problem is in Boulder, but the coasters went to outlying towns.&nbsp;</p>\n\n<p>Yes, Boulder watering holes didn't receive the coasters because there's already major emerald ash borer awareness efforts there and there's quite a few bars in the city.</p>\n\n<p>Teddy McMurdo, a manager at the Pumphouse Brewery in Longmont, said Pumphouse received ash borer coasters, but they're already out. Patrons found the coasters so interesting, many took them home, McMurdo said.</p>\n\n<p>\"And they were free, so we were happy to spread the word,\" he said.</p>\n\n<p>Jean Ditslear, owner of 300 Suns Brewing in Longmont, said she received three stacks of the coasters and is just starting to use them.</p>\n\n<p>\"I think it's cute,\" Ditslear said. \"It's a really unique way to spread the word. It's really clever and they have kind of a captive audience sitting there drinking beer.\"</p>\n\n<p>Ditslear added that her customers think the \"WATCH YOUR ASH!\" slogan is pretty funny.</p>\n\n<p>The campaign has been so successful, they plan to print another 5,000 coasters soon.&nbsp;</p>\n\n<p>So, environmental issues, social messaging, and community awareness all community awareness…all from beer coasters.&nbsp;</p>\n\n<p>What new ideas have you generated today?</p>\n";*/
    
    //NSString *temp = [htmlString stringByReplacingOccurrencesOfString:@"width:650px" withString:@"width:100%"];
    
    //NSString *txtHTML = [NSString stringWithFormat:@"%@%@%@",@"<font face=\"verdana\" color=\"white\">",temp,@"</font>"];
    
    //<body style="background-color: transparent;">
    //[self.webView loadHTMLString:txtHTML baseURL:nil];
    

    [self.webView loadRequest:requestObj];
}

#pragma mark Webview Delegates
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark - Orientation
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}


-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
}
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

@end
