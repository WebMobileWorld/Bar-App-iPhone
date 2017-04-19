//
//  FindBarAroundMeViewController.m
//  AmericanDiveBars
//
//  Created by spaculus on 1/18/16.
//  Copyright © 2016 spaculus. All rights reserved.
//

#import "FindBarAroundMeViewController.h"
#import "BarDetailFullMugViewController.h"
#import "BarDetailHalfMugViewController.h"
#import "EventDetailViewController.h"
#import "BarSuggestViewController.h"

#import "BarCell.h"

@interface FindBarAroundMeViewController ()<MBProgressHUDDelegate,FPPopoverControllerDelegate,CLLocationManagerDelegate>
{
    MBProgressHUD *HUD;
    
    FPPopoverController *popover;
    
    
    // Core Location
    CLLocationManager *locationManager;
    CLGeocoder * geoCoder;
    double myLatitude;
    double myLongitude;

    // Map Places
    int Pin_Tag;
    double double_lat;                      //to hold latitude
    double double_long;                     //to hold longitude

    
    NSMutableArray *placesOutputArray;
    
    // Map Callouts
    UIButton *btnMapInfo;


    BOOL isMap;
}
@property (strong, nonatomic) NSMutableArray *aryList;
@property (strong, nonatomic) NSMutableArray *aryEvents;
@property (strong, nonatomic) IBOutlet MKMapView *viewMap;
@property (strong, nonatomic) IBOutlet UITableView *tblView;

@end

@implementation FindBarAroundMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(self.isFromHappy) {
        self.navigationItem.titleView = [CommonUtils setTitleLabel:@"HAPPY HOURS NEAR YOU"];
        [self.btnSuggest setHidden:YES];
    }
    else {
        self.navigationItem.titleView = [CommonUtils setTitleLabel:@"BARS NEAR YOU"];
        [self.btnSuggest setHidden:NO];
    }
    
    [self configData];
    [self configureTopButtons];
    [self startLocationManager];
    //[self callTempWs];

}

-(void)configData {
    isMap = YES;
    self.aryEvents = [[NSMutableArray alloc] init];
}

