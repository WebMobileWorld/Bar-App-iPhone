//
//  PrivacySettingViewController.m
//  AmericanDiveBars
//
//  Created by spaculus on 10/12/15.
//  Copyright © 2015 spaculus. All rights reserved.
//

#import "PrivacySettingViewController.h"
#import "PrivacySettingCell.h"

@interface PrivacySettingViewController () <MBProgressHUDDelegate,PrivacySettingsFooterViewDelegate,FPPopoverControllerDelegate>
{
    //HUD
    MBProgressHUD *HUD;
    
    //POPOVER
    FPPopoverController *popover;
    
    NSString *keyWord;
    
    //Check webservice called
    BOOL isWS;
    BOOL isRadioButtonTapped;
    
    // Table View Footer
    PrivacySettingsFooterView *settingFooterView;
    
    //PrivacySettings
    PrivacySettings *setting;
}

//CUSTOM POPUP TABLE VIEW
@property (strong, nonatomic) LGFilterView  *filterView;
@property (strong, nonatomic) NSArray   *titlesArray;

//Main Table
@property (strong, nonatomic) IBOutlet UITableView *tblView;
@property (strong, nonatomic) NSMutableArray *aryList;

@end



@implementation PrivacySettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [CommonUtils setTitleLabel:@"Privacy Settings"];
    [self configureTopButtons];
    [self initializeDataStructure];
    [self configureTableViewFooter];
}

-(void)initializeDataStructure {
    self.aryList = [[NSMutableArray alloc]  init];
    keyWord = @"";
    isWS = NO;
    isRadioButtonTapped = NO;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setNavImage];
    self.navigationController.navigationBar.topItem.title = @" ";
    
    [self callPrivacySeetingsWebservice];
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
//    FindBarViewController *findBar = [[FindBarViewController alloc] initWithNibName:@"FindBarViewController" bundle:nil];
//    [self.navigationController pushViewController:findBar animated:YES];
}


-(void)openRightMenu_Clicked:(UIButton *)btnRightMenu {
    [self.view endEditing:YES];

    [self btnFilterClicked:btnRightMenu];
}

-(void)btnFilterClicked:(id)sender
{
    LeftMenu_Popup *controller = [[LeftMenu_Popup alloc] initWithStyle:UITableViewStylePlain];
    controller.privacyDelegate = self;
    
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

-(void)configureTableViewFooter  {
    id footerView = [[[NSBundle mainBundle] loadNibNamed:@"PrivacySettingsFooterView" owner:self options:nil] objectAtIndex:0];
    settingFooterView = (PrivacySettingsFooterView *)footerView;
    
    settingFooterView.delegate = self;
}

#pragma mark PrivacySettingsFooterView Delegate
-(void)btnSaveTapped {
    [self callUpdatePrivacySeetingsWebservice];
}

-(void)btnCancelTapped {
    [self resetPrivaceSetting];
}

-(void)resetPrivaceSetting {
    setting.setting_id = setting.pre_setting_id;
    setting.setting_user_id = setting.pre_setting_user_id;
    setting.setting_fname = setting.pre_setting_fname;
    setting.setting_lname = setting.pre_setting_lname;
    setting.setting_gender1 = setting.pre_setting_gender1;
    setting.setting_address1 = setting.pre_setting_address1;
    setting.setting_abt = setting.pre_setting_abt;
    setting.setting_album = setting.pre_setting_album;
    
    isRadioButtonTapped = NO;
    [self.tblView reloadData];
}
-(void)setPrivacySettings {
    setting.pre_setting_id = setting.setting_id;
    setting.pre_setting_user_id = setting.setting_user_id;
    setting.pre_setting_fname = setting.setting_fname;
    setting.pre_setting_lname = setting.setting_lname;
    setting.pre_setting_gender1 = setting.setting_gender1;
    setting.pre_setting_address1 = setting.setting_address1;
    setting.pre_setting_abt = setting.setting_abt;
    setting.pre_setting_album = setting.setting_album;
}

#pragma mark View For Header
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (isRadioButtonTapped) {
        return settingFooterView;
    }
    else {
        return nil;
    }
}


#pragma mark Height For Header
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (isRadioButtonTapped) {
        return 56;
    }
    else {
        return 0;
    }
}


