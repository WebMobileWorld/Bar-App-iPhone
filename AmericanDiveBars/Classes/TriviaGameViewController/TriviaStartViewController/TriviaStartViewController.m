//
//  TriviaStartViewController.m
//  AmericanDiveBars
//
//  Created by spaculus on 4/25/16.
//  Copyright © 2016 spaculus. All rights reserved.
//

#import "TriviaStartViewController.h"
#import "TriviaGameViewController.h"

@interface TriviaStartViewController () <MBProgressHUDDelegate, FPPopoverControllerDelegate>
{
    //HUD
    MBProgressHUD *HUD;

    
    //POPOVER
    FPPopoverController *popover;
    
    TriviaGame *game;
    
}
@property (strong, nonatomic) IBOutlet UIImageView *bg;
@property (strong, nonatomic) IBOutlet UIButton *btnStartGame;

@property (strong, nonatomic) NSMutableArray *aryList;


@end

@implementation TriviaStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [CommonUtils setTitleLabel:@"BAR TRIVIA GAME"];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)btnStartGameClicked:(id)sender {
    if (game) {
        if ([game.aryQuestions count]!=0) {
            TriviaGameViewController *trivia = [[TriviaGameViewController alloc] initWithNibName:@"TriviaGameViewController" bundle:nil];
            trivia.game = game;
            [self.navigationController pushViewController:trivia animated:YES];
        }
    }
    
}




