//
//  LiquorDirectoryDetailViewController.m
//  AmericanDiveBars
//
//  Created by spaculus on 9/30/15.
//  Copyright © 2015 spaculus. All rights reserved.
//

#import "LiquorDirectoryDetailViewController.h"
#import "DirectoryCommentViewController.h"

#import "DirectoryReplyViewController.h"


#import "VideoViewController.h"
#import "BarDetailCell.h"
#import "DirectoryDetailCell.h"
#import <Social/Social.h>

#define CLIEND_ID @"990806806578-17af1lspds8m4klq1q2q6mgklfqolmbj.apps.googleusercontent.com"
static NSString *const kClientId = CLIEND_ID;

static NSString * const kPlaceholderText = @"Insert Comment Here...";

static NSString * const kLeaveCommentPlaceholderText = @"Insert Comment Here...";


@interface LiquorDirectoryDetailViewController () <MBProgressHUDDelegate,ShowMoreViewDelegate,GPPSignInDelegate,TakeALookCellDelegate,FPPopoverControllerDelegate,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
{
    MBProgressHUD *HUD;
    
    //POPOVER
    FPPopoverController *popover;
    
    //LOAD MORE
    NSInteger offset;
    NSInteger limit;
    
    BOOL isWSStatus;
    
    FullLiquorDetail *fullLiquorDetail;
    
    //Take a Look Cell Image
    UIImage *imgTakeLook;
    
    //BAR GALLERY
    NSInteger selectedIndex;
    
    // Get In Touch
    BOOL showingPlaceholder;
    NSString *nameForGetInTouch;
    NSString *phoneForGetInTouch;
    NSString *emailForGetInTouch;
    NSString *commentForGetInTouch;
    
    // Leave A Comment
    BOOL showingLeaveCommentPlaceholder;
    NSString *commentTitle;
    NSString *comment;
    NSInteger selectedCommentIndex;
    //Google Plus SDK
    GPPSignIn *signIn;
    
    //Favourite Bar
    NSString *isFavBar;
    NSString *isLikeThisBar;
}

//Main Table
@property (strong, nonatomic) IBOutlet UITableView *tblView;
@property (strong, nonatomic) NSMutableArray *aryList;

@property (strong, nonatomic) IBOutlet UIView *viewShowMore;


//Pintrest
@property (strong, nonatomic) Pinterest *pinterest;
@end

@implementation LiquorDirectoryDetailViewController

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
    self.navigationItem.titleView = [CommonUtils setTitleLabel:@"LIQUOR DETAILS"];
    [self configureTopButtons];
    [self setInitialData];
}

-(void)setInitialData {
    commentForGetInTouch = @"";
    nameForGetInTouch = @"";
    phoneForGetInTouch = @"";
    emailForGetInTouch = @"";
    isFavBar = @"0";
    isLikeThisBar = @"0";
    
    imgTakeLook = nil;
    selectedIndex = 0;
    selectedCommentIndex = -1;
    
    commentTitle = @"";
    comment = @"";
    
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
    
    
    
    
    [self callLiquorDetailWebservice];
    
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
//    FindBarViewController *findBar = [[FindBarViewController alloc] initWithNibName:@"FindBarViewController" bundle:nil];
//    [self.navigationController pushViewController:findBar animated:YES];
}


-(void)openRightMenu_Clicked:(UIButton *)btnRightMenu {
    [self btnFilterClicked:btnRightMenu];
}

