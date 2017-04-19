//
//  AlbumGalleryImage.m
//  AmericanDiveBars
//
//  Created by spaculus on 10/8/15.
//  Copyright © 2015 spaculus. All rights reserved.
//

#import "AlbumGalleryImage.h"

@implementation AlbumGalleryImage
+(instancetype)getAlbumGalleryImageWithDictionary:(NSDictionary *)dict {
    AlbumGalleryImage *galImage = [[AlbumGalleryImage alloc] init];
    
    galImage.gal_bar_gallery_id = [CommonUtils getNotNullString:[dict valueForKey:@"bar_gallery_id"]];
    galImage.gal_bar_image_id = [CommonUtils getNotNullString:[dict valueForKey:@"bar_image_id"]];
    galImage.gal_bar_image_name = [CommonUtils getNotNullString:[dict valueForKey:@"bar_image_name"]];
    galImage.gal_pre_img_name = galImage.gal_bar_image_name;
    galImage.gal_pre_img_id = galImage.gal_bar_image_id;
    galImage.gal_image_title = [CommonUtils getNotNullString:[dict valueForKey:@"image_title"]];
    galImage.gal_imgEdited = NO;
    galImage.gal_from_WS = YES;
    galImage.isNewImageAdded = NO;
    return galImage;
    
}

+(instancetype)getAlbumGalleryImageWithLocalDictionary:(NSDictionary *)dict {
    AlbumGalleryImage *galImage = [[AlbumGalleryImage alloc] init];
    
    galImage.gal_pre_img_name = [CommonUtils getNotNullString:[dict valueForKey:@"gal_pre_img_name"]];
    galImage.gal_pre_img_id = [CommonUtils getNotNullString:[dict valueForKey:@"gal_pre_img_id"]];
    galImage.gal_bar_image_name = [CommonUtils getNotNullString:[dict valueForKey:@"bar_image_name"]];
    galImage.gal_image_title = [CommonUtils getNotNullString:[dict valueForKey:@"image_title"]];
    galImage.gal_type = [CommonUtils getNotNullString:[dict valueForKey:@"type"]];
    galImage.gal_imgEdited = YES;
    galImage.gal_localImage = [dict valueForKey:@"image"];
    
    galImage.gal_from_WS = NO;
    return galImage;
}
@end
