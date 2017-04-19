//
//  LeftMenu_Popup.h
//  GoodBoater
//
//  Created by admin on 14/05/15.
//  Copyright (c) 2015 spaculus. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BarSearchViewController.h"
#import "BeerDirectoryViewController.h"
#import "BeerDirectoryDetailViewController.h"
#import "CocktailDirectoryViewController.h"
#import "CocktailDirectoryDetailViewController.h"
#import "LiquorDirectoryViewController.h"
#import "LiquorDirectoryDetailViewController.h"
#import "TaxiDirectoryViewController.h"
#import "TaxiDirectoryDetailViewController.h"
#import "PhotoGalleryViewController.h"
#import "PhotoGalleryDetailViewController.h"
#import "BarListViewController.h"
#import "BarDetailFullMugViewController.h"
#import "BarDetailHalfMugViewController.h"
#import "EventDetailViewController.h"
#import "EventListViewController.h"
#import "DashboardViewController.h"
#import "MyProfileViewController.h"

#import "MyFavoriteBarViewController.h"
#import "MyFavoriteBeerViewController.h"
#import "MyFavoriteCocktailViewController.h"
#import "MyFavoriteLiquorViewController.h"

#import "MyAlbumViewController.h"
#import "AddEditAlbumViewController.h"

#import "PrivacySettingViewController.h"

#import "ChangePasswordViewController.h"

#import "ContactUsViewController.h"
#import "CMSPageViewController.h"
#import "MapViewController.h"
#import "GetDirectionsViewController.h"
#import "DirectionListViewController.h"

#import "FindBarViewController.h"

#import "BarSearchHappyHoursViewController.h"

#import "FindBarAroundMeViewController.h"

#import "BeerSuggestViewController.h"
#import "CocktailSuggestViewController.h"
#import "LiquorSuggestViewController.h"
#import "BarSuggestViewController.h"

#import "BarSpecialHoursViewController.h"

#import "BarReviewViewController.h"
#import "DirectoryCommentViewController.h"
#import "DirectoryReplyViewController.h"

#import "ArticleViewController.h"
#import "ArticleDetailViewController.h"

#import "TriviaGameViewController.h"
#import "TriviaStartViewController.h"
#import "TriviaGameResultViewController.h"



@interface LeftMenu_Popup : UITableViewController

@property(nonatomic, strong) BarSearchViewController *barDelegate;
@property(nonatomic, strong) BeerDirectoryViewController *beerDelegate;
@property(nonatomic, strong) BeerDirectoryDetailViewController *beerDetailDelegate;
@property(nonatomic, strong) CocktailDirectoryViewController *cocktailDelegate;
@property(nonatomic, strong) LiquorDirectoryViewController *liquorDelegate;
@property(nonatomic, strong) TaxiDirectoryViewController *taxiDelegate;
@property(nonatomic, strong) TaxiDirectoryDetailViewController *taxiDetailDelegate;
@property(nonatomic, strong) PhotoGalleryViewController *photoDelegate;
@property(nonatomic, strong) PhotoGalleryDetailViewController *photoDetailDelegate;
@property(nonatomic, strong) BarListViewController *barListDelegate;
@property(nonatomic, strong) BarDetailFullMugViewController *barDetailFullMugDelegate;
@property(nonatomic, strong) BarDetailHalfMugViewController *barDetailHalfMugDelegate;
@property(nonatomic, strong) EventDetailViewController *eventDetailDelegate;
@property(nonatomic, strong) EventListViewController *eventListDelegate;
@property(nonatomic, strong) CocktailDirectoryDetailViewController *cocktailDetailDelegate;
@property(nonatomic, strong) LiquorDirectoryDetailViewController *liquorDetailDelegate;
@property(nonatomic, strong) DashboardViewController *dashBoardDelegate;
@property(nonatomic, strong) MyProfileViewController *myProfileDelegate;
@property(nonatomic, strong) MyFavoriteBarViewController *myFavBarDelegate;
@property(nonatomic, strong) MyFavoriteBeerViewController *myFavBeerDelegate;
@property(nonatomic, strong) MyFavoriteCocktailViewController *myFavCocktailDelegate;
@property(nonatomic, strong) MyFavoriteLiquorViewController *myFavLiquorDelegate;
@property(nonatomic, strong) MyAlbumViewController *myAlbumdDelegate;
@property(nonatomic, strong) AddEditAlbumViewController *addEditDelegate;
@property(nonatomic, strong) PrivacySettingViewController *privacyDelegate;
@property(nonatomic, strong) ChangePasswordViewController *changePwdDelegate;
@property(nonatomic, strong) ContactUsViewController *contactUsDelegate;
@property(nonatomic, strong) CMSPageViewController *cmsPageDelegate;
@property(nonatomic, strong) MapViewController *mapDelegate;
@property(nonatomic, strong) GetDirectionsViewController *getDirectionDelegate;
@property(nonatomic, strong) DirectionListViewController *directionListDelegate;
@property(nonatomic, strong) FindBarViewController *findBarDelegate;
@property(nonatomic, strong) BarSearchHappyHoursViewController *barSearchHappyHourDelegate;
@property(nonatomic, strong) FindBarAroundMeViewController *findBarAroundMeDelagate;
@property(nonatomic, strong) BeerSuggestViewController *suggestBeerDelegate;
@property(nonatomic, strong) CocktailSuggestViewController *suggestCocktailDelegate;
@property(nonatomic, strong) LiquorSuggestViewController *suggestLiquorDelegate;
@property(nonatomic, strong) BarSuggestViewController *suggestBarDelegate;

@property(nonatomic, strong) BarSpecialHoursViewController *barSpecialHourDelegate;

@property(nonatomic, strong) BarReviewViewController *barReviewDelegate;
@property(nonatomic, strong) DirectoryCommentViewController *directoryCommentDelegate;
@property(nonatomic, strong) DirectoryReplyViewController *replyDelegate;


@property(nonatomic, strong) ArticleViewController *articleDelegate;
@property(nonatomic, strong) ArticleDetailViewController *articleDetailDelegate;

@property(nonatomic, strong) TriviaGameViewController *gameDelegate;
@property(nonatomic, strong) TriviaStartViewController *startGameDelegate;
@property(nonatomic, strong) TriviaGameResultViewController *gameResultDelegate;

@property(nonatomic, strong) NSArray *aryItems;
@end
