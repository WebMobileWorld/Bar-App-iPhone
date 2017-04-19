//
//  LiquorDetail.m
//  AmericanDiveBars
//
//  Created by spaculus on 9/30/15.
//  Copyright © 2015 spaculus. All rights reserved.
//

#import "LiquorDetail.h"

@implementation LiquorDetail
+(instancetype)getLiquorDetailWithDictionary:(NSDictionary *)dict {
    LiquorDetail *liquorDetail = [[LiquorDetail alloc] init];
    
    liquorDetail.liquor_country = [CommonUtils getNotNullString:[dict valueForKey:@"country"]];
    liquorDetail.liquor_fav_liquor= [CommonUtils getNotNullString:[dict valueForKey:@"fav_liquor"]];
    liquorDetail.liquor_image_default = [CommonUtils getNotNullString:[dict valueForKey:@"image_default"]];
    liquorDetail.liquor_like_liquor = [CommonUtils getNotNullString:[dict valueForKey:@"like_liquor"]];
    liquorDetail.liquor_liquor_description = [CommonUtils getNotNullString:[dict valueForKey:@"liquor_description"]];
    liquorDetail.liquor_liquor_id = [CommonUtils getNotNullString:[dict valueForKey:@"liquor_id"]];
    liquorDetail.liquor_liquor_image = [CommonUtils getNotNullString:[dict valueForKey:@"liquor_image"]];
    liquorDetail.liquor_liquor_title = [CommonUtils getNotNullString:[dict valueForKey:@"liquor_title"]];
    liquorDetail.liquor_slug = [CommonUtils getNotNullString:[dict valueForKey:@"liquor_slug"]];
    
    
    liquorDetail.liquor_producer =  [CommonUtils getNotNullString:[dict valueForKey:@"producer"]];
    liquorDetail.liquor_proof = [CommonUtils getNotNullString:[dict valueForKey:@"proof"]];
    liquorDetail.liquor_type = [CommonUtils getNotNullString:[dict valueForKey:@"type"]];
    liquorDetail.liquor_upload_type = [CommonUtils getNotNullString:[dict valueForKey:@"upload_type"]];
    liquorDetail.liquor_video_link = [CommonUtils getNotNullString:[dict valueForKey:@"video_link"]];
    
    liquorDetail.liquor_status = [CommonUtils getNotNullString:[dict valueForKey:@"status"]];
    
    return liquorDetail;
}

@end
