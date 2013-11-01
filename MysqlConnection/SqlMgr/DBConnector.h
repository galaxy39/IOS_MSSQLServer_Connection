//
//  DBConnector.h
//  ARSLanch
//
//  Created by Galaxy39 on 1/29/13.
//  Copyright (c) 2013 FED. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SQLMgr.h"
#import "Obj_Database.h"

#define CREATE_DB_SQL_PREFIX  @"CREATE TABLE IF NOT EXISTS "
#define DELETE_DB_SQL_PREFIX    @"DROP TABLE IF EXISTS "

@interface DBConnector : NSObject
{
    SQLMgr * mDatabase;
}
-(void)createTables;
- (void)insertIntoHistory:(Obj_Database*)item;
- (NSMutableArray*)getHistoryArray;
- (NSMutableArray*)getDeletedArray;
- (void)updateHistory:(Obj_Database*)item;
- (void)AddToHistory:(Obj_Database*)item;
- (void)DeleteFromHistory:(Obj_Database*)item;
//////////
- (void)insertBuildQuery:(Obj_Database*)item :(NSString*)tableName :(NSString*)columns :(NSString*)searchRule;
- (void)updateBuildQuery:(Obj_Query*)item;
- (void)deleteBuildQuery:(Obj_Query*)item;
- (NSMutableArray *)getQuerys;
@end
