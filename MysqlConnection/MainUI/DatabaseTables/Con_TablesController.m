//
//  Con_TablesController.m
//  MysqlConnection
//
//  Created by Galaxy39 on 10/15/13.
//  Copyright (c) 2013 oDesk. All rights reserved.
//

#import "Con_TablesController.h"
#import "BaseTableNameCell.h"
#import "Con_SearchController.h"
#import "AdminTableConfController.h"

@interface Con_TablesController ()

@end

@implementation Con_TablesController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        isAdminMode = NO;
    }
    return self;
}
- (void)setTableNames:(NSArray*)tableNames
{
    m_tableNameArray = [[NSMutableArray alloc] initWithArray:[tableNames objectAtIndex:0]] ;
    for(NSDictionary * item in m_tableNameArray){
        NSString * tableName = [item objectForKey:@"name"];
        if([tableName isEqualToString:@"admin_conf_mgr"]){
            [m_tableNameArray removeObject:item];
        }
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSString * userName = [MySqlServerConnection getUserName];
    if([userName isEqualToString:@"sa"]){
        isAdminMode = YES;
    }
    
    if([[UIDevice currentDevice].systemVersion floatValue] >= 7){
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.table_dataContainer.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    self.table_dataContainer.delegate = self;
    self.table_dataContainer.dataSource = self;
    [self.table_dataContainer reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_tableNameArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseTableNameCell * cellView = (BaseTableNameCell*)[[[NSBundle mainBundle] loadNibNamed:@"BaseTableNameCell" owner:nil options:nil] objectAtIndex:0];
    if(isAdminMode)
        [cellView setAccessoryType:UITableViewCellAccessoryDetailButton];
    NSString * tableTitle = [[m_tableNameArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    cellView.lbl_title.text = tableTitle;
    return cellView;
}
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    m_selectedTableName = [[m_tableNameArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    m_selectedTableColumns = [NSMutableArray new];
    
    MySqlServerConnection * sharedConnection = [MySqlServerConnection getInstance:self :0];
    m_selectedTableColumns = [sharedConnection getColumNamesInTable:m_selectedTableName];
}
//////
- (void)recivedDataArray:(NSArray *)result :(BOOL)res :(int)signalId
{
    if(result == nil || [result count] == 0)
        return;
    if(signalId == 0){
        m_selectedTableColumns = result;
        MySqlServerConnection * sharedConnection = [MySqlServerConnection getInstance:self :1];
        [sharedConnection createAdminConfTable];
    }else if(signalId ==1){
        MySqlServerConnection * sharedConnection = [MySqlServerConnection getInstance:self :2];
        [sharedConnection getConfStringInTable:m_selectedTableName];
    }else if(signalId == 2){
        NSString * confData = (NSString*)[result objectAtIndex:0];
        AdminTableConfController * controller = [[AdminTableConfController alloc]initWithNibName:@"AdminTableConfController" bundle:nil];
        controller.title = m_selectedTableName;
        [controller setInfoData:m_selectedTableName :m_selectedTableColumns];
        [controller setConfData:confData];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if(signalId == 10){
        m_selectedTableColumns =[result objectAtIndex:0];
        MySqlServerConnection * sharedConnection = [MySqlServerConnection getInstance:self :11];
        m_selectedConfData = [sharedConnection getConfStringInTable:m_selectedTableName];
    }else if(signalId == 11){
        m_selectedConfData = (NSString*)[result objectAtIndex:0];
        if([m_selectedConfData isEqualToString:@""]){
            NSMutableArray * array = [NSMutableArray new];
            for (NSDictionary * item in m_selectedTableColumns) {
                NSString * columnName = [item objectForKey:@"name"];
                [array addObject:columnName];
            }
            m_selectedConfData = [array componentsJoinedByString:@","];
        }
        
        [self performSegueWithIdentifier:@"Con_SearchController" sender:self];
    }
}

///
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    m_selectedTableName = [[m_tableNameArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    m_selectedTableColumns = [NSMutableArray new];
    MySqlServerConnection * sharedConnection = [MySqlServerConnection getInstance:self :10];
    m_selectedTableColumns = [sharedConnection getColumNamesInTable:m_selectedTableName];
    
}
/////
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
    }else if([[segue identifier] isEqualToString:@"Con_SearchController"]){
        Con_SearchController * controller = [segue destinationViewController];
        [controller setInitialData:m_selectedTableName :m_selectedTableColumns];
        [controller setConfData:m_selectedConfData];
    }
}
@end
