//
//  EventDetailViewController.m
//  AmericanDiveBars
//
//  Created by spaculus on 9/23/15.
//  Copyright (c) 2015 spaculus. All rights reserved.
//

#import "EventDetailViewController.h"
#import "BarDetailCell.h"
#import "EventDetailCells.h"

@interface EventDetailViewController ()<MBProgressHUDDelegate,BarGalleryCellDelegate,ShowMoreViewDelegate,FPPopoverControllerDelegate,TTTAttributedLabelDelegate,UITableViewDataSource,UITableViewDelegate>
{
    MBProgressHUD *HUD;
    
    //POPOVER
    FPPopoverController *popover;
    
    //LOAD MORE
    NSInteger offset;
    NSInteger limit;
    
    BOOL isWSStatus;

    //BAR GALLERY
    NSInteger selectedIndex;

    //Full Event Detail
    FullEventInfo *eventInfo;
}

//Main Table
@property (strong, nonatomic) IBOutlet UITableView *tblView;
@property (strong, nonatomic) NSMutableArray *aryList;

@property (strong, nonatomic) IBOutlet UIView *viewShowMore;
@end

@implementation EventDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [CommonUtils setTitleLabel:self.barEvent.barEvent_event_title];
    [self configureTopButtons];
    [self setInitialData];
    // Do any additional setup after loading the view from its nib.
}


-(void)setInitialData {
    selectedIndex = 0;
    
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
    
    [self callEventDetailWebservice];
    
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
    controller.eventDetailDelegate = self;
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
    [self.tblView registerNib:[UINib nibWithNibName:Nib_EventDetailCell bundle:nil] forCellReuseIdentifier:EventDetailCellIdentifier];
    [self.tblView registerNib:[UINib nibWithNibName:Nib_EventDetailMainTitleCell bundle:nil] forCellReuseIdentifier:EventDetailMainTitleCellIdentifier];
}


#pragma mark TableView Datasource and Delegates
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (isWSStatus) {
        return 5;
    }
    else {
        return 0;
    }

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
            
        case 1:
            return 1;
            break;

        case 2:
            return 5;
            break;
            
        case 3:
            return 1;
            break;
        
        case 4:
            return 1;
            break;
            
        default:
            return 0;
            break;
    }
}
#pragma mark Cell For Row
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return [self BarGalleryCellAtIndexPath:indexPath];
            break;
            
        case 1:
            return [self EventDetailMainTitleCellAtIndexPath:indexPath];
            break;
            
        case 2:
            return [self EventDetailCellAtIndexPath:indexPath];
            break;
            
        case 3:
            return [self ShowMoreCellAtIndexPath:indexPath];
            break;
        
        case 4:
            return [self HowToFindUSCellAtIndexPath:indexPath];
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
#pragma mark HowToFindUS Cell Configuration
- (HowToFindUSCell *)HowToFindUSCellAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"HowToFindUSCell";
    
    HowToFindUSCell *cell = (HowToFindUSCell *)[self.tblView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib;
        if([CommonUtils isiPad])
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"HowToFindUSCell" owner:self options:nil];
        }
        else
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"HowToFindUSCell" owner:self options:nil];
        }
        cell = [nib objectAtIndex:0];
    }
    [cell getLatlongfromAddress:eventInfo.eventDetail.fullAddress];
    [cell.btnGetDirections addTarget:self action:@selector(btnGetDirections_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
}


-(void)btnGetDirections_Clicked:(UIButton *)btnGetDirection {
    NSString *urladdress = [[NSString stringWithFormat:@"http://maps.apple.com/?address=%@",eventInfo.eventDetail.fullAddress] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urladdress];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
//    GetDirectionsViewController *getDirection = [[GetDirectionsViewController alloc] initWithNibName:@"GetDirectionsViewController" bundle:nil];
//    getDirection.isFromGetDirection = YES;
//    getDirection.lat = @"";
//    getDirection.lng = @"";
//    getDirection.address_Unformated = eventInfo.eventDetail.fullAddress_Unformated;
//    getDirection.address_Formated = eventInfo.eventDetail.fullAddress;
//    [self.navigationController pushViewController:getDirection animated:YES];
}

#pragma mark
#pragma mark BarGalleryCell Cell Configuration
- (BarGalleryCell *)BarGalleryCellAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"BarGalleryCell";
    
    BarGalleryCell *cell = (BarGalleryCell *)[self.tblView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib;
        if([CommonUtils isiPad])
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"BarGalleryCell-ipad" owner:self options:nil];
        }
        else
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"BarGalleryCell" owner:self options:nil];
        }
        cell = [nib objectAtIndex:0];
    }
    cell.delegate = self;

    if(eventInfo.aryEventGallery.count>0) {
        EventGallery *eventGallery = [eventInfo.aryEventGallery objectAtIndex:selectedIndex];
        cell.lblBarTitle.hidden = YES;
        cell.viewShadow.hidden = YES;
        
        NSString *event_image_name = [eventGallery eventGal_event_image_name];
        NSString *strImgURL = [NSString stringWithFormat:@"%@%@%@",WEBIMAGE_URL,BAR_EVENTGALLERY_LARGE,event_image_name];
        NSURL *imgURL = [NSURL URLWithString:strImgURL];
        [cell.imgBarLarge sd_setImageWithURL:imgURL placeholderImage:[UIImage imageNamed:@"bar-gallery-large-placeholder.png"]];
        
        [cell configureBarGalleryThumbnailCellWith:eventInfo.aryEventGallery withOriginalImageURL:eventGallery.eventGal_OriginalImageURL forImageType:BAR_EVENTGALLERY_SMALL];
    }
    else {
        cell.lblBarTitle.hidden = YES;
        cell.viewShadow.hidden = YES;
        [cell.imgBarLarge sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"bar-gallery-placeholder.png"]];
        cell.imgBarLarge.hidden = YES;
        cell.lblNoData.hidden = NO;
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
}

