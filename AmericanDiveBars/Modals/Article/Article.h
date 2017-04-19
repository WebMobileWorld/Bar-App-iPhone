//
//  Article.h
//  AmericanDiveBars
//
//  Created by spaculus on 4/21/16.
//  Copyright © 2016 spaculus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Article : NSObject

@property (strong, nonatomic) NSString * blog_title;
@property (strong, nonatomic) NSString * blog_id;
@property (strong, nonatomic) NSString * blog_image;
@property (strong, nonatomic) NSString * blog_description;
@property (strong, nonatomic) NSString * blog_description_with_image;
@property (strong, nonatomic) NSString * total_rating;
@property (strong, nonatomic) NSString * date_added;

@property (strong, nonatomic) NSString * first_name;
@property (strong, nonatomic) NSString * last_name;
@property (strong, nonatomic) NSString * fullName;

@property (strong, nonatomic) NSString * base64_blog_id;

+(instancetype)getArticleWithDictionary:(NSDictionary *)dict;
@end


/*
 {
 "admin_id" = 0;
 "blog_description" = "<p>tet</p>\n";
 "blog_id" = 118;
 "blog_image" = "blog_image53913.jpg";
 "blog_meta_description" = "";
 "blog_meta_keyword" = "";
 "blog_meta_title" = "";
 "blog_title" = test;
 "date_added" = "2016-04-01 10:50:42";
 "first_name" = "<null>";
 "last_name" = "<null>";
 "master_id" = 0;
 status = active;
 "total_number" = 2;
 "total_rating" = 5;
 "user_id" = 0;
 
 
 :@"total_rating"]];
 
 }
 */