-(void)callTempWs {
    myLatitude = 41.279169;
    myLongitude =  -96.099817;
    if (self.isFromHappy) {
        [self callBarListWebservice];
    }
    else {
        [self callBarListWebservice];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews {
    [self setStatusBarVisibility];
    popover.contentSize = CGSizeMake(150, self.view.bounds.size.height-20);
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.topItem.title = @" ";
    [self setStatusBarVisibility];
}

-(void)setStatusBarVisibility {
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    CGSize blankImageSize = CGSizeMake(self.view.bounds.size.width, 64);
    UIImage *blank = [CommonUtils imageFromColor:[UIColor colorWithRed:187.0/255.0 green:124.0/255.0 blue:37.0/255.0 alpha:1.0] forSize:blankImageSize withCornerRadius:0.0];
    [CommonUtils setNavigationBarImage:blank forNavigationBar:self.navigationController.navigationBar];
}

- (IBAction)btnSuggestClicked:(id)sender {
    
    BarSuggestViewController *suggest = [[BarSuggestViewController alloc] initWithNibName:@"BarSuggestViewController" bundle:nil];
    [self.navigationController pushViewController:suggest animated:YES];
    
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
    btnTopSearch = [CommonUtils barItemWithImage:[UIImage imageNamed:@"top-home.png"] highlightedImage:nil xOffset:-5 target:self action:@selector(btnTopSearch_Clicked:)];
    
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
    controller.findBarAroundMeDelagate = self;
    if ([CommonUtils isLoggedIn]) {
        //All
        controller.aryItems = @[@{@"image":@"user-no_image_LM.png",@"title":@"User"},
                                @{@"image":@"dashboard-LM.png",@"title":@"My Dashboard"},
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
            BeerDirectoryViewController *beer = [[BeerDirectoryViewController alloc]  initWithNibName:@"BeerDirectoryViewController" bundle:nil];
            [self.navigationController pushViewController:beer animated:YES];
        }
            break;
        case 3:
        {
            CocktailDirectoryViewController *cocktail = [[CocktailDirectoryViewController alloc]  initWithNibName:@"CocktailDirectoryViewController" bundle:nil];
            [self.navigationController pushViewController:cocktail animated:YES];
        }
            break;
            
        case 4:
        {
            LiquorDirectoryViewController *liquor = [[LiquorDirectoryViewController alloc]  initWithNibName:@"LiquorDirectoryViewController" bundle:nil];
            [self.navigationController pushViewController:liquor animated:YES];
        }
            break;
            
        case 5:
        {
            TaxiDirectoryViewController *taxi = [[TaxiDirectoryViewController alloc] initWithNibName:@"TaxiDirectoryViewController" bundle:nil];
            [self.navigationController pushViewController:taxi animated:YES];
        }
            break;
            
        case 6:
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
        case 7:
        {
            ArticleViewController *article = [[ArticleViewController alloc]  initWithNibName:@"ArticleViewController" bundle:nil];
            [self.navigationController pushViewController:article animated:YES];
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




#pragma mark Map and Current Location

#pragma mark - Location Delegates
-(void)startLocationManager
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.mode = MBProgressHUDModeIndeterminate;
    
    locationManager = [[CLLocationManager alloc]init];
    geoCoder = [[CLGeocoder alloc]init];
    locationManager.delegate = self;
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
    {
        [locationManager requestWhenInUseAuthorization];
    }
    
    [locationManager startUpdatingLocation];
}

#pragma mark - Core Location

#pragma mark Location Delegates
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [locationManager stopUpdatingLocation];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSLog(@"error : %@",error);
    //ShowAlert(AlertTitle,ERR_FINDING_LOCATION);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"LatLong : %f , %f",locationManager.location.coordinate.latitude , locationManager.location.coordinate.longitude);
    
    myLatitude = locationManager.location.coordinate.latitude;
    myLongitude = locationManager.location.coordinate.longitude;
    [locationManager stopUpdatingLocation];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if (self.isFromHappy) {
        [self callBarListWebservice];
    }
    else {
        [self callBarListWebservice];
    }
    
}

#pragma mark - Map -
-(void)getDataToMapIT
{
    if (placesOutputArray) {
        [placesOutputArray removeAllObjects];
        placesOutputArray = nil;
        placesOutputArray = [[NSMutableArray alloc] init];
        
    }
    else {
        placesOutputArray = [[NSMutableArray alloc] init];
    }
    
    for (Bar *bar in self.aryList) {
        NSString *lat = [bar bar_lat];
        NSString *lng = [bar bar_lng];
        NSString *name = [bar bar_title];
        NSString *bar_type = [bar bar_type];
        NSLog(@"bar_type = %@",bar_type);
        NSString *addrs = nil;
        BOOL isEvent = NO;
        if(self.isFromHappy) {
            addrs = [bar bar_sph_duration];
        }
        else {
            addrs = [bar fullAddress];
        }
        NSString *bar_logo = [bar bar_logo];
        NSString *strImgURL = [NSString stringWithFormat:@"%@%@%@",WEBIMAGE_URL,BARLIST_LOGO,bar_logo];
        
        NSString *pinType = @"o";
        
        Place *place = [[Place alloc] init];
        [place setLat:lat];
        [place setLng:lng];
        [place setName:name];
        [place setAddrs:addrs];
        [place setImgURL:strImgURL];
        [place setPinType:pinType];
        [place setBar_type:bar_type];
        [place setIsEvent:isEvent];
        [placesOutputArray addObject:place];
    }
    
    for (BarEvent *event in self.aryEvents) {
        NSString *lat = [event barEvent_event_lat];
        NSString *lng = [event barEvent_event_lng];
        NSString *name = [event barEvent_event_title];
        NSString *bar_type = @"";
        BOOL isEvent = YES;
        
        NSLog(@"bar_type = %@",bar_type);
        NSString *addrs = nil;
        if(self.isFromHappy) {
            addrs = [event barEvent_venue];
        }
        else {
            addrs = [event barEvent_venue];
        }
        NSString *bar_logo = [event barEvent_event_image];
        NSString *strImgURL = [NSString stringWithFormat:@"%@%@%@",WEBIMAGE_URL,BARLIST_LOGO,bar_logo];
        
        NSString *pinType = @"o";
        
        Place *place = [[Place alloc] init];
        [place setLat:lat];
        [place setLng:lng];
        [place setName:name];
        [place setAddrs:addrs];
        [place setImgURL:strImgURL];
        [place setPinType:pinType];
        [place setBar_type:bar_type];
        [place setIsEvent:isEvent];
        [placesOutputArray addObject:place];
    }
}

#pragma mark - Map Annotation Related Delegates and Methods...

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    static NSString *identifier = @"MyLocation";
    MKAnnotationView *annotationView = nil;
    if ([annotation isKindOfClass:[PlacePin class]])
    {
        annotationView =  (MKAnnotationView *)[self.viewMap dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if (annotationView == nil)
        {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            
        } else
        {
            annotationView.annotation = annotation;
        }
        
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        
        if (self.isFromHappy) {
            if([[(PlacePin *)annotationView.annotation image] isEqualToString:@"map_pin_HH.png"])
            {
                btnMapInfo = [UIButton buttonWithType:UIButtonTypeCustom];
                btnMapInfo.frame = CGRectMake(0, 0, 40, 40);
                [btnMapInfo setBackgroundImage:[UIImage imageNamed:@"gray_right_arrow.png"] forState:UIControlStateNormal];
                annotationView.rightCalloutAccessoryView = btnMapInfo;
                
                annotationView.image = [UIImage imageNamed:@"map_pin_HH.png"];
            }

            else {
                btnMapInfo = [UIButton buttonWithType:UIButtonTypeCustom];
                btnMapInfo.frame = CGRectMake(0, 0, 40, 40);
                [btnMapInfo setBackgroundImage:[UIImage imageNamed:@"gray_right_arrow.png"] forState:UIControlStateNormal];
                annotationView.rightCalloutAccessoryView = btnMapInfo;
                
                annotationView.image = [UIImage imageNamed:@"red-dot.png"];
            }
        }
        else {
            btnMapInfo = [UIButton buttonWithType:UIButtonTypeCustom];
            btnMapInfo.frame = CGRectMake(0, 0, 40, 40);
            [btnMapInfo setBackgroundImage:[UIImage imageNamed:@"gray_right_arrow.png"] forState:UIControlStateNormal];
            annotationView.rightCalloutAccessoryView = btnMapInfo;
            if([[(PlacePin *)annotationView.annotation image] isEqualToString:@"star-pin.png"])
            {
                annotationView.image = [UIImage imageNamed:@"star-pin.png"];
            }
            else {
                annotationView.image = [UIImage imageNamed:@"map_pin.png"];
            }
        }
        
        UIImageView *myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,40,40)];
        [myImageView sd_setImageWithURL:[NSURL URLWithString:[[placesOutputArray objectAtIndex:[(PlacePin *)annotationView.annotation nTag]] imgURL]] placeholderImage:[UIImage imageNamed:@"no_bar_detail.png"]];
        
        annotationView.leftCalloutAccessoryView = myImageView;
    }
    else
    {
        [mapView.userLocation setTitle:@"I am here"];
        
//        annotationView =  (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
//        
//        if (annotationView == nil)
//        {
//            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
//        } else
//        {
//            annotationView.annotation = annotation;
//        }
//        
//        annotationView.rightCalloutAccessoryView = nil;
//        annotationView.enabled = YES;
//        annotationView.canShowCallout = YES;
//        annotationView.image = [UIImage imageNamed:@"star_pin.png"];
//        
//        [self zoomToFitMapAnnotationsForUserLocation:mapView];
    }
    
    return annotationView;
}

-(void)parseDataForMapView:(MKMapView *)mapView
{
    if(mapView.annotations)
    {
        [mapView removeAnnotations:mapView.annotations];
    }
    
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta=0.5;
    span.longitudeDelta=0.5;
    
    CLLocationCoordinate2D location;
    
    region.span = span;
    region.center = location;
    
    NSMutableArray *anoteArr = [[NSMutableArray alloc] initWithCapacity:[placesOutputArray count]];
    [anoteArr removeAllObjects];
    
    for (int i = 0; i<[placesOutputArray count]; i++)
    {
        double_lat = [[NSString stringWithFormat:@"%@",[[placesOutputArray objectAtIndex:i] lat]] doubleValue];
        double_long = [[NSString stringWithFormat:@"%@",[[placesOutputArray objectAtIndex:i] lng]] doubleValue];
        
        location.latitude = double_lat;
        location.longitude = double_long;
        
        PlacePin *mapPoint = nil;
        
        if (self.isFromHappy) {
            if ([[placesOutputArray objectAtIndex:i] isEvent]) {
                mapPoint = [[PlacePin alloc] initWithLocation:location image:@"red-dot.png"];
                mapPoint.subtitle = [[placesOutputArray objectAtIndex:i] addrs];
                mapPoint.isEvent = YES;
            }
            else {
                mapPoint.isEvent = NO;
                if ([[[placesOutputArray objectAtIndex:i] pinType] isEqualToString:@"o"])
                {
                    
                    mapPoint = [[PlacePin alloc] initWithLocation:location image:@"map_pin_HH.png"];
                    mapPoint.subtitle = [[placesOutputArray objectAtIndex:i] addrs];
                }
                else
                {
                    mapPoint = [[PlacePin alloc] initWithLocation:location image:@"star_pin.png"];
                    mapPoint.subtitle = [[placesOutputArray objectAtIndex:i] addrs];
                }
            }
            
        }
        else {
            mapPoint.isEvent = NO;
            if ([[[placesOutputArray objectAtIndex:i] pinType] isEqualToString:@"o"])
            {
                if ([[[placesOutputArray objectAtIndex:i] bar_type] isEqualToString:@"half_mug"]) {
                    mapPoint = [[PlacePin alloc] initWithLocation:location image:@"map_pin.png"];
                }
                else {
                    mapPoint = [[PlacePin alloc] initWithLocation:location image:@"star-pin.png"];
                }
                mapPoint.subtitle = [[placesOutputArray objectAtIndex:i] addrs];
            }
            else
            {
                mapPoint = [[PlacePin alloc] initWithLocation:location image:@"star_pin.png"];
                mapPoint.subtitle = [[placesOutputArray objectAtIndex:i] addrs];
            }
        }
        
        mapPoint.nTag = i;
        mapPoint.title = [[placesOutputArray objectAtIndex:i] name];
        [anoteArr addObject:mapPoint];
        
        mapPoint = nil;
    }
    
    [mapView addAnnotations:(NSArray*)anoteArr];
    [anoteArr removeAllObjects];
    
    @try
    {
        [self zoomToFitMapAnnotations:mapView];
    }
    @catch (NSException *exception)
    {
        ShowAlert(AlertTitle, [exception description]);
    }
}

-(void)zoomToFitMapAnnotationsForUserLocation:(MKMapView*)mv
{
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta=0.5;//0.2
    span.longitudeDelta=0.5;//0.2
    
    CLLocationCoordinate2D location;
    location.latitude = self.viewMap.userLocation.location.coordinate.latitude;//annotation.coordinate.latitude;
    location.longitude = self.viewMap.userLocation.location.coordinate.longitude;//annotation.coordinate.longitude;
    region.span=span;
    region.center=location;
    
    [mv regionThatFits:region];
    [mv setRegion:region animated:TRUE];
}

-(void)zoomToFitMapAnnotations:(MKMapView*)mv
{
    if([mv.annotations count] == 0)
        return;
    
    if([mv.annotations count] == 1)
    {
        MKCoordinateRegion region;
        MKCoordinateSpan span;
        span.latitudeDelta=0.2;// 0.05
        span.longitudeDelta=0.2;// 0.05
        
        for(PlacePin* annotation in mv.annotations)
        {
            CLLocationCoordinate2D location;
            location.latitude = annotation.coordinate.latitude;
            location.longitude = annotation.coordinate.longitude;
            region.span=span;
            region.center=location;
            
            [mv regionThatFits:region];
            [mv setRegion:region animated:TRUE];
        }
    }
    else
    {
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
        region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1; // Add a little extra space on the sides 4.65
        region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1; // Add a little extra space on the sides 4.65
        
        region = [mv regionThatFits:region];
        [mv setRegion:region animated:YES];
    }
}
#pragma mark - btnMapInfo Clicked
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    PlacePin *pin = (PlacePin *)view.annotation;
    
    if ([pin isEvent]) {
        
        NSString *pinTitle = [pin title];
        
        for (BarEvent *event in self.aryEvents) {
            
            if ([event.barEvent_event_title isEqualToString:pinTitle]) {
                NSArray *aryFound = @[event];
                if ([aryFound count]!=0) {
                    BarEvent *barevent = [aryFound objectAtIndex:0];
                    
                    EventDetailViewController *detailVC = [[EventDetailViewController alloc] initWithNibName:@"EventDetailViewController" bundle:nil];
                    detailVC.barEvent = barevent;
                    [self.navigationController pushViewController:detailVC animated:YES];
                }
                break;
            }
        }
            //        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.title LIKE %@",pinTitle];
            //        NSArray *aryFound = [self.aryEvents filteredArrayUsingPredicate:predicate];
    }
    else {
        
        NSString *pinTitle = [pin title];
        
        for (Bar *bar in self.aryList) {
            if ([bar.bar_title isEqualToString:pinTitle]) {
                NSArray *aryFound = @[bar];
                if ([aryFound count]!=0) {
                    
                    if ([[bar bar_type] isEqualToString:@"full_mug"]) {
                        BarDetailFullMugViewController *barDetailFullMug = [[BarDetailFullMugViewController alloc] initWithNibName:@"BarDetailFullMugViewController" bundle:nil];
                        barDetailFullMug.bar = bar;
                        [self.navigationController pushViewController:barDetailFullMug animated:YES];
                        
                    }
                    else {
                        BarDetailHalfMugViewController *barDetailHalfMug = [[BarDetailHalfMugViewController alloc] initWithNibName:@"BarDetailHalfMugViewController" bundle:nil];
                        barDetailHalfMug.bar = bar;
                        [self.navigationController pushViewController:barDetailHalfMug animated:YES];
                        
                    }
                }
                break;
            }
        }
        
        // NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.title LIKE %@",pinTitle];
        // NSArray *aryFound = [self.aryList filteredArrayUsingPredicate:predicate];
        
        /*if ([aryFound count]!=0) {
            Bar *bar = [aryFound objectAtIndex:0];
            
            if ([[bar bar_type] isEqualToString:@"full_mug"]) {
                BarDetailFullMugViewController *barDetailFullMug = [[BarDetailFullMugViewController alloc] initWithNibName:@"BarDetailFullMugViewController" bundle:nil];
                barDetailFullMug.bar = bar;
                [self.navigationController pushViewController:barDetailFullMug animated:YES];
                
            }
            else {
                BarDetailHalfMugViewController *barDetailHalfMug = [[BarDetailHalfMugViewController alloc] initWithNibName:@"BarDetailHalfMugViewController" bundle:nil];
                barDetailHalfMug.bar = bar;
                [self.navigationController pushViewController:barDetailHalfMug animated:YES];
                
            }
        }*/
    }
}


