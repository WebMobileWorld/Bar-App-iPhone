//
//  GetDirectionsViewController.m
//  GetDirections
//
//  Created by spaculus on 10/29/15.
//  Copyright © 2015 spaculus. All rights reserved.
//

#import "GetDirectionsViewController.h"
#import "GetDirectionCells.h"

@interface GetDirectionsViewController ()<FPPopoverControllerDelegate,GetDirectionMapCellDelegate>
{
    //POPOVER
    FPPopoverController *popover;
    
    NSArray *aryDirections;
    
    NSInteger numberOfSections;
    
    BOOL isSource;
    
    
    
}

@property (strong, nonatomic) IBOutlet TPKeyboardAvoidingTableView *tblView;
@property (strong, nonatomic) NSMutableArray *aryList;


@end

@implementation GetDirectionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.titleView = [CommonUtils setTitleLabel:@"GET DIRECTIONS"];
    [self configureTopButtons];
    [self initializeDatastructure];
}

-(void)initializeDatastructure {
    isSource = NO;
    numberOfSections = 1;
    [self registerCell];
    [self.tblView reloadData];
}

-(void)setStatusBarVisibility {
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

-(void)viewDidLayoutSubviews {
    [self setStatusBarVisibility];
    popover.contentSize = CGSizeMake(150, self.view.bounds.size.height-20);
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        numberOfSections = 1;
        if ([aryDirections count]>0) {
            GetDirectionMapCell *cell = (GetDirectionMapCell *)[self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            cell.btnDirectionList.hidden = NO;
            [self.tblView reloadData];
        }
    }
    else {
        if ([aryDirections count]>0) {
            numberOfSections = 3;
        }
        else {
            numberOfSections = 1;
        }
        
        GetDirectionMapCell *cell = (GetDirectionMapCell *)[self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        cell.btnDirectionList.hidden = YES;
        [self.tblView reloadData];
    }
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
    [self.navigationController popToRootViewControllerAnimated:YES];
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
    controller.getDirectionDelegate = self;
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
-(void)registerCell
{
    [self.tblView registerNib:[UINib nibWithNibName:Nib_GetDirectionMapCell bundle:nil] forCellReuseIdentifier:GetDirectionMapCellIdentifier];
    [self.tblView registerNib:[UINib nibWithNibName:Nib_GetDirectionDetailCell bundle:nil] forCellReuseIdentifier:GetDirectionDetailCellIdentifier];
}
#pragma mark TableView Datasource and Delegates
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([aryDirections count]>0) {
        return numberOfSections;
    }
    else {
        return numberOfSections;
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
            return [CommonUtils getArrayCountFromArray:aryDirections];
            break;
            
        default:
            return 0;
            break;
    }
    return 1;
}
#pragma mark Cell For Row
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return [self GetDirectionMapCellAtIndexPath:indexPath];
            break;
            
        case 1:
            return [self TItleCellAtIndexPath:indexPath];
            break;
            
        case 2:
            return [self GetDirectionDetailCellAtIndexPath:indexPath];
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
        nib = [[NSBundle mainBundle] loadNibNamed:@"TItleCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    if (indexPath.section == 1) {
        cell.lblTitle.text = @"Driving Direction List";
    }
    
    
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
}

#pragma mark
#pragma mark GetDirectionMapCell Cell Configuration
- (GetDirectionMapCell *)GetDirectionMapCellAtIndexPath:(NSIndexPath *)indexPath 
{
    static GetDirectionMapCell *cell = nil;
    cell = [self.tblView dequeueReusableCellWithIdentifier:GetDirectionMapCellIdentifier];
    cell.delegate = self;
    [self configureGetDirectionMapCell:cell atIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)configureGetDirectionMapCell:(GetDirectionMapCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.lblDestination.text = self.address_Formated;
    cell.isFromGetDirection = self.isFromGetDirection;
    
    if ([self.lat length]==0 && [self.lng length]==0) {

        [cell getLatlongfromAddress:self.address_Unformated isSource:isSource];
    }
    else {
        [cell configureMapWithLatitude:self.lat andLongitude:self.lng forAddress:self.address_Unformated isSource:isSource];
    }
}


-(void)getDirectionListFromSourceToDestination:(NSArray *)aryDirectionList isSourceAddress:(BOOL)isSourceAddress {
    aryDirections = aryDirectionList;

    
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        numberOfSections = 1;
        if ([aryDirections count]>0) {
            GetDirectionMapCell *cell = (GetDirectionMapCell *)[self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            self.isFromGetDirection = cell.isFromGetDirection;
            cell.btnDirectionList.hidden = NO;
            [self.tblView reloadData];
        }
        
    }
    else {
        if ([aryDirections count]>0) {
            numberOfSections = 3;
        }
        else {
            numberOfSections = 1;
        }
        
        GetDirectionMapCell *cell = (GetDirectionMapCell *)[self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        self.isFromGetDirection = cell.isFromGetDirection;
        cell.btnDirectionList.hidden = YES;
        [self.tblView reloadData];
    }

    
    
    isSource = isSourceAddress;
    [self.tblView reloadData];
}

-(void)getDirectionListViewController_FromSourceToDestination:(NSArray *)aryDirectionList isSourceAddress:(BOOL)isSourceAddress{
    isSource = isSourceAddress;
    DirectionListViewController *directionList = [[DirectionListViewController alloc] initWithNibName:@"DirectionListViewController" bundle:nil];
    directionList.aryDirections = aryDirectionList;
    [self.navigationController pushViewController:directionList animated:YES];
}





#pragma mark
#pragma mark GetDirectionDetailCell Cell Configuration
- (GetDirectionDetailCell *)GetDirectionDetailCellAtIndexPath:(NSIndexPath *)indexPath
{
    static GetDirectionDetailCell *cell = nil;
    cell = [self.tblView dequeueReusableCellWithIdentifier:GetDirectionDetailCellIdentifier];
    [self configureGetDirectionDetailCell:cell atIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)configureGetDirectionDetailCell:(GetDirectionDetailCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    // Pull out the correct step
    MKRouteStep *step = [aryDirections objectAtIndex:indexPath.row];
    cell.lblDirection.text = step.instructions;
    cell.lblDistance.text = [NSString stringWithFormat:@"%.2f miles", step.distance / 1609.34];
}


#pragma mark Height For Row

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
            //GetDirectionMapCell
        case 0:
        {
            CGFloat cellHeight = [self heightForGetDirectionMapCellAtIndexPath:indexPath];
            return cellHeight;
        }
            break;
            
            //TitleCell
        case 1:
            return 50;
            break;
            
            //GetDirectionDetailCell
        case 2:
        {
            CGFloat cellHeight = [self heightForGetDirectionDetailCellAtIndexPath:indexPath];
            return cellHeight;
        }
            break;
            
        default:
        {
            return 0;
        }
    }
}

#pragma mark GetDirectionMapCell Cell With Height Configuration
- (CGFloat)heightForGetDirectionMapCellAtIndexPath:(NSIndexPath *)indexPath
{
    static GetDirectionMapCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tblView dequeueReusableCellWithIdentifier:GetDirectionMapCellIdentifier];
    });
    
    [self configureGetDirectionMapCell:sizingCell atIndexPath:indexPath];
    return [self calculateHeightForConfiguredSizingCell:sizingCell];
}

#pragma mark GetDirectionDetailCell Cell With Height Configuration
- (CGFloat)heightForGetDirectionDetailCellAtIndexPath:(NSIndexPath *)indexPath
{
    static GetDirectionDetailCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tblView dequeueReusableCellWithIdentifier:GetDirectionDetailCellIdentifier];
    });
    
    [self configureGetDirectionDetailCell:sizingCell atIndexPath:indexPath];
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
            //GetDirectionMapCell
        case 0:
            return 499; //485;
            break;
            
            //TitleCell
        case 1:
            return 50;
            break;
            
            //GetDirectionDetailCell
        case 2:
            return 66;
            break;
            
        default:
            return 0;
    }
}

@end
