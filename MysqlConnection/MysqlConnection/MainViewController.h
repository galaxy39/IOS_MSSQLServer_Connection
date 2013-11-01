//
//  MainViewController.h
//  MysqlConnection
//
//  Created by Galaxy39 on 10/15/13.
//  Copyright (c) 2013 oDesk. All rights reserved.
//

#import "FlipsideViewController.h"
#import "Con_settingController.h"
#import "Con_TablesController.h"
#import "BuildViewController.h"
#import "BaseTableCell.h"
#import "MySqlServerConnection.h"
#import "CretoriaViewController.h"

@interface MainViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,BaseTableCellDelegate,MySqlServerConnectionDeegate,BuildViewControllerDelegate,UIAlertViewDelegate>
{
    NSMutableArray * m_connectedDatabases;
    NSMutableArray * m_recentDatabases;
    NSMutableArray * m_queryArray;
    
    Obj_Database * signal_item;
    NSArray * m_containTables;
    
    BOOL isQueryEditMode;
    Obj_Query * m_selectedQueryItem;
    Obj_Query * m_delteQueryItem;
}
@property (retain, nonatomic) IBOutlet UITableView *table_connectedDatabase;
@property (retain, nonatomic) IBOutlet UITableView *table_recentDatabase;
@property (weak, nonatomic) IBOutlet UITableView *table_Query;
@end