#pragma  mark - Buttton Toggle
- (IBAction)btnToggleClicked:(id)sender {
    isMap = !isMap;
    if (isMap) {
        [self.btnToggle setBackgroundImage:[UIImage imageNamed:@"list.png"] forState:UIControlStateNormal];
        self.viewMap.hidden = NO;
        self.tblView.hidden = YES;
    }
    else {
        [self.btnToggle setBackgroundImage:[UIImage imageNamed:@"view-map.png"] forState:UIControlStateNormal];
        self.viewMap.hidden = YES;
        self.tblView.hidden = NO;
        [self.tblView reloadData];
    }
}


#pragma mark - Oriantation
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

#pragma mark - Webservice Call
-(void)callBarListWebservice {
    
    [CommonUtils callWebservice:@selector(bar_lists) forTarget:self];
    
}


#pragma mark - Table View
#pragma mark Number of Section
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark Number of Row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [CommonUtils getArrayCountFromArray:self.aryList];
}

#pragma mark Cell for Row
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"BarCell";
    
    BarCell *cell = (BarCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib;
        if([CommonUtils isiPad])
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"BarCell" owner:self options:nil];
        }
        else
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"BarCell" owner:self options:nil];
        }
        cell = [nib objectAtIndex:0];
    }
    
    Bar *bar = [self.aryList objectAtIndex:indexPath.row];
    cell.lblBarTitle.text = [CommonUtils removeHTMLFromString:bar.bar_title];
    cell.lblPhone.text = [CommonUtils removeHTMLFromString:bar.bar_phone];
    
    NSString *fullAddress = [CommonUtils removeHTMLFromString:bar.fullAddress];//[NSString stringWithFormat:@"%@,%@,%@ %@",bar.bar_address,bar.bar_city,bar.bar_state,bar.bar_zipcode];
    cell.lblAddress.text = fullAddress;
    int total_rating = [[bar bar_total_rating] intValue];
    int total_commnets = [[bar bar_total_commnets] intValue];
    
    [cell setBarRatingsBy:total_rating andComments:total_commnets];
    
    if ([[bar bar_type] isEqualToString:@"full_mug"]) {
        cell.imgBarType.image = [UIImage imageNamed:@"full-mug.png"];
    }
    else {
        cell.imgBarType.image = [UIImage imageNamed:@"half-mug.png"];
    }
    
    NSString *bar_logo = [bar bar_logo];
    NSString *strImgURL = [NSString stringWithFormat:@"%@%@%@",WEBIMAGE_URL,BARLIST_LOGO,bar_logo];
    NSURL *imgURL = [NSURL URLWithString:strImgURL];
    
    [cell.imgBarLogo sd_setImageWithURL:imgURL placeholderImage:[UIImage imageNamed:@"no_bar.png"]];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}


