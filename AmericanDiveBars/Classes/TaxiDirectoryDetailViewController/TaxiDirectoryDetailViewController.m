//
//  TaxiDirectoryDetailViewController.m
//  AmericanDiveBars
//
//  Created by spaculus on 10/1/15.
//  Copyright © 2015 spaculus. All rights reserved.
//

#import "TaxiDirectoryDetailViewController.h"
#import "BarDetailCell.h"
#import "DirectoryDetailCell.h"

#define CLIEND_ID @"990806806578-17af1lspds8m4klq1q2q6mgklfqolmbj.apps.googleusercontent.com"
static NSString *const kClientId = CLIEND_ID;

static NSString * const kPlaceholderText = @"Insert Comment Here...";

@interface TaxiDirectoryDetailViewController () <MBProgressHUDDelegate,ShowMoreViewDelegate,FPPopoverControllerDelegate,TTTAttributedLabelDelegate,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
{
    MBProgressHUD *HUD;
    
    //POPOVER
    FPPopoverController *popover;
    
    //LOAD MORE
    NSInteger offset;
    NSInteger limit;
    
    BOOL isWSStatus;
    
    TaxiDetail *taxiDetail;
}

//Main Table
@property (strong, nonatomic) IBOutlet UITableView *tblView;
@property (strong, nonatomic) NSMutableArray *aryList;

@property (strong, nonatomic) IBOutlet UIView *viewShowMore;


//Pintrest
@property (strong, nonatomic) Pinterest *pinterest;
@end

@implementation TaxiDirectoryDetailViewController

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (!self) {
        return nil;
    }
    else {
        
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [CommonUtils setTitleLabel:@"TAXI DETAILS"];
    [self configureTopButtons];
    [self setInitialData];
}

-(void)setInitialData {
    
    [self configureShowMoreView];
    [self hideShowMoreView];
    
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
    self.navigationController.navigationBar.topItem.title = @" ";
    [self setStatusBarVisibility];
    
    limit = 3;
    offset = 0;

    [self callTaxiDetailWebservice];
    
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
    controller.taxiDetailDelegate = self;
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


/**************/


#pragma mark - Table View
-(void)registerCell
{
    [self.tblView registerNib:[UINib nibWithNibName:Nib_DirectoryBasicCell bundle:nil] forCellReuseIdentifier:DirectoryBasicCellIdentifier];
    [self.tblView registerNib:[UINib nibWithNibName:Nib_DescriptionCell bundle:nil] forCellReuseIdentifier:DescriptionCellIdentifier];
}

#pragma mark TableView Datasource and Delegates
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (isWSStatus) {
       return 12;
    }
    else {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return 1;
    
}

#pragma mark Cell For Row
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return [self DirectoryBasicCellAtIndexPath:indexPath];
            break;
        case 1:
            return [self DescriptionTitleCellAtIndexPath:indexPath];
            break;
        case 2:
            return [self DescriptionCellAtIndexPath:indexPath];
            break;
        case 3:
            return [self DescriptionTitleCellAtIndexPath:indexPath];
            break;
        case 4:
            return [self DescriptionCellAtIndexPath:indexPath];
            break;
        case 5:
            return [self DescriptionTitleCellAtIndexPath:indexPath];
            break;
        case 6:
            return [self DescriptionCellAtIndexPath:indexPath];
            break;
        case 7:
            return [self DescriptionTitleCellAtIndexPath:indexPath];
            break;
        case 8:
            return [self DescriptionCellAtIndexPath:indexPath];
            break;
        case 9:
            return [self DescriptionTitleCellAtIndexPath:indexPath];
            break;
        case 10:
            return [self DescriptionCellAtIndexPath:indexPath];
            break;
        case 11:
            return [self ShowMoreCellAtIndexPath:indexPath];
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


#pragma mark
#pragma mark TItleCell Cell Configuration
- (TItleCell *)TItleCellAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"TItleCell";
    
    TItleCell *cell = (TItleCell *)[self.tblView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib;
        if([CommonUtils isiPad])
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"TItleCell" owner:self options:nil];
        }
        else
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"TItleCell" owner:self options:nil];
        }
        cell = [nib objectAtIndex:0];
    }
    
    if (indexPath.section == 17) {
        cell.lblTitle.text = @"Reviews";
    }
    
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
}