-(void)btnFilterClicked:(id)sender
{
    LeftMenu_Popup *controller = [[LeftMenu_Popup alloc] initWithStyle:UITableViewStylePlain];
    controller.liquorDetailDelegate = self;
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
#pragma mark Textfield Delegates
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    commentTitle = textField.text;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - TEXT VIEW

-(void)configureWriteReviewTextView:(DirectoryLeaveCommentCell *)cell
{
    
    showingLeaveCommentPlaceholder = YES;
    if ([comment length]==0)
    {
        [cell.txtComment setText:kLeaveCommentPlaceholderText];
        [cell.txtComment setTextColor:[UIColor colorWithRed:146.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0]];
    }
    else
    {
        [cell.txtComment setText:comment];
        [cell.txtComment setTextColor:[UIColor whiteColor]];
        showingLeaveCommentPlaceholder = NO;
    }
}
#pragma mark UITextView Delegate Methods
-(void)textViewDidBeginEditing:(UITextView *)textView {
    
    // Check if it's showing a placeholder, remove it if so
    
    if(showingLeaveCommentPlaceholder) {
        [textView setText:@""];
        [textView setTextColor:[UIColor colorWithRed:146.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0]];
        
        showingLeaveCommentPlaceholder = NO;
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView {
    
    
    
    
    if([[textView text] length] == 0 && !showingLeaveCommentPlaceholder) {
        [textView setText:kLeaveCommentPlaceholderText];
        [textView setTextColor:[UIColor colorWithRed:146.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0]];
        
        showingLeaveCommentPlaceholder = YES;
    }
    else
    {
        NSLog(@"%@",textView.text);
        comment = textView.text;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES ;
}



#pragma mark - Table View
-(void)registerCell
{
    [self.tblView registerNib:[UINib nibWithNibName:Nib_DirectoryBasicCell bundle:nil] forCellReuseIdentifier:DirectoryBasicCellIdentifier];
    [self.tblView registerNib:[UINib nibWithNibName:Nib_DescriptionCell bundle:nil] forCellReuseIdentifier:DescriptionCellIdentifier];
    [self.tblView registerNib:[UINib nibWithNibName:Nib_DirectoryCommentCell bundle:nil] forCellReuseIdentifier:DirectoryCommentCellIdentifier];
    
    //
    //    [self.tblView registerNib:[UINib nibWithNibName:Nib_BarEventsCell bundle:nil] forCellReuseIdentifier:BarEventsCellIdentifier];
    //    [self.tblView registerNib:[UINib nibWithNibName:Nib_BeersServedCell bundle:nil] forCellReuseIdentifier:BeersServedCellIdentifier];
    //    [self.tblView registerNib:[UINib nibWithNibName:Nib_Cocktail_LiquorsCell bundle:nil] forCellReuseIdentifier:Cocktail_LiquorsCellIdentifier];
    //
    //    [self.tblView registerNib:[UINib nibWithNibName:Nib_RavesAndRentsCell bundle:nil] forCellReuseIdentifier:RavesAndRentsCellIdentifier];
}

#pragma mark TableView Datasource and Delegates
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (isWSStatus) {
        if([fullLiquorDetail.aryLiquorComments count]>0) {
            //return 12;
            return 17;
        }
        else {
            return 14;
        }
    }
    else {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section == 15) {
        return [CommonUtils getArrayCountFromArray:[fullLiquorDetail aryLiquorComments]];
    }
    else {
        return 1;
    }
    
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
            return [self ShowMoreCellAtIndexPath:indexPath];
            break;
        case 10:
            return [self ShareCellAtIndexPath:indexPath];
            break;
        case 11:
            return [self TakeALookCellAtIndexPath:indexPath];
            break;
        
            
            
        case 12:
            return [self TItleCellAtIndexPath:indexPath];
            break;
            
        case 13:
            return [self DirectoryLeaveCommentCellAtIndexPath:indexPath];
            break;
            
        case 14:
            return [self TItleCellAtIndexPath:indexPath];
            break;
            
        case 15:
            return [self DirectoryCommentCellAtIndexPath:indexPath];
            break;
            
        case 16:
            return [self ViewAllCellAtIndexPath:indexPath];
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
    
    if (indexPath.section == 12) {
        cell.lblTitle.text = @"RANTS & RAVES";
    }
    
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
}

#pragma mark
#pragma mark ViewAllCell Cell Configuration
- (ViewAllCell *)ViewAllCellAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"ViewAllCell";
    
    ViewAllCell *cell = (ViewAllCell *)[self.tblView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib;
        if([CommonUtils isiPad])
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"ViewAllCell" owner:self options:nil];
        }
        else
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"ViewAllCell" owner:self options:nil];
        }
        cell = [nib objectAtIndex:0];
    }
    
    if (fullLiquorDetail.aryLiquorComments>0) {
        cell.lblMore.text = @"View All";
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
#pragma mark DirectoryLeaveCommentCell Cell Configuration
- (DirectoryLeaveCommentCell *)DirectoryLeaveCommentCellAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"DirectoryLeaveCommentCell";
    
    DirectoryLeaveCommentCell *cell = (DirectoryLeaveCommentCell *)[self.tblView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib;
        if([CommonUtils isiPad])
        {
            nib = [[NSBundle mainBundle] loadNibNamed:Nib_DirectoryLeaveCommentCell owner:self options:nil];
            cell = [nib objectAtIndex:1];
        }
        else
        {
            nib = [[NSBundle mainBundle] loadNibNamed:Nib_DirectoryLeaveCommentCell owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
    }
    
    cell.txtCommentTitle.text = commentTitle;
    
    [self configureWriteReviewTextView:cell];
    
    [cell.btnSubmit addTarget:self action:@selector(btnSubmitReview:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
}

-(void)btnSubmitReview:(UIButton *)btnSubmit {
    [self.view endEditing:YES];
    
    DirectoryLeaveCommentCell *cell = (DirectoryLeaveCommentCell *)[self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:13]];
    [cell.txtCommentTitle resignFirstResponder];
    [cell.txtComment resignFirstResponder];
    
    
    
    if ([comment isEqualToString:@""])
    {
        ShowAlert(AlertTitle, @"Please enter title of comment.");
        commentTitle = @"";
        [cell.txtCommentTitle becomeFirstResponder];
    }
    else
    {
        
         [self callAddLiquorCommentWebservice];
    }
}

#pragma mark
#pragma mark TakeALookCell Cell Configuration
- (TakeALookCell *)TakeALookCellAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"TakeALookCell";
    
    TakeALookCell *cell = (TakeALookCell *)[self.tblView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib;
        if([CommonUtils isiPad])
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"TakeALookCell-ipad" owner:self options:nil];
        }
        else
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"TakeALookCell" owner:self options:nil];
        }
        cell = [nib objectAtIndex:0];
    }
    
    if ([fullLiquorDetail.liquorDetail.liquor_upload_type isEqualToString:@"video"]) {
        NSString *bar_video_link = fullLiquorDetail.liquorDetail.liquor_video_link;
        if ([bar_video_link length]!=0) {
            cell.imgYoutubeThumbnail.hidden = NO;
            cell.playerView.hidden = YES;
            [cell.imgYoutubeThumbnail sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"waitvideo.png"]];
            NSURL *url = [NSURL URLWithString:bar_video_link];
            NSString *youtubeID = [HCYoutubeParser youtubeIDFromYoutubeURL:url];
            cell.bar_video_link = bar_video_link;
            cell.youtubeID = youtubeID;
            
            [cell configureCellForYoutube];
        }
        else {
            [cell.imgYoutubeThumbnail sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"novideo.png"]];
        }
    }
    else {
        NSString *cocktail_image = fullLiquorDetail.liquorDetail.liquor_image_default;
        
        NSString *strImgURL = [NSString stringWithFormat:@"%@%@%@",WEBIMAGE_URL,LIQUOR_LARGE_IMAGE,cocktail_image];
        NSURL *imgURL = [NSURL URLWithString:strImgURL];
        [cell configureCellWithURL:imgURL];
        cell.imgPlayVideo.hidden = YES;
        [cell.imgYoutubeThumbnail sd_setImageWithURL:imgURL placeholderImage:[UIImage imageNamed:@"no_cocktail_detail.png"]];
        
        
        
        cell.delegate = self;
    }
    
    
    
    //[self setYouTubeThumbnailImage];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
}

