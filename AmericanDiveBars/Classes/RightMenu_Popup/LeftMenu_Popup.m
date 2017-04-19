//
//  LeftMenu_Popup.m
//  GoodBoater
//
//  Created by admin on 14/05/15.
//  Copyright (c) 2015 spaculus. All rights reserved.
//

#import "LeftMenu_Popup.h"
#import "LeftPopupMenuCell.h"
#import "HomeViewController.h"

@interface LeftMenu_Popup ()<UITableViewDataSource,UITableViewDelegate,TTTAttributedLabelDelegate>
{
    
    NSString *userType;
    
    NSArray *aryMenuItems;
    NSString *strDeviceToken;
}
@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) NSURLConnection *connectionLogout;

@end

@implementation LeftMenu_Popup

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    
    aryMenuItems = self.aryItems;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"LeftPopupMenuCell" bundle:nil] forCellReuseIdentifier:@"LeftPopupMenuCell"];
    self.tableView.backgroundColor = [UIColor colorWithRed:76.0/255.0 green:65.0/255.0 blue:41.0/255.0 alpha:1.0];
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [aryMenuItems count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellHeight = [self heightMenuCellAtIndexPath:indexPath];
    return cellHeight;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 115.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self MenuCellAtIndexPath:indexPath];
}

- (LeftPopupMenuCell *)MenuCellAtIndexPath:(NSIndexPath *)indexPath
{
    static LeftPopupMenuCell *cell = nil;
    cell = [self.tableView dequeueReusableCellWithIdentifier:@"LeftPopupMenuCell"];
    [self configureMenuCell:cell atIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

-(void)configureMenuCell:(LeftPopupMenuCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.lblMenuName.delegate = self;
    
    if(indexPath.row == 0)
    {
        if ([CommonUtils isLoggedIn]) {
            User *user = [CommonUtils getUserLoginDetails];
            if ([user.user_image length]==0) {
                
                cell.imgMenu.image = [UIImage imageNamed:[[aryMenuItems objectAtIndex:indexPath.row] valueForKey:@"image"]];
                cell.lblMenuName.text = [[aryMenuItems objectAtIndex:indexPath.row] valueForKey:@"title"];
            }
            else {
                NSString *strImgURL = [[NSString stringWithFormat:@"%@%@%@",WEBIMAGE_URL,USER_PROFILE_IMAGE,user.user_image] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                NSURL *imgURL = [NSURL URLWithString:strImgURL];
                
                [cell.imgMenu sd_setImageWithURL:imgURL placeholderImage:[UIImage imageNamed:[[aryMenuItems objectAtIndex:indexPath.row] valueForKey:@"image"]]];
                cell.lblMenuName.text = user.user_name;
                
                cell.imgMenu.layer.cornerRadius = cell.imgMenu.frame.size.height /2;
                cell.imgMenu.layer.masksToBounds = YES;
            }
            
        }
        else {
            cell.imgMenu.image = [UIImage imageNamed:[[aryMenuItems objectAtIndex:indexPath.row] valueForKey:@"image"]];
            cell.lblMenuName.text = [[aryMenuItems objectAtIndex:indexPath.row] valueForKey:@"title"];
            
            cell.imgMenu.layer.cornerRadius = 0.0f;
            cell.imgMenu.layer.masksToBounds = YES;
        }
        
    }
    else {
        NSLog(@"%@",indexPath);
        cell.lblMenuName.text = [[aryMenuItems objectAtIndex:indexPath.row] valueForKey:@"title"];
        cell.imgMenu.image = [UIImage imageNamed:[[aryMenuItems objectAtIndex:indexPath.row] valueForKey:@"image"]];
        
        cell.imgMenu.layer.cornerRadius = 0.0f;
        cell.imgMenu.layer.masksToBounds = YES;

    }

    
    cell.contentView.backgroundColor = [UIColor colorWithRed:76.0/255.0 green:65.0/255.0 blue:41.0/255.0 alpha:1.0];
    cell.backgroundColor = [UIColor colorWithRed:76.0/255.0 green:65.0/255.0 blue:41.0/255.0 alpha:1.0];
}

- (CGFloat)heightMenuCellAtIndexPath:(NSIndexPath *)indexPath
{
    static LeftPopupMenuCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tableView dequeueReusableCellWithIdentifier:@"LeftPopupMenuCell"];
    });
    
    [self configureMenuCell:sizingCell atIndexPath:indexPath];
    return [self calculateHeightForConfiguredSizingCell:sizingCell];
}

