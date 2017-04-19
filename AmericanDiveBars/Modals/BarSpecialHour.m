//
//  BarSpecialHour.m
//  AmericanDiveBars
//
//  Created by spaculus on 2/24/16.
//  Copyright © 2016 spaculus. All rights reserved.
//

#import "BarSpecialHour.h"
#import "SPHDetail.h"

@implementation BarSpecialHour
+(instancetype)getBarSpecialHourWithDictionary:(NSDictionary *)dict {
    BarSpecialHour *specialHour = [[BarSpecialHour alloc] init];
    
    specialHour.sph_bar_hour_id = [CommonUtils getNotNullString:[dict valueForKey:@"bar_hour_id"]];
    specialHour.sph_bar_id = [CommonUtils getNotNullString:[dict valueForKey:@"bar_id"]];
    specialHour.sph_day = [CommonUtils getNotNullString:[dict valueForKey:@"day"]];
    specialHour.sph_days = [CommonUtils getNotNullString:[dict valueForKey:@"days"]];
    
    specialHour.sph_hour_from = [CommonUtils getNotNullString:[dict valueForKey:@"hour_from"]];
    specialHour.sph_hour_to = [CommonUtils getNotNullString:[dict valueForKey:@"hour_to"]];
    
    NSString *price = [CommonUtils getNotNullString:[dict valueForKey:@"price"]];
    NSString *priceValue = [price stringByReplacingOccurrencesOfString:@"$" withString:@""];
    specialHour.sph_price = priceValue;
    
    specialHour.sph_speciality = [CommonUtils getNotNullString:[dict valueForKey:@"speciality"]];
    
    specialHour.sph_duration = [NSString stringWithFormat:@"%@ - %@",specialHour.sph_hour_from,specialHour.sph_hour_to];
    
    
    NSString *name = @"";
    

    NSString *beer_name = [CommonUtils getNotNullString:[dict valueForKey:@"beer_name"]];
    NSString *cocktail_name = [CommonUtils getNotNullString:[dict valueForKey:@"cocktail_name"]];
    NSString *food_name = [CommonUtils getNotNullString:[dict valueForKey:@"food_name"]];
    NSString *liquor_name = [CommonUtils getNotNullString:[dict valueForKey:@"liquor_name"]];
    NSString *other_name = [CommonUtils getNotNullString:[dict valueForKey:@"other_name"]];
    
    NSString *sp_beer_price = [CommonUtils getNotNullString:[dict valueForKey:@"sp_beer_price"]];
    NSString *beer_price = [sp_beer_price stringByReplacingOccurrencesOfString:@"$" withString:@""];

    NSString *sp_cocktail_price = [CommonUtils getNotNullString:[dict valueForKey:@"sp_cocktail_price"]];
    NSString *cocktail_price = [sp_cocktail_price stringByReplacingOccurrencesOfString:@"$" withString:@""];
    
    NSString *sp_liquor_price = [CommonUtils getNotNullString:[dict valueForKey:@"sp_liquor_price"]];
    NSString *liquor_price = [sp_liquor_price stringByReplacingOccurrencesOfString:@"$" withString:@""];

    
    NSString *sp_food_price = [CommonUtils getNotNullString:[dict valueForKey:@"food_price"]];
    NSString *food_price = [sp_food_price stringByReplacingOccurrencesOfString:@"$" withString:@""];

    
    NSString *sp_other_price = [CommonUtils getNotNullString:[dict valueForKey:@"other_price"]];
    NSString *other_price = [sp_other_price stringByReplacingOccurrencesOfString:@"$" withString:@""];

    
    specialHour.sph_cat = [CommonUtils getNotNullString:[dict valueForKey:@"cat"]];
    
    NSString *catname = @"";
    if ([specialHour.sph_cat isEqualToString:@"beer"]) {
        name = beer_name;
        specialHour.sph_price = [NSString stringWithFormat:@"$ %@",beer_price];
        catname = @"Beer Name :";
    }
    else if ([specialHour.sph_cat isEqualToString:@"cocktail"]) {
        name = cocktail_name;
        specialHour.sph_price = [NSString stringWithFormat:@"$ %@",cocktail_price];
        catname = @"Cocktail Name :";
    }
    else if ([specialHour.sph_cat isEqualToString:@"food"]) {
        name = food_name;
        specialHour.sph_price = [NSString stringWithFormat:@"$ %@",food_price];
        catname = @"Food Name :";
    }
    else if ([specialHour.sph_cat isEqualToString:@"liquor"]) {
        name = liquor_name;
        specialHour.sph_price = [NSString stringWithFormat:@"$ %@",liquor_price];
        catname = @"Liquor Name :";
    }
    else {
        name = other_name;
        specialHour.sph_price = [NSString stringWithFormat:@"$ %@",other_price];
        catname = @"Other Name :";
    }
    
    NSDictionary *dictSPH_Detail = @{@"price":specialHour.sph_price,@"name":name,@"cat":catname};
    specialHour.sph_detail = [BarSpecialHour getDetailFromDict:dictSPH_Detail];
    
    // specialHour.sph_detail = [NSString stringWithFormat:@"%@ $ %@",specialHour.sph_speciality,specialHour.sph_price];
    
    return specialHour;
}

+(SPHDetail *)getDetailFromDict:(NSDictionary *)dict {
    SPHDetail *sphDetail = [SPHDetail getSpecialHourDetailFromDict:dict];
    return sphDetail;
}

@end
/*
 "bar_hour_id" = 7;
 "bar_id" = 68645;
 day = 1;
 days = Monday;
 "hour_from" = "6:00 PM";
 "hour_to" = "10:00 PM";
 price = "$10";
 speciality = "Rum Cocktails";
 */
