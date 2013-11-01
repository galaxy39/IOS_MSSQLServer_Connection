//
//  SQLMgr.h
//  Online_Education
//
//  Created by hana on 3/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface SQLMgr : NSObject
{
    FMDatabase * mDatabase;
    NSString * dbFilePath;
    NSArray  * mResult;
    int        mErrorCode;
    NSString * mErrorStr;
    FMResultSet * rs;
}
-(id) init;
-(void) connect;
-(void) disconnect;
-(BOOL) open;
-(void) close;
-(BOOL) executeQuery:(NSString*)query;
-(BOOL) executeUpdate:(NSString*)sql;
-(NSString*) getLastError;
-(BOOL) next;
-(NSString*) getValue:(NSString*) recordName;
-(NSString*) getValueAt:(int) index;
- (int)getIntValue:(NSString *)recordName;
-(void) transation;
-(void) commit;
-(void) rollback;
@end
