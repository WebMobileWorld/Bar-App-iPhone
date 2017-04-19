//
//  Article.m
//  AmericanDiveBars
//
//  Created by spaculus on 4/21/16.
//  Copyright © 2016 spaculus. All rights reserved.
//

#import "Article.h"

@implementation Article
+(instancetype)getArticleWithDictionary:(NSDictionary *)dict {
    
    Article *article = [[Article alloc] init];
    
    article.blog_description =  [CommonUtils removeHTMLFromString:[CommonUtils getNotNullString:[dict valueForKey:@"blog_description"]]];
    article.blog_description_with_image = [CommonUtils getNotNullString:[dict valueForKey:@"blog_description_with_image"]];
    //[CommonUtils getNotNullString:[dict valueForKey:@"blog_description"]];
    article.blog_id = [CommonUtils getNotNullString:[dict valueForKey:@"blog_id"]];
    article.blog_image = [CommonUtils getNotNullString:[dict valueForKey:@"blog_image"]];
    article.blog_title = [CommonUtils getNotNullString:[dict valueForKey:@"blog_title"]];
    article.first_name = [CommonUtils getNotNullString:[dict valueForKey:@"first_name"]];
    article.last_name = [CommonUtils getNotNullString:[dict valueForKey:@"last_name"]];
    article.total_rating = [CommonUtils getNotNullString:[dict valueForKey:@"total_rating"]];
    
    
    article.base64_blog_id = @"";
    
    NSString * strDate = [CommonUtils getNotNullString:[dict valueForKey:@"date_added"]];
    
     article.date_added = [CommonUtils getDateFormattedFromStringDate:strDate withInputFormat:@"yyyy-MM-dd HH:mm:ss" andOutputFormat:@"MM-dd-yyyy" isString:YES];
    
    article.fullName = [Article getFullNameFromFirstName:article.first_name andLastName:article.last_name];
    
    
    
    return article;
}


+(NSString *)getFullNameFromFirstName:(NSString *)fname andLastName:(NSString *)lname {
    NSString *fullName = nil;
    
    if ([fname length]>0) {
        fullName = [NSString stringWithFormat:@"%@",fname];
    }
    
    if ([lname length] > 0) {
        if ([fullName length]>0) {
            fullName = [NSString stringWithFormat:@"%@, %@",fullName,lname];
        }
        else {
            fullName = lname;
        }
    }
    if (fullName == nil) {
        fullName = @"";
    }
    return fullName;
    
}

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
 }
 */