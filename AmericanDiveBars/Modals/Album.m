//
//  Album.m
//  AmericanDiveBars
//
//  Created by spaculus on 10/7/15.
//  Copyright © 2015 spaculus. All rights reserved.
//

#import "Album.h"

@implementation Album
+(instancetype)getAlbumWithDictionary:(NSDictionary *)dict {
    Album *album = [[Album alloc] init];
    
    album.album_bar_gallery_id = [CommonUtils getNotNullString:[dict valueForKey:@"bar_gallery_id"]];
    album.album_bar_id = [CommonUtils getNotNullString:[dict valueForKey:@"bar_id"]];
    album.album_date_added = [CommonUtils getNotNullString:[dict valueForKey:@"date_added"]];
    album.album_description = [CommonUtils getNotNullString:[dict valueForKey:@"description"]];
    album.album_gallery = [CommonUtils getNotNullString:[dict valueForKey:@"gallery"]];
    album.album_reorder = [CommonUtils getNotNullString:[dict valueForKey:@"reorder"]];
    album.album_status = [CommonUtils getNotNullString:[dict valueForKey:@"status"]];
    album.album_title = [CommonUtils getNotNullString:[dict valueForKey:@"title"]];
    album.album_checked = @"0";
    album.indexPath = nil;
    
    return album;
}
@end
