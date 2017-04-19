//
//  CMSPageViewController.h
//  BreetyNetwork
//
//  Created by admin on 04/03/15.
//  Copyright (c) 2015 spaculus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMSPageViewController : UIViewController<UIWebViewDelegate>
@property (nonatomic, strong) NSString *cmsPageSlug;
@property (nonatomic, strong) NSString *topTitle;

-(void)selectedTableRow:(NSUInteger)rowNum;
@end
