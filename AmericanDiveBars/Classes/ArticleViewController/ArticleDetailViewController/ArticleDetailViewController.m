//
//  ArticleDetailViewController.m
//  AmericanDiveBars
//
//  Created by spaculus on 4/20/16.
//  Copyright © 2016 spaculus. All rights reserved.
//

#import "ArticleDetailViewController.h"

#import <Social/Social.h>
#define CLIEND_ID @"990806806578-17af1lspds8m4klq1q2q6mgklfqolmbj.apps.googleusercontent.com"
static NSString *const kClientId = CLIEND_ID;



@interface ArticleDetailViewController ()<MBProgressHUDDelegate,FPPopoverControllerDelegate,GPPSignInDelegate,RateViewDelegate,UIActionSheetDelegate>
{
    
    
    //HUD
    MBProgressHUD *HUD;
    
    //POPOVER
    FPPopoverController *popover;
    
    //Google Plus SDK
    GPPSignIn *signIn;
    
    NSURL *shareURL;
    
    NSString *ratings;
    
    NSURL *webURL;
    
    NSString *base64_blog_id;

}


@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (nonatomic, strong) IBOutlet RateView *rateView;
@property (nonatomic, strong) IBOutlet UILabel *articleName;
@property (nonatomic, strong) IBOutlet UIButton *btnShare;
@property (nonatomic, strong) IBOutlet UIButton *btnDate;
@property (nonatomic, strong) IBOutlet UIImageView *imgBlog;

//Pintrest
@property (strong, nonatomic) Pinterest *pinterest;


@end

@implementation ArticleDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.titleView = [CommonUtils setTitleLabel:@"ARTICLE DETAILS"];
    [self configureTopButtons];
    [self configUI];
    [self configRateView];
    [self callArticleDetailWebservice];
   // [self loadWebView];
    
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

-(void) configRateView {
    self.rateView.notSelectedImage  = [UIImage imageNamed:@"no-rating_star.png"];
    //self.rateView.halfSelectedImage = [UIImage imageNamed:@"star-half"];
    self.rateView.fullSelectedImage = [UIImage imageNamed:@"full_star.png"];
    
    if ([ratings length]!=0) {
        self.rateView.userInteractionEnabled = NO;
        self.rateView.delegate = nil;
        self.rateView.rating = [ratings floatValue];
    }
    else {
        self.rateView.userInteractionEnabled = YES;
        self.rateView.delegate = self;
        self.rateView.rating = 0.0f;
    }
    
    
    self.rateView.editable = YES;
    self.rateView.maxRating = 5;
    
    [self.rateView setLeftMargin:0];
    [self.rateView setMidMargin:0];
    [self.rateView setMinImageSize:CGSizeMake(0, 0)];
    
    
}

-(void)rateView:(RateView *)rateView ratingDidChange:(float)rating {
    int rate = fabs(rating);
    
    ratings = [NSString stringWithFormat:@"%d",rate];
    
    [self callAddRatingsWebservice];
}

-(void)configUI {
    self.articleName.text = self.article.blog_title;
    [self.btnDate setTitle:[NSString stringWithFormat:@" %@",self.article.date_added] forState:UIControlStateNormal];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.mode = MBProgressHUDModeIndeterminate;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        base64_blog_id = [CommonUtils getBase64StringFrom:self.article.blog_id];
        NSLog(@"Base 64 = %@",base64_blog_id);
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        NSString *strURL = [NSString stringWithFormat:@"%@%@%@",SHARE_URL,@"article/detail/",base64_blog_id];
        shareURL = [NSURL URLWithString:strURL];//https://americanbars.com/article/detail/
        ratings = [self.article total_rating];
        
        NSString *blog_image = [self.article blog_image];
        NSString *strImgURL = [NSString stringWithFormat:@"%@%@%@",WEBIMAGE_URL,IMAGETHUMB_BLOG,blog_image];
        NSURL *imgArticle = [NSURL URLWithString:strImgURL];
        self.imgBlog.contentMode = UIViewContentModeScaleAspectFit;
        [self.imgBlog sd_setImageWithURL:imgArticle placeholderImage:[UIImage imageNamed:@"no-article.png"]];
    }];

    
    
}