-(void)playYoutubeVideo {
    NSLog(@"webview tapped");
}

#pragma mark TakeALookCell Deleagte
-(void)presentImageViewController:(JTSImageViewController *)jtvc {
    [jtvc showFromViewController:self transition:JTSImageViewControllerTransition_FromOriginalPosition];
}
-(void)tapYoutubeVideo:(NSString *)videoURL
{
    VideoViewController *videoView;
    if([CommonUtils isiPad])
    {
        videoView = [[VideoViewController alloc] initWithNibName:@"VideoViewController_iPad" bundle:nil];
    }
    else
    {
        videoView = [[VideoViewController alloc] initWithNibName:@"VideoViewController" bundle:nil];
    }
    
    videoView.VideoUrl = videoURL;//[dictGroupDetails valueForKey:@"video_link"];
    [self.navigationController pushViewController:videoView animated:YES];
}
#pragma mark
#pragma mark ShareCell Cell Configuration
- (ShareCell *)ShareCellAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"ShareCell";
    
    ShareCell *cell = (ShareCell *)[self.tblView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib;
        if([CommonUtils isiPad])
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"ShareCell" owner:self options:nil];
        }
        else
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"ShareCell" owner:self options:nil];
        }
        cell = [nib objectAtIndex:0];
    }
    
    if ([isFavBar isEqualToString:@"1"]) {
        [cell.btnAddToFav setTitle:@"Remove from List" forState:UIControlStateNormal];
    }
    else {
        [cell.btnAddToFav setTitle:@"Add to My Liquor List" forState:UIControlStateNormal];
    }
    
    if ([isLikeThisBar isEqualToString:@"1"]) {
        [cell.btnLikeThisBar setTitle:@"Dislike This Beer" forState:UIControlStateNormal];
    }
    else {
        [cell.btnLikeThisBar setTitle:@"Like This Beer" forState:UIControlStateNormal];
    }
    
    cell.btnFb.hidden = YES;
    cell.btnTwitter.hidden = YES;
    cell.btnLinkedIn.hidden = YES;
    cell.btnGooglePlus.hidden = YES;
    cell.btnDribble.hidden = YES;
    cell.btnPintrest.hidden = YES;
    
    [cell.btnShare addTarget:self action:@selector(btnShare_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.btnAddToFav addTarget:self action:@selector(btnAddToFav_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnLikeThisBar addTarget:self action:@selector(btnLikeThisBar_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
}

-(void)btnAddToFav_Clicked:(UIButton *)btnShare {
    if ([CommonUtils isLoggedIn]) {
        [self callLiquorFavoriteWebservice];
    }
    else {
        [CommonUtils redirectToLoginScreenWithTarget:self];
    }
    
}

-(void)btnLikeThisBar_Clicked:(UIButton *)btnShare {
    if ([CommonUtils isLoggedIn]) {
        [self callLiquorLikesWebservice];
    }
    else {
        [CommonUtils redirectToLoginScreenWithTarget:self];
    }
}

-(void)btnShare_Clicked:(UIButton *)btnShare {
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
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",SHARE_URL,@"liquor/detail/",fullLiquorDetail.liquorDetail.liquor_slug]];
    [composeController setInitialText:fullLiquorDetail.liquorDetail.liquor_liquor_title];
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
    NSString *strURL = [NSString stringWithFormat:@"%@%@%@",SHARE_URL,@"liquor/detail/",fullLiquorDetail.liquorDetail.liquor_slug];
    NSURL *url = [NSURL URLWithString:strURL];
    [composeController setInitialText:fullLiquorDetail.liquorDetail.liquor_liquor_title];
    
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
        
        NSString *productURL = [NSString stringWithFormat:@"%@%@%@",SHARE_URL,@"liquor/detail/",fullLiquorDetail.liquorDetail.liquor_slug];
        NSURL *shareUrl = [NSURL URLWithString:productURL];
        
        [shareBuilder setURLToShare:shareUrl];
        [shareBuilder setPrefillText:fullLiquorDetail.liquorDetail.liquor_liquor_title];
        
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
    [_pinterest createPinWithImageURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",WEBIMAGE_URL,BAR_ICON_LOGO,[fullLiquorDetail.liquorDetail liquor_liquor_image]]]
                            sourceURL:[NSURL URLWithString:@"http://placekitten.com"]
                          description:@"Pinning from Pin It Demo"];
}

-(void)configurePintrest {
    _pinterest = [[Pinterest alloc] initWithClientId:@"4799816673504799498" urlSchemeSuffix:@"prod"];
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
    if (fullLiquorDetail.liquorDetail.liquor_liquor_description.length >0) {
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
        cell.lblTitle.text = @"Type :";
    }
    if (indexPath.section == 3) {
        cell.lblTitle.text = @"ABV :";
    }
    if (indexPath.section == 5) {
        cell.lblTitle.text = @"Producer :";
    }
    if (indexPath.section == 7) {
        cell.lblTitle.text = @"Description :";
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
    if (indexPath.section == 12) {
        cell.lblDesc.numberOfLines = 4;
    }
    else {
        cell.lblDesc.numberOfLines = 2;
    }
    
    if (indexPath.section == 2) {
        cell.lblDesc.text = [CommonUtils removeHTMLFromString:fullLiquorDetail.liquorDetail.liquor_type];
    }
    
    if (indexPath.section == 4) {
        cell.lblDesc.text = [CommonUtils removeHTMLFromString:fullLiquorDetail.liquorDetail.liquor_proof];
    }
    
    if (indexPath.section == 6) {
        cell.lblDesc.text = [CommonUtils removeHTMLFromString:fullLiquorDetail.liquorDetail.liquor_producer];
    }
    
    if (indexPath.section == 8) {
        cell.lblDesc.text = [self removeHTMLContentsFromString:fullLiquorDetail.liquorDetail.liquor_liquor_description];
    }
}

-(NSString *)removeHTMLContentsFromString:(NSString *)htmlString {
    //NSString *html = @"S.Panchami 01.38<br>Arudra 02.01<br>V.08.54-10.39<br>D.05.02-06.52<br> <font color=red><u>Festival</u></font><br><font color=blue>Shankara Jayanthi<br></font>";
    NSAttributedString *attr = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUTF8StringEncoding]
                                                                options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                          NSCharacterEncodingDocumentAttribute:@(NSUTF8StringEncoding)}
                                                     documentAttributes:nil
                                                                  error:nil];
    //NSLog(@"html: %@", htmlString);
    //NSLog(@"attr: %@", attr);
    //NSLog(@"string: %@", [attr string]);
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
    LiquorDetail *liquor = [fullLiquorDetail liquorDetail];
    cell.lblBeerTitle.text = [CommonUtils removeHTMLFromString:liquor.liquor_liquor_title];
    cell.lblBrewedByTitle.text = @"";   //@"Type :";
    cell.lblBrewedBy.text = @"";        //[CommonUtils removeHTMLFromString:liquor.liquor_type];
    
    NSString *liquor_image = [liquor liquor_liquor_image];
    NSString *strImgURL = [NSString stringWithFormat:@"%@%@%@",WEBIMAGE_URL,LIQUOR_DETAIL_IMAGE,liquor_image];
    NSURL *imgURL = [NSURL URLWithString:strImgURL];
    
    [cell.imgBeerLogo sd_setImageWithURL:imgURL placeholderImage:[UIImage imageNamed:@"no_liquor_detail.png"]];
    
}


#pragma mark
#pragma mark DirectoryCommentCell Cell Configuration
- (DirectoryCommentCell *)DirectoryCommentCellAtIndexPath:(NSIndexPath *)indexPath
{
    static DirectoryCommentCell *cell = nil;
    cell = [self.tblView dequeueReusableCellWithIdentifier:DirectoryCommentCellIdentifier];
    [self configureDirectoryCommentCell:cell atIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)configureDirectoryCommentCell:(DirectoryCommentCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    LiquorComment  *liquorComment = [[fullLiquorDetail aryLiquorComments] objectAtIndex:indexPath.row];
    
    if ([liquorComment.liquor_user_id isEqualToString:@"0"]) {
        cell.lblUserName.text = @"ADB";
    }
    else {
        cell.lblUserName.text = [CommonUtils removeHTMLFromString:liquorComment.liquor_fullName];
    }
    
    
    cell.btnReply.tag = indexPath.row;
    cell.btnLike.tag = indexPath.row;
    
    cell.lblTitle.text = [CommonUtils removeHTMLFromString:liquorComment.liquor_comment_title];
    cell.lblDesc.text = [CommonUtils removeHTMLFromString:liquorComment.liquor_comment];
    
    NSString *strDuration = liquorComment.liquor_date_added; //[[CommonUtils getDateFromString:liquorComment.liquor_date_added withFormat:@"yyyy-MM-dd HH:mm:ss"] formattedAsTimeAgo];
    cell.lblTimeAgo.text = strDuration;
    
    NSString *profile_image = [liquorComment liquor_profile_image];
    NSString *strImgURL = [NSString stringWithFormat:@"%@%@%@",WEBIMAGE_URL,USERPROFILEIMAGE_COMMENT,profile_image];
    NSURL *imgURL = [NSURL URLWithString:strImgURL];
    
    [cell.imgUser sd_setImageWithURL:imgURL placeholderImage:[UIImage imageNamed:@"user-no_image_RM.png"]];
    
    [cell.btnReply addTarget:self action:@selector(replyOnComment:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnLike addTarget:self action:@selector(likeComment:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *nummberOfLikes = nil;
    if ([liquorComment.liquor_total_like isEqualToString:@"0"] || [liquorComment.liquor_total_like isEqualToString:@"1"]) {
        nummberOfLikes = [NSString stringWithFormat:@"%@ Like",liquorComment.liquor_total_like];
    }
    else {
        if ([liquorComment.liquor_total_like isEqualToString:@""]) {
            nummberOfLikes = [NSString stringWithFormat:@"0 Like"];
        }
        else {
            nummberOfLikes = [NSString stringWithFormat:@"%@ Likes",liquorComment.liquor_total_like];
        }
        nummberOfLikes = [NSString stringWithFormat:@"%@ Likes",liquorComment.liquor_total_like];
    }
    
    
    
    [cell.btnLike setTitle:nummberOfLikes forState:UIControlStateNormal];
    
    if ([liquorComment.liquor_is_like isEqualToString:@"1"]) {
        [cell.btnLike setImage:[UIImage imageNamed:@"thumb_down.png"] forState:UIControlStateNormal];
    }
    else {
        [cell.btnLike setImage:[UIImage imageNamed:@"thumb_up.png"] forState:UIControlStateNormal];
    }
    cell.btnDelete.hidden = YES;
}


-(void)replyOnComment:(UIButton *)btnReply {
    BeerComment *beerComment = [self.aryList objectAtIndex:btnReply.tag];
    
    DirectoryReplyViewController *replyVC = [[DirectoryReplyViewController alloc] initWithNibName:@"DirectoryReplyViewController" bundle:nil];
    replyVC.type = @"liquor";
    replyVC.masterCommentID = beerComment.beerComment_beer_comment_id;
    replyVC.fullLiquorDetail = fullLiquorDetail;
    [self.navigationController pushViewController:replyVC animated:YES];
}

-(void)likeComment:(UIButton *)btnLike {
    selectedCommentIndex = btnLike.tag;
    [self callLiquorComentLikesWebservice];
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
            break;
            
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
            
            //ShowMore Cell
        case 9:
            return 25;
            break;
            
            //ShareCell
        case 10:
            return 109;
            break;
            
            //TakeALookCell
        case 11:
            if ([CommonUtils isiPad]) {
                return 500;
            }
            else {
                return 200;
            }
            break;
            
            //            //TItleCell
            //        case 12:
            //            return 50;
            //            break;
            //            
            //            //DirectoryCommentCell
            //        case 13:
            //        {
            //            CGFloat cellHeight = [self heightForDirectoryCommentCellAtIndexPath:indexPath];
            //            return cellHeight;
            //        }
            
            // TItleCell
        case 12:
            return 50;
            break;
            
            // DirectoryLeaveCommentCell
        case 13:
            return 176;
            break;
            
            // TitleCell
        case 14:
            return 50;
            break;
            
            // DirectoryCommentCell
        case 15:
        {
            CGFloat cellHeight = [self heightForDirectoryCommentCellAtIndexPath:indexPath];
            return cellHeight;
        }
            break;
            
            // View All Cell
        case 16:
            return 25;
            break;
            
        default:
        {
            return 0;
        }
    }
    
}

#pragma mark
#pragma mark DirectoryCommentCell Cell With Height Configuration
- (CGFloat)heightForDirectoryCommentCellAtIndexPath:(NSIndexPath *)indexPath
{
    static DirectoryCommentCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tblView dequeueReusableCellWithIdentifier:DirectoryCommentCellIdentifier];
    });
    
    [self configureDirectoryCommentCell:sizingCell atIndexPath:indexPath];
    return [self calculateHeightForConfiguredSizingCell:sizingCell];
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
            //return 174;
            return 115;
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
            break;
            
            //DescriptionTitleCell
        case 7:
            return 30;
            break;
            
            //DescriptionCell
        case 8:
            return 22;
            
            //ShowMore Cell
        case 9:
            return 25;
            break;
            
            //ShareCell
        case 10:
            return 109;
            break;
            
            //TakeALookCell
        case 11:
            if ([CommonUtils isiPad]) {
                return 500;
            }
            else {
                return 200;
            }
            break;
            
            // TItleCell
        case 12:
            return 50;
            break;
            
            // DirectoryLeaveCommentCell
        case 13:
            return 176;
            break;
            
            // TItleCell
        case 14:
            return 50;
            break;
            
            //DirectoryCommentCell
        case 15:
            return 112;
            break;
            
            // ViewAllCell
        case 16:
            return 25;
            break;
            
            
        default:
            return 0;
    }
    
}

