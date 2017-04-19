//
//  SPHDetail.m
//  AmericanDiveBars
//
//  Created by spaculus on 5/11/16.
//  Copyright © 2016 spaculus. All rights reserved.
//

#import "SPHDetail.h"

@implementation SPHDetail
+(SPHDetail *)getSpecialHourDetailFromDict:(NSDictionary *)dict {
    SPHDetail *sphDetail = [[SPHDetail alloc] init];
    
    sphDetail.detailName = [CommonUtils getNotNullString:[dict valueForKey:@"name"]];
    sphDetail.price =[CommonUtils getNotNullString:[dict valueForKey:@"price"]];
    sphDetail.cat =[CommonUtils getNotNullString:[dict valueForKey:@"cat"]];
    
    return sphDetail;
}
@end
