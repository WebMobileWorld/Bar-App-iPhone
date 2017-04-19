//
//  BarGallery.m
//  AmericanDiveBars
//
//  Created by spaculus on 9/16/15.
//  Copyright (c) 2015 spaculus. All rights reserved.
//

#import "BarGallery.h"

@implementation BarGallery
+(instancetype)getBarGalleryWithDictionary:(NSDictionary *)dict {
    
    BarGallery *barGallery = [[BarGallery alloc] init];
    
    barGallery.bargal_image_name = [CommonUtils getNotNullString:[dict valueForKey:@"bar_image_name"]];
    barGallery.bargal_description  = [CommonUtils getNotNullString:[dict valueForKey:@"description"]];
    barGallery.bargal_image_link = [CommonUtils getNotNullString:[dict valueForKey:@"image_link"]];
    barGallery.bargal_image_title = [CommonUtils getNotNullString:[dict valueForKey:@"image_title"]];
    barGallery.bargal_title = [CommonUtils getNotNullString:[dict valueForKey:@"title"]];
    barGallery.bargal_bar_gallery_id = [CommonUtils getNotNullString:[dict valueForKey:@"bar_gallery_id"]];
    
    barGallery.bargal_OriginalImageURL = [BarGallery getOriginalImageURLByName:barGallery.bargal_image_name];
    
    return barGallery;
    
}

+(NSURL *)getOriginalImageURLByName:(NSString *)imageName {
    NSString *strImgURL = [NSString stringWithFormat:@"%@%@%@",WEBIMAGE_URL,BARGALLARY_ORIGINAL,imageName];
    NSURL *imgURL = [NSURL URLWithString:strImgURL];
    return imgURL;
}

+(UIImage *)getOriginalImageWithURL:(NSURL *)url {
    UIImage *imgOriginal = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    return imgOriginal;
}

@end
