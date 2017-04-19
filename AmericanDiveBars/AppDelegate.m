//
//  AppDelegate.m
//  AmericanDiveBars
//
//  Created by spaculus on 8/18/15.
//  Copyright (c) 2015 spaculus. All rights reserved.
//

#import "AppDelegate.h"
#import "MainMenuViewController.h"
#import "LoginViewController.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>

#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@interface AppDelegate ()
{
    NSString *device_token;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    [Fabric with:@[[Crashlytics class]]];
    
    [self configPushNotificationForApplication:application withLaunchingWithOptions:launchOptions];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    NSLog(@"BEFORE..!! %@",[[NSDate date]description]);
    
    //Extend the splash screen for 3 seconds.
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:3]];
    
    NSLog(@"AFTER..!! %@",[[NSDate date]description]);
    
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"LoggedIn"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"LoggedIn"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"LoggedIn"] isEqualToString:@"0"])
    {
        LoginViewController *login = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        self.navController = [[UINavigationController alloc] initWithRootViewController:login];
    }
    else {
        MainMenuViewController *mainView = [[MainMenuViewController alloc] init];
        self.navController = [[UINavigationController alloc] initWithRootViewController:mainView];
        
    }

    
    self.window.rootViewController = self.navController;
    //[CommonUtils setNavigationBarImage:[UIImage imageNamed:@"nav-6-P.png"]];
    
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options {
    
    return [[FBSDKApplicationDelegate sharedInstance] application:app
                                                          openURL:url
                                                sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                       annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
}

-(void)configPushNotificationForApplication:(UIApplication *)application withLaunchingWithOptions:(NSDictionary *)launchOptions {
#ifdef __IPHONE_8_0
    if(NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1)
    {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge
                                                                                             |UIRemoteNotificationTypeSound
                                                                                             |UIRemoteNotificationTypeAlert) categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }else
    {
        //register to receive notifications
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
#else
    //register to receive notifications
    UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
#endif
    
    NSDictionary *aPushNotification = [launchOptions valueForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if(aPushNotification)
    {
        [self application:application didReceiveRemoteNotification:aPushNotification];
    }
    
    if (application.applicationIconBadgeNumber != 0)
    {
        // Reset the Badge
        application.applicationIconBadgeNumber = 0;
    }

}

#pragma mark - PUSH NOTIFICATION

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"Did Register for Remote Notifications with Device Token (%@)", deviceToken);
    device_token = [NSString stringWithFormat:@"%@",deviceToken];
    //@"<35afeff6 b841df56 b0c50108 20e47b12 d3cb2d27 ba273634 917e4e72 c0e83848>";
    
    NSLog(@"Device Token : %@",device_token);
    
    
    //NSString *token = [CommonUtils getNotNullString:[[NSUserDefaults standardUserDefaults] objectForKey:@"token_id"]];
    
    //if ([token length]==0) {
        [[NSUserDefaults standardUserDefaults] setObject:device_token forKey:@"token_id"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        [self callRegisteriPhoneDeviceWebservice];
    //}
    

}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    if (error.code == 3010) {
        NSLog(@"Push notifications are not supported in the iOS Simulator.");
    } else {
        // show some alert or otherwise handle the failure to register.
        NSLog(@"application:didFailToRegisterForRemoteNotificationsWithError: %@", error);
    }
    
    NSLog(@"Did Fail to Register for Remote Notifications");
    NSLog(@"%@, %@", error, error.localizedDescription);
}

#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}
#endif

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //For iOS < 8
    
    NSLog(@"didReceiveRemoteNotification called");
    NSLog(@"USER INFO - %@",userInfo);
    
    for (id key in userInfo) {
        NSLog(@"key: %@, value: %@", key, [userInfo objectForKey:key]);
    }
    
    NSString *notifMessage = [CommonUtils getNotNullString:[[userInfo valueForKey:@"aps"] valueForKey:@"alert"]];
    NSString *strSubject = [userInfo objectForKey:@"subject"];
    
    ShowAlert(strSubject, notifMessage);
    // [self handlePush:application forRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    // For iOS 8+
    
    NSLog(@"handleActionWithIdentifier called");
    NSLog(@"USER INFO - %@",userInfo);
    
    for (id key in userInfo) {
        NSLog(@"key: %@, value: %@", key, [userInfo objectForKey:key]);
    }
    
    NSString *notifMessage = [CommonUtils getNotNullString:[[userInfo valueForKey:@"aps"] valueForKey:@"alert"]];
    NSString *strSubject = [userInfo objectForKey:@"subject"];

    ShowAlert(strSubject, notifMessage);
    // [self handlePush:application forRemoteNotification:userInfo];
}

#pragma mark -
/*
 -(void)handlePush:(UIApplication *)application forRemoteNotification:(NSDictionary *)userInfo
{
    // To Show ALert on App Start
    notifMessage = [[userInfo valueForKey:@"aps"] valueForKey:@"alert"];
    //ShowAlert(AlertTitle, notifMessage);
    
    // To Show Badge Count on App Icon
    application.applicationIconBadgeNumber = 0;
    
    NSInteger badgeNumber = [[[userInfo objectForKey:@"aps"] objectForKey:@"badge"] intValue];
    [application setApplicationIconBadgeNumber:badgeNumber];
    NSLog(@"Badge %ld",(long)badgeNumber);
    
    // Navigate By Push Type
    strType = [userInfo objectForKey:@"type"];
    strSubject = [userInfo objectForKey:@"subject"];
    
    if ([userInfo objectForKey:@"wave_id"]) {
        
        wID = [userInfo objectForKey:@"wave_id"];
    }
    
    [CommonUtils alertViewDelegateWithTitle:strSubject
                                withMessage:notifMessage
                                  andTarget:self
                            forCancelString:@"View"
                       forOtherButtonString:@"Cancel"
                                    withTag:100];
}
 */

#pragma mark - webservice call
-(void)callRegisteriPhoneDeviceWebservice {
    [CommonUtils callWebservice:@selector(register_iphone_device) forTarget:self];
}

#pragma mark - Webservice Request
-(void)register_iphone_device
{
    
    
    NSString *deviceId  = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    [[NSUserDefaults standardUserDefaults] setObject:deviceId forKey:@"device_id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSString *myURL = [NSString stringWithFormat:@"%@register_iphone_device",WEBSERVICE_URL];
    NSMutableURLRequest *Request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: myURL]];
    
    NSString *params = [NSString stringWithFormat:@"device_id=%@&token_id=%@&device=iphone",deviceId,device_token];
    
    [Request setHTTPMethod:@"POST"];
    [Request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    [NSURLConnection sendAsynchronousRequest:Request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (connectionError == nil) {
            
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
            }
        }
        else {
            
        }
        
    }];
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return YES;
}



@end