#pragma mark Number of Section
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark Number of Row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return 6;
}

#pragma mark Cell for Row
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.section) {
        case 0:
        {
            static NSString *simpleTableIdentifier = @"PrivacySettingCell";
            
            PrivacySettingCell *cell = (PrivacySettingCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            if (cell == nil)
            {
                NSArray *nib;
                if([CommonUtils isiPad])
                {
                    nib = [[NSBundle mainBundle] loadNibNamed:@"PrivacySettingCell" owner:self options:nil];
                }
                else
                {
                    nib = [[NSBundle mainBundle] loadNibNamed:@"PrivacySettingCell" owner:self options:nil];
                }
                cell = [nib objectAtIndex:0];
            }
            
            
            ADBRadioButton *btnShow = (ADBRadioButton *) [cell.contentView viewWithTag:100];
            ADBRadioButton *btnHide = (ADBRadioButton *) [cell.contentView viewWithTag:101];
            
            btnShow.row = indexPath.row;
            btnHide.row = indexPath.row;
            
            [btnShow addTarget:self action:@selector(btnShow_CliCked:) forControlEvents:UIControlEventTouchUpInside];
            [btnHide addTarget:self action:@selector(btnHide_CliCked:) forControlEvents:UIControlEventTouchUpInside];
            
            if (isWS) {
                switch (indexPath.row) {
                    case 0:
                        cell.lblTitle.text = @"First Name";
                        if ([setting.setting_fname isEqualToString:@"1"]) {
                            [btnShow setImage:[UIImage imageNamed:@"radio-on.png"] forState:UIControlStateNormal];
                            [btnHide setImage:[UIImage imageNamed:@"radio-off.png"] forState:UIControlStateNormal];
                        }
                        else {
                            [btnShow setImage:[UIImage imageNamed:@"radio-off.png"] forState:UIControlStateNormal];
                            [btnHide setImage:[UIImage imageNamed:@"radio-on.png"] forState:UIControlStateNormal];
                        }
                        break;
                        
                    case 1:
                        cell.lblTitle.text = @"Last Name";
                        if ([setting.setting_lname isEqualToString:@"1"]) {
                            [btnShow setImage:[UIImage imageNamed:@"radio-on.png"] forState:UIControlStateNormal];
                            [btnHide setImage:[UIImage imageNamed:@"radio-off.png"] forState:UIControlStateNormal];
                        }
                        else {
                            [btnShow setImage:[UIImage imageNamed:@"radio-off.png"] forState:UIControlStateNormal];
                            [btnHide setImage:[UIImage imageNamed:@"radio-on.png"] forState:UIControlStateNormal];
                        }
                        break;
                        
                    case 2:
                        cell.lblTitle.text = @"Gender";
                        if ([setting.setting_gender1 isEqualToString:@"1"]) {
                            [btnShow setImage:[UIImage imageNamed:@"radio-on.png"] forState:UIControlStateNormal];
                            [btnHide setImage:[UIImage imageNamed:@"radio-off.png"] forState:UIControlStateNormal];
                        }
                        else {
                            [btnShow setImage:[UIImage imageNamed:@"radio-off.png"] forState:UIControlStateNormal];
                            [btnHide setImage:[UIImage imageNamed:@"radio-on.png"] forState:UIControlStateNormal];
                        }
                        break;
                        
                    case 3:
                        cell.lblTitle.text = @"Address";
                        if ([setting.setting_address1 isEqualToString:@"1"]) {
                            [btnShow setImage:[UIImage imageNamed:@"radio-on.png"] forState:UIControlStateNormal];
                            [btnHide setImage:[UIImage imageNamed:@"radio-off.png"] forState:UIControlStateNormal];
                        }
                        else {
                            [btnShow setImage:[UIImage imageNamed:@"radio-off.png"] forState:UIControlStateNormal];
                            [btnHide setImage:[UIImage imageNamed:@"radio-on.png"] forState:UIControlStateNormal];
                        }
                        break;
                        
                    case 4:
                        cell.lblTitle.text = @"About";
                        if ([setting.setting_abt isEqualToString:@"1"]) {
                            [btnShow setImage:[UIImage imageNamed:@"radio-on.png"] forState:UIControlStateNormal];
                            [btnHide setImage:[UIImage imageNamed:@"radio-off.png"] forState:UIControlStateNormal];
                        }
                        else {
                            [btnShow setImage:[UIImage imageNamed:@"radio-off.png"] forState:UIControlStateNormal];
                            [btnHide setImage:[UIImage imageNamed:@"radio-on.png"] forState:UIControlStateNormal];
                        }
                        break;
                        
                    case 5:
                        cell.lblTitle.text = @"Album";
                        if ([setting.setting_album isEqualToString:@"1"]) {
                            [btnShow setImage:[UIImage imageNamed:@"radio-on.png"] forState:UIControlStateNormal];
                            [btnHide setImage:[UIImage imageNamed:@"radio-off.png"] forState:UIControlStateNormal];
                        }
                        else {
                            [btnShow setImage:[UIImage imageNamed:@"radio-off.png"] forState:UIControlStateNormal];
                            [btnHide setImage:[UIImage imageNamed:@"radio-on.png"] forState:UIControlStateNormal];
                        }
                        break;
                        
                    default:
                        break;
                }
            }
            else {
                switch (indexPath.row) {
                    case 0:
                        cell.lblTitle.text = @"First Name";
                        break;
                    case 1:
                        cell.lblTitle.text = @"Last Name";
                        break;
                    case 2:
                        cell.lblTitle.text = @"Gender";
                        break;
                    case 3:
                        cell.lblTitle.text = @"Address";
                        break;
                    case 4:
                        cell.lblTitle.text = @"About";
                        break;
                    case 5:
                        cell.lblTitle.text = @"Album";
                        break;
                        
                    default:
                        break;
                }
                [btnHide setImage:[UIImage imageNamed:@"radio-off.png"] forState:UIControlStateNormal];
                [btnShow setImage:[UIImage imageNamed:@"radio-off.png"] forState:UIControlStateNormal];
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


-(void)btnShow_CliCked:(ADBRadioButton *)btnShow {
    
    PrivacySettingCell *cell = (PrivacySettingCell *)[self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:btnShow.tag inSection:0]];
    ADBRadioButton *btnHide = (ADBRadioButton *) [cell.contentView viewWithTag:101];
    isRadioButtonTapped = YES;
    
    switch (btnShow.row) {
        case 0:
            setting.setting_fname = @"1";
            [btnShow setImage:[UIImage imageNamed:@"radio-on.png"] forState:UIControlStateNormal];
            [btnHide setImage:[UIImage imageNamed:@"radio-off.png"] forState:UIControlStateNormal];
            break;

        case 1:
            setting.setting_lname = @"1";
            [btnShow setImage:[UIImage imageNamed:@"radio-on.png"] forState:UIControlStateNormal];
            [btnHide setImage:[UIImage imageNamed:@"radio-off.png"] forState:UIControlStateNormal];
            break;

        case 2:
            setting.setting_gender1 = @"1";
            [btnShow setImage:[UIImage imageNamed:@"radio-on.png"] forState:UIControlStateNormal];
            [btnHide setImage:[UIImage imageNamed:@"radio-off.png"] forState:UIControlStateNormal];
            break;

        case 3:
            setting.setting_address1 = @"1";
            [btnShow setImage:[UIImage imageNamed:@"radio-on.png"] forState:UIControlStateNormal];
            [btnHide setImage:[UIImage imageNamed:@"radio-off.png"] forState:UIControlStateNormal];
            break;

        case 4:
            setting.setting_abt = @"1";
            [btnShow setImage:[UIImage imageNamed:@"radio-on.png"] forState:UIControlStateNormal];
            [btnHide setImage:[UIImage imageNamed:@"radio-off.png"] forState:UIControlStateNormal];
            break;
            
        case 5:
            setting.setting_album = @"1";
            [btnShow setImage:[UIImage imageNamed:@"radio-on.png"] forState:UIControlStateNormal];
            [btnHide setImage:[UIImage imageNamed:@"radio-off.png"] forState:UIControlStateNormal];
            break;

        default:
            break;
    }
    
    [self.tblView reloadData];
}

-(void)btnHide_CliCked:(ADBRadioButton *)btnHide {
    
    PrivacySettingCell *cell = (PrivacySettingCell *)[self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:btnHide.tag inSection:0]];
    ADBRadioButton *btnShow = (ADBRadioButton *) [cell.contentView viewWithTag:100];
    isRadioButtonTapped = YES;
    
    switch (btnHide.row) {
        case 0:
            setting.setting_fname = @"0";
            [btnShow setImage:[UIImage imageNamed:@"radio-off.png"] forState:UIControlStateNormal];
            [btnHide setImage:[UIImage imageNamed:@"radio-on.png"] forState:UIControlStateNormal];
            break;
            
        case 1:
            setting.setting_lname = @"0";
            [btnShow setImage:[UIImage imageNamed:@"radio-off.png"] forState:UIControlStateNormal];
            [btnHide setImage:[UIImage imageNamed:@"radio-on.png"] forState:UIControlStateNormal];
            break;
            
        case 2:
            setting.setting_gender1 = @"0";
            [btnShow setImage:[UIImage imageNamed:@"radio-off.png"] forState:UIControlStateNormal];
            [btnHide setImage:[UIImage imageNamed:@"radio-on.png"] forState:UIControlStateNormal];
            break;
            
        case 3:
            setting.setting_address1 = @"0";
            [btnShow setImage:[UIImage imageNamed:@"radio-off.png"] forState:UIControlStateNormal];
            [btnHide setImage:[UIImage imageNamed:@"radio-on.png"] forState:UIControlStateNormal];
            break;
            
        case 4:
            setting.setting_abt = @"0";
            [btnShow setImage:[UIImage imageNamed:@"radio-off.png"] forState:UIControlStateNormal];
            [btnHide setImage:[UIImage imageNamed:@"radio-on.png"] forState:UIControlStateNormal];
            break;
            
        case 5:
            setting.setting_album = @"0";
            [btnShow setImage:[UIImage imageNamed:@"radio-off.png"] forState:UIControlStateNormal];
            [btnHide setImage:[UIImage imageNamed:@"radio-on.png"] forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
            
    [self.tblView reloadData];
}

#pragma mark Cell Height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.section) {
        case 0:
            return 46;
            break;
            
        default:
            return 44;
            break;
    }
}

#pragma mark did Select Row
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
-(void)callPrivacySeetingsWebservice {
    [CommonUtils callWebservice:@selector(privacy_settings) forTarget:self];
}


-(void)callUpdatePrivacySeetingsWebservice {
    [CommonUtils callWebservice:@selector(update_privacy_settings) forTarget:self];
}

#pragma mark - Webservice
#pragma mark privacy_settings
-(void)privacy_settings
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.mode = MBProgressHUDModeIndeterminate;
    
    User *user = [CommonUtils getUserLoginDetails];
    NSString *user_id = [user user_id];
    NSString *device_id = [user device_id];
    NSString *unique_code =[user unique_code];
    
    // 192.168.1.27/ADB/api/privacy_settings
    NSString *myURL = [NSString stringWithFormat:@"%@privacy_settings",WEBSERVICE_URL];
    NSMutableURLRequest *Request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: myURL]];
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
            id tempDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
            NSLog(@"Dict : %@",tempDict);
            isWS = YES;
            if ([tempDict isKindOfClass:[NSArray class]]) {
                
                NSDictionary *dictSettings = @{@"getsetting":@{@"abt":@"0",
                                                                    @"address1":@"0",
                                                                    @"album":@"0",
                                                                    @"email1":@"0",
                                                                    @"fname":@"0",
                                                                    @"gender1" : @"0",
                                                                    @"lname" : @"0",
                                                                    @"mnum" : @"0",
                                                                    @"pic" : @"0",
                                                                    @"setting_id" : @"0",
                                                               @"user_id" : user_id}};
                setting = [PrivacySettings getPrivacySettingsWithDictionary:[dictSettings valueForKey:@"getsetting"]];
                [self.tblView reloadData];
            }
            else {
                NSDictionary *dictSettings = (NSDictionary *)tempDict;
                if([[dictSettings allKeys] count]!=0) {
                    if ([[dictSettings valueForKey:@"status"] isEqualToString:@"success"]) {
                        isWS = YES;
                        setting = [PrivacySettings getPrivacySettingsWithDictionary:[dictSettings valueForKey:@"getsetting"]];
                        [self.tblView reloadData];
                    }
                    else {
                        
                        NSDictionary *dictSettings = @{@"getsetting":@{@"abt":@"0",
                                                                       @"address1":@"0",
                                                                       @"album":@"0",
                                                                       @"email1":@"0",
                                                                       @"fname":@"0",
                                                                       @"gender1" : @"0",
                                                                       @"lname" : @"0",
                                                                       @"mnum" : @"0",
                                                                       @"pic" : @"0",
                                                                       @"setting_id" : @"0",
                                                                       @"user_id" : user_id}};
                        setting = [PrivacySettings getPrivacySettingsWithDictionary:[dictSettings valueForKey:@"getsetting"]];
                        [self.tblView reloadData];
                    }
                }
                else {
                    
                    NSDictionary *dictSettings = @{@"getsetting":@{@"abt":@"0",
                                                                   @"address1":@"0",
                                                                   @"album":@"0",
                                                                   @"email1":@"0",
                                                                   @"fname":@"0",
                                                                   @"gender1" : @"0",
                                                                   @"lname" : @"0",
                                                                   @"mnum" : @"0",
                                                                   @"pic" : @"0",
                                                                   @"setting_id" : @"0",
                                                                   @"user_id" : user_id}};
                    setting = [PrivacySettings getPrivacySettingsWithDictionary:[dictSettings valueForKey:@"getsetting"]];
                    [self.tblView reloadData];
                }
            }
            
            
            
           /* NSDictionary *dictSettings = @{@"status":@"fail"};@{@"abt":@"1",
                                                            @"address1":@"0",
                                                            @"album":@"1",
                                                            @"email1":@"0",
                                                            @"fname":@"1",
                                                            @"gender1" : @"1",
                                                            @"lname" : @"1",
                                                            @"mnum" : @"0",
                                                            @"pic" : @"0",
                                                            @"setting_id" : @"38",
                                                            @"user_id" : @"309"}*/
            
            
        }
        else {
            
            NSDictionary *dictSettings = @{@"getsetting":@{@"abt":@"0",
                                                           @"address1":@"0",
                                                           @"album":@"0",
                                                           @"email1":@"0",
                                                           @"fname":@"0",
                                                           @"gender1" : @"0",
                                                           @"lname" : @"0",
                                                           @"mnum" : @"0",
                                                           @"pic" : @"0",
                                                           @"setting_id" : @"0",
                                                           @"user_id" : user_id}};
            setting = [PrivacySettings getPrivacySettingsWithDictionary:[dictSettings valueForKey:@"getsetting"]];
            [self.tblView reloadData];
        }
        
    }];
    
}


