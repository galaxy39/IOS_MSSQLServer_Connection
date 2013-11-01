//
//  MainViewController.m
//  MysqlConnection
//
//  Created by Galaxy39 on 10/15/13.
//  Copyright (c) 2013 oDesk. All rights reserved.
//

#import "MainViewController.h"
#import "Obj_Database.h"
#import "DBConnector.h"


@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.title = @"Databases";
    
    signal_item = nil;
    isQueryEditMode = NO;
    
    if([[UIDevice currentDevice].systemVersion floatValue] >= 7){
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.table_connectedDatabase.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
        self.table_recentDatabase.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
        self.table_Query.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    m_connectedDatabases = [[DBConnector new] getHistoryArray];
    m_recentDatabases = [[DBConnector new] getDeletedArray];
    m_queryArray = [[DBConnector new] getQuerys];
    self.table_connectedDatabase.delegate = self;
    self.table_connectedDatabase.dataSource = self;
    [self.table_connectedDatabase reloadData];
    self.table_recentDatabase.delegate = self;
    self.table_recentDatabase.dataSource = self;
    [self.table_recentDatabase reloadData];
    self.table_Query.delegate = self;
    self.table_Query.dataSource = self;
    [self.table_Query reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark table management
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.table_connectedDatabase)
        return [m_connectedDatabases count] + 1;
    if(tableView == self.table_Query){
        return [m_queryArray count];
    }
    return [m_recentDatabases count] + 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{return 0;}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{return 0;}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseTableCell * cellView = (BaseTableCell*)[[[NSBundle mainBundle] loadNibNamed:@"BaseTableCell" owner:nil options:nil] objectAtIndex:0];
    cellView.delegate = self;
    if(tableView == self.table_connectedDatabase){
        
        cellView.tag = indexPath.row;
        
        if(indexPath.row == [m_connectedDatabases count]){
            [cellView setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            cellView.lbl_name.text = @"";
            cellView.lbl_description.text = @"";
            [cellView.lbl_newConnection setAlpha:1.f];
            [cellView.btnDelete setAlpha:0.f];
        }else{
            Obj_Database * item = (Obj_Database*)[m_connectedDatabases objectAtIndex:indexPath.row];
            cellView.lbl_name.text = item.dbName;
            cellView.lbl_description.text = item.dbDescription;
            [cellView.btn_add setAlpha:0.f];
        }
    }else if(tableView == self.table_recentDatabase){
        
        cellView.tag = indexPath.row + 1000;
        
        [cellView setAccessoryType:UITableViewCellAccessoryNone];
        if(indexPath.row == [m_recentDatabases count]){
            [cellView setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            cellView.lbl_name.text = @"";
            cellView.lbl_description.text = @"";
            [cellView.lbl_newConnection setAlpha:1.f];
            cellView.lbl_newConnection.text = @"Demo SQL Server";
            [cellView.btnDelete setAlpha:0.f];
            [cellView.btn_add setAlpha:0.f];
        }else{
            Obj_Database * item = (Obj_Database*)[m_recentDatabases objectAtIndex:indexPath.row];
            cellView.lbl_name.text = item.dbName;
            cellView.lbl_description.text = item.dbDescription;
            [cellView.btnDelete setAlpha:0.f];
        }
    }else if(tableView == self.table_Query){
        cellView.tag = indexPath.row + 10000;
//        [cellView setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        cellView.lbl_name.text = @"";
        cellView.lbl_description.text = @"";
        [cellView.lbl_newConnection setAlpha:1.f];
        [cellView.btnDelete setAlpha:1.f];
        [cellView.btn_add setAlpha:0.f];
        Obj_Query * item  = (Obj_Query*)[m_queryArray objectAtIndex:indexPath.row];
        cellView.lbl_newConnection.text = item.query_showName;
    }
    return cellView;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.table_connectedDatabase){
        if(indexPath.row == [m_connectedDatabases count]){
            signal_item = nil;
            [self performSegueWithIdentifier:@"Con_SettingController" sender:self];
        }
        else{
            signal_item = (Obj_Database*)[m_connectedDatabases objectAtIndex:indexPath.row];
            ////// connect to mysql server /////
            
            MySqlServerConnection * m_sqlServerConnection = [MySqlServerConnection createInstance:[NSString stringWithFormat:@"%@:%@",signal_item.dbHost,signal_item.dbPort] UserName:signal_item.dbUserName Password:signal_item.dbPasswd SchemaName:signal_item.dbName signalReciver:self];
            m_sqlServerConnection = [MySqlServerConnection getInstance:self :0];
            if(m_sqlServerConnection){
                m_containTables = [m_sqlServerConnection getTableNamesInSchema];
            }
            
        }
    }
    if(tableView == self.table_Query){
        Obj_Query * item  = (Obj_Query*)[m_queryArray objectAtIndex:indexPath.row];
        for(Obj_Database* subDB in m_connectedDatabases){
            if([subDB.dbId intValue] == [item.query_dbId intValue]){
                signal_item =subDB;
                break;
            }
        }
        CretoriaViewController * controller = [[CretoriaViewController alloc] initWithNibName:@"CretoriaViewController" bundle:nil];
        controller.title = [NSString stringWithFormat:@"Saved Query>%@",item.query_Id];
        [controller setQueryInfo:item :signal_item];
        [self.navigationController pushViewController:controller animated:YES];
    }
}
//////
- (void)recivedDataArray:(NSArray *)result :(BOOL)res :(int)signalId
{
    if(result == nil || [result count] == 0)
        return;
    if(signalId == 1){
        /////edit query mode
        m_containTables = result;
        isQueryEditMode = YES;
        [self performSegueWithIdentifier:@"view_build_controller" sender:self];
        return;
    }
    if(signalId == 0){
        m_containTables = result;
        [self performSegueWithIdentifier:@"view_build_controller" sender:self];
    }
}

////
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.table_connectedDatabase){
        if(indexPath.row == [m_connectedDatabases count]){
            signal_item = nil;
            [self performSegueWithIdentifier:@"Con_SettingController" sender:self];
        }else{
            signal_item = (Obj_Database*)[m_connectedDatabases objectAtIndex:indexPath.row];
            [self performSegueWithIdentifier:@"Con_SettingController" sender:self];
        }
    }else if(tableView == self.table_Query){
        Obj_Query * item  = (Obj_Query*)[m_queryArray objectAtIndex:indexPath.row];
        m_selectedQueryItem = item;
        for(Obj_Database* subDB in m_connectedDatabases){
            if([subDB.dbId intValue] == [item.query_dbId intValue]){
                signal_item =subDB;
                break;
            }
        }
        MySqlServerConnection * m_sqlServerConnection = [MySqlServerConnection createInstance:[NSString stringWithFormat:@"%@:%@",signal_item.dbHost,signal_item.dbPort] UserName:signal_item.dbUserName Password:signal_item.dbPasswd SchemaName:signal_item.dbName signalReciver:self];
        m_sqlServerConnection = [MySqlServerConnection getInstance:self :1];
        [m_sqlServerConnection getTableNamesInSchema];
        
    }
}
//////
- (void)refreshTables
{
    m_connectedDatabases = [[DBConnector new] getHistoryArray];
    m_recentDatabases = [[DBConnector new] getDeletedArray];
    [self.table_connectedDatabase reloadData];
    [self.table_recentDatabase reloadData];
}
- (void)BaseTableCellDelegate_AddAction:(int)index
{
    Obj_Database * item = nil;
    if(index >= 1000){
        item = (Obj_Database*)[m_recentDatabases objectAtIndex:index-1000];
    }else{
        if(index == [m_connectedDatabases count]){
            signal_item = nil;
            [self performSegueWithIdentifier:@"Con_SettingController" sender:self];
            return;
        }
       item = (Obj_Database*)[m_connectedDatabases objectAtIndex:index];
    }
    
    [[DBConnector new] AddToHistory:item];
    
    [self refreshTables];
}
- (void)BaseTableCellDelegate_DeleteAction:(int)index
{
    Obj_Database * item = nil;
    if(index >= 1000 && index < 10000){
        item = (Obj_Database*)[m_recentDatabases objectAtIndex:index-1000];
    }else if(index >= 10000){
        m_delteQueryItem  = (Obj_Query*)[m_queryArray objectAtIndex:index-10000];
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"MSSQL server connect" message:@"Are you sure delete this Query?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
        [alertView show];
        return;
        
            }
    else{
        if(index == [m_connectedDatabases count]){
            signal_item = nil;
            [self performSegueWithIdentifier:@"Con_SettingController" sender:self];
            return;
        }
        item = (Obj_Database*)[m_connectedDatabases objectAtIndex:index];
    }
    [[DBConnector new] DeleteFromHistory:item];
    
    [self refreshTables];
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0){
    [[DBConnector new] deleteBuildQuery:m_delteQueryItem];
    m_queryArray = [[DBConnector new] getQuerys];
    self.table_Query.delegate = self;
    self.table_Query.dataSource = self;
    [self.table_Query reloadData];
    }
    return;

}
/////
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
    }else if([[segue identifier] isEqualToString:@"Con_SettingController"]){
        Con_SettingController * controller = [segue destinationViewController];
        if(signal_item)
            [controller setInformation:signal_item];
    }else if([[segue identifier] isEqualToString:@"Con_tableController"]){
        Con_TablesController * controller = [segue destinationViewController];
        [controller setTableNames:m_containTables];
    }else if([[segue identifier] isEqualToString:@"view_build_controller"]){
        BuildViewController * controller = [segue destinationViewController];
        [controller setInformations:signal_item :m_containTables];
        if(isQueryEditMode){
            [controller setUpdateQueryItem:m_selectedQueryItem];
            isQueryEditMode = NO;
        }
        controller.delegate = self;
    }
}
////
- (void)BuildViewControllerDelegate_needUpdate
{
    m_queryArray = [[DBConnector new] getQuerys];
    self.table_Query.delegate = self;
    self.table_Query.dataSource = self;
    [self.table_Query reloadData];
}

@end
