//
//  VideoViewController.h
//  SocialFriendzy
//
//  Created by Spaculus2 on 15/10/15.
//  Copyright © 2015 Spaculus2. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoViewController : UIViewController
{
    NSMutableData *receiveData;
    NSURLRequest *request;
    MBProgressHUD *HUD;
}
@property (strong, nonatomic) IBOutlet UIImageView *VideoImage;
@property (strong, nonatomic) NSString *VideoUrl;
@property (strong, nonatomic) NSString *videoId;
@property (strong, nonatomic) IBOutlet YTPlayerView *playerView;

@end
