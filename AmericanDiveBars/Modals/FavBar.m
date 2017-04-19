//
//  FavBar.m
//  AmericanDiveBars
//
//  Created by spaculus on 10/6/15.
//  Copyright © 2015 spaculus. All rights reserved.
//

#import "FavBar.h"

@implementation FavBar
+(instancetype)getFavBarWithDictionary:(NSDictionary *)dict {
    FavBar *favBar = [[FavBar alloc] init];
    favBar.fav_bar_id = [CommonUtils getNotNullString:[dict valueForKey:@"bar_id"]];
    favBar.fav_bar_title = [CommonUtils getNotNullString:[dict valueForKey:@"bar_title"]];
    favBar.fav_bar_type = [CommonUtils getNotNullString:[dict valueForKey:@"bar_type"]];
    favBar.fav_date_added = [CommonUtils getNotNullString:[dict valueForKey:@"date_added"]];
    favBar.fav_bar_logo = [CommonUtils getNotNullString:[dict valueForKey:@"bar_logo"]];
    favBar.fav_checked = @"0";
    favBar.indexPath = nil;
    return favBar;
}

@end