#pragma mark BarGalleryCell Delegates
-(void)presentImageViewController:(JTSImageViewController *)jtvc
{
    //isPictureClicked = YES;
    [jtvc showFromViewController:self transition:JTSImageViewControllerTransition_FromOriginalPosition];
}

-(void)didSelectThumbnailImage:(UIImage *)img AtIndexPath:(NSIndexPath *)indexPath forCell:(BarGalleryCell *)cell {
    if(eventInfo.aryEventGallery.count>0) {
        selectedIndex = indexPath.item;
        
        EventGallery *eventGallery = [eventInfo.aryEventGallery objectAtIndex:selectedIndex];
        
        NSString *event_image_name = [eventGallery eventGal_event_image_name];
        NSString *strImgURL = [NSString stringWithFormat:@"%@%@%@",WEBIMAGE_URL,BAR_EVENTGALLERY_LARGE,event_image_name];
        NSURL *imgURL = [NSURL URLWithString:strImgURL];
        
        
        
        //BarGalleryCell *cell = (BarGalleryCell *)[self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:10]];
        [cell.imgBarLarge sd_setImageWithURL:imgURL placeholderImage:[UIImage imageNamed:@"bar-gallery-large-placeholder.png"]];
    }

    
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
    if (eventInfo.eventDetail.eventDetail_event_desc.length>0) {
        cell.lblMore.text = @"Show More";
        cell.lblMore.textColor = [UIColor colorWithRed:187.0/255.0 green:124.0/255.0 blue:37.0/255.0 alpha:1.0];
        
    }
    else {
        cell.lblMore.text = @"";
        cell.lblUnderline.backgroundColor = [UIColor clearColor];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
}

#pragma mark
#pragma mark EventDetailMainTitleCell Configuration
- (EventDetailMainTitleCell *)EventDetailMainTitleCellAtIndexPath:(NSIndexPath *)indexPath
{
    static EventDetailMainTitleCell *cell = nil;
    cell = [self.tblView dequeueReusableCellWithIdentifier:EventDetailMainTitleCellIdentifier];
    [self configureEventDetailMainTitleCell:cell atIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)configureEventDetailMainTitleCell:(EventDetailMainTitleCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.lblTitle.text = @"Event Name";
    cell.lblValue.text = eventInfo.eventDetail.eventDetail_event_title;
    cell.lblTitle.textColor = [UIColor colorWithRed:189.0/255.0 green:127.0/255.0 blue:52.0/255.0 alpha:1.0];
    cell.lblValue.textColor = [UIColor colorWithRed:189.0/255.0 green:127.0/255.0 blue:52.0/255.0 alpha:1.0];
}

#pragma mark
#pragma mark EventDetailCell Cell Configuration
- (EventDetailCell *)EventDetailCellAtIndexPath:(NSIndexPath *)indexPath
{
    static EventDetailCell *cell = nil;
    cell = [self.tblView dequeueReusableCellWithIdentifier:EventDetailCellIdentifier];
    [self configureEventDetailCell:cell atIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)configureEventDetailCell:(EventDetailCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            cell.lblTitle.text = @"Organized By";
            if([eventInfo.eventDetail.eventDetail_bar_title length] > 0)
            {
                cell.lblValue.text = [self setTextColorInLabelText:[CommonUtils removeHTMLFromString:eventInfo.eventDetail.eventDetail_bar_title] withColor:[UIColor colorWithRed:189.0/255.0 green:127.0/255.0 blue:52.0/255.0 alpha:1.0]];
            }
            else
            {
                cell.lblValue.text = @" ";
            }
            cell.lblTitle.textColor = [UIColor colorWithRed:189.0/255.0 green:127.0/255.0 blue:52.0/255.0 alpha:1.0];
            break;
            
        case 1:
            cell.lblTitle.text = @"Address";
            NSRange address_range = [cell.lblValue.text rangeOfString:cell.lblValue.text];
            [cell.lblValue addLinkToAddress:nil withRange:address_range];
            cell.lblValue.delegate = self;
            cell.lblValue.enabledTextCheckingTypes = NSTextCheckingTypeAddress;
            if([eventInfo.eventDetail.fullAddress length] > 0)
            {
                cell.lblValue.text = [self setTextColorInLabelText:[CommonUtils removeHTMLFromString:eventInfo.eventDetail.fullAddress] withColor:[UIColor colorWithRed:189.0/255.0 green:127.0/255.0 blue:52.0/255.0 alpha:1.0]];
            }
            else
            {
                cell.lblValue.text = @" ";
            }
            cell.lblTitle.textColor = [UIColor colorWithRed:189.0/255.0 green:127.0/255.0 blue:52.0/255.0 alpha:1.0];
            break;
            
        case 2:
            cell.lblTitle.text = @"Event Date";
            if([eventInfo.eventDetail.eventDetail_OrganizedDate length] > 0)
            {
                cell.lblValue.text = [self setTextColorInLabelText:eventInfo.strEventTime withColor:[UIColor whiteColor]];
            }
            else
            {
                cell.lblValue.text = @" ";
            }
            cell.lblTitle.textColor = [UIColor colorWithRed:189.0/255.0 green:127.0/255.0 blue:52.0/255.0 alpha:1.0];
            break;
            
        case 3:
            cell.lblTitle.text = @"Event Category";//@"Event Time";
            if([eventInfo.eventDetail.eventDetail_Category length] > 0)
            {
                cell.lblValue.text = [self setTextColorInLabelText:[CommonUtils removeHTMLFromString:eventInfo.eventDetail.eventDetail_Category] withColor:[UIColor whiteColor]];
            }
            else
            {
                cell.lblValue.text = @" ";
            }
            cell.lblTitle.textColor = [UIColor colorWithRed:189.0/255.0 green:127.0/255.0 blue:52.0/255.0 alpha:1.0];
            break;
            
        case 4:
            cell.lblTitle.text = @"Description";
            if([eventInfo.eventDetail.eventDetail_event_desc length] > 0)
            {
                cell.lblValue.text = [self setTextColorInLabelText:[CommonUtils removeHTMLFromString:eventInfo.eventDetail.eventDetail_event_desc] withColor:[UIColor whiteColor]];
            }
            else
            {
                cell.lblValue.text = @" ";
            }
            cell.lblValue.numberOfLines = 4;
            cell.lblTitle.textColor = [UIColor colorWithRed:189.0/255.0 green:127.0/255.0 blue:52.0/255.0 alpha:1.0];
            break;
            
        default:
            break;
    }
}


#pragma mark TTTAttributedLabel Delegate
- (void)attributedLabel:(TTTAttributedLabel *)label
didSelectLinkWithAddress:(NSDictionary *)addressComponents {
    if ([label.text length]==0) {
        ShowAlert(AlertTitle, @"No address found");
        return;
    }
    
    NSString *urladdress = [[NSString stringWithFormat:@"http://maps.apple.com/?address=%@",eventInfo.eventDetail.fullAddress] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urladdress];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
    
//    GetDirectionsViewController *getDirection = [[GetDirectionsViewController alloc] initWithNibName:@"GetDirectionsViewController" bundle:nil];
//    getDirection.isFromGetDirection = NO;
//    getDirection.lat = @"";
//    getDirection.lng = @"";
//    getDirection.address_Unformated = eventInfo.eventDetail.fullAddress_Unformated;
//    getDirection.address_Formated = eventInfo.eventDetail.fullAddress;
//    [self.navigationController pushViewController:getDirection animated:YES];
    NSLog(@"%@",label.text);
}

-(NSAttributedString *)setTextColorInLabelText:(NSString *)text withColor:(UIColor *)color{
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:text
                                                                    attributes:@{
                                                                                 (id)kCTForegroundColorAttributeName : (id)color.CGColor,
                                                                                 NSFontAttributeName : [UIFont fontWithName:@"Verdana" size:14.0],
                                                                                 NSKernAttributeName : [NSNull null]
                                                                                 }];
    return attString;
}

#pragma mark Height For Row

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
            
            //BarGalleryCell
        case 0:
            if ([CommonUtils isiPad]) {
                return 511;
            }
            else {
                return 351;
            }
            break;
            
            //EventDetailMainTitleCell
        case 1:
            {
                CGFloat cellHeight = [self heightForEventDetailMainTitleCellAtIndexPath:indexPath];
                return cellHeight;
            }
            break;

            //EventDetailCell
        case 2:
            {
                CGFloat cellHeight = [self heightForEventDetailCellAtIndexPath:indexPath];
                return cellHeight;
            }
            break;
            
            //ShowMoreCell
        case 3:
            return 25;
            break;
         
            //HowToFindUSCell
        case 4:
            return 238;
            break;
            
            
        default:
            return 0;
            break;
    }

}

