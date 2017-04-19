//
//  HomeViewController.m
//  AmericanDiveBars
//
//  Created by spaculus on 8/27/15.
//  Copyright (c) 2015 spaculus. All rights reserved.
//

#import "HomeViewController.h"
#import "LoginViewController.h"
#import "UIViewController+AMSlideMenu.h"
#import "HomeCell.h"

// #import "BarSearchViewController.h"
#import "FindBarViewController.h"
#import "BeerDirectoryViewController.h"
#import "CocktailDirectoryViewController.h"
#import "LiquorDirectoryViewController.h"
#import "TaxiDirectoryViewController.h"
#import "PhotoGalleryViewController.h"
#import "DashboardViewController.h"
#import "TriviaStartViewController.h"
#import "ArticleViewController.h"

static NSString * const HomeCellIdentifier = @"HomeCellIdentifier";

@interface HomeViewController ()
{
    NSArray *aryHomeOptions;
}
@end

@implementation HomeViewController

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self registerCell];
        return self;
    }
    else {
        return nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setStatusBarVisibility];

    aryHomeOptions = @[@{@"name":@"BAR & EVENT \n SEARCH",@"image":@"bar_home.png"},
                       @{@"name":@"BEER DIRECTORY",@"image":@"beer_home.png"},
                       @{@"name":@"COCKTAIL RECIPES",@"image":@"cocktail_home.png"},
                       @{@"name":@"LIQUOR DIRECTORY",@"image":@"liquor_home.png"},
                       @{@"name":@"TRIVIA GAME",@"image":@"trivia-game_home.png"},
                       @{@"name":@"ARTICLES",@"image":@"article_home.png"},
                       @{@"name":@"TAXI DIRECTORY",@"image":@"taxi_home.png"},
                       @{@"name":@"MY DASHBOARD",@"image":@"dashboard_home.png"}];
    [self registerCell];
    
    
}

-(void)viewDidLayoutSubviews {
    NSLog(@"nav = %lf",self.navigationController.navigationBar.frame.size.height);
}

-(void)setStatusBarVisibility {
    
  
    

    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setNavigationBarImage];
}

