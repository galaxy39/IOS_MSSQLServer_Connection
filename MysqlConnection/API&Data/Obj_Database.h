//
//  Obj_Database.h
//  MysqlConnection
//
//  Created by Galaxy39 on 10/15/13.
//  Copyright (c) 2013 oDesk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Obj_Database : NSObject
@property (nonatomic,retain)NSString * dbId;
@property (nonatomic,retain)NSString * dbName;
@property (nonatomic,retain)NSString * dbHost;
@property (nonatomic,retain)NSString * dbUserName;
@property (nonatomic,retain)NSString * dbPasswd;
@property (nonatomic,retain)NSString * dbPort;
@property (nonatomic,retain)NSString * dbDescription;
@property (nonatomic,retain)NSString * dbDateStr;
@end

@interface Obj_Query : NSObject
@property (nonatomic,retain)NSString * query_Id;
@property (nonatomic,retain)NSString * query_dbId;
@property (nonatomic,retain)NSString * query_dbName;
@property (nonatomic,retain)NSString * query_tableName;
@property (nonatomic,retain)NSString * query_columns;
@property (nonatomic,retain)NSString * query_searchRule;
@property (nonatomic,retain)NSString * query_showName;
@end