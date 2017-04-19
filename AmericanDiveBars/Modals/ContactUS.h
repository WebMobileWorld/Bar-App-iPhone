//
//  ContactUS.h
//  AmericanDiveBars
//
//  Created by spaculus on 10/23/15.
//  Copyright © 2015 spaculus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactUS : NSObject
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *website;
+(instancetype)getContactUSWithDictionary:(NSDictionary *)dict;
@end