/*
-(void)setBarRatingsBy:(int)total_rating {
    switch (total_rating) {
        case 0:
            self.imgStar1.image = [UIImage imageNamed:@"no-rating_star.png"];
            self.imgStar2.image = [UIImage imageNamed:@"no-rating_star.png"];
            self.imgStar3.image = [UIImage imageNamed:@"no-rating_star.png"];
            self.imgStar4.image = [UIImage imageNamed:@"no-rating_star.png"];
            self.imgStar5.image = [UIImage imageNamed:@"no-rating_star.png"];
            
            break;
            
        case 1:
            self.imgStar1.image = [UIImage imageNamed:@"full_star.png"];
            self.imgStar2.image = [UIImage imageNamed:@"no-rating_star.png"];
            self.imgStar3.image = [UIImage imageNamed:@"no-rating_star.png"];
            self.imgStar4.image = [UIImage imageNamed:@"no-rating_star.png"];
            self.imgStar5.image = [UIImage imageNamed:@"no-rating_star.png"];
            
            break;
            
        case 2:
            self.imgStar1.image = [UIImage imageNamed:@"full_star.png"];
            self.imgStar2.image = [UIImage imageNamed:@"full_star.png"];
            self.imgStar3.image = [UIImage imageNamed:@"no-rating_star.png"];
            self.imgStar4.image = [UIImage imageNamed:@"no-rating_star.png"];
            self.imgStar5.image = [UIImage imageNamed:@"no-rating_star.png"];
            
            break;
            
        case 3:
            self.imgStar1.image = [UIImage imageNamed:@"full_star.png"];
            self.imgStar2.image = [UIImage imageNamed:@"full_star.png"];
            self.imgStar3.image = [UIImage imageNamed:@"full_star.png"];
            self.imgStar4.image = [UIImage imageNamed:@"no-rating_star.png"];
            self.imgStar5.image = [UIImage imageNamed:@"no-rating_star.png"];
            
            break;
            
        case 4:
            self.imgStar1.image = [UIImage imageNamed:@"full_star.png"];
            self.imgStar2.image = [UIImage imageNamed:@"full_star.png"];
            self.imgStar3.image = [UIImage imageNamed:@"full_star.png"];
            self.imgStar4.image = [UIImage imageNamed:@"full_star.png"];
            self.imgStar5.image = [UIImage imageNamed:@"no-rating_star.png"];
            
            break;
            
        case 5:
            self.imgStar1.image = [UIImage imageNamed:@"full_star.png"];
            self.imgStar2.image = [UIImage imageNamed:@"full_star.png"];
            self.imgStar3.image = [UIImage imageNamed:@"full_star.png"];
            self.imgStar4.image = [UIImage imageNamed:@"full_star.png"];
            self.imgStar5.image = [UIImage imageNamed:@"full_star.png"];
            
            break;
            
            
        default:
            self.imgStar1.image = [UIImage imageNamed:@"no-rating_star.png"];
            self.imgStar2.image = [UIImage imageNamed:@"no-rating_star.png"];
            self.imgStar3.image = [UIImage imageNamed:@"no-rating_star.png"];
            self.imgStar4.image = [UIImage imageNamed:@"no-rating_star.png"];
            self.imgStar5.image = [UIImage imageNamed:@"no-rating_star.png"];
            break;
            
    }
}
*/


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
    controller.articleDetailDelegate = self;
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

-(IBAction)btnShare_Clicked:(UIButton *)btnShare {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Share Via" delegate:self cancelButtonTitle:@"Cancel"destructiveButtonTitle:nil otherButtonTitles:@"Facebook",@"Twitter", @"Google+",@"Pintrest",nil];
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
        {
            [self shareWithFaceBook];
            break;
        }
            
            
        case 1:
        {
            [self shareWithTwitter];
            break;
        }
            
            
        case 2:
        {
            [self shareWithGooglePlus];
            break;
        }
            
        case 3:
        {
            [self shareWithPintrest];
            break;
        }
            
        default:
            break;
    }
}