#pragma mark
#pragma mark ShowMoreCell Cell Configuration
- (ShowMoreCell *)ShowMoreCellAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"ShowMoreCell";
    
    ShowMoreCell *cell = (ShowMoreCell *)[self.tblView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib;
        if([CommonUtils isiPad])
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"ShowMoreCell" owner:self options:nil];
        }
        else
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"ShowMoreCell" owner:self options:nil];
        }
        cell = [nib objectAtIndex:0];
    }
    if (taxiDetail.taxi_taxi_desc.length >0) {
        cell.lblMore.text = @"Show More";
        cell.lblUnderline.backgroundColor = [UIColor colorWithRed:187.0/255.0 green:124.0/255.0 blue:37.0/255.0 alpha:1.0];
        
    }
    else {
        cell.lblMore.text = @"";
        cell.lblUnderline.backgroundColor = [UIColor clearColor];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
}



#pragma mark
#pragma mark DescriptionTitleCell Cell Configuration
- (DescriptionTitleCell *)DescriptionTitleCellAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"DescriptionTitleCell";
    
    DescriptionTitleCell *cell = (DescriptionTitleCell *)[self.tblView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib;
        if([CommonUtils isiPad])
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"DescriptionTitleCell" owner:self options:nil];
        }
        else
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"DescriptionTitleCell" owner:self options:nil];
        }
        cell = [nib objectAtIndex:0];
    }
    
    if (indexPath.section == 1) {
        cell.lblTitle.text = @"Company Website Address :";
    }
    if (indexPath.section == 3) {
        cell.lblTitle.text = @"Company Mobile Number :";
    }
    if (indexPath.section == 5) {
        cell.lblTitle.text = @"Owner Name :";
    }
    if (indexPath.section == 7) {
        cell.lblTitle.text = @"Owner Mobile Number :";
    }
    if (indexPath.section == 9) {
        cell.lblTitle.text = @"About Company :";
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
}


#pragma mark
#pragma mark DescriptionCell Cell Configuration
- (DescriptionCell *)DescriptionCellAtIndexPath:(NSIndexPath *)indexPath
{
    static DescriptionCell *cell = nil;
    cell = [self.tblView dequeueReusableCellWithIdentifier:DescriptionCellIdentifier];
    [self configureDescriptionCell:cell atIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)configureDescriptionCell:(DescriptionCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 10) {
        cell.lblDesc.numberOfLines = 4;
        cell.lblDesc.textColor = [UIColor whiteColor];
    }
    else {
        cell.lblDesc.numberOfLines = 2;
        cell.lblDesc.textColor = [UIColor whiteColor];
    }
    
    if (indexPath.section == 2) {
        cell.lblDesc.text = [CommonUtils removeHTMLFromString:taxiDetail.taxi_cmpn_website];
        cell.lblDesc.textColor = [UIColor whiteColor];
        NSRange whiteRange = [cell.lblDesc.text rangeOfString:cell.lblDesc.text];
        [cell.lblDesc addLinkToURL:[NSURL URLWithString:cell.lblDesc.text] withRange:whiteRange];
        cell.lblDesc.delegate = self;

    }
    
    if (indexPath.section == 4) {
        cell.lblDesc.text = [CommonUtils removeHTMLFromString:taxiDetail.taxi_phone_number];
        cell.lblDesc.textColor = [UIColor colorWithRed:189.0/255.0 green:127.0/255.0 blue:52.0/255.0 alpha:1.0];
        NSRange phone_range = [cell.lblDesc.text rangeOfString:cell.lblDesc.text];
        [cell.lblDesc addLinkToPhoneNumber:nil withRange:phone_range];
        cell.lblDesc.delegate = self;
        cell.lblDesc.enabledTextCheckingTypes = NSTextCheckingTypePhoneNumber;
    }
    
    if (indexPath.section == 6) {
        cell.lblDesc.text = [CommonUtils removeHTMLFromString:taxiDetail.taxi_fullName];
        cell.lblDesc.textColor = [UIColor whiteColor];
    }
    
    if (indexPath.section == 8) {
        cell.lblDesc.text = [CommonUtils removeHTMLFromString:taxiDetail.taxi_mobile_no];
        cell.lblDesc.textColor = [UIColor colorWithRed:189.0/255.0 green:127.0/255.0 blue:52.0/255.0 alpha:1.0];
        NSRange phone_range = [cell.lblDesc.text rangeOfString:cell.lblDesc.text];
        [cell.lblDesc addLinkToPhoneNumber:nil withRange:phone_range];
        cell.lblDesc.delegate = self;
        cell.lblDesc.enabledTextCheckingTypes = NSTextCheckingTypePhoneNumber;
    }
    
    if (indexPath.section == 10) {
        cell.lblDesc.text = [self removeHTMLContentsFromString:taxiDetail.taxi_taxi_desc];
        cell.lblDesc.textColor = [UIColor whiteColor];
    }
}