#pragma mark Cell Height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 114;
}

#pragma mark did Select Row
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Bar *bar = [self.aryList objectAtIndex:indexPath.row];
    if ([[bar bar_type] isEqualToString:@"full_mug"]) {
        BarDetailFullMugViewController *barDetailFullMug = [[BarDetailFullMugViewController alloc] initWithNibName:@"BarDetailFullMugViewController" bundle:nil];
        barDetailFullMug.bar = bar;
        [self.navigationController pushViewController:barDetailFullMug animated:YES];
        
    }
    else {
        BarDetailHalfMugViewController *barDetailHalfMug = [[BarDetailHalfMugViewController alloc] initWithNibName:@"BarDetailHalfMugViewController" bundle:nil];
        barDetailHalfMug.bar = bar;
        [self.navigationController pushViewController:barDetailHalfMug animated:YES];
        
    }
    
}


#pragma mark - Webservice
#pragma mark bar_lists
-(void)bar_lists
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.mode = MBProgressHUDModeIndeterminate;
    
    User *user = [CommonUtils getUserLoginDetails];
    NSString *user_id = [user user_id];
    NSString *device_id = [user device_id];
    NSString *unique_code =[user unique_code];
    
    NSString *name,*state,*city,*zip;
    name = self.searchDetail.searchByName;
    state = self.searchDetail.searchByState;
    city = self.searchDetail.searchByCity;
    zip = self.searchDetail.searchByZip;
    
    //192.168.1.27/ADB/api/bar_lists
    NSString *myURL = [NSString stringWithFormat:@"%@bar_lists",WEBSERVICE_URL];
    NSMutableURLRequest *Request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: myURL]];
    
    NSString *params = @"";

    if (self.isFromHappy) {
        params = [NSString stringWithFormat:@"user_id=%@&device_id=%@&unique_code=%@&limit=@""&offset=@""&state=%@&city=%@&zipcode=%@&title=%@&order_by=%@&lat=%@&lang=%@&address_j=%@&days=%@",user_id,device_id,unique_code,state,city,zip,name,@"bar_title#ASC",[NSString stringWithFormat:@"%lf",myLatitude],[NSString stringWithFormat:@"%lf",myLongitude],self.searchDetail.searchAddress,self.searchDetail.searchDays];

    }
    else {
        params = [NSString stringWithFormat:@"user_id=%@&device_id=%@&unique_code=%@&limit=@""&offset=@""&state=%@&city=%@&zipcode=%@&title=%@&order_by=%@&lat=%@&lang=%@&address_j=%@&days=%@",user_id,device_id,unique_code,@"",@"",@"",@"",@"bar_title#ASC",[NSString stringWithFormat:@"%lf",myLatitude],[NSString stringWithFormat:@"%lf",myLongitude],@"",@""];

    }
    

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
                NSArray *aryBarList = [[tempDict valueForKey:@"barlist"] valueForKey:@"result"];
                
                if (self.isFromHappy) {
                    NSArray *aryBarHappyHoursList = [[tempDict valueForKey:@"bar_happy_hours"] valueForKey:@"result"];
                    NSArray *aryEventList = [[tempDict valueForKey:@"bar_events"] valueForKey:@"result"];
                    
                    if (aryBarHappyHoursList == nil ) {
                        aryBarHappyHoursList = @[];
                    }
                    self.aryList = [self getBarsFromResult:aryBarList withSpecialHOurs:aryBarHappyHoursList];
                    self.aryEvents = [self getEventsFromResult:aryEventList];
                }
                else {
                    self.aryList = [self getBarsFromResult:aryBarList withSpecialHOurs:@[]];
                }
                
                [self getDataToMapIT];
                [self parseDataForMapView:self.viewMap];
            }
        }
        else {
        }
        if([self.aryList count]==0){
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate.window makeToast:@"No bars found" duration:4.0 position:CSToastPositionBottom];
        }
    }];
}

