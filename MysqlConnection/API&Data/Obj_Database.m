//
//  Obj_Database.m
//  MysqlConnection
//
//  Created by Galaxy39 on 10/15/13.
//  Copyright (c) 2013 oDesk. All rights reserved.
//

#import "Obj_Database.h"

@implementation Obj_Database
@synthesize dbDescription,dbHost,dbId,dbName,dbPasswd,dbPort,dbUserName,dbDateStr;
@end

@implementation Obj_Query
@synthesize query_columns,query_dbId,query_Id,query_searchRule,query_tableName,query_showName,query_dbName;
@end