-(NSString *)removeHTMLContentsFromString:(NSString *)htmlString {
    //NSString *html = @"S.Panchami 01.38<br>Arudra 02.01<br>V.08.54-10.39<br>D.05.02-06.52<br> <font color=red><u>Festival</u></font><br><font color=blue>Shankara Jayanthi<br></font>";
    NSAttributedString *attr = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUTF8StringEncoding]
                                                                options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                          NSCharacterEncodingDocumentAttribute:@(NSUTF8StringEncoding)}
                                                     documentAttributes:nil
                                                                  error:nil];
    NSLog(@"html: %@", htmlString);
    NSLog(@"attr: %@", attr);
    NSLog(@"string: %@", [attr string]);
    NSString *finalString = [attr string];
    
    return finalString;
}

#pragma mark
#pragma mark DirectoryBasicCell Cell Configuration
- (DirectoryBasicCell *)DirectoryBasicCellAtIndexPath:(NSIndexPath *)indexPath
{
    static DirectoryBasicCell *cell = nil;
    cell = [self.tblView dequeueReusableCellWithIdentifier:DirectoryBasicCellIdentifier];
    [self configureDirectoryBasicCell:cell atIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)configureDirectoryBasicCell:(DirectoryBasicCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    
    cell.lblBeerTitle.text = [CommonUtils removeHTMLFromString:taxiDetail.taxi_taxi_company];
    cell.lblBrewedByTitle.text = @"Company Address :";
    cell.lblBrewedBy.text = [CommonUtils removeHTMLFromString:taxiDetail.fullAddress];
    cell.lblBrewedBy.textColor = [UIColor colorWithRed:189.0/255.0 green:127.0/255.0 blue:52.0/255.0 alpha:1.0];
    
    cell.lblBrewedBy.textColor = [UIColor colorWithRed:189.0/255.0 green:127.0/255.0 blue:52.0/255.0 alpha:1.0];
    [self setAddressLabel:cell.lblBrewedBy withColor:[UIColor colorWithRed:189.0/255.0 green:127.0/255.0 blue:52.0/255.0 alpha:1.0]];
    
    cell.lblBrewedBy.delegate = self;
    cell.lblBrewedBy.enabledTextCheckingTypes = NSTextCheckingTypeAddress;
    
    NSString *taxi_image = [taxiDetail taxi_taxi_image];
    NSString *strImgURL = [NSString stringWithFormat:@"%@%@%@",WEBIMAGE_URL,TAXI_DETAIL_IMAGE,taxi_image];
    NSURL *imgURL = [NSURL URLWithString:strImgURL];
    
    [cell.imgBeerLogo sd_setImageWithURL:imgURL placeholderImage:[UIImage imageNamed:@"no_taxi_detail.png"]];
    
}





#pragma mark TTTAttributedLabel Delegate
-(void)setAddressLabel:(TTTAttributedLabel *)lbl withColor:(UIColor *)color{
    
    NSMutableDictionary *mutableActiveLinkAttributes = [NSMutableDictionary dictionary];
    [mutableActiveLinkAttributes setObject:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
    [mutableActiveLinkAttributes setObject:color forKey:(NSString *)kCTForegroundColorAttributeName];
    lbl.activeLinkAttributes = [NSDictionary dictionaryWithDictionary:mutableActiveLinkAttributes];
    
    
    NSRange address_range = [lbl.text rangeOfString:lbl.text];
    [lbl addLinkToAddress:mutableActiveLinkAttributes withRange:address_range];
}

- (void)attributedLabel:(TTTAttributedLabel *)label
didSelectLinkWithAddress:(NSDictionary *)addressComponents {
    if ([label.text length]==0) {
        ShowAlert(AlertTitle, @"No address found");
        return;
    }
    NSString *urladdress = [[NSString stringWithFormat:@"http://maps.apple.com/?address=%@",taxiDetail.fullAddress] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urladdress];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
//    GetDirectionsViewController *getDirection = [[GetDirectionsViewController alloc] initWithNibName:@"GetDirectionsViewController" bundle:nil];
//    getDirection.isFromGetDirection = NO;
//    getDirection.lat = @"";
//    getDirection.lng = @"";
//    getDirection.address_Unformated = taxiDetail.fullAddress_Unformated;
//    getDirection.address_Formated = taxiDetail.fullAddress;
//    [self.navigationController pushViewController:getDirection animated:YES];
//    NSLog(@"%@",label.text);
}
- (void)attributedLabel:(TTTAttributedLabel *)label
didSelectLinkWithPhoneNumber:(NSString *)phoneNumber {
    NSLog(@"Phone Number Selected : %@",phoneNumber);
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"] ) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",label.text]]];
    } else {
        UIAlertView *Notpermitted=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your device doesn't support this feature." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [Notpermitted show];
    }
}

