//
//  FavBar.h
//  AmericanDiveBars
//
//  Created by spaculus on 10/6/15.
//  Copyright © 2015 spaculus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FavBar : NSObject
@property (strong, nonatomic) NSString *fav_bar_id;
@property (strong, nonatomic) NSString *fav_bar_title;
@property (strong, nonatomic) NSString *fav_bar_type;
@property (strong, nonatomic) NSString *fav_date_added;
@property (strong, nonatomic) NSString *fav_checked;
@property (strong, nonatomic) NSString *fav_bar_logo;

@property (strong, nonatomic) NSIndexPath *indexPath;
+(instancetype)getFavBarWithDictionary:(NSDictionary *)dict;
@end
