//
//  MySqlServerConnection.m
//  MysqlConnection
//
//  Created by Galaxy39 on 10/18/13.
//  Copyright (c) 2013 oDesk. All rights reserved.
//

#import "MySqlServerConnection.h"

@implementation MySqlServerConnection
    @synthesize m_resultArray;
static MySqlServerConnection * _serverConnection;
- (id)init
{
    self = [super init];
    if(self){
        signal_id = 0;
    }
    return self;
}
-(void)setConnectionData:(NSString*)host UserName:(NSString*)name Password:(NSString*)pass SchemaName:(NSString*)schema
{
    m_schemaName = schema;
    m_host = host;
    m_userName = name;
    m_password = pass;
}
- (void)setSignalId:(int)idex
{
    signal_id = idex;
}
+ (NSString*)getUserName
{
    return _serverConnection->m_userName;
}
- (void)reconnect
{
    [_serverConnection setConnectionData:m_host UserName:m_userName Password:m_password SchemaName:m_schemaName];
}
+(id)createInstance:(NSString*)host UserName:(NSString*)name Password:(NSString*)pass SchemaName:(NSString*)schema signalReciver:(id)reciver
{
    if(!_serverConnection){
        _serverConnection = [[MySqlServerConnection alloc] init];
    }
    [_serverConnection setConnectionData:host UserName:name Password:pass SchemaName:schema];
    _serverConnection.delegate = reciver;
    return _serverConnection;
}

+(id)getInstance:(id)reciver :(int)signalId;
{
    [_serverConnection reconnect];
    _serverConnection.delegate = reciver;
    [_serverConnection setSignalId:signalId];
    return _serverConnection;
}
#pragma mark - SQLClientDelegate
    
    //Required
