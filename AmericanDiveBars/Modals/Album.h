//
//  Album.h
//  AmericanDiveBars
//
//  Created by spaculus on 10/7/15.
//  Copyright © 2015 spaculus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Album : NSObject
@property (strong, nonatomic) NSString *album_bar_gallery_id;
@property (strong, nonatomic) NSString *album_bar_id;
@property (strong, nonatomic) NSString *album_date_added;
@property (strong, nonatomic) NSString *album_description;
@property (strong, nonatomic) NSString *album_gallery;
@property (strong, nonatomic) NSString *album_reorder;
@property (strong, nonatomic) NSString *album_status;
@property (strong, nonatomic) NSString *album_title;
@property (strong, nonatomic) NSString *album_checked;
@property (strong, nonatomic) NSIndexPath *indexPath;

+(instancetype)getAlbumWithDictionary:(NSDictionary *)dict;

@end