#pragma mark Did Select Row
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 9) {
        [self displayShowMoreView];
    }
    if (indexPath.section == 11) {
        if ([fullLiquorDetail.liquorDetail.liquor_upload_type isEqualToString:@"video"]) {
            if ([fullLiquorDetail.liquorDetail.liquor_video_link length]==0) {
                return;
            }
            else {
//                TakeALookCell *cell = (TakeALookCell *)[tableView cellForRowAtIndexPath:indexPath];
//                cell.youtubeView.hidden = NO;
//                cell.imgPlayVideo.hidden = YES;
//                cell.imgYoutubeThumbnail.hidden = YES;
//                [cell configureCellForYoutube];
            }
        }
        else {
        }
        
    }
    if (indexPath.section == 16) {
        // [self displayShowMoreView];
        DirectoryCommentViewController *directoryComment = [[DirectoryCommentViewController alloc]initWithNibName:@"DirectoryCommentViewController" bundle:nil];
        directoryComment.fullLiquorDetail = fullLiquorDetail;
        directoryComment.type = @"liquor";
        [self.navigationController pushViewController:directoryComment animated:YES];
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
        [showMoreView reloadShowMoreTable:@[[self removeHTMLContentsFromString:fullLiquorDetail.liquorDetail.liquor_liquor_description]]];
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
-(void)callLiquorDetailWebservice {
    [CommonUtils callWebservice:@selector(liquor_details) forTarget:self];
}

-(void)callLiquorFavoriteWebservice {
    [CommonUtils callWebservice:@selector(liquor_favorite) forTarget:self];
}

-(void)callLiquorLikesWebservice {
    [CommonUtils callWebservice:@selector(liquor_likes) forTarget:self];
}

-(void)callLiquorComentLikesWebservice {
    [CommonUtils callWebservice:@selector(liquor_comment_likes) forTarget:self];
}

-(void)callAddLiquorCommentWebservice {
    [CommonUtils callWebservice:@selector(add_liquor_comment) forTarget:self];
}

#pragma mark - Webservice
#pragma mark liquor_details
-(void)liquor_details
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
    NSString *myURL = [NSString stringWithFormat:@"%@liquor_details",WEBSERVICE_URL];
    NSMutableURLRequest *Request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: myURL]];
    //NSString *params = [NSString stringWithFormat:@"user_id=%@&limit=%ld&offset=%ld&bar_id=%@",user_id,(long)limit,(long)offset,self.bar.bar_id];
    NSString *params = [NSString stringWithFormat:@"user_id=%@&device_id=%@&unique_code=%@&limit=%ld&offset=%ld&liquor_id=%@",user_id,device_id,unique_code,(long)limit,(long)offset,self.liquor.liquor_id];
    
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
                fullLiquorDetail = [FullLiquorDetail getFullLiquorDetailWithDictionary:tempDict];
                if ([fullLiquorDetail.liquorDetail.liquor_fav_liquor isEqualToString:@"1"]) {
                    isFavBar = @"1";
                }
                else {
                    isFavBar = @"0";
                }
                
                if ([fullLiquorDetail.liquorDetail.liquor_like_liquor isEqualToString:@"1"]) {
                    isLikeThisBar = @"1";
                }
                else {
                    isLikeThisBar = @"0";
                }
                
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

