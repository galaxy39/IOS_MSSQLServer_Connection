//
//  CommonApi.m
//  MysqlConnection
//
//  Created by Galaxy39 on 10/15/13.
//  Copyright (c) 2013 oDesk. All rights reserved.
//

#import "CommonApi.h"

@implementation CommonApi
+(NSString*)dateToString:(NSDate*)date
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd hh-mm-ss"];
    return [formatter stringFromDate:date];
}
+(NSDate*)stringToDate:(NSString*)date
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd hh-mm-ss"];
    return [formatter dateFromString:date];
}
@end
