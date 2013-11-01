//
//  DBConnector.m
//  ARSLanch
//
//  Created by Galaxy39 on 1/29/13.
//  Copyright (c) 2013 FED. All rights reserved.
//

#import "DBConnector.h"
@implementation DBConnector

//////////////////
-(void)createTables
{
    mDatabase = [[SQLMgr alloc]init];
    [mDatabase connect];
    
    if(![mDatabase open]){
        [mDatabase disconnect];
        return;
    }
    
    NSString* query = [NSString stringWithFormat:@"%@ History (dbID integer primary key autoincrement, HostName text, UserName text, Password text, dbName text, dbPort text, Description text, DateTime text,flag integer)",CREATE_DB_SQL_PREFIX];
    if(![mDatabase executeUpdate:query]){
		[mDatabase close];
        return;
    }
    
    query = [NSString stringWithFormat:@"%@ Connect (ConnectId integer primary key autoincrement,dbID integer,DateTime text)",CREATE_DB_SQL_PREFIX];
    if(![mDatabase executeUpdate:query]){
		[mDatabase close];
        return;
    }
    
    query = [NSString stringWithFormat:@"%@ Query (QueryId integer primary key autoincrement,dbID integer,tableName text,columns text,SearchRule text,ShowName text,DBName text)",CREATE_DB_SQL_PREFIX];
    if(![mDatabase executeUpdate:query]){
		[mDatabase close];
        return;
    }
    [mDatabase close];
    [mDatabase disconnect];
}
///
- (void)insertBuildQuery:(Obj_Database*)item :(NSString*)tableName :(NSString*)columns :(NSString*)searchRule
{
    NSString * query = [NSString stringWithFormat:@"insert into Query (dbID,tableName,columns,SearchRule,ShowName,DBName) values(%d,'%@','%@','%@','%@','%@')",[item.dbId intValue],tableName,columns,searchRule,[NSString stringWithFormat:@"%@->%@->Search",item.dbName,tableName],item.dbName];
    mDatabase = [[SQLMgr alloc]init];
    [mDatabase connect];
    
    if(![mDatabase open]){
        [mDatabase disconnect];
        return;
    }
    if(![mDatabase executeUpdate:query]){
		[mDatabase close];
        return;
    }
    [mDatabase close];
    [mDatabase disconnect];
}
- (void)updateBuildQuery:(Obj_Query*)item
{
    NSString * query = [NSString stringWithFormat:@"update Query set dbID = %@,tableName = '%@',columns = '%@',SearchRule = '%@',ShowName = '%@' where QueryId = %@",item.query_dbId,item.query_tableName,item.query_columns,item.query_searchRule,[NSString stringWithFormat:@"%@->%@->Search",item.query_dbName,item.query_tableName],item.query_Id];
    mDatabase = [[SQLMgr alloc]init];
    [mDatabase connect];
    
    if(![mDatabase open]){
        [mDatabase disconnect];
        return;
    }
    if(![mDatabase executeUpdate:query]){
		[mDatabase close];
        return;
    }
    [mDatabase close];
    [mDatabase disconnect];
}
- (void)deleteBuildQuery:(Obj_Query*)item
{
    NSString * query = [NSString stringWithFormat:@"delete from Query where QueryId = %@",item.query_Id];
    mDatabase = [[SQLMgr alloc]init];
    [mDatabase connect];
    
    if(![mDatabase open]){
        [mDatabase disconnect];
        return;
    }
    if(![mDatabase executeUpdate:query]){
		[mDatabase close];
        return;
    }
    [mDatabase close];
    [mDatabase disconnect];
}
- (NSMutableArray *)getQuerys
{
    NSMutableArray * items = [NSMutableArray new];
    mDatabase = [[SQLMgr alloc]init];
    [mDatabase connect];
    
    if(![mDatabase open]){
        [mDatabase disconnect];
        return nil;
    }
    NSString * query  = [NSString stringWithFormat:@"select *from Query"];
    if([mDatabase executeQuery:query]){
        while([mDatabase next]){
            Obj_Query * item = [[Obj_Query alloc] init];
            item.query_Id = [mDatabase getValue:@"QueryId"];
            item.query_dbId = [mDatabase getValue:@"dbID"];
            item.query_tableName = [mDatabase getValue:@"tableName"];
            item.query_columns = [mDatabase getValue:@"columns"];
            item.query_searchRule = [mDatabase getValue:@"SearchRule"];
            item.query_showName =[mDatabase getValue:@"ShowName"];
            item.query_dbName = [mDatabase getValue:@"DBName"];
            [items addObject:item];
        }
    }
    [mDatabase close];
    [mDatabase disconnect];
    return items;

}
///
- (void)insertIntoHistory:(Obj_Database*)item
{
    mDatabase = [[SQLMgr alloc]init];
    [mDatabase connect];
    
    if(![mDatabase open]){
        [mDatabase disconnect];
        return;
    }
    
    NSString* query = [NSString stringWithFormat:@"insert into History (HostName,UserName,Password,dbName,dbPort,Description,DateTime,flag) values('%@','%@','%@','%@','%@','%@','%@',1)",item.dbHost,item.dbUserName,item.dbPasswd,item.dbName,item.dbPort,item.dbDescription,item.dbDateStr];
    if(![mDatabase executeUpdate:query]){
		[mDatabase close];
        return;
    }
    [mDatabase close];
    [mDatabase disconnect];
}
- (NSMutableArray*)getHistoryArray
{
    NSMutableArray * items = [NSMutableArray new];
    mDatabase = [[SQLMgr alloc]init];
    [mDatabase connect];
    
    if(![mDatabase open]){
        [mDatabase disconnect];
        return nil;
    }
    NSString * query  = [NSString stringWithFormat:@"select *from History where flag = 1"];
    if([mDatabase executeQuery:query]){
        while([mDatabase next]){
            Obj_Database * item = [[Obj_Database alloc] init];
            item.dbId = [mDatabase getValue:@"dbID"];
            item.dbHost = [mDatabase getValue:@"HostName"];
            item.dbUserName = [mDatabase getValue:@"UserName"];
            item.dbPasswd = [mDatabase getValue:@"Password"];
            item.dbName = [mDatabase getValue:@"dbName"];
            item.dbPort = [mDatabase getValue:@"dbPort"];
            item.dbDescription = [mDatabase getValue:@"Description"];
            item.dbDateStr = [mDatabase getValue:@"DateTime"];
            [items addObject:item];
        }
    }
    [mDatabase close];
    [mDatabase disconnect];
    return items;
}
- (NSMutableArray*)getDeletedArray
{
    NSMutableArray * items = [NSMutableArray new];
    mDatabase = [[SQLMgr alloc]init];
    [mDatabase connect];
    
    if(![mDatabase open]){
        [mDatabase disconnect];
        return nil;
    }
    NSString * query  = [NSString stringWithFormat:@"select *from History where flag = 0"];
    if([mDatabase executeQuery:query]){
        while([mDatabase next]){
            Obj_Database * item = [[Obj_Database alloc] init];
            item.dbId = [mDatabase getValue:@"dbID"];
            item.dbHost = [mDatabase getValue:@"HostName"];
            item.dbUserName = [mDatabase getValue:@"UserName"];
            item.dbPasswd = [mDatabase getValue:@"Password"];
            item.dbName = [mDatabase getValue:@"dbName"];
            item.dbPort = [mDatabase getValue:@"dbPort"];
            item.dbDescription = [mDatabase getValue:@"Description"];
            item.dbDateStr = [mDatabase getValue:@"DateTime"];
            [items addObject:item];
        }
    }
    [mDatabase close];
    [mDatabase disconnect];
    return items;
}
- (void)updateHistory:(Obj_Database*)item
{
    mDatabase = [[SQLMgr alloc]init];
    [mDatabase connect];
    
    if(![mDatabase open]){
        [mDatabase disconnect];
        return;
    }
    NSString* query = [NSString stringWithFormat:@"update History set HostName = '%@',UserName = '%@',Password = '%@',dbName = '%@',dbPort = '%@',Description = '%@',DateTime = '%@' where dbID = %@",item.dbHost,item.dbUserName,item.dbPasswd,item.dbName,item.dbPort,item.dbDescription,item.dbDateStr,item.dbId];
    if(![mDatabase executeUpdate:query]){
		[mDatabase close];
        return;
    }
    [mDatabase close];
    [mDatabase disconnect];
}
- (void)AddToHistory:(Obj_Database*)item
{
    mDatabase = [[SQLMgr alloc]init];
    [mDatabase connect];
    
    if(![mDatabase open]){
        [mDatabase disconnect];
        return;
    }
    NSString* query = [NSString stringWithFormat:@"update History set flag = 1 where dbID = %@",item.dbId];
    [mDatabase executeUpdate:query];
    [mDatabase close];
    [mDatabase disconnect];
}
- (void)DeleteFromHistory:(Obj_Database*)item
{
    mDatabase = [[SQLMgr alloc]init];
    [mDatabase connect];
    
    if(![mDatabase open]){
        [mDatabase disconnect];
        return;
    }
    NSString* query = [NSString stringWithFormat:@"update History set flag = 0 where dbID = %@",item.dbId];
    [mDatabase executeUpdate:query];
    [mDatabase close];
    [mDatabase disconnect];
}
@end