- (void)attributedLabel:(__unused TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    [[[UIActionSheet alloc] initWithTitle:[url absoluteString] delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Open Link in Safari", nil), nil] showInView:self.view];
}




#pragma mark Height For Row

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
            //DirectoryBasicCell
        case 0:
        {
            CGFloat cellHeight = [self heightForDirectoryBasicCellAtIndexPath:indexPath];
            return cellHeight;
        }
            break;
            
            //DescriptionTitleCell
        case 1:
            return 30;
            break;
            
            //DescriptionCell
        case 2:
        {
            CGFloat cellHeight = [self heightForDescriptionCellAtIndexPath:indexPath];
            return cellHeight;
        }
            break;
            
            //DescriptionTitleCell
        case 3:
            return 30;
            break;
            
            //DescriptionCell
        case 4:
        {
            CGFloat cellHeight = [self heightForDescriptionCellAtIndexPath:indexPath];
            return cellHeight;
        }
            //DescriptionTitleCell
        case 5:
            return 30;
            break;
            
            //DescriptionCell
        case 6:
        {
            CGFloat cellHeight = [self heightForDescriptionCellAtIndexPath:indexPath];
            return cellHeight;
        }
            
            //DescriptionTitleCell
        case 7:
            return 30;
            break;
            
            //DescriptionCell
        case 8:
        {
            CGFloat cellHeight = [self heightForDescriptionCellAtIndexPath:indexPath];
            return cellHeight;
        }
            //DescriptionTitleCell
        case 9:
            return 30;
            break;
            
            //DescriptionCell
        case 10:
        {
            CGFloat cellHeight = [self heightForDescriptionCellAtIndexPath:indexPath];
            return cellHeight;
        }

            //ShowMore Cell
        case 11:
        {
            return 25;
        }
            
        default:
        {
            return 0;
        }
    }
    
}

#pragma mark
#pragma mark DescriptionCell Cell With Height Configuration
- (CGFloat)heightForDescriptionCellAtIndexPath:(NSIndexPath *)indexPath
{
    static DescriptionCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tblView dequeueReusableCellWithIdentifier:DescriptionCellIdentifier];
    });
    
    [self configureDescriptionCell:sizingCell atIndexPath:indexPath];
    return [self calculateHeightForConfiguredSizingCell:sizingCell];
}

#pragma mark
#pragma mark DirectoryBasicCell Cell With Height Configuration
- (CGFloat)heightForDirectoryBasicCellAtIndexPath:(NSIndexPath *)indexPath
{
    static DirectoryBasicCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tblView dequeueReusableCellWithIdentifier:DirectoryBasicCellIdentifier];
    });
    
    [self configureDirectoryBasicCell:sizingCell atIndexPath:indexPath];
    return [self calculateHeightForConfiguredSizingCell:sizingCell];
}

#pragma mark Calculate Height for Cell

- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell
{
    sizingCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tblView.frame), CGRectGetHeight(sizingCell.bounds));
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1.0f; // Add 1.0f for the cell separator height
}

#pragma mark Estmated Height For Row
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
            //DirectoryBasicCell
        case 0:
            return 174;
            break;
            
            //DescriptionTitleCell
        case 1:
            return 30;
            break;
            
            //DescriptionCell
        case 2:
            return 22;
            break;
            
            //DescriptionTitleCell
        case 3:
            return 30;
            break;
            
            //DescriptionCell
        case 4:
            return 22;
            break;
            
            //DescriptionTitleCell
        case 5:
            return 30;
            break;
            
            //DescriptionCell
        case 6:
            return 22;
            //DescriptionTitleCell
            
        case 7:
            return 30;
            break;
            
            //DescriptionCell
        case 8:
            return 22;
            
            //DescriptionTitleCell
        case 9:
            return 30;
            break;
            
            //DescriptionCell
        case 10:
            return 22;
            
            //ShowMore Cell
        case 11:
            return 25;
            break;
            
        default:
            return 0;
    }
    
}

#pragma mark Did Select Row
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 11) {
        [self displayShowMoreView];
    }
}

#pragma mark - Show More View
-(void)hideShowMoreView {
    self.viewShowMore.alpha = 1.0;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.viewShowMore.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.viewShowMore setHidden:YES];
    }];
}

-(void)displayShowMoreView {
    [self.viewShowMore setHidden:NO];
    self.viewShowMore.alpha = 0.0;
    [UIView animateWithDuration:0.3 animations:^{
        self.viewShowMore.alpha = 1.0;
        ShowMoreView *showMoreView = (ShowMoreView *)[[self.viewShowMore subviews] objectAtIndex:0];
        [showMoreView reloadShowMoreTable:@[[self removeHTMLContentsFromString:taxiDetail.taxi_taxi_desc]]];
        [self.viewShowMore setHidden:NO];
        
    } completion:^(BOOL finished) {
    }];
}

-(void)configureShowMoreView {
    
    [self.viewShowMore setHidden:NO];
    id view = [[[NSBundle mainBundle] loadNibNamed:@"ShowMoreView" owner:self options:nil] objectAtIndex:0];
    ShowMoreView *showMoreView = (ShowMoreView *)view;
    [showMoreView configureShowMoreView];
    showMoreView.delegate = self;
    [self.viewShowMore addSubview:showMoreView];
    [self.view layoutIfNeeded];
}

-(void)dismissShowMoreView {
    [self hideShowMoreView];
}

#pragma mark - Oriantation
- (BOOL)isLandscapeOrientation {
    return UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation);
}


#pragma mark - Webservice Call
-(void)callTaxiDetailWebservice {
    [CommonUtils callWebservice:@selector(taxi_details) forTarget:self];
}

#pragma mark - Webservice
#pragma mark taxi_details
-(void)taxi_details
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.mode = MBProgressHUDModeIndeterminate;
    
    User *user = [CommonUtils getUserLoginDetails];
    NSString *user_id = [user user_id];
    NSString *device_id = [user device_id];
    NSString *unique_code =[user unique_code];
    
    //192.168.1.27/ADB/api/beer_details
    NSString *myURL = [NSString stringWithFormat:@"%@taxi_details",WEBSERVICE_URL];
    NSMutableURLRequest *Request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: myURL]];
    //NSString *params = [NSString stringWithFormat:@"user_id=%@&limit=%ld&offset=%ld&bar_id=%@",user_id,(long)limit,(long)offset,self.bar.bar_id];
    NSString *params = [NSString stringWithFormat:@"user_id=%@&device_id=%@&unique_code=%@&limit=%ld&offset=%ld&taxi_id=%@",user_id,device_id,unique_code,(long)limit,(long)offset,self.taxi.taxi_id];
    
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
                taxiDetail = [TaxiDetail getTaxiDetailWithDictionary:[[[tempDict valueForKey:@"taxi_detail"] valueForKey:@"result"] objectAtIndex:0]];
                isWSStatus = YES;
                [self registerCell];
            }
        }
        else {
            isWSStatus = NO;
        }
        
        [self.tblView reloadData];
        
    }];
    
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

@end