-(void)setNavigationBarImage {
    if (![CommonUtils isiPad]) {
        if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
            
            if ([CommonUtils isIPhone4_Landscape]) {
                [CommonUtils setNavigationBarImage:[[UIImage imageNamed:@"nav-4-L.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch] forNavigationBar:self.navigationController.navigationBar];
            }
            else if ([CommonUtils isIPhone5_Landscape]) {
                [CommonUtils setNavigationBarImage:[[UIImage imageNamed:@"nav-5-L.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch] forNavigationBar:self.navigationController.navigationBar];
            }
            else if ([CommonUtils isIPhone6_Landscape]) {
                [CommonUtils setNavigationBarImage:[[UIImage imageNamed:@"nav-6-L.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch] forNavigationBar:self.navigationController.navigationBar];
            }
            else {
                [CommonUtils setNavigationBarImage:[[UIImage imageNamed:@"nav-6p-L.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch] forNavigationBar:self.navigationController.navigationBar];
            }
            
        }
        else {
            
            if ([CommonUtils isIPhone4]) {
                [CommonUtils setNavigationBarImage:[[UIImage imageNamed:@"nav-4-5-P.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch] forNavigationBar:self.navigationController.navigationBar];
            }
            else if ([CommonUtils isIPhone5]) {
                [CommonUtils setNavigationBarImage:[[UIImage imageNamed:@"nav-4-5-P.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch] forNavigationBar:self.navigationController.navigationBar];
            }
            else if ([CommonUtils isIPhone6]) {
                [CommonUtils setNavigationBarImage:[[UIImage imageNamed:@"nav-6-P.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch] forNavigationBar:self.navigationController.navigationBar];
            }
            else {
                [CommonUtils setNavigationBarImage:[[UIImage imageNamed:@"nav-6p-P.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch] forNavigationBar:self.navigationController.navigationBar];
            }
            
        }
    }
    else {
        if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
            [CommonUtils setNavigationBarImage:[[UIImage imageNamed:@"nav-ipad-L.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch] forNavigationBar:self.navigationController.navigationBar];
        }
        else {
            [CommonUtils setNavigationBarImage:[[UIImage imageNamed:@"nav-ipad-P.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch] forNavigationBar:self.navigationController.navigationBar];
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    CGSize blankImageSize = CGSizeMake(self.view.bounds.size.width, 64);
    UIImage *blank = [CommonUtils imageFromColor:[UIColor colorWithRed:187.0/255.0 green:124.0/255.0 blue:37.0/255.0 alpha:1.0] forSize:blankImageSize withCornerRadius:0.0];
    [CommonUtils setNavigationBarImage:blank forNavigationBar:self.navigationController.navigationBar];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Collection View
-(void)registerCell {
    [self.cv registerNib:[UINib nibWithNibName:@"HomeCell" bundle:nil] forCellWithReuseIdentifier:HomeCellIdentifier];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return aryHomeOptions.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    static HomeCell *cell = nil;
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:HomeCellIdentifier forIndexPath:indexPath];
    
    switch (indexPath.item) {
        case 0:
            cell.backgroundColor = [UIColor colorWithRed:187.0/255.0 green:124.0/255.0 blue:37.0/255.0 alpha:1.0];
            break;
        case 1:
            cell.backgroundColor = [UIColor colorWithRed:143.0/255.0 green:98.0/255.0 blue:30.0/255.0 alpha:1.0];
            break;
        case 2:
            cell.backgroundColor = [UIColor colorWithRed:143.0/255.0 green:98.0/255.0 blue:30.0/255.0 alpha:1.0];
            break;
        case 3:
            cell.backgroundColor = [UIColor colorWithRed:187.0/255.0 green:124.0/255.0 blue:37.0/255.0 alpha:1.0];
            break;
        case 4:
            cell.backgroundColor = [UIColor colorWithRed:187.0/255.0 green:124.0/255.0 blue:37.0/255.0 alpha:1.0];
            break;
        case 5:
            cell.backgroundColor = [UIColor colorWithRed:143.0/255.0 green:98.0/255.0 blue:30.0/255.0 alpha:1.0];
            break;
        case 6:
            cell.backgroundColor = [UIColor colorWithRed:143.0/255.0 green:98.0/255.0 blue:30.0/255.0 alpha:1.0];
            break;
        case 7:
            cell.backgroundColor = [UIColor colorWithRed:187.0/255.0 green:124.0/255.0 blue:37.0/255.0 alpha:1.0];
            break;
            
        default:
            break;
    }
    
    NSDictionary *dict = [aryHomeOptions objectAtIndex:indexPath.item];
    cell.lblHome.text = [dict valueForKey:@"name"];
    cell.imgHome.image = [UIImage imageNamed:[dict valueForKey:@"image"]];
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    return CGSizeMake(collectionView.frame.size.width/2, collectionView.frame.size.height/3);
    if(![CommonUtils isiPad])
    {
        if([CommonUtils isIPhone6])
        {
            return CGSizeMake(collectionView.frame.size.width/2, 150);//return CGSizeMake(179, 191);162
        }
        else if ([CommonUtils isIPhone6Plus])
        {
            return CGSizeMake(collectionView.frame.size.width/2, 167);//CGSizeMake(199, 214);179
        }
        else
        {
            return CGSizeMake(collectionView.frame.size.width/2, 121);//CGSizeMake(151, 165);137
        }
    }
    else
    {
        return CGSizeMake(collectionView.frame.size.width/2, 243);//CGSizeMake(376, 335);251
    }
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.item) {
        case 0:
            {
                FindBarViewController *findBar = [[FindBarViewController alloc]  initWithNibName:@"FindBarViewController" bundle:nil];
                [self.navigationController pushViewController:findBar animated:YES];
                
                //                BarSearchViewController *barSearch = [[BarSearchViewController alloc]  initWithNibName:@"BarSearchViewController" bundle:nil];
                //                [self.navigationController pushViewController:barSearch animated:YES];
            }
            break;
        case 1:
            {
                BeerDirectoryViewController *beer = [[BeerDirectoryViewController alloc]  initWithNibName:@"BeerDirectoryViewController" bundle:nil];
                [self.navigationController pushViewController:beer animated:YES];
            }
            break;
        case 2:
            {
                CocktailDirectoryViewController *cocktail = [[CocktailDirectoryViewController alloc]  initWithNibName:@"CocktailDirectoryViewController" bundle:nil];
                [self.navigationController pushViewController:cocktail animated:YES];
            }
            break;
        case 3:
            {
                LiquorDirectoryViewController *liquor = [[LiquorDirectoryViewController alloc]  initWithNibName:@"LiquorDirectoryViewController" bundle:nil];
                [self.navigationController pushViewController:liquor animated:YES];
            }
            break;
            
        case 4:
        {
            TriviaStartViewController *triviaStart = [[TriviaStartViewController alloc]  initWithNibName:@"TriviaStartViewController" bundle:nil];
            [self.navigationController pushViewController:triviaStart animated:YES];
        }
            break;
        case 5:
        {
            
            ArticleViewController *article = [[ArticleViewController alloc]  initWithNibName:@"ArticleViewController" bundle:nil];
            [self.navigationController pushViewController:article animated:YES];
            
            //                PhotoGalleryViewController *photo = nil;
            //                if ([CommonUtils isiPad]) {
            //                    photo = [[PhotoGalleryViewController alloc]  initWithNibName:@"PhotoGalleryViewController_iPad" bundle:nil];
            //                }
            //                else {
            //                    photo = [[PhotoGalleryViewController alloc]  initWithNibName:@"PhotoGalleryViewController" bundle:nil];
            //                }
            //                [self.navigationController pushViewController:photo animated:YES];
        }
            break;
            
        case 6:
            {
                TaxiDirectoryViewController *taxi = [[TaxiDirectoryViewController alloc]  initWithNibName:@"TaxiDirectoryViewController" bundle:nil];
                [self.navigationController pushViewController:taxi animated:YES];
            }
            break;
        case 7:
            {
                
                DashboardViewController *dashboard = [[DashboardViewController alloc]  initWithNibName:@"DashboardViewController" bundle:nil];
                [self.navigationController pushViewController:dashboard animated:YES];
                
                    //                PhotoGalleryViewController *photo = nil;
                    //                if ([CommonUtils isiPad]) {
                    //                    photo = [[PhotoGalleryViewController alloc]  initWithNibName:@"PhotoGalleryViewController_iPad" bundle:nil];
                    //                }
                    //                else {
                    //                    photo = [[PhotoGalleryViewController alloc]  initWithNibName:@"PhotoGalleryViewController" bundle:nil];
                    //                }
                    //                [self.navigationController pushViewController:photo animated:YES];
            }
            break;
        default:
            break;
    }

}


#pragma mark - Oriantation
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}


-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self.cv reloadData];
   
}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [self.cv reloadData];
    [self setStatusBarVisibility];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];

         switch (orientation) {
             case UIInterfaceOrientationPortrait:
             case UIInterfaceOrientationPortraitUpsideDown:
                 if (![CommonUtils isiPad]) {
                     
                     
                     if ([CommonUtils isIPhone4]) {
                         [CommonUtils setNavigationBarImage:[[UIImage imageNamed:@"nav-4-5-P.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch] forNavigationBar:self.navigationController.navigationBar];
                     }
                     else if ([CommonUtils isIPhone5]) {
                         [CommonUtils setNavigationBarImage:[[UIImage imageNamed:@"nav-4-5-P.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch] forNavigationBar:self.navigationController.navigationBar];
                     }
                     else if ([CommonUtils isIPhone6]) {
                         [CommonUtils setNavigationBarImage:[[UIImage imageNamed:@"nav-6-P.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch] forNavigationBar:self.navigationController.navigationBar];
                     }
                     else {
                         [CommonUtils setNavigationBarImage:[[UIImage imageNamed:@"nav-6p-P.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch] forNavigationBar:self.navigationController.navigationBar];
                     }
                     

                 }
                 else {
                     
                         [CommonUtils setNavigationBarImage:[[UIImage imageNamed:@"nav-ipad-P.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch] forNavigationBar:self.navigationController.navigationBar];

                 }
                 
                 
                 break;
                 
             case UIInterfaceOrientationLandscapeLeft:
             case UIInterfaceOrientationLandscapeRight:
                 if (![CommonUtils isiPad]) {
                     if ([CommonUtils isIPhone4_Landscape]) {
                         [CommonUtils setNavigationBarImage:[[UIImage imageNamed:@"nav-4-L.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch] forNavigationBar:self.navigationController.navigationBar];
                     }
                     else if ([CommonUtils isIPhone5_Landscape]) {
                         [CommonUtils setNavigationBarImage:[[UIImage imageNamed:@"nav-5-L.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch] forNavigationBar:self.navigationController.navigationBar];
                     }
                     else if ([CommonUtils isIPhone6_Landscape]) {
                         [CommonUtils setNavigationBarImage:[[UIImage imageNamed:@"nav-6-L.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch] forNavigationBar:self.navigationController.navigationBar];
                     }
                     else {
                         [CommonUtils setNavigationBarImage:[[UIImage imageNamed:@"nav-6p-L.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch] forNavigationBar:self.navigationController.navigationBar];
                         self.navigationController.navigationBar.frame = CGRectMake(0,32, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height+20);
                         
                     }
                 }
                 else {
                      [CommonUtils setNavigationBarImage:[[UIImage imageNamed:@"nav-ipad-L.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch] forNavigationBar:self.navigationController.navigationBar];
                     
                        //                     if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
                        //                         
                        //                         NSLog(@"after nav = %lf",self.navigationController.navigationBar.frame.size.height);
                        //                     }
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
