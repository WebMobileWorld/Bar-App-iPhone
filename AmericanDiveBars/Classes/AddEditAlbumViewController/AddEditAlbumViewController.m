//
//  AddEditAlbumViewController.m
//  AmericanDiveBars
//
//  Created by spaculus on 10/7/15.
//  Copyright © 2015 spaculus. All rights reserved.
//

#import "AddEditAlbumViewController.h"
#import "AddEditAlbumCell.h"

@interface AddEditAlbumViewController () <MBProgressHUDDelegate,AddEditAlbumCellDelegate,AddEditAlbumHeaderViewDelegate,AddEditAlbumFooterViewDelegate,UzysAssetsPickerControllerDelegate,FPPopoverControllerDelegate,UIActionSheetDelegate>
{
    //HUD
    MBProgressHUD *HUD;
    
    //POPOVER
    FPPopoverController *popover;
    
    //TABLE HEADER & FOOTER
    AddEditAlbumHeaderView *addEditAlbumHeaderView;
    AddEditAlbumFooterView *addEditAlbumFooterView;
    
    //LOAD MORE
    NSInteger offset;
    NSInteger limit;
    NSInteger totalRecords;
    
    //SEARCH LABEL TEXT IN HEADER VIEW
    NSString *keyWord;
    
    //Table Selected Cell
    BOOL allSelected;
    NSString *delBarImageId;
    NSMutableArray *aryDelIndexpaths;
    NSInteger selIndex;
    
    NSIndexPath *selIndexPath;
    
    //AlbumDetail
    AlbumDetail *albumDetail;
    
    //Album Title
    NSString *albumTitle;
    
    //Open ImagePicker on tapped image
    BOOL imgSelected;
    NSInteger maxImages;
    
}

//CUSTOM POPUP TABLE VIEW
@property (strong, nonatomic) LGFilterView  *filterView;
@property (strong, nonatomic) NSArray   *titlesArray;

//Main Table
@property (strong, nonatomic) IBOutlet UITableView *tblView;
@property (strong, nonatomic) NSMutableArray *aryList;


@property (strong, nonatomic) NSMutableArray *aryImages;
@end



@implementation AddEditAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configureTopButtons];
    
    [self configureTableViewHeader];
    
    [self configureTableViewFooter];
    
    [self initializeDataStructure];
    
    if (self.album) {
        self.navigationItem.titleView = [CommonUtils setTitleLabel:@"EDIT ALBUM"];
        [self callGetAlbumWebservice];
    }
    else {
        self.navigationItem.titleView = [CommonUtils setTitleLabel:@"ADD ALBUM"];
    }

}

-(void)initializeDataStructure {
    self.aryList = [[NSMutableArray alloc]  init];
    aryDelIndexpaths = [[NSMutableArray alloc] init];
    self.aryImages = [[NSMutableArray alloc] init];
    keyWord = @"";
    delBarImageId = @"0";
    selIndex = -1;
    imgSelected = NO;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setNavImage];
    self.navigationController.navigationBar.topItem.title = @" ";
    
    limit = 10;
    offset = 0;
    totalRecords = 0;
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
    [self.view endEditing:YES];
    [self btnTopSearchClicked:btnTopSearch];
}

-(void)btnTopSearchClicked:(UIButton *)btnTopSearch {
    FindBarViewController *findBar = [[FindBarViewController alloc] initWithNibName:@"FindBarViewController" bundle:nil];
    [self.navigationController pushViewController:findBar animated:YES];
}
-(void)openRightMenu_Clicked:(UIButton *)btnRightMenu {
    [self.view endEditing:YES];
    [self btnFilterClicked:btnRightMenu];
}

-(void)btnFilterClicked:(id)sender
{
    LeftMenu_Popup *controller = [[LeftMenu_Popup alloc] initWithStyle:UITableViewStylePlain];
    controller.addEditDelegate = self;
    
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

-(void)configureTableViewHeader  {
    id headerView = [[[NSBundle mainBundle] loadNibNamed:@"AddEditAlbumHeaderView" owner:self options:nil] objectAtIndex:0];
    addEditAlbumHeaderView = (AddEditAlbumHeaderView *)headerView;
    [addEditAlbumHeaderView configureAddEditAlbumView:@"Search My Album"];
    
    addEditAlbumHeaderView.delegate = self;
}


-(void)configureTableViewFooter  {
    id footerView = [[[NSBundle mainBundle] loadNibNamed:@"AddEditAlbumFooterView" owner:self options:nil] objectAtIndex:0];
    addEditAlbumFooterView = (AddEditAlbumFooterView *)footerView;
    [addEditAlbumFooterView configureAddEditAlbumFooterView];
    if (self.album) {
        [addEditAlbumFooterView.btnCreateAlbum setTitle:@"Save" forState:UIControlStateNormal];
    }
    else {
        addEditAlbumFooterView.txtStatus.text = @"Active";
        [addEditAlbumFooterView.btnCreateAlbum setTitle:@"Save" forState:UIControlStateNormal];
    }
    
    addEditAlbumFooterView.delegate = self;
}

#pragma mark AddEditAlbumHeaderView Delegate

-(void)didSelectImageTitle:(NSString *)imgTitle {
    [self.view endEditing:YES];
    albumTitle = imgTitle;
}

-(void)openImageSelector {
    [self.view endEditing:YES];
    imgSelected = NO;
    maxImages = MAX_INPUT;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self showImagePicker];
    }];
}