#pragma mark
#pragma mark EventDetailMainTitle Cell With Height Configuration
- (CGFloat)heightForEventDetailMainTitleCellAtIndexPath:(NSIndexPath *)indexPath
{
    static EventDetailMainTitleCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tblView dequeueReusableCellWithIdentifier:EventDetailMainTitleCellIdentifier];
    });
    
    [self configureEventDetailMainTitleCell:sizingCell atIndexPath:indexPath];
    return [self calculateHeightForConfiguredSizingCell:sizingCell];
}

#pragma mark
#pragma mark EventDetail Cell With Height Configuration
- (CGFloat)heightForEventDetailCellAtIndexPath:(NSIndexPath *)indexPath
{
    static EventDetailCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tblView dequeueReusableCellWithIdentifier:EventDetailCellIdentifier];
    });
    
    [self configureEventDetailCell:sizingCell atIndexPath:indexPath];
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
            //BarGalleryCell
        case 0:
            if ([CommonUtils isiPad]) {
                return 511;
            }
            else {
                return 351;
            }
            break;
            
            //EventDetailMainTitleCell
        case 1:
            return 29;
            break;
            
            //EventDetailCell
        case 2:
            return 29;
            break;
            
            //ShowMoreCell
        case 3:
            return 25;
            break;
            
            //HowToFindUSCell
        case 4:
            return 238;
            break;
            
        default:
            return 0;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3) {
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
        [showMoreView reloadShowMoreTable:@[[CommonUtils removeHTMLFromString:eventInfo.eventDetail.eventDetail_event_desc]]];
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

#pragma mark - Webservice Call
-(void)callEventDetailWebservice {
    [CommonUtils callWebservice:@selector(event_details) forTarget:self];
}


#pragma mark - Webservice
#pragma mark bar_details
-(void)event_details
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.mode = MBProgressHUDModeIndeterminate;
    
    User *user = [CommonUtils getUserLoginDetails];
    NSString *user_id = [user user_id];
    NSString *device_id = [user device_id];
    NSString *unique_code =[user unique_code];
    
    //192.168.1.27/ADB/api/event_details
    NSString *myURL = [NSString stringWithFormat:@"%@event_details",WEBSERVICE_URL];
    NSMutableURLRequest *Request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: myURL]];
    //NSString *params = [NSString stringWithFormat:@"user_id=%@&limit=%ld&offset=%ld&bar_id=%@",user_id,(long)limit,(long)offset,self.bar.bar_id];
    NSString *params = [NSString stringWithFormat:@"user_id=%@&device_id=%@&unique_code=%@&limit=%ld&offset=%ld&event_id=%@",user_id,device_id,unique_code,(long)limit,(long)offset,self.barEvent.barEvent_event_id];
    
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
                eventInfo = [FullEventInfo getFullEventInfoWithDictionary:tempDict];
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


@end