#pragma mark update_privacy_settings
-(void)update_privacy_settings
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.mode = MBProgressHUDModeIndeterminate;
    
    User *user = [CommonUtils getUserLoginDetails];
    NSString *user_id = [user user_id];
    NSString *device_id = [user device_id];
    NSString *unique_code =[user unique_code];
    
    // 192.168.1.27/ADB/api/privacy_settings
    NSString *myURL = [NSString stringWithFormat:@"%@update_privacy_settings",WEBSERVICE_URL];
    NSMutableURLRequest *Request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: myURL]];
    NSString *params = [NSString stringWithFormat:@"user_id=%@&device_id=%@&unique_code=%@&setting_id=%@&fname=%@&lname=%@&gender1=%@&address1=%@&abt=%@&album=%@",user_id,device_id,unique_code,setting.setting_id,setting.setting_fname,setting.setting_lname,setting.setting_gender1,setting.setting_address1,setting.setting_abt,setting.setting_album];
    
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
                [self setPrivacySettings];
                isRadioButtonTapped = NO;
                ShowAlert(AlertTitle, @"Privacy settings updated successfully !");
            }
            [self.tblView reloadData];
        }
        else {
            
        }
        
    }];
}

/*
 {
 "getsetting": {
 "setting_id": "16",
 "user_id": "221",
 "fname": "1",
 "lname": "1",
 "email1": "",
 "gender1": "1",
 "address1": "1",
 "mnum": "",
 "abt": "1",
 "pic": "",
 "album": "1"
 },
 "status": "success"
 }
 */





@end
