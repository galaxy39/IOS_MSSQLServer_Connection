//
//  CretoriaViewController.m
//  MysqlConnection
//
//  Created by Galaxy39 on 10/28/13.
//  Copyright (c) 2013 oDesk. All rights reserved.
//

#import "CretoriaViewController.h"
#import "BaseSearchCell.h"

@interface CretoriaViewController ()

@end

@implementation CretoriaViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)setQueryInfo:(Obj_Query*)query :(Obj_Database*)dataBase
{
    m_data_query = query;
    m_data_base = dataBase;
    m_columns = [NSMutableArray new];
    m_columns = [[NSMutableArray alloc]initWithArray:[m_data_query.query_searchRule componentsSeparatedByString:@","]];
    for(NSString * columnName in m_columns){
        if(columnName == nil || [columnName isEqualToString:@""])
            [m_columns removeObject:columnName];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Excute" style:UIBarButtonItemStyleBordered target:self action:@selector(onExcute)];
    
    if([[UIDevice currentDevice].systemVersion floatValue] >= 7){
        _dataContainer.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    _dataContainer.delegate = self;
    _dataContainer.dataSource = self;
    [_dataContainer reloadData];
}
- (void)onExcute
{
    NSMutableArray * array = [NSMutableArray new];
    for(int i=0;i<[m_columns count];i++){
        UITableViewCell * cellView = (UITableViewCell*)[_dataContainer cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        NSString * columnName;
        NSString * condition;
        for(UIView * subView in cellView.contentView.subviews){
            if([subView isKindOfClass:[UILabel class]])
                columnName = ((UILabel*)subView).text;
            else if([subView isKindOfClass:[UITextField class]]){
                condition = ((UITextField*)subView).text;
            }
        }
        if(condition.length > 0){
            NSString * conditionStr = [NSString stringWithFormat:@" %@ LIKE '%%%@%%' ",columnName,condition];
            [array addObject:conditionStr];
        }
    }
    NSString * sumCondtionStr = [array componentsJoinedByString:@"and"];
    NSString * query;
    if(sumCondtionStr && sumCondtionStr.length > 0){
        query = [NSString stringWithFormat:@"select %@ from %@ where %@",m_data_query.query_columns,m_data_query.query_tableName,sumCondtionStr];
    }else{
        query = [NSString stringWithFormat:@"select %@ from %@",m_data_query.query_columns,m_data_query.query_tableName];
    }
    searchQuery = query;
    [MySqlServerConnection createInstance:[NSString stringWithFormat:@"%@:%@",m_data_base.dbHost,m_data_base.dbPort] UserName:m_data_base.dbUserName Password:m_data_base.dbPasswd SchemaName:m_data_base.dbName signalReciver:self];
    [[MySqlServerConnection getInstance:self :1] exeQuery:searchQuery];
}

- (void)recivedDataArray:(NSArray *)result :(BOOL)res :(int)signalId
{
    if(result == nil || [result count] == 0)
        return;
   if(signalId == 1){
        NSArray * resultArray = [result objectAtIndex:0];
       if([resultArray count] == 0){
           UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"MSSQL Server Connect" message:@"There are no data" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
           [alertView show];
           return;
       }
        ShowResultViewController * controller = [[ShowResultViewController alloc]initWithNibName:@"ShowResultViewController" bundle:nil];
       controller.title = [NSString stringWithFormat:@"%@->Columns",self.title];
        [controller setDataArray:resultArray];
       [controller setKeyArray:[[NSMutableArray alloc]initWithArray:[m_data_query.query_columns componentsSeparatedByString:@","]]];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_columns count] + 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellIndenitfier = [NSString stringWithFormat:@"cellIndenitfier%d", indexPath.row];
    UITableViewCell * cellView = [tableView dequeueReusableCellWithIdentifier:cellIndenitfier];
    if (!cellView){
        cellView = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndenitfier];
        if(indexPath.row >= [m_columns count]){
            return cellView;
        }
        NSString * tableTitle = [m_columns objectAtIndex:indexPath.row];
        UITextField * myTextField = [[UITextField alloc] initWithFrame:CGRectMake(12, 26, 296, 30)];
        myTextField.borderStyle = UITextBorderStyleRoundedRect;
        myTextField.returnKeyType = UIReturnKeyDone;
        myTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        myTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        myTextField.placeholder = [NSString stringWithFormat:@"Enter %@",tableTitle];
        myTextField.delegate = self;
        [cellView.contentView addSubview:myTextField];
        UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 2, 296, 21)];
        titleLabel.textColor = [UIColor blueColor];
        [titleLabel setText:tableTitle];
        [cellView.contentView addSubview:titleLabel];

    }
//
//    cellView = (BaseSearchCell*)[[[NSBundle mainBundle] loadNibNamed:@"BaseSearchCell" owner:nil options:nil] objectAtIndex:0];
//    if(indexPath.row >= [m_columns count]-1){
//        ((BaseSearchCell*)cellView).lbl_columnName.alpha = 0.f;
//        ((BaseSearchCell*)cellView.edt_search).alpha = 0.f;
//        return cellView;
//    }
//    NSString * tableTitle = [m_columns objectAtIndex:indexPath.row];
//    ((BaseSearchCell*)cellView).lbl_columnName.text = tableTitle;
//    ((BaseSearchCell*)cellView).edt_search.placeholder = [NSString stringWithFormat:@"Enter %@",tableTitle];
//    }
//    cellView.edt_search.text =m_data_query.query_searchRule;
    return cellView;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}
@end
