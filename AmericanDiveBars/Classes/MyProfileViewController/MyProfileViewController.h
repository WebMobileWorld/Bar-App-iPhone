//
//  MyProfileViewController.h
//  AmericanDiveBars
//
//  Created by spaculus on 10/2/15.
//  Copyright © 2015 spaculus. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MyProfileControllerDelegate <NSObject>
-(void)removeMyProfile;
@end

@interface MyProfileViewController : UIViewController
@property (nonatomic, strong) id<MyProfileControllerDelegate> delegate;
@property (nonatomic, assign) BOOL isMyProfileFromMenu;
-(void)selectedTableRow:(NSUInteger)rowNum;
@end