#pragma mark AddEditAlbumFooterView Delegate
-(void)didOpenStatusOption {
    [self.view endEditing:YES];
    [self configureActionSheet];
}
-(void)createAlbum {
    [self.view endEditing:YES];
    [self callAddEditAlbumWebservice];
}
-(void)cancelToCreateAlbum {
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark View For Header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
       
        return addEditAlbumHeaderView;
    }
    else {
        return nil;
    }
}

#pragma mark Height For Header
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
        return 107;
}

#pragma mark View For Footer
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if ([self.aryImages count]>0) {
        return addEditAlbumFooterView;
    }
    else {
        return nil;
    }
}


#pragma mark Height For Footer
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if ([self.aryImages count]>0) {
        return 107;
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
    
        return [CommonUtils getArrayCountFromArray:self.aryImages];
    
}

#pragma mark Cell for Row
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.section) {
        case 0:
        {
            static NSString *simpleTableIdentifier = @"AddEditAlbumCell";
            
            AddEditAlbumCell *cell = (AddEditAlbumCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            if (cell == nil)
            {
                NSArray *nib;
                if([CommonUtils isiPad])
                {
                    nib = [[NSBundle mainBundle] loadNibNamed:@"AddEditAlbumCell" owner:self options:nil];
                }
                else
                {
                    nib = [[NSBundle mainBundle] loadNibNamed:@"AddEditAlbumCell" owner:self options:nil];
                }
                cell = [nib objectAtIndex:0];
            }
            [cell configureCellUI];
            cell.delegate = self;
            
            cell.txtImageTitle.tag = indexPath.row;
            cell.img.tag = indexPath.row;
            
            
            
            AlbumGalleryImage *galImage = [self.aryImages objectAtIndex:indexPath.row];
            
            if (galImage.gal_from_WS) {
                NSString *image_name = [galImage gal_bar_image_name];
                NSString *strImgURL = [NSString stringWithFormat:@"%@%@%@",WEBIMAGE_URL,ALBUM_GALLERY_IMAGE,image_name];
                NSURL *imgURL = [NSURL URLWithString:strImgURL];
                
                [cell.img sd_setImageWithURL:imgURL placeholderImage:[UIImage imageNamed:@"bar-gallery-small-placeholder.png"]];
                
                cell.txtImageTitle.text = galImage.gal_image_title;
            }
            else {
                cell.img.image = galImage.gal_localImage;
                cell.txtImageTitle.text = galImage.gal_image_title;
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

#pragma mark AddEditAlbumCell Delegate
-(void)btnDeleteTappedForIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    if ([self.aryImages count]==1) {
        ShowAlert(AlertTitle, @"You can not delete all images");
        return;
    }
    AlbumGalleryImage *galImage = [self.aryImages objectAtIndex:indexPath.row];
    if (galImage.gal_from_WS) {
        delBarImageId = galImage.gal_bar_image_id;
        selIndex = indexPath.row;
        [CommonUtils alertViewDelegateWithTitle:AlertTitle withMessage:@"Are you sure you want to delete this image ?" andTarget:self forCancelString:@"YES" forOtherButtonString:@"NO" withTag:300];
         NSLog(@"Deleted Bar Id = %@",delBarImageId);
    }
    else {
        [self.aryImages removeObjectAtIndex:indexPath.row];
        [self.tblView reloadData];
    }
}

-(void)openImagePickerControllerFromSelectedIndexPath:(NSIndexPath *)indexPath {
    selIndexPath = indexPath;
    imgSelected = YES;
    maxImages = 1;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self showImagePicker];
    }];
}

#pragma mark Cell Height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.section) {
        case 0:
            return 69;
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


#pragma mark - Open image picker
-(void)showImagePicker
{
#if 0
    UzysAppearanceConfig *appearanceConfig = [[UzysAppearanceConfig alloc] init];
    appearanceConfig.finishSelectionButtonColor = [UIColor blueColor];
    appearanceConfig.assetsGroupSelectedImageName = @"checker.png";
    [UzysAssetsPickerController setUpAppearanceConfig:appearanceConfig];
#endif
    
    UzysAssetsPickerController *picker = [[UzysAssetsPickerController alloc] init];
    picker.delegate = self;
    
    picker.maximumNumberOfSelectionVideo = 0;
    picker.maximumNumberOfSelectionPhoto = maxImages;
    
    [self presentViewController:picker animated:YES completion:^{
    }];
}