#pragma mark liquor_id
-(void)liquor_favorite
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.mode = MBProgressHUDModeIndeterminate;
    
    User *user = [CommonUtils getUserLoginDetails];
    NSString *user_id = [user user_id];
    NSString *device_id = [user device_id];
    NSString *unique_code =[user unique_code];
    
    //192.168.1.27/ADB/api/bar_details
    NSString *myURL = [NSString stringWithFormat:@"%@liquor_favorite",WEBSERVICE_URL];
    NSMutableURLRequest *Request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: myURL]];
    //NSString *params = [NSString stringWithFormat:@"user_id=%@&limit=%ld&offset=%ld&bar_id=%@",user_id,(long)limit,(long)offset,self.bar.bar_id];
    NSString *params = [NSString stringWithFormat:@"user_id=%@&device_id=%@&unique_code=%@&liquor_id=%@",user_id,device_id,unique_code,self.liquor.liquor_id];
    
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
                //fullMugBar = [FullMugBar getFullMugBarWithDictionary:tempDict];
                isFavBar = [CommonUtils getNotNullString:[tempDict valueForKey:@"message"]];
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


#pragma mark liquor_likes
-(void)liquor_likes
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.mode = MBProgressHUDModeIndeterminate;
    
    User *user = [CommonUtils getUserLoginDetails];
    NSString *user_id = [user user_id];
    NSString *device_id = [user device_id];
    NSString *unique_code =[user unique_code];
    
    //192.168.1.27/ADB/api/bar_details
    NSString *myURL = [NSString stringWithFormat:@"%@liquor_likes",WEBSERVICE_URL];
    NSMutableURLRequest *Request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: myURL]];
    //NSString *params = [NSString stringWithFormat:@"user_id=%@&limit=%ld&offset=%ld&bar_id=%@",user_id,(long)limit,(long)offset,self.bar.bar_id];
    NSString *params = [NSString stringWithFormat:@"user_id=%@&device_id=%@&unique_code=%@&liquor_id=%@",user_id,device_id,unique_code,self.liquor.liquor_id];
    
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
                //fullMugBar = [FullMugBar getFullMugBarWithDictionary:tempDict];
                isLikeThisBar = [CommonUtils getNotNullString:[tempDict valueForKey:@"message"]];
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