-(void)viewDidLayoutSubviews {
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        
        if (![CommonUtils isiPad]) {
            
            if ([CommonUtils isIPhone4_Landscape]) {
                self.bg.image = [UIImage imageNamed:@"login-signup-bg-iphone-L.png"];
            }
            else if ([CommonUtils isIPhone5_Landscape]) {
                self.bg.image = [UIImage imageNamed:@"login-signup-bg-iphone-L.png"];
            }
            else if ([CommonUtils isIPhone6_Landscape]) {
                self.bg.image = [UIImage imageNamed:@"login-signup-bg-iphone-L.png"];
                
            }
            else {
                self.bg.image = [UIImage imageNamed:@"login-signup-bg-iphone-L.png"];
            }
        }
        else {
            self.bg.image = [UIImage imageNamed:@"login-signup-bg-ipad-L.png"];
        }
        
    }
    else {
        if (![CommonUtils isiPad]) {
            
            
            if ([CommonUtils isIPhone4]) {
                self.bg.image = [UIImage imageNamed:@"login-signup-bg-iphone.png"];
            }
            else if ([CommonUtils isIPhone5]) {
                self.bg.image = [UIImage imageNamed:@"login-signup-bg-iphone.png"];
            }
            else if ([CommonUtils isIPhone6]) {
                self.bg.image = [UIImage imageNamed:@"login-signup-bg-iphone.png"];
            }
            else {
                self.bg.image = [UIImage imageNamed:@"login-signup-bg-iphone.png"];
            }
            
            
        }
        else {
            self.bg.image = [UIImage imageNamed:@"login-signup-bg-ipad.png"];
        }
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    CGSize blankImageSize = CGSizeMake(self.view.bounds.size.width, 64);
    UIImage *blank = [CommonUtils imageFromColor:[UIColor colorWithRed:187.0/255.0 green:124.0/255.0 blue:37.0/255.0 alpha:1.0] forSize:blankImageSize withCornerRadius:0.0];
    [CommonUtils setNavigationBarImage:blank forNavigationBar:self.navigationController.navigationBar];
    
    [self callTriviaWebservice];
    [self configureTopButtons];
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
    controller.startGameDelegate = self;
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
            break;
        }
            
        case 9:
        {
            TriviaStartViewController *trivia = [[TriviaStartViewController alloc]  initWithNibName:@"TriviaStartViewController" bundle:nil];
            [self.navigationController pushViewController:trivia animated:YES];
            break;
        }
            /*{
             ArticleViewController *article = [[ArticleViewController alloc]  initWithNibName:@"ArticleViewController" bundle:nil];
             [self.navigationController pushViewController:article animated:YES];
             }*/
            break;
        default:
            break;
    }
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
                     
                     
                     if ([CommonUtils isIPhone4]) {
                         self.bg.image = [UIImage imageNamed:@"login-signup-bg-iphone.png"];
                         
                     }
                     else if ([CommonUtils isIPhone5]) {
                         self.bg.image = [UIImage imageNamed:@"login-signup-bg-iphone.png"];
                         
                     }
                     else if ([CommonUtils isIPhone6]) {
                         self.bg.image = [UIImage imageNamed:@"login-signup-bg-iphone.png"];
                         
                     }
                     else {
                         self.bg.image = [UIImage imageNamed:@"login-signup-bg-iphone.png"];
                         
                     }
                     
                     
                 }
                 else {
                     self.bg.image = [UIImage imageNamed:@"login-signup-bg-ipad.png"];
                     
                 }
                 
                 
                 break;
                 
             case UIInterfaceOrientationLandscapeLeft:
             case UIInterfaceOrientationLandscapeRight:
                 if (![CommonUtils isiPad]) {
                     
                     if ([CommonUtils isIPhone4_Landscape]) {
                         self.bg.image = [UIImage imageNamed:@"login-signup-bg-iphone-L.png"];
                     }
                     else if ([CommonUtils isIPhone5_Landscape]) {
                         self.bg.image = [UIImage imageNamed:@"login-signup-bg-iphone-L.png"];
                     }
                     else if ([CommonUtils isIPhone6_Landscape]) {
                         self.bg.image = [UIImage imageNamed:@"login-signup-bg-iphone-L.png"];
                     }
                     else {
                         self.bg.image = [UIImage imageNamed:@"login-signup-bg-iphone-L.png"];
                         self.navigationController.navigationBar.frame = CGRectMake(0,32, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height+20);
                     }
                 }
                 else {
                     self.bg.image = [UIImage imageNamed:@"login-signup-bg-ipad-L.png"];
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


- (void)didReceiveMemoryWarning {
 [super didReceiveMemoryWarning];
 // Dispose of any resources that can be recreated.
}


#pragma mark - Webservice Call
-(void)callTriviaWebservice {
    [CommonUtils callWebservice:@selector(trivia) forTarget:self];
}

#pragma mark - Webservice
#pragma mark trivia
-(void)trivia
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
    NSString *myURL = [NSString stringWithFormat:@"%@trivia",WEBSERVICE_URL];
    NSMutableURLRequest *Request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: myURL]];
    
    // NSString *params = [NSString stringWithFormat:@"user_id=%@&device_id=%@&unique_code=%@&limit=%ld&offset=%ld&state=%@&city=%@&zipcode=%@&title=%@&order_by=%@",user_id,device_id,unique_code,(long)limit,(long)offset,state,city,zip,name,order_by];
    
    NSString *params = [NSString stringWithFormat:@"user_id=%@&device_id=%@&unique_code=%@",user_id,device_id,unique_code];
    
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
                
                
                if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
                    
                    if (![CommonUtils isiPad]) {
                        
                        if ([CommonUtils isIPhone4_Landscape]) {
                            self.bg.image = [UIImage imageNamed:@"login-signup-bg-iphone-L.png"];
                        }
                        else if ([CommonUtils isIPhone5_Landscape]) {
                            self.bg.image = [UIImage imageNamed:@"login-signup-bg-iphone-L.png"];
                        }
                        else if ([CommonUtils isIPhone6_Landscape]) {
                            self.bg.image = [UIImage imageNamed:@"login-signup-bg-iphone-L.png"];
                            
                        }
                        else {
                            self.bg.image = [UIImage imageNamed:@"login-signup-bg-iphone-L.png"];
                        }
                    }
                    else {
                        self.bg.image = [UIImage imageNamed:@"login-signup-bg-ipad-L.png"];
                    }
                    
                }
                else {
                    if (![CommonUtils isiPad]) {
                        
                        
                        if ([CommonUtils isIPhone4]) {
                            self.bg.image = [UIImage imageNamed:@"login-signup-bg-iphone.png"];
                        }
                        else if ([CommonUtils isIPhone5]) {
                            self.bg.image = [UIImage imageNamed:@"login-signup-bg-iphone.png"];
                        }
                        else if ([CommonUtils isIPhone6]) {
                            self.bg.image = [UIImage imageNamed:@"login-signup-bg-iphone.png"];
                        }
                        else {
                            self.bg.image = [UIImage imageNamed:@"login-signup-bg-iphone.png"];
                        }
                        
                        
                    }
                    else {
                        self.bg.image = [UIImage imageNamed:@"login-signup-bg-ipad.png"];
                    }
                }
                
                game  = [TriviaGame getTriviaGameWithDictionary:tempDict];
                NSLog(@"%@",[NSString stringWithFormat:@"%@bar_pages_banner/%@",WEBIMAGE_URL,game.gameImageName]);
                [self.bg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@bar_pages_banner/%@",WEBIMAGE_URL,game.gameImageName]] placeholderImage:self.bg.image];
                //self.aryList = [self getQuetsionsFromResult:aryQuestionList];
                
            }
        }
        else {
        }
    }];
}


@end
