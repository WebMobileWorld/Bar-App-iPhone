//
//  AlbumDetail.m
//  AmericanDiveBars
//
//  Created by spaculus on 10/8/15.
//  Copyright © 2015 spaculus. All rights reserved.
//

#import "AlbumDetail.h"

@implementation AlbumDetail
+(instancetype)getAlbumDetailWithDictionary:(NSDictionary *)dict {
    AlbumDetail *albumDetail = [[AlbumDetail alloc] init];
    
    Album *album = [Album getAlbumWithDictionary:[dict valueForKey:@"gallery"]];
    albumDetail.album = album;
    albumDetail.aryGalImages = [AlbumDetail getGalleryImages:[dict valueForKey:@"galleryimages"]];
    
    albumDetail.imgCount = albumDetail.aryGalImages.count;
    return albumDetail;
}

+(NSArray *)getGalleryImages:(NSArray *)aryGalImages_ {
    NSMutableArray *aryImages = [@[] mutableCopy];
    if ([aryImages count]>0) {
        [aryImages removeAllObjects];
    }
    
    for (NSDictionary *dict in aryGalImages_) {
        AlbumGalleryImage *galImage = [AlbumGalleryImage getAlbumGalleryImageWithDictionary:dict];
        [aryImages addObject:galImage];
    }
    return aryImages;
}

@end
