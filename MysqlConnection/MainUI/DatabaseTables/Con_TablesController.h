//
//  Con_TablesController.h
//  MysqlConnection
//
//  Created by Galaxy39 on 10/15/13.
//  Copyright (c) 2013 oDesk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MySqlServerConnection.h"

@interface Con_TablesController : UIViewController<UITableViewDataSource,UITableViewDelegate,MySqlServerConnectionDeegate>
{
    NSMutableArray * m_tableNameArray;
    NSArray * m_selectedTableColumns;
    NSString * m_selectedTableName;
    NSString * m_selectedConfData;
    
    BOOL isAdminMode;
}
@property (retain, nonatomic) IBOutlet UITableView *table_dataContainer;
- (void)setTableNames:(NSArray*)tableNames;
@end
