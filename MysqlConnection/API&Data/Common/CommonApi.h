//
//  CommonApi.h
//  MysqlConnection
//
//  Created by Galaxy39 on 10/15/13.
//  Copyright (c) 2013 oDesk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonApi : NSObject
+(NSString*)dateToString:(NSDate*)date;
+(NSDate*)stringToDate:(NSString*)date;
@end