#pragma mark Calculate Height for Cell
- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell {
    
    sizingCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tableView.frame), CGRectGetHeight(sizingCell.bounds));
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1.0f; // Add 1.0f for the cell separator height
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([userType isEqualToString:@"business"])
    {
        if(indexPath.row == 7)
        {
            [CommonUtils alertViewDelegateWithTitle:AlertTitle withMessage:@"Are you sure you want to logout?" andTarget:self forCancelString:@"YES" forOtherButtonString:@"NO" withTag:919];
        }
    }
    else
    {
        if(indexPath.row == 10)
        {
            [CommonUtils alertViewDelegateWithTitle:AlertTitle withMessage:@"Are you sure you want to logout?" andTarget:self forCancelString:@"YES" forOtherButtonString:@"NO" withTag:919];
        }
    }
    if([self.barDelegate respondsToSelector:@selector(selectedTableRow:)])
    {
        [self.barDelegate selectedTableRow:indexPath.row];
    }
    if([self.beerDelegate respondsToSelector:@selector(selectedTableRow:)])
    {
        [self.beerDelegate selectedTableRow:indexPath.row];
    }
    if([self.beerDetailDelegate respondsToSelector:@selector(selectedTableRow:)])
    {
        [self.beerDetailDelegate selectedTableRow:indexPath.row];
    }
    if([self.cocktailDelegate respondsToSelector:@selector(selectedTableRow:)])
    {
        [self.cocktailDelegate selectedTableRow:indexPath.row];
    }
    if([self.cocktailDetailDelegate respondsToSelector:@selector(selectedTableRow:)])
    {
        [self.cocktailDetailDelegate selectedTableRow:indexPath.row];
    }
    if([self.liquorDelegate respondsToSelector:@selector(selectedTableRow:)])
    {
        [self.liquorDelegate selectedTableRow:indexPath.row];
    }
    if([self.liquorDetailDelegate respondsToSelector:@selector(selectedTableRow:)])
    {
        [self.liquorDetailDelegate selectedTableRow:indexPath.row];
    }
    if([self.taxiDelegate respondsToSelector:@selector(selectedTableRow:)])
    {
        [self.taxiDelegate selectedTableRow:indexPath.row];
    }
    if([self.taxiDetailDelegate respondsToSelector:@selector(selectedTableRow:)])
    {
        [self.taxiDetailDelegate selectedTableRow:indexPath.row];
    }
    if([self.photoDelegate respondsToSelector:@selector(selectedTableRow:)])
    {
        [self.photoDelegate selectedTableRow:indexPath.row];
    }
    if([self.photoDetailDelegate respondsToSelector:@selector(selectedTableRow:)])
    {
        [self.photoDetailDelegate selectedTableRow:indexPath.row];
    }
    if([self.barListDelegate respondsToSelector:@selector(selectedTableRow:)])
    {
        [self.barListDelegate selectedTableRow:indexPath.row];
    }
    if([self.barDetailFullMugDelegate respondsToSelector:@selector(selectedTableRow:)])
    {
        [self.barDetailFullMugDelegate selectedTableRow:indexPath.row];
    }
    if([self.barDetailHalfMugDelegate respondsToSelector:@selector(selectedTableRow:)])
    {
        [self.barDetailHalfMugDelegate selectedTableRow:indexPath.row];
    }
    if([self.eventDetailDelegate respondsToSelector:@selector(selectedTableRow:)])
    {
        [self.eventDetailDelegate selectedTableRow:indexPath.row];
    }
    if([self.eventListDelegate respondsToSelector:@selector(selectedTableRow:)])
    {
        [self.eventListDelegate selectedTableRow:indexPath.row];
    }
    if([self.dashBoardDelegate respondsToSelector:@selector(selectedTableRow:)])
    {
        [self.dashBoardDelegate selectedTableRow:indexPath.row];
    }
    if([self.myProfileDelegate respondsToSelector:@selector(selectedTableRow:)])
    {
        [self.myProfileDelegate selectedTableRow:indexPath.row];
    }
    if([self.myFavBarDelegate respondsToSelector:@selector(selectedTableRow:)])
    {
        [self.myFavBarDelegate selectedTableRow:indexPath.row];
    }
    if([self.myFavBeerDelegate respondsToSelector:@selector(selectedTableRow:)])
    {
        [self.myFavBeerDelegate selectedTableRow:indexPath.row];
    }
    if([self.myFavCocktailDelegate respondsToSelector:@selector(selectedTableRow:)])
    {
        [self.myFavCocktailDelegate selectedTableRow:indexPath.row];
    }
    if([self.myFavLiquorDelegate respondsToSelector:@selector(selectedTableRow:)])
    {
        [self.myFavLiquorDelegate selectedTableRow:indexPath.row];
    }
    if([self.myAlbumdDelegate respondsToSelector:@selector(selectedTableRow:)])
    {
        [self.myAlbumdDelegate selectedTableRow:indexPath.row];
    }
    if([self.addEditDelegate respondsToSelector:@selector(selectedTableRow:)])
    {
        [self.addEditDelegate selectedTableRow:indexPath.row];
    }
    if([self.privacyDelegate respondsToSelector:@selector(selectedTableRow:)])
    {
        [self.privacyDelegate selectedTableRow:indexPath.row];
    }
    if([self.changePwdDelegate respondsToSelector:@selector(selectedTableRow:)])
    {
        [self.changePwdDelegate selectedTableRow:indexPath.row];
    }
    if([self.contactUsDelegate respondsToSelector:@selector(selectedTableRow:)])
    {
        [self.contactUsDelegate selectedTableRow:indexPath.row];
    }
    if([self.cmsPageDelegate respondsToSelector:@selector(selectedTableRow:)])
    {
        [self.cmsPageDelegate selectedTableRow:indexPath.row];
    }
    if([self.mapDelegate respondsToSelector:@selector(selectedTableRow:)])
    {
        [self.mapDelegate selectedTableRow:indexPath.row];
    }
    if([self.getDirectionDelegate respondsToSelector:@selector(selectedTableRow:)])
    {
        [self.getDirectionDelegate selectedTableRow:indexPath.row];
    }
    if([self.directionListDelegate respondsToSelector:@selector(selectedTableRow:)])
    {
        [self.directionListDelegate selectedTableRow:indexPath.row];
    }
    if([self.findBarDelegate respondsToSelector:@selector(selectedTableRow:)])
    {
        [self.findBarDelegate selectedTableRow:indexPath.row];
    }
    if([self.barSearchHappyHourDelegate respondsToSelector:@selector(selectedTableRow:)])
    {
        [self.barSearchHappyHourDelegate selectedTableRow:indexPath.row];
    }
    if([self.findBarAroundMeDelagate respondsToSelector:@selector(selectedTableRow:)])
    {
        [self.findBarAroundMeDelagate selectedTableRow:indexPath.row];
    }
    if([self.suggestBeerDelegate respondsToSelector:@selector(selectedTableRow:)])
    {
        [self.suggestBeerDelegate selectedTableRow:indexPath.row];
    }
    if([self.suggestCocktailDelegate respondsToSelector:@selector(selectedTableRow:)])
    {
        [self.suggestCocktailDelegate selectedTableRow:indexPath.row];
    }
    if([self.suggestLiquorDelegate respondsToSelector:@selector(selectedTableRow:)])
    {
        [self.suggestLiquorDelegate selectedTableRow:indexPath.row];
    }
    if([self.suggestBarDelegate respondsToSelector:@selector(selectedTableRow:)])
    {
        [self.suggestBarDelegate selectedTableRow:indexPath.row];
    }
    if([self.barSpecialHourDelegate respondsToSelector:@selector(selectedTableRow:)])
    {
        [self.barSpecialHourDelegate selectedTableRow:indexPath.row];
    }
    if([self.barReviewDelegate respondsToSelector:@selector(selectedTableRow:)])
    {
        [self.barReviewDelegate selectedTableRow:indexPath.row];
    }
    if([self.directoryCommentDelegate respondsToSelector:@selector(selectedTableRow:)])
    {
        [self.directoryCommentDelegate selectedTableRow:indexPath.row];
    }
    if([self.replyDelegate respondsToSelector:@selector(selectedTableRow:)])
    {
        [self.replyDelegate selectedTableRow:indexPath.row];
    }
    if([self.articleDelegate respondsToSelector:@selector(selectedTableRow:)])
    {
        [self.articleDelegate selectedTableRow:indexPath.row];
    }
    if([self.articleDetailDelegate respondsToSelector:@selector(selectedTableRow:)])
    {
        [self.articleDetailDelegate selectedTableRow:indexPath.row];
    }
    if([self.gameDelegate respondsToSelector:@selector(selectedTableRow:)])
    {
        [self.gameDelegate selectedTableRow:indexPath.row];
    }
    if([self.startGameDelegate respondsToSelector:@selector(selectedTableRow:)])
    {
        [self.startGameDelegate selectedTableRow:indexPath.row];
    }
    if([self.gameResultDelegate respondsToSelector:@selector(selectedTableRow:)])
    {
        [self.gameResultDelegate selectedTableRow:indexPath.row];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 919)
    {
        if (buttonIndex == 0)
        {
            BOOL hasConnected = [CommonUtils connected];
            if (hasConnected)
            {
                
            }
            else
            {
                //ShowAlert(AlertTitle, NO_INTERNET_CONNECTION_ERROR);
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