-(void)shareWithFaceBook {
    NSLog(@"FB");
    
    
     SLComposeViewController *composeController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
     //http://192.168.1.27/ADB/
     //http://americanbars.com/bar/details/%@
     //NSString *strURL = [NSString stringWithFormat:@"192.168.1.27/ADB/bar/details/%@",fullMugBar.barDetail.bar_slug];
    NSURL *url = shareURL; //[NSURL URLWithString:@"http://americanbars.com"];
    
     [composeController setInitialText:self.article.blog_title];
     [composeController addURL:url];
     //[composeController addImage:[UIImage imageNamed:@"logo_home_page.png"]];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
         [self presentViewController:composeController animated:YES completion:nil];
        SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result)
        {
            if (result == SLComposeViewControllerResultCancelled)
            {
                NSLog(@"Failure in Posting to Facebook");
            }
            else
            {
                NSLog(@"Successfully Posted to Facebook");
            }
        };
        composeController.completionHandler = myBlock;
    }];
    
    
    
}

-(void)shareWithTwitter {
    
    NSLog(@"Twit");
    SLComposeViewController *composeController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    NSURL *url = shareURL;
     [composeController setInitialText:self.article.blog_title];
     
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
     [shareBuilder setPrefillText:self.article.blog_title];
     
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




#pragma mark - Web view

-(void)loadWebView {
    [self.webView setOpaque:NO];
    [self.webView setBackgroundColor:[UIColor clearColor]];
    self.webView.scrollView.showsHorizontalScrollIndicator = YES;
    self.webView.scalesPageToFit = YES;
    NSURL *url = webURL;
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestObj];
    
}


//NSString *htmlString = self.article.blog_description_with_image;//

/*@"<p>Welcome to Colorado! Now, watch your ash! Boulder County craft breweries are working together to make the public aware about a bug.&nbsp;</p>\n\n<p>\"WATCH YOUR ASH!\" one side of the paper coaster cheerfully warns drinkers from under their glass. The other side encourages people to slow the spread of emerald ash borer by not taking hard wood out of Boulder County and removing affected ash trees.</p>\n\n<p><img alt=\"Emerald Ash Borer\" src=\"https://americanbars.com/upload/barlogo/1460059571_eab_emerging_website.jpg\" style=\"height:378px; width:650px\" /></p>\n\n<p><img alt=\"\" src=\"https://americanbars.com/upload/barlogo/1460059639_Emerald-Ash-borer-damage.jpg\" style=\"height:413px; width:650px\" /></p>\n\n<p>Emerald ash borer has only been confirmed within in Colorado in the city of Boulder, according to the county's Emerald Ash Borer webpage.</p>\n\n<p>Gabi Boerkircher, a communications specialist with the county, came up with the idea for the coasters during one of the monthly meetings the county employees have about emerald ash borer. (hmmm…I wonder where they hold these monthly meetings, eh?)&nbsp;</p>\n\n<p>The goal is to try to reach a lot of the folks who may not be following traditional news outlets,</p>\n\n<p>Yes, there are places in sophisticated places in the nation where people don’t actually look at news. Heavens! Therefore the county used $750 of leftover grant funding to print 5,000 coasters. (Yes, we paused also…Leftover Grant Money? Impossible! And 5,000 coasters in a college town — University of Colorado is located there — that should last, what? About three hours?)</p>\n\n<p><img alt=\"EAB\" src=\"https://americanbars.com/upload/barlogo/1460059718_Still0406_00000_1459981058556_1435821_ver1.0.jpg\" style=\"height:366px; width:650px\" /></p>\n\n<p>And here is the kicker: The coasters went to select bars and pubs in Longmont, Lafayette, Louisville, Erie, Superior, Lyons, Gunbarrel and Niwot. Yes, the problem is in Boulder, but the coasters went to outlying towns.&nbsp;</p>\n\n<p>Yes, Boulder watering holes didn't receive the coasters because there's already major emerald ash borer awareness efforts there and there's quite a few bars in the city.</p>\n\n<p>Teddy McMurdo, a manager at the Pumphouse Brewery in Longmont, said Pumphouse received ash borer coasters, but they're already out. Patrons found the coasters so interesting, many took them home, McMurdo said.</p>\n\n<p>\"And they were free, so we were happy to spread the word,\" he said.</p>\n\n<p>Jean Ditslear, owner of 300 Suns Brewing in Longmont, said she received three stacks of the coasters and is just starting to use them.</p>\n\n<p>\"I think it's cute,\" Ditslear said. \"It's a really unique way to spread the word. It's really clever and they have kind of a captive audience sitting there drinking beer.\"</p>\n\n<p>Ditslear added that her customers think the \"WATCH YOUR ASH!\" slogan is pretty funny.</p>\n\n<p>The campaign has been so successful, they plan to print another 5,000 coasters soon.&nbsp;</p>\n\n<p>So, environmental issues, social messaging, and community awareness all community awareness…all from beer coasters.&nbsp;</p>\n\n<p>What new ideas have you generated today?</p>\n";*/


