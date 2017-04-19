//
//  TriviaGameResultViewController.m
//  AmericanDiveBars
//
//  Created by spaculus on 4/28/16.
//  Copyright © 2016 spaculus. All rights reserved.
//

#import "TriviaGameResultViewController.h"
#import "TriviaStartViewController.h"
#import "TriviaResultCell.h"

#import <Social/Social.h>

#define CLIEND_ID @"990806806578-17af1lspds8m4klq1q2q6mgklfqolmbj.apps.googleusercontent.com"
static NSString *const kClientId = CLIEND_ID;

@interface TriviaGameResultViewController () <FPPopoverControllerDelegate,GPPSignInDelegate>
{
    //POPOVER
    FPPopoverController *popover;
    
    //Google Plus SDK
    GPPSignIn *signIn;
    
    NSURL *shareURL;

}

@property (strong, nonatomic) IBOutlet UITableView *tblView;
@property (strong, nonatomic) Pinterest *pinterest;

@end

@implementation TriviaGameResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [CommonUtils setTitleLabel:@"QUIZ"];
    [self initializeData];

    // Do any additional setup after loading the view from its nib.
}

-(void)initializeData {
    NSString *strURL = [NSString stringWithFormat:@"%@%@",SHARE_URL,@"trivia"];
    shareURL = [NSURL URLWithString:strURL];
}

#pragma mark -

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setNavImage];
    self.navigationController.navigationBar.topItem.title = @" ";
    [self.tblView reloadData];
    [self configureTopButtons];
}

-(void)setStatusBarVisibility {
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

-(void)viewDidLayoutSubviews {
    [self setStatusBarVisibility];
    popover.contentSize = CGSizeMake(150, self.view.bounds.size.height-20);
}

-(void)setNavImage {
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
    controller.gameResultDelegate = self;
    if ([CommonUtils isLoggedIn]) {
        //All
        controller.aryItems = @[@{@"image":@"user-no_image_LM.png",@"title":@"User"},
                                @{@"image":@"dashboard-LM.png",@"title":@"My Dashboard"},
                                @{@"image":@"bar-LM.png",@"title":@"Find Bar"},
                                @{@"image":@"beer-LM.png",@"title":@"Beer Directory"},
                                @{@"image":@"cocktail-LM.png",@"title":@"Cocktail Recipes"},
                                @{@"image":@"liquor-LM.png",@"title":@"Liquor Directory"},
                                @{@"image":@"taxi-RM.png",@"title":@"Taxi Directory"},
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
            
        default:
            break;
    }
    
}


#pragma mark - Table View
#pragma mark Number of Section
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    /*if(offset < totalRecords && totalRecords>10) {
     return 2;
     }
     else
     {
     return 1;
     }*/
    
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
    
    /*if (section == 0) {
     return [CommonUtils getArrayCountFromArray:self.aryList];
     }
     else {
     return 1;
     }*/
    return 1;
}

#pragma mark Cell for Row
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"TriviaResultCell";
    
    TriviaResultCell *cell = (TriviaResultCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib;
        if([CommonUtils isiPad])
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"TriviaResultCell" owner:self options:nil];
        }
        else
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"TriviaResultCell" owner:self options:nil];
        }
        cell = [nib objectAtIndex:0];
    }
    
    cell.lblYourScore.text = [self.result result];
    cell.lblTimeTaken.text = [self.result duration];
    
    [cell.btnFb addTarget:self action:@selector(btnFb_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnTwitter addTarget:self action:@selector(btnTwitter_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnGoogle addTarget:self action:@selector(btnGooglePlus_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnPintrest addTarget:self action:@selector(btnPintrest_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.btnTryAgain addTarget:self action:@selector(btnTryAgain_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

-(void) btnFb_Clicked:(UIButton *)btnFb {
    [self shareWithFaceBook];
}

-(void) btnTwitter_Clicked:(UIButton *)btnTwitter {
    [self shareWithTwitter];
}

-(void) btnGooglePlus_Clicked:(UIButton *)btnGoogle {
    [self shareWithGooglePlus];
}

-(void) btnPintrest_Clicked:(UIButton *)btnPintrest {
    [self shareWithPintrest];
}


-(void)shareWithFaceBook {
    NSLog(@"FB");
    
    
    SLComposeViewController *composeController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    //http://192.168.1.27/ADB/
    //http://americanbars.com/bar/details/%@
    
    NSURL *url = shareURL; //[NSURL URLWithString:@"http://americanbars.com"];
    // [composeController setInitialText:self.article.blog_title];
    [composeController addURL:url];
    //[composeController addImage:[UIImage imageNamed:@"logo_home_page.png"]];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self presentViewController:composeController animated:YES completion:nil];
        SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result)
        {
            if (result == SLComposeViewControllerResultCancelled)
            {
                NSLog(@"Failure in Posting to Twitter");
            }
            else
            {
                NSLog(@"Successfully Posted to Twitter");
            }
        };
        composeController.completionHandler =myBlock;
    }];
    
}

-(void)shareWithTwitter {
    
    NSLog(@"Twit");
    SLComposeViewController *composeController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    NSURL *url = shareURL;
   // [composeController setInitialText:self.article.blog_title];
    
    [composeController addURL:url];
    //[composeController addImage:[UIImage imageNamed:@"logo_home_page.png"]];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self presentViewController:composeController animated:YES completion:nil];
        SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result)
        {
            if (result == SLComposeViewControllerResultCancelled)
            {
                NSLog(@"Failure in Posting to Twitter");
            }
            else
            {
                NSLog(@"Successfully Posted to Twitter");
            }
        };
        composeController.completionHandler =myBlock;
    }];
}


