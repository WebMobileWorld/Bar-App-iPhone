//
//  LiquorDirectory.m
//  AmericanDiveBars
//
//  Created by spaculus on 9/12/15.
//  Copyright (c) 2015 spaculus. All rights reserved.
//

#import "LiquorDirectory.h"

@implementation LiquorDirectory
+(instancetype)getLiquorWithDictionary:(NSDictionary *)dict {
    LiquorDirectory *liquor = [[LiquorDirectory alloc] init];
    
    liquor.liquor_id = [CommonUtils getNotNullString:[dict valueForKey:@"liquor_id"]];
    liquor.liquor_image = [CommonUtils getNotNullString:[dict valueForKey:@"liquor_image"]];
    liquor.liquor_title = [CommonUtils getNotNullString:[dict valueForKey:@"liquor_title"]];
    liquor.liquor_producer = [CommonUtils getNotNullString:[dict valueForKey:@"producer"]];
    liquor.liquor_proof = [CommonUtils getNotNullString:[dict valueForKey:@"proof"]];
    liquor.liquor_status = [CommonUtils getNotNullString:[dict valueForKey:@"status"]];
    liquor.liquor_type = [CommonUtils getNotNullString:[dict valueForKey:@"type"]];

    return liquor;
}
@end
