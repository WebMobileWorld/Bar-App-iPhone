//
//  MapViewController.m
//  AmericanDiveBars
//
//  Created by spaculus on 10/23/15.
//  Copyright © 2015 spaculus. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()<FPPopoverControllerDelegate>
{
    //POPOVER
    FPPopoverController *popover;
    
    NSMutableArray *placesOutputArray;
}

@property (nonatomic, strong) IBOutlet MKMapView *map;


@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.titleView = [CommonUtils setTitleLabel:@"Our Location"];
    [self configureTopButtons];
    
    [self getLatlongfromAddress:self.address];
    
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
    controller.mapDelegate = self;
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


#pragma mark - Map view

-(void)getLatlongfromAddress:(NSString *)address
{
    NSString *mapURL = [[NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?address=%@",address] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:mapURL];
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    if(data == nil)
    {
        //ShowAlert(AlertTitle, MSG_SERVER_NOT_REACHABLE);
        return;
    }
    
    NSDictionary *dict = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    //NSLog(@"Map Address = %@",dict);
    
    placesOutputArray = [@[] mutableCopy];
    NSArray * allPlases = [dict valueForKeyPath:@"results"];
    if([allPlases count] > 0)
    {
        NSString *lat = [[[[[allPlases objectAtIndex:0] valueForKey:@"geometry"] valueForKey:@"location"] valueForKey:@"lat"] stringValue];
        NSString *lng = [[[[[allPlases objectAtIndex:0] valueForKey:@"geometry"] valueForKey:@"location"] valueForKey:@"lng"] stringValue];
        NSString *name = [[allPlases objectAtIndex:0] valueForKey:@"name"];
        NSString *addrs = address;
        
        Place *place = [[Place alloc] init];
        [place setLat:lat];
        [place setLng:lng];
        [place setName:name];
        [place setAddrs:addrs];
        [placesOutputArray addObject:place];
        
        NSLog(@"%@",placesOutputArray);
        
        //[placesOutputArray addObjectsFromArray:[dict valueForKey:@"location"]];
        
        [self parseDataForMapView:self.map];
    }
}



-(void)parseDataForMapView:(MKMapView *)mapView
{
    
    if(mapView.annotations){
        [mapView removeAnnotations:mapView.annotations];
    }
    
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta=0.0;
    span.longitudeDelta=0.0;
    
    CLLocationCoordinate2D location;
    
    region.span = span;
    region.center = location;
    
    NSMutableArray *anoteArr=[[NSMutableArray alloc]initWithCapacity:[placesOutputArray count]];
    
    for (int i = 0; i<[placesOutputArray count]; i++)
    {
        location.latitude = [[[placesOutputArray objectAtIndex:i] lat] doubleValue];
        location.longitude = [[[placesOutputArray objectAtIndex:i] lng] doubleValue];
        
        PlacePin *mapPoint = [[PlacePin alloc] initWithLocation:location];
        mapPoint.nTag = i;
        
        mapPoint.title = [[placesOutputArray objectAtIndex:i] addrs];
        
        [anoteArr addObject:mapPoint];
        
        mapPoint = nil;
    }
    
    
    [mapView addAnnotations:(NSArray*)anoteArr];
    
    [anoteArr removeAllObjects];
    //[mapView setRegion:region animated:YES];
    //[mapView regionThatFits:region];
    @try {
        [self zoomToFitMapAnnotations:mapView];
    }
    @catch (NSException *exception) {
        // JEKIL 24/8/2012 NSLog(@"You can not set zoomlevel of map.");
    }
    // region = [mapView regionThatFits:region];
    
}

-(void)zoomToFitMapAnnotations:(MKMapView*)mv
{
    //// JEKIL 24/8/2012 NSLog(@"zoom To Fit Map Annotations");
    if([mv.annotations count] == 0)
        return;
    
    if([mv.annotations count] == 1) {
        
        MKCoordinateRegion region;
        MKCoordinateSpan span;
        span.latitudeDelta=0.001;//0.2
        span.longitudeDelta=0.001;//0.2
        
        for(PlacePin* annotation in mv.annotations){
            
            CLLocationCoordinate2D location;
            location.latitude = annotation.coordinate.latitude;
            location.longitude = annotation.coordinate.longitude;
            region.span=span;
            region.center=location;
            
            [mv setRegion:region animated:TRUE];
            [mv regionThatFits:region];
        }
    }
    else {
        CLLocationCoordinate2D topLeftCoord;
        topLeftCoord.latitude = -90;
        topLeftCoord.longitude = 180;
        
        CLLocationCoordinate2D bottomRightCoord;
        bottomRightCoord.latitude = 90;
        bottomRightCoord.longitude = -180;
        
        for(PlacePin* annotation in mv.annotations)
        {
            topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
            topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
            
            bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
            bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
        }
        
        MKCoordinateRegion region;
        region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
        region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
        region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1; // Add a little extra space on the sides
        region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1; // Add a little extra space on the sides
        
        region = [mv regionThatFits:region];
        [mv setRegion:region animated:YES];
    }
}



#pragma mark - MAP VIEW

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    NSLog(@"pin tapped");
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    NSLog(@"calloutaccessory view tapped");
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    
    MKPinAnnotationView *pinView = nil;
    if(annotation != self.map.userLocation)
    {
        static NSString *defaultPinID = @"com.invasivecode.pin";
        pinView = (MKPinAnnotationView *)[self.map dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if ( pinView == nil )
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:defaultPinID];
    }
    else {
        [mapView.userLocation setTitle:@"I am here"];
    }
    
    [pinView setPinColor:MKPinAnnotationColorRed];
    pinView.canShowCallout = YES;
    pinView.animatesDrop = YES;
    
    
    return pinView;
}


#pragma mark - Orientation
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}


-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
}
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
