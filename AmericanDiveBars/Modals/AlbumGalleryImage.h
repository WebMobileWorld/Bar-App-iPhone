//
//  AlbumGalleryImage.h
//  AmericanDiveBars
//
//  Created by spaculus on 10/8/15.
//  Copyright © 2015 spaculus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlbumGalleryImage : NSObject
@property (strong, nonatomic)  NSString * gal_bar_gallery_id;
@property (strong, nonatomic)  NSString * gal_bar_image_id;
@property (strong, nonatomic)  NSString * gal_bar_image_name;
@property (strong, nonatomic)  NSString * gal_image_title;

@property (strong, nonatomic)  NSString * gal_pre_img_name;
@property (strong, nonatomic)  NSString * gal_pre_img_id;
@property (strong, nonatomic)  UIImage *gal_localImage;
@property (assign, nonatomic)  BOOL gal_from_WS;
@property (strong, nonatomic)  NSString * gal_type;
@property (assign, nonatomic)  BOOL  gal_imgEdited;
@property (assign, nonatomic)  BOOL isNewImageAdded;

+(instancetype)getAlbumGalleryImageWithDictionary:(NSDictionary *)dict;
+(instancetype)getAlbumGalleryImageWithLocalDictionary:(NSDictionary *)dict;

@end