-(NSMutableArray *)getBarsFromResult:(NSArray *)aryBarList withSpecialHOurs:(NSArray *)aryBarHappyHoursList
{
    NSMutableArray *aryBars = [@[] mutableCopy];
    if ([aryBars count]>0) {
        [aryBars removeAllObjects];
    }
    
    for (NSDictionary *dict in aryBarList) {
        Bar *bar = [Bar getBarWithDictionary:dict];
        
        if ([aryBarHappyHoursList count]!=0) {
            
            NSArray *aryHappyHours = [self getBarHappyHoursFromResult:aryBarHappyHoursList];
            
            NSString *strDuration = @"";
        
            NSMutableArray *aryHoursDuration = [[NSMutableArray alloc] init];
            
            
            
            if ([aryHappyHours count]!=0) {
                
                for (BarSpecialHour *specialHour  in aryHappyHours) {
                    
                    if([specialHour.sph_bar_id isEqualToString:bar.bar_id]) {
                        [aryHoursDuration addObject:specialHour.sph_duration];
                    }
                }
                
                strDuration = [aryHoursDuration componentsJoinedByString:@","];
                
                bar.bar_sph_duration = strDuration;
                
            }
        }

        [aryBars addObject:bar];
    }
    return aryBars;
}


-(NSMutableArray *)getEventsFromResult:(NSArray *)aryEventList
{
    NSMutableArray *aryEvents = [@[] mutableCopy];
    if ([aryEvents count]>0) {
        [aryEvents removeAllObjects];
    }
    
    for (NSDictionary *dict in aryEventList) {
        BarEvent *event = [BarEvent getBarEventWithDictionary:dict];
        [aryEvents addObject:event];
    }
    return aryEvents;
}

-(NSMutableArray *)getBarHappyHoursFromResult:(NSArray *)aryBarHappyHourList
{
    NSMutableArray *aryHappyHours = [@[] mutableCopy];
    if ([aryHappyHours count]>0) {
        [aryHappyHours removeAllObjects];
    }
    
    for (NSDictionary *dict in aryBarHappyHourList) {
        BarSpecialHour *specialHour = [BarSpecialHour getBarSpecialHourWithDictionary:dict];
        
        
        
        [aryHappyHours addObject:specialHour];
    }
    return aryHappyHours;
}



@end