- (void)error:(NSString*)error code:(int)code severity:(int)severity
    {
        NSLog(@"Error #%d: %@ (Severity %d)", code, error, severity);
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Error code" message:[NSString stringWithFormat:@"Error #%d: %@ (Severity %d)", code, error, severity] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
    //Optional
- (void)message:(NSString*)message
    {
    }
    
    

- (NSArray*)getTableNamesInSchema
{
    SQLClient* m_client = [SQLClient sharedInstance];
	m_client.delegate = self;
	[m_client connect:m_host username:m_userName password:m_password database:m_schemaName completion:^(BOOL success) {
  		if (success)
		{
            ///select name,type from sys.tables order by name desc
    		[m_client execute:@"select name,type from sys.tables order by name desc" completion:^(NSArray* results) {
                m_resultArray = results;
                if(m_resultArray ==nil){
                    NSArray * tmpArray = [NSArray new];
                    m_resultArray = tmpArray;
                }
                [m_client disconnect];
                [self.delegate recivedDataArray:m_resultArray :success :signal_id];
			}];
		}
	}];    return m_resultArray;
}
- (NSArray*)getColumNamesInTable:(NSString*)tableName;
{
    SQLClient* m_client = [SQLClient sharedInstance];
	m_client.delegate = self;
	[m_client connect:m_host username:m_userName password:m_password database:m_schemaName completion:^(BOOL success) {
  		if (success)
		{
            NSString * query = [NSString stringWithFormat:@"select * from sys.columns where object_id=OBJECT_ID('%@')",tableName];
            ///select name,type from sys.tables order by name desc
    		[m_client execute:query completion:^(NSArray* results) {
                m_resultArray = results;
                if(m_resultArray ==nil){
                    NSArray * tmpArray = [NSArray new];
                    m_resultArray = tmpArray;
                }
                    
                [m_client disconnect];
                [self.delegate recivedDataArray:m_resultArray :success :signal_id];
			}];
		}
	}];
    return m_resultArray;
    
}
- (NSArray*)exeQuery:(NSString*)query
{
    SQLClient* m_client = [SQLClient sharedInstance];
	m_client.delegate = self;
	[m_client connect:m_host username:m_userName password:m_password database:m_schemaName completion:^(BOOL success) {
  		if (success)
		{
    		[m_client execute:query completion:^(NSArray* results) {
                m_resultArray = results;
                if(m_resultArray ==nil){
                    NSArray * tmpArray = [NSArray new];
                    m_resultArray = tmpArray;
                }
                [m_client disconnect];
                [self.delegate recivedDataArray:m_resultArray :success :signal_id];
			}];
		}
	}];
    return m_resultArray;
}
- (void)createAdminConfTable
{
    //if(not exist(select * from information_schema.tables where table_name='admin_conf_mgr')) begin create table if not exists admin_conf_mgr (id integer primary key,tableName varchar(100),conf varchar(400)) end
    NSString * query = [NSString stringWithFormat:@"if not exists (select * from INFORMATION_SCHEMA.TABLES where table_name='admin_conf_mgr') create table admin_conf_mgr (tableName varchar(100),conf varchar(400))"];
    SQLClient* m_client = [SQLClient sharedInstance];
	m_client.delegate = self;
	[m_client connect:m_host username:m_userName password:m_password database:m_schemaName completion:^(BOOL success) {
  		if (success)
		{
    		[m_client execute:query completion:^(NSArray* results) {
                m_resultArray = results;
                if(m_resultArray ==nil){
                    NSArray * tmpArray = [[NSArray alloc] initWithObjects:@"", nil];
                    m_resultArray = tmpArray;
                }
                [m_client disconnect];
                [self.delegate recivedDataArray:m_resultArray :success :signal_id];
			}];
		}
	}];
}
- (NSString*)getConfStringInTable:(NSString*)tableName
{
    SQLClient* m_client = [SQLClient sharedInstance];
	m_client.delegate = self;
	[m_client connect:m_host username:m_userName password:m_password database:m_schemaName completion:^(BOOL success) {
  		if (success)
		{
            NSString * query = [NSString stringWithFormat:@"select * from admin_conf_mgr where tableName = '%@'",tableName];
            ///select name,type from sys.tables order by name desc
    		[m_client execute:query completion:^(NSArray* results) {
                m_resultArray = results;
                if(m_resultArray ==nil || [m_resultArray count] == 0){
                    NSArray * tmpArray = [[NSArray alloc] initWithObjects:@"", nil];
                    m_resultArray = tmpArray;
                }
                else if([[m_resultArray objectAtIndex:0] count] == 0){
                    NSArray * tmpArray = [[NSArray alloc] initWithObjects:@"", nil];
                    m_resultArray = tmpArray;
                }else{
                    NSString * confString = [[[m_resultArray objectAtIndex:0] objectAtIndex:0] objectForKey:@"conf"];
                    NSArray * tmpArray = [[NSArray alloc] initWithObjects:confString, nil];
                    m_resultArray = tmpArray;
                }
                [m_client disconnect];
                [self.delegate recivedDataArray:m_resultArray :success :signal_id];
			}];
		}
	}];
    return @"";
}
- (void)admin_conf_mgr_isSet:(NSString*)tableName
{
    NSString * query = [NSString stringWithFormat:@"select count(*) from admin_conf_mgr where tableName = '%@'",tableName];
    SQLClient* m_client = [SQLClient sharedInstance];
	m_client.delegate = self;
	[m_client connect:m_host username:m_userName password:m_password database:m_schemaName completion:^(BOOL success) {
  		if (success)
		{
    		[m_client execute:query completion:^(NSArray* results) {
                m_resultArray = results;
                if(m_resultArray ==nil){
                    NSArray * tmpArray = [NSArray new];
                    m_resultArray = tmpArray;
                }
                [m_client disconnect];
                [self.delegate recivedDataArray:m_resultArray :success :signal_id];
			}];
		}
	}];
    
}
- (void)update_admin_conf_mgr:(NSString*)tableName :(NSString*)confData
{
    NSString * query = [NSString stringWithFormat:@"update admin_conf_mgr set conf = '%@' where tableName = '%@'",confData,tableName];
    SQLClient* m_client = [SQLClient sharedInstance];
	m_client.delegate = self;
	[m_client connect:m_host username:m_userName password:m_password database:m_schemaName completion:^(BOOL success) {
  		if (success)
		{
    		[m_client execute:query completion:^(NSArray* results) {
                m_resultArray = results;
                if(m_resultArray ==nil){
                    NSArray * tmpArray = [NSArray new];
                    m_resultArray = tmpArray;
                }
                [m_client disconnect];
                [self.delegate recivedDataArray:m_resultArray :success :signal_id];
			}];
		}
	}];

}
- (void)insert_admin_conf_mgr:(NSString*)tableName :(NSString*)confData
{
    NSString * query = [NSString stringWithFormat:@"insert into admin_conf_mgr (tableName,conf) values ('%@','%@')",tableName,confData];
    SQLClient* m_client = [SQLClient sharedInstance];
	m_client.delegate = self;
	[m_client connect:m_host username:m_userName password:m_password database:m_schemaName completion:^(BOOL success) {
  		if (success)
		{
    		[m_client execute:query completion:^(NSArray* results) {
                m_resultArray = results;
                if(m_resultArray ==nil){
                    NSArray * tmpArray = [NSArray new];
                    m_resultArray = tmpArray;
                }
                [m_client disconnect];
                [self.delegate recivedDataArray:m_resultArray :success :signal_id];
			}];
		}
	}];

}

@end
