//
//  FavLiquor.m
//  AmericanDiveBars
//
//  Created by spaculus on 10/6/15.
//  Copyright © 2015 spaculus. All rights reserved.
//

#import "FavLiquor.h"

@implementation FavLiquor
+(instancetype)getFavLiquorWithDictionary:(NSDictionary *)dict {
    FavLiquor *favLiquor = [[FavLiquor alloc] init];
    favLiquor.fav_liquor_id = [CommonUtils getNotNullString:[dict valueForKey:@"liquor_id"]];
    favLiquor.fav_liquor_title = [CommonUtils getNotNullString:[dict valueForKey:@"liquor_title"]];
    favLiquor.fav_liquor_type = [CommonUtils getNotNullString:[dict valueForKey:@"type"]];
    favLiquor.fav_liquor_producer = [CommonUtils getNotNullString:[dict valueForKey:@"brewed_by"]];
    favLiquor.fav_date_added = [CommonUtils getNotNullString:[dict valueForKey:@"date"]];
    favLiquor.fav_liquor_image = [CommonUtils getNotNullString:[dict valueForKey:@"liquor_image"]];
    
    favLiquor.fav_checked = @"0";
    favLiquor.indexPath = nil;
    return favLiquor;
}

@end