//NSString *temp = [htmlString stringByReplacingOccurrencesOfString:@"width:650px" withString:@"width:100%"];

//NSString *txtHTML = [NSString stringWithFormat:@"%@%@",@"<style>img{display: inline; height: auto; max-width: 100%; width:100%;}p{color:white; font-size:25px; font-face:\"verdana\";}</style>",htmlString];

//<font size=\"8\" face=\"verdana\" color=\"white\"> @"</font>"
//<body style="background-color: transparent;"> size=\"10\"
//[self.webView loadHTMLString:txtHTML baseURL:nil];

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

#pragma mark - Webservice Call
-(void)callAddRatingsWebservice {
    [CommonUtils callWebservice:@selector(addRating) forTarget:self];
}

-(void)callArticleDetailWebservice {
    [CommonUtils callWebservice:@selector(articledetail) forTarget:self];
}


#pragma mark - Webservice

#pragma mark bar_lists WITH LOAD MORE
-(void)articledetail
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.mode = MBProgressHUDModeIndeterminate;
    
    User *user = [CommonUtils getUserLoginDetails];
    NSString *user_id = [user user_id];
    NSString *device_id = [user device_id];
    NSString *unique_code =[user unique_code];
    
    
    //192.168.1.27/ADB/api/bar_lists
    NSString *myURL = [NSString stringWithFormat:@"%@articledetail",WEBSERVICE_URL];
    NSMutableURLRequest *Request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: myURL]];
    
    // NSString *params = [NSString stringWithFormat:@"user_id=%@&device_id=%@&unique_code=%@&limit=%ld&offset=%ld&state=%@&city=%@&zipcode=%@&title=%@&order_by=%@",user_id,device_id,unique_code,(long)limit,(long)offset,state,city,zip,name,order_by];
    
    NSString *params = [NSString stringWithFormat:@"user_id=%@&device_id=%@&unique_code=%@&article_id=%@",user_id,device_id,unique_code,self.article.blog_id];
    
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
                NSString *strURL = [CommonUtils getNotNullString:[tempDict valueForKey:@"url"]];
                
                webURL =[NSURL URLWithString:strURL];
                
                [self loadWebView];
            }
        }
        else {
        }
    }];
}


#pragma mark addRating
-(void)addRating
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.mode = MBProgressHUDModeIndeterminate;
    
    User *user = [CommonUtils getUserLoginDetails];
    NSString *user_id = [user user_id];
    NSString *device_id = [user device_id];
    NSString *unique_code =[user unique_code];
    
    
    //192.168.1.27/ADB/api/bar_lists
    NSString *myURL = [NSString stringWithFormat:@"%@add_rating",WEBSERVICE_URL];
    NSMutableURLRequest *Request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: myURL]];
    
    // NSString *params = [NSString stringWithFormat:@"user_id=%@&device_id=%@&unique_code=%@&limit=%ld&offset=%ld&state=%@&city=%@&zipcode=%@&title=%@&order_by=%@",user_id,device_id,unique_code,(long)limit,(long)offset,state,city,zip,name,order_by];
    
    NSString *params = [NSString stringWithFormat:@"user_id=%@&device_id=%@&unique_code=%@&blog_id=%@&blog_rating=%@",user_id,device_id,unique_code,self.article.blog_id,ratings];
    
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
            }
        }
        else {
        }
    }];
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
