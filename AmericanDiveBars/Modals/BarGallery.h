//
//  BarGallery.h
//  AmericanDiveBars
//
//  Created by spaculus on 9/16/15.
//  Copyright (c) 2015 spaculus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BarGallery : NSObject
@property (strong, nonatomic) NSString *bargal_image_name;
@property (strong, nonatomic) NSString *bargal_description;
@property (strong, nonatomic) NSString *bargal_image_link;
@property (strong, nonatomic) NSString *bargal_image_title;
@property (strong, nonatomic) NSString *bargal_title;
@property (strong, nonatomic) NSString *bargal_bar_gallery_id;

@property (strong, nonatomic) NSURL *bargal_OriginalImageURL;

+(instancetype)getBarGalleryWithDictionary:(NSDictionary *)dict;
@end