#pragma mark  UzysAssetsPickerControllerDelegate methods
- (void)UzysAssetsPickerController:(UzysAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    //self.imageView.backgroundColor = [UIColor clearColor];
    DLog(@"assets %@",assets);
    if(assets.count ==1)
    {
        //self.labelDescription.text = [NSString stringWithFormat:@"%ld asset selected",(unsigned long)assets.count];
    }
    else
    {
        //self.labelDescription.text = [NSString stringWithFormat:@"%ld assets selected",(unsigned long)assets.count];
    }
    
    for (ALAsset *alAsset in assets) {
        if([[alAsset valueForProperty:@"ALAssetPropertyType"] isEqualToString:@"ALAssetTypePhoto"]) //Photo
        {
            UIImage *img = [UIImage imageWithCGImage:alAsset.defaultRepresentation.fullResolutionImage
                                                scale:alAsset.defaultRepresentation.scale
                                          orientation:(UIImageOrientation)alAsset.defaultRepresentation.orientation];
            NSLog(@"%@",[[alAsset defaultRepresentation] filename]);
            
            
            if (imgSelected) {
                NSDictionary *dictImage = [@{@"bar_image_name":[[alAsset defaultRepresentation] filename],@"image":img,@"type":@"image",@"image_title":[[self.aryImages objectAtIndex:selIndexPath.row] gal_image_title],@"gal_pre_img_name":[[self.aryImages objectAtIndex:selIndexPath.row] gal_pre_img_name],@"gal_pre_img_id":[[self.aryImages objectAtIndex:selIndexPath.row] gal_pre_img_id]} mutableCopy];
                
                AlbumGalleryImage *galImage = [AlbumGalleryImage getAlbumGalleryImageWithLocalDictionary:dictImage];
                galImage.isNewImageAdded = NO;
                [self.aryImages replaceObjectAtIndex:[selIndexPath row] withObject:galImage];
                
            }
            else {
                NSDictionary *dictImage = [@{@"bar_image_name":[[alAsset defaultRepresentation] filename],@"image":img,@"type":@"image",@"image_title":@""} mutableCopy];
                
                AlbumGalleryImage *galImage = [AlbumGalleryImage getAlbumGalleryImageWithLocalDictionary:dictImage];
                galImage.isNewImageAdded = YES;
                [self.aryImages addObject:galImage];
            }
            
        }
    }
    
    [self.tblView reloadData];
}

- (void)UzysAssetsPickerControllerDidExceedMaximumNumberOfSelection:(UzysAssetsPickerController *)picker
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:NSLocalizedStringFromTable(@"Exceed Maximum Number Of Selection", @"UzysAssetsPickerController", nil)
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}


#pragma mark - TextField

#pragma mark Textfield Delegates
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    AlbumGalleryImage *galImage = [self.aryImages objectAtIndex:textField.tag];
    galImage.gal_image_title = textField.text;
    [self.aryImages replaceObjectAtIndex:textField.tag withObject:galImage];
    [self.tblView reloadData];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}



#pragma mark - UIAction Sheet

-(void)configureActionSheet {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Status" delegate:self cancelButtonTitle:@"Cancel"destructiveButtonTitle:nil otherButtonTitles:@"Active",@"Inactive",nil];
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            addEditAlbumFooterView.txtStatus.text = @"Active";
            break;
        case 1:
            addEditAlbumFooterView.txtStatus.text = @"Inactive";
            break;
        default:
            break;
    }
}


#pragma mark - Alert View
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 300) {
        if (buttonIndex == 0) {
            [self callDeleteAlbumImageListWebservice];
        }
    }
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
-(void)callGetAlbumWebservice {
    [CommonUtils callWebservice:@selector(edit_album) forTarget:self];
}

-(void)callDeleteAlbumImageListWebservice {
    [CommonUtils callWebservice:@selector(remove_gallery_image) forTarget:self];
}

-(void)callAddEditAlbumWebservice {
    [CommonUtils callWebservice:@selector(add_album) forTarget:self];
}

