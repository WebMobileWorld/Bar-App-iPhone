//
//  LiquorDetail.h
//  AmericanDiveBars
//
//  Created by spaculus on 9/30/15.
//  Copyright © 2015 spaculus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LiquorDetail : NSObject
@property (strong, nonatomic) NSString *liquor_country;
@property (strong, nonatomic) NSString *liquor_fav_liquor;
@property (strong, nonatomic) NSString *liquor_image_default;
@property (strong, nonatomic) NSString *liquor_like_liquor;
@property (strong, nonatomic) NSString *liquor_liquor_description;
@property (strong, nonatomic) NSString *liquor_liquor_id;
@property (strong, nonatomic) NSString *liquor_liquor_image;
@property (strong, nonatomic) NSString *liquor_liquor_title;
@property (strong, nonatomic) NSString *liquor_producer;
@property (strong, nonatomic) NSString *liquor_proof;
@property (strong, nonatomic) NSString *liquor_type;
@property (strong, nonatomic) NSString *liquor_upload_type;
@property (strong, nonatomic) NSString *liquor_video_link;
@property (strong, nonatomic) NSString *liquor_status;
@property (strong, nonatomic) NSString *liquor_slug;
+(instancetype)getLiquorDetailWithDictionary:(NSDictionary *)dict;
@end