#pragma mark liquor_comment_likes
-(void)liquor_comment_likes
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.mode = MBProgressHUDModeIndeterminate;
    
    User *user = [CommonUtils getUserLoginDetails];
    NSString *user_id = [user user_id];
    NSString *device_id = [user device_id];
    NSString *unique_code =[user unique_code];
    
    LiquorComment  *liquorComment = [[fullLiquorDetail aryLiquorComments] objectAtIndex:selectedCommentIndex];
    
    //192.168.1.27/ADB/api/bar_details
    NSString *myURL = [NSString stringWithFormat:@"%@liquor_comment_likes",WEBSERVICE_URL];
    NSMutableURLRequest *Request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: myURL]];
    //NSString *params = [NSString stringWithFormat:@"user_id=%@&limit=%ld&offset=%ld&bar_id=%@",user_id,(long)limit,(long)offset,self.bar.bar_id];
    
    NSString *params = [NSString stringWithFormat:@"user_id=%@&device_id=%@&unique_code=%@&beer_id=%@&is_like=%@&beer_comment_id=%@",user_id,device_id,unique_code,self.liquor.liquor_id,liquorComment.liquor_is_like,liquorComment.liquor_comment_id];
    
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
                
                liquorComment.liquor_is_like = [CommonUtils getNotNullString:[tempDict valueForKey:@"is_like"]];
                liquorComment.liquor_total_like = [CommonUtils getNotNullString:[tempDict valueForKey:@"total_like"]];
                
                [[fullLiquorDetail aryLiquorComments] replaceObjectAtIndex:selectedCommentIndex withObject:liquorComment];
                
                DirectoryCommentCell *cell = [self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedCommentIndex inSection:19]];
                
                if ([liquorComment.liquor_is_like isEqualToString:@"1"]) {
                    [cell.btnLike setImage:[UIImage imageNamed:@"thumb_down.png"] forState:UIControlStateNormal];
                }
                else {
                    [cell.btnLike setImage:[UIImage imageNamed:@"thumb_up.png"] forState:UIControlStateNormal];
                }
            }
        }
        else {
            isWSStatus = NO;
        }
        
        [self.tblView reloadData];
        
    }];
    
}


