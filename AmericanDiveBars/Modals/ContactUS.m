//
//  ContactUS.m
//  AmericanDiveBars
//
//  Created by spaculus on 10/23/15.
//  Copyright © 2015 spaculus. All rights reserved.
//

#import "ContactUS.h"

@implementation ContactUS
+(instancetype)getContactUSWithDictionary:(NSDictionary *)dict {
    
    ContactUS *contactToUs = [[ContactUS alloc] init];
    
    contactToUs.address = [CommonUtils getNotNullString:[dict valueForKey:@"site_address"]];
    contactToUs.phone = [CommonUtils getNotNullString:@"800.303.8803"];
    contactToUs.email = [CommonUtils getNotNullString:[dict valueForKey:@"site_email"]];
    contactToUs.website = [CommonUtils getNotNullString:[dict valueForKey:@"site_name"]];
    
    return contactToUs;
    
}
@end
