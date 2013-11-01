//
//  Con_SearchController.m
//  MysqlConnection
//
//  Created by Galaxy39 on 10/16/13.
//  Copyright (c) 2013 oDesk. All rights reserved.
//

#import "Con_SearchController.h"


@interface Con_SearchController ()

@end

@implementation Con_SearchController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)setInitialData:(NSString*)tableName :(NSArray*)columnArray
{
    m_tableName = tableName ;
    m_columArray = columnArray ;
}
- (void)setConfData:(NSString*)conf
{
    m_confData = conf;
    m_confArray = [NSArray new];
    m_confArray = [m_confData componentsSeparatedByString:@","] ;
    tmpArray = [NSMutableArray new];
    for(NSDictionary * dict in m_columArray){
        NSString * columnName = [dict objectForKey:@"name"];
        if([m_confArray containsObject:columnName]){
            [tmpArray addObject:dict];
        }
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Search" style:UIBarButtonItemStyleBordered target:self action:@selector(onSearch)];
    
    if([[UIDevice currentDevice].systemVersion floatValue] >= 7){
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.m_dataContainer.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    self.m_dataContainer.delegate = self;
    self.m_dataContainer.dataSource = self;
    [self.m_dataContainer reloadData];

}
- (void)onSearch
{
    NSMutableArray * conditionArray = [NSMutableArray new];
    for(int i=0;i<[tmpArray count];i++){
        NSString * columnName = [[tmpArray objectAtIndex:i] objectForKey:@"name"];
        BaseSearchCell * cellView = (BaseSearchCell*)[self.m_dataContainer cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        NSString * condition = cellView.edt_search.text;
        if(condition.length > 0){
            [conditionArray addObject:[NSString stringWithFormat:@" %@ LIKE '%%%@%%' ",columnName,condition]];
        }
    }
    NSString * query = [NSString stringWithFormat:@"select * from %@ where %@",m_tableName,[conditionArray componentsJoinedByString:@"and"]];
    if([conditionArray count] == 0)
        query = [NSString stringWithFormat:@"select * from %@",m_tableName];
    NSLog(@"%@",query);
    [[MySqlServerConnection getInstance:self :0] exeQuery:query];
}
////
- (void)recivedDataArray:(NSArray *)result :(BOOL)res :(int)signalId
{
    if(result == nil || [result count] == 0)
        return;
    SearchResultController * controller = [[SearchResultController alloc] initWithNibName:@"SearchResultController" bundle:nil];
    [controller setFilterArray:m_confArray];
    [controller setSearchResult:[result objectAtIndex:0]];
    [self.navigationController pushViewController:controller animated:YES];
}
///////
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tmpArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseSearchCell * cellView = (BaseSearchCell*)[[[NSBundle mainBundle] loadNibNamed:@"BaseSearchCell" owner:nil options:nil] objectAtIndex:0];
    NSString * tableTitle = [[tmpArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    cellView.edt_search.placeholder = [NSString stringWithFormat:@"Search by %@",tableTitle];
    return cellView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}


@end
