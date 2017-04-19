//
//  AlbumDetail.h
//  AmericanDiveBars
//
//  Created by spaculus on 10/8/15.
//  Copyright © 2015 spaculus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlbumDetail : NSObject
@property (strong, nonatomic) Album *album;
@property (strong, nonatomic) NSArray *aryGalImages;
@property (nonatomic, assign) NSInteger imgCount;
+(instancetype)getAlbumDetailWithDictionary:(NSDictionary *)dict;
@end
