//
//  MySqlServerConnection.h
//  MysqlConnection
//
//  Created by Galaxy39 on 10/18/13.
//  Copyright (c) 2013 oDesk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SQLClient.h"

@protocol MySqlServerConnectionDeegate
- (void)recivedDataArray:(NSArray*)result :(BOOL)res :(int)signalId;
@end

@interface MySqlServerConnection : NSObject<SQLClientDelegate>
{
//    MysqlConnection * m_connection;
    NSString * m_host;
    NSString * m_userName;
    NSString * m_password;
    NSString * m_schemaName;
    
    
    SQLClient* client;
    
    int signal_id;
    
}
@property (nonatomic,retain)NSArray* m_resultArray;
@property(nonatomic,retain)id<MySqlServerConnectionDeegate>delegate;
    
+(id)createInstance:(NSString*)host UserName:(NSString*)name Password:(NSString*)pass SchemaName:(NSString*)schema signalReciver:(id)reciver;
+(id)getInstance:(id)reciver :(int)signalId;

-(void)setConnectionData:(NSString*)host UserName:(NSString*)name Password:(NSString*)pass SchemaName:(NSString*)schema;
- (void)setSignalId:(int)idex;
- (void)reconnect;

//////////////////////////////////
- (NSArray*)getTableNamesInSchema;
- (NSArray*)getColumNamesInTable:(NSString*)tableName;
- (NSArray*)exeQuery:(NSString*)query;

/////
- (void)createAdminConfTable;
- (NSString*)getConfStringInTable:(NSString*)tableName;
- (void)admin_conf_mgr_isSet:(NSString*)tableName;
- (void)update_admin_conf_mgr:(NSString*)tableName :(NSString*)confData;
- (void)insert_admin_conf_mgr:(NSString*)tableName :(NSString*)confData;
/////
+ (NSString*)getUserName;


@end
