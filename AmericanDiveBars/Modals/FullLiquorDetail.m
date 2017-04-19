//
//  FullLiquorDetail.m
//  AmericanDiveBars
//
//  Created by spaculus on 9/30/15.
//  Copyright © 2015 spaculus. All rights reserved.
//

#import "FullLiquorDetail.h"

@implementation FullLiquorDetail
+(instancetype)getFullLiquorDetailWithDictionary:(NSDictionary *)dict {
    FullLiquorDetail *fullLiquorDetail = [[FullLiquorDetail alloc] init];
    
    LiquorDetail *liquorDetail = [LiquorDetail getLiquorDetailWithDictionary:[[[dict valueForKey:@"liquor_detail"] valueForKey:@"result"] objectAtIndex:0]];
    fullLiquorDetail.liquorDetail = liquorDetail;
    
    fullLiquorDetail.aryLiquorComments = [self getLiquorComments:[[dict valueForKey:@"liquorcomments"] valueForKey:@"result"]];
    
    return fullLiquorDetail;
}

+(NSMutableArray *)getLiquorComments:(NSArray *)aryLiquorComments_ {
    NSMutableArray *aryComments = [@[] mutableCopy];
    if ([aryComments count]>0) {
        [aryComments removeAllObjects];
    }
    
    for (NSDictionary *dict in aryLiquorComments_) {
        LiquorComment *liquorComment = [LiquorComment getLiquorCommentWithDictionary:dict];
        [aryComments addObject:liquorComment];
    }
    return aryComments;
}

@end
