//
//  FavLiquor.h
//  AmericanDiveBars
//
//  Created by spaculus on 10/6/15.
//  Copyright © 2015 spaculus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FavLiquor : NSObject
@property (strong, nonatomic) NSString *fav_liquor_id;
@property (strong, nonatomic) NSString *fav_liquor_title;
@property (strong, nonatomic) NSString *fav_liquor_type;
@property (strong, nonatomic) NSString *fav_liquor_producer;
@property (strong, nonatomic) NSString *fav_date_added;
@property (strong, nonatomic) NSString *fav_checked;
@property (strong, nonatomic) NSString *fav_liquor_image;
@property (strong, nonatomic) NSIndexPath *indexPath;
+(instancetype)getFavLiquorWithDictionary:(NSDictionary *)dict;
@end
