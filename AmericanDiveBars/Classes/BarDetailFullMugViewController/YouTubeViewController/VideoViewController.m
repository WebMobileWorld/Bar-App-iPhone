//
//  VideoViewController.m
//  JooriRE
//
//  Created by Jigar Joshi on 01/12/14.
//  Copyright (c) 2014 HighTech. All rights reserved.
//

#import "VideoViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface VideoViewController () <MBProgressHUDDelegate,YTPlayerViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *WebVideo;
@end

@implementation VideoViewController
@synthesize WebVideo,VideoUrl;

- (void)viewDidLoad
{
    [super viewDidLoad];
self.playerView.delegate = self;
    NSDictionary *playerVars = @{
                                 @"playsinline" : @1,
                                 };
    [self.playerView loadWithVideoId:self.videoId playerVars:playerVars];
   // [self.playerView loadWithVideoId:self.videoId];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(VideoProperty)];
//    tap.numberOfTapsRequired = 1;
//    tap.numberOfTouchesRequired = 1;
//    self.VideoImage.userInteractionEnabled = YES;
//    [self.VideoImage addGestureRecognizer:tap];
    
    //[self performSelector:@selector(VideoProperty) withObject:nil afterDelay:0.001];
    // Do any additional setup after loading the view.
}

- (void)playerView:(YTPlayerView *)playerView didChangeToState:(YTPlayerState)state {
    switch (state) {
        case kYTPlayerStatePlaying:
            NSLog(@"Started playback");
            break;
        case kYTPlayerStatePaused:
            NSLog(@"Paused playback");
            break;
        default:
            break;
    }
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.topItem.title = @" ";
    self.navigationController.navigationBarHidden = NO;
}

-(void)VideoProperty
{
    VideoUrl = [VideoUrl stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *videoid;
    NSURL *urlVideo;
    
    if ([VideoUrl rangeOfString:@"autoplay="].location == NSNotFound)
    {
        urlVideo = [NSURL URLWithString:[NSString stringWithFormat:@"%@?rel=0&autoplay=1",VideoUrl]];
    }
    else
    {
        urlVideo = [NSURL URLWithString:[NSString stringWithFormat:@"%@",VideoUrl]];
    }
    
    if ([[CommonUtils YoutubeEmbededDetectType:VideoUrl] length])
    {
        videoid=[CommonUtils YoutubeEmbededDetectType:VideoUrl];
        if ([VideoUrl rangeOfString:@"embed/"].location == NSNotFound)
        {
            
        }
        else
        {
            NSString *embeddedString = [NSString stringWithFormat:@"https://www.youtube.com/watch?v=%@?rel=0&autoplay=1",videoid];
            urlVideo = [NSURL URLWithString:[NSString stringWithFormat:@"%@",embeddedString]];
        }
    }
    else
    {
        videoid = [VideoUrl substringWithRange:NSMakeRange([VideoUrl rangeOfString:@"v="].location+2, [VideoUrl length]-[VideoUrl rangeOfString:@"v="].location-2)];
        videoid = [videoid stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if ([videoid rangeOfString:@"&"].location == NSNotFound)
        {
        }
        else
        {
            videoid = [videoid substringWithRange:NSMakeRange(0, [videoid rangeOfString:@"&"].location)];
        }
        
        if ([videoid rangeOfString:@"#"].location == NSNotFound)
        {
        }
        else
        {
            videoid = [videoid substringWithRange:NSMakeRange(0, [videoid rangeOfString:@"#"].location)];
        }
        
        urlVideo=[NSURL URLWithString:[NSString stringWithFormat:@"%@?rel=0&autoplay=1",VideoUrl]];
        
        if ([videoid rangeOfString:@"&"].location == NSNotFound)
        {
            
        }
        else
        {
            NSLog(@"v=%lu",(unsigned long)[videoid rangeOfString:@"&"].location);
        }
    }
    
    WebVideo.scrollView.bounces=NO;
    WebVideo.scrollView.scrollEnabled=NO;
    WebVideo.mediaPlaybackRequiresUserAction=NO;
    
    NSURL *urlImage=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",wallpost_youtube,videoid,wallpost_youtube_name]];
    self.VideoImage.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:urlImage]];
    
    WebVideo.backgroundColor=[UIColor blackColor];
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"Loading...";
    HUD.mode = MBProgressHUDModeIndeterminate;
    
    request = [[NSURLRequest alloc]initWithURL:urlVideo];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if( connection )
    {
        receiveData = [NSMutableData data];
    }
    else
    {
        NSLog(@"theConnection is NULL");
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [receiveData setLength: 0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receiveData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"ERROR with theConenction");
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"Warning" message:@"No Internet Connection Please try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [al show];
    
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *string = [[NSString alloc] initWithData:receiveData encoding:NSUTF8StringEncoding] ;
    NSURL *urlVideo=[NSURL URLWithString:VideoUrl];
    [WebVideo loadHTMLString:string baseURL:urlVideo];
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}



- (void)webViewDidStartLoad:(UIWebView *)webView {
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"Loading...";
    HUD.mode = MBProgressHUDModeIndeterminate;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error {
    ShowAlert(AlertTitle, @"unable to play video");
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end