#pragma mark add_liquor_comment
-(void)add_liquor_comment {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.mode = MBProgressHUDModeIndeterminate;
    
    User *user = [CommonUtils getUserLoginDetails];
    NSString *user_id = [user user_id];
    NSString *device_id = [user device_id];
    NSString *unique_code =[user unique_code];
    
    //192.168.1.27/ADB/api/bar_details
    NSString *myURL = [NSString stringWithFormat:@"%@add_liquor_comment",WEBSERVICE_URL];
    NSMutableURLRequest *Request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: myURL]];
    //NSString *params = [NSString stringWithFormat:@"user_id=%@&limit=%ld&offset=%ld&bar_id=%@",user_id,(long)limit,(long)offset,self.bar.bar_id];
    NSString *params = [NSString stringWithFormat:@"user_id=%@&device_id=%@&unique_code=%@&liquor_id=%@&comment_title=%@&comment=%@",user_id,device_id,unique_code,self.liquor.liquor_id,commentTitle,comment];
    
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
                
                ShowAlert(AlertTitle, @"Your comment is added successfully.");
                
                commentTitle = @"";
                comment = @"";
                showingLeaveCommentPlaceholder = YES;
                isWSStatus = YES;
                [self callLiquorDetailWebservice];
                
            }
        }
        else {
            isWSStatus = NO;
        }
        
        [self.tblView reloadData];
        
    }];
    
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
