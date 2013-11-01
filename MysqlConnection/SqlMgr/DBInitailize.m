//
//  DBInitailize.m
//  Tradie_Diary
//
//  Created by Galaxy39 on 11/26/12.
//  Copyright (c) 2012 Anthony. All rights reserved.
//

#import "DBInitailize.h"


@implementation DBInitailize
-(BOOL)initialize
{
    NSString * source_db_path = [[NSBundle mainBundle] pathForResource:@"MysqlConnect" ofType:@"sqlite"];
    NSLog(@"%@",source_db_path);
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * filePath = [paths objectAtIndex:0];
    NSString * dbFilePath = [filePath stringByAppendingPathComponent:@"MysqlConnect.sqlite"];
    NSError * error = nil;
//   if([[NSFileManager defaultManager] fileExistsAtPath:dbFilePath])
//       [[NSFileManager defaultManager] removeItemAtPath:dbFilePath error:&error];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:dbFilePath]){
        [[NSFileManager defaultManager] copyItemAtPath:source_db_path toPath:dbFilePath error:&error];
    }
    else
        return NO;
    
    DBConnector * m_connector = [[DBConnector alloc]init];
    [m_connector createTables];
    return YES;
}
@end
