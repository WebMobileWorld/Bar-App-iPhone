//
//  LiquorServed.m
//  AmericanDiveBars
//
//  Created by spaculus on 9/16/15.
//  Copyright (c) 2015 spaculus. All rights reserved.
//

#import "LiquorServed.h"

@implementation LiquorServed
+(instancetype)getLiquorServedWithDictionary:(NSDictionary *)dict {
    LiquorServed *liquorServed = [[LiquorServed alloc] init];
    
    liquorServed.liquor_id = [CommonUtils getNotNullString:[dict valueForKey:@"liquor_id"]];
    liquorServed.liquor_image = [CommonUtils getNotNullString:[dict valueForKey:@"liquor_image"]];
    liquorServed.liquor_title = [CommonUtils getNotNullString:[dict valueForKey:@"liquor_title"]];
    liquorServed.liquor_producer = [CommonUtils getNotNullString:[dict valueForKey:@"producer"]];
    liquorServed.liquor_proof = [CommonUtils getNotNullString:[dict valueForKey:@"proof"]];
    liquorServed.liquor_type = [CommonUtils getNotNullString:[dict valueForKey:@"type"]];
    
    return liquorServed;
}

@end