-(void)shareWithGooglePlus {
    
    NSLog(@"G+");
    
    if([signIn trySilentAuthentication] == YES)
    {
        id<GPPNativeShareBuilder> shareBuilder = [[GPPShare sharedInstance] nativeShareDialog];
        
        
        NSURL *shareUrl = shareURL;
        
        [shareBuilder setURLToShare:shareUrl];
        //[shareBuilder setPrefillText:self.article.blog_title];
        
        [shareBuilder open];
    }
    else
    {
        UIAlertView *failLogin = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please sign in to share on your Google Plus account." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [failLogin setTag:156];
        [failLogin show];
    }
}

- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth error: (NSError *) error
{
    NSLog(@"Received error %@ and auth object %@",error, auth);
    if (error != nil)
    {
        // if there is an error, notify the user and end the activity
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was an error loggin in." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        NSLog(@"%@ %@",[GPPSignIn sharedInstance].userEmail, [GPPSignIn sharedInstance].userID);
    }
}

-(void)shareWithPintrest {
    
    NSLog(@"Pi");
    [self configurePintrest];
    [_pinterest createPinWithImageURL:shareURL
                            sourceURL:[NSURL URLWithString:@"http://placekitten.com"]
                          description:@"Pinning from Pin It Demo"];
}

-(void)configurePintrest {
    _pinterest = [[Pinterest alloc] initWithClientId:@"4799816673504799498" urlSchemeSuffix:@"prod"];
}

#pragma mark - Third Party Api
#pragma mark GooglePlus SDK
-(void)configureGooglePlus {
    signIn = [GPPSignIn sharedInstance];
    signIn.shouldFetchGooglePlusUser = YES;
    signIn.shouldFetchGoogleUserEmail = YES;
    signIn.clientID = kClientId;
    signIn.scopes = @[kGTLAuthScopePlusLogin];
    signIn.delegate = self;
    [signIn trySilentAuthentication];
}


#pragma mark - Try Again

-(void)btnTryAgain_Clicked:(UIButton *)btnTryAgain {
    for (UIViewController *vc in [self.navigationController viewControllers]) {
        if ([vc isKindOfClass:[TriviaStartViewController class]]) {
            TriviaStartViewController *vc_ = (TriviaStartViewController *)vc;
            [self.navigationController popToViewController:vc_ animated:YES];
            break;
        }
    }
}

#pragma mark Navigation Back Button Handler
-(BOOL) navigationShouldPopOnBackButton
{
    for (UIViewController *vc in [self.navigationController viewControllers]) {
        if ([vc isKindOfClass:[TriviaStartViewController class]]) {
            TriviaStartViewController *vc_ = (TriviaStartViewController *)vc;
            [self.navigationController popToViewController:vc_ animated:YES];
            break;
        }
    }

    
    return NO;
}

#pragma mark Height For Row

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 498;
}
#pragma mark Estmated Height For Row
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 498;
}
#pragma mark Did Select Row
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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


#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