#pragma mark - Webservice
#pragma mark edit_album
-(void)edit_album
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.mode = MBProgressHUDModeIndeterminate;
    
    User *user = [CommonUtils getUserLoginDetails];
    NSString *user_id = [user user_id];
    NSString *device_id = [user device_id];
    NSString *unique_code =[user unique_code];
    
    NSString *barGalleryId = [self getBarGalleryId];
    
    //192.168.1.27/ADB/api/edit_album
    NSString *myURL = [NSString stringWithFormat:@"%@edit_album",WEBSERVICE_URL];
    NSMutableURLRequest *Request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: myURL]];
    NSString *params = [NSString stringWithFormat:@"user_id=%@&device_id=%@&unique_code=%@&limit=%ld&offset=%ld&bar_gallery_id=%@",user_id,device_id,unique_code,(long)limit,(long)offset,barGalleryId];
    
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
                albumDetail = [AlbumDetail getAlbumDetailWithDictionary:tempDict];
                for (AlbumGalleryImage *galImage in albumDetail.aryGalImages) {
                    [self.aryImages addObject:galImage];
                }
                //self.aryImages = [albumDetail.aryGalImages mutableCopy];
                addEditAlbumHeaderView.txtAlbumTitle.text = albumDetail.album.album_title;
                albumTitle = albumDetail.album.album_title;
                addEditAlbumFooterView.txtStatus.text = albumDetail.album.album_status;
                [self.tblView reloadData];
            }
        }
        else {
            
        }
        
    }];
    
}

-(NSString *)getBarGalleryId {
    if (self.album) {
        return self.album.album_bar_gallery_id;
    }
    else {
        return @"";
    }
}

#pragma mark edit_album
-(void)add_album {
    if ([albumTitle length]==0) {
        ShowAlert(AlertTitle, @"Please enter album title");
        return;
    }
    User *user = [CommonUtils getUserLoginDetails];
    NSString *user_id = [user user_id];
    NSString *device_id = [user device_id];
    NSString *unique_code =[user unique_code];
    NSString *barGalleryId = [self getBarGalleryId];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.mode = MBProgressHUDModeIndeterminate;
    
    //192.168.1.27/ADB/api/add_album
    NSString *urlString = [NSString stringWithFormat:@"%@add_album",WEBSERVICE_URL];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    for (int i=0; i<[self.aryImages count]; i++)
    {
        AlbumGalleryImage *galImage  =[self.aryImages objectAtIndex:i];
        UIImage* image = [[self.aryImages objectAtIndex:i] gal_localImage];//[[self.aryImages objectAtIndex:i] valueForKey:@"image"];
        NSData *imgData = UIImageJPEGRepresentation(image, 0.1);
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        if ([galImage gal_from_WS]) {
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: multipart/form-data; name=\"photo_image[]\"; filename=\"WS_%@\"\r\n",[[self.aryImages objectAtIndex:i] gal_bar_image_name]] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        else {
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: multipart/form-data; name=\"photo_image[]\"; filename=\"DEVICE_%@\"\r\n",[[self.aryImages objectAtIndex:i] gal_bar_image_name]] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        [body appendData:[@"Content-Type: multipart/form-data\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imgData];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
        //pre_img
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"pre_img[]"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n",[galImage gal_pre_img_name]] dataUsingEncoding:NSUTF8StringEncoding]];
        
        //image_id
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"image_id[]"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n",[galImage gal_pre_img_id]] dataUsingEncoding:NSUTF8StringEncoding]];
        
        //image_title
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"image_title[]"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n",[galImage gal_image_title]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    //user_id
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"user_id"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n",user_id] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //device_id
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"device_id"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n",device_id] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //unique_code
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"unique_code"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n",unique_code] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //bar_gallery_id
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"bar_gallery_id"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n",barGalleryId] dataUsingEncoding:NSUTF8StringEncoding]];
   
    //status
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"status"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n",addEditAlbumFooterView.txtStatus.text] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //title
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"title"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n",albumTitle] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
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
                [self.navigationController popViewControllerAnimated:YES];
                if (self.album) {
                    ShowAlert(AlertTitle, @"Album updated successfully!");
                }
                else {
                    ShowAlert(AlertTitle, @"Album added successfully!");
                }
                
            }
        }
        else {
        }
        [self.tblView reloadData];
    }];
}

#pragma mark remove_gallery_image
-(void)remove_gallery_image
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.mode = MBProgressHUDModeIndeterminate;
    
    User *user = [CommonUtils getUserLoginDetails];
    NSString *user_id = [user user_id];
    NSString *device_id = [user device_id];
    NSString *unique_code =[user unique_code];
    
    
    //192.168.1.27/ADB/api/favoritebar
    NSString *myURL = [NSString stringWithFormat:@"%@remove_gallery_image",WEBSERVICE_URL];
    NSMutableURLRequest *Request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: myURL]];
    NSString *params = [NSString stringWithFormat:@"user_id=%@&device_id=%@&unique_code=%@&limit=%ld&offset=%ld&bar_image_id=%@",user_id,device_id,unique_code,(long)limit,(long)offset,delBarImageId];
    
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
                [self.aryImages removeObjectAtIndex:selIndex];
                selIndex = -1;
                [self.tblView reloadData];
            }
        }
        else {
            
        }
        
    }];
    
}


@end
