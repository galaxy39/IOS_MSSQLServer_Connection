//
//  BuildViewController.m
//  MysqlConnection
//
//  Created by Galaxy39 on 10/28/13.
//  Copyright (c) 2013 oDesk. All rights reserved.
//

#import "BuildViewController.h"
#import "DBConnector.h"

@interface BuildViewController ()

@end

@implementation BuildViewController
@synthesize delegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)onSelectTable:(id)sender {
    
    if([selectedTableName isEqualToString:self.edt_tableName.text]){
        self.sub_selectTableView.alpha = 0.f;
        return;
    }
    [self.edt_tableName setText:selectedTableName];
    self.edt_columns.text = @"";
    self.edt_searchRule.text = @"";
    
    NSString * tableName = self.edt_tableName.text;
    MySqlServerConnection * sharedConnection = [MySqlServerConnection getInstance:self :0];
    [sharedConnection getColumNamesInTable:tableName];
}

- (void)setInformations:(Obj_Database*)selectDb :(NSArray*)tableArray
{
    m_selectDb = selectDb;
    m_tableArray = [tableArray objectAtIndex:0];
}
- (void)setUpdateQueryItem:(Obj_Query*)item
{
    isUpdateMode = YES;
    m_defaultInformation = item;

}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField == self.edt_tableName){
        self.sub_selectTableView.alpha = 1.f;
        self.tableSelector.delegate = self;
        self.tableSelector.dataSource = self;
        [self.tableSelector reloadAllComponents];
    }else if(textField == self.edt_columns){
        if(self.edt_tableName.text.length == 0)
            return NO;
        AdminTableConfController * controller = [[AdminTableConfController alloc]initWithNibName:@"AdminTableConfController" bundle:nil];
        [controller setType:0];
        controller.delegate = self;
        [controller setInfoData:self.edt_tableName.text :m_selectedTableColumns];
        if(self.edt_columns.text.length > 0){
            [controller setConfData:self.edt_columns.text];
        }
        [self.navigationController pushViewController:controller animated:YES];
    }else if(textField == self.edt_searchRule){
        if(self.edt_columns.text.length == 0)
            return NO;
        NSArray * columnArray = [self.edt_columns.text componentsSeparatedByString:@","];
        AdminTableConfController * controller = [[AdminTableConfController alloc]initWithNibName:@"AdminTableConfController" bundle:nil];
        [controller setType:1];
        if(self.edt_searchRule.text.length > 0){
            [controller setConfData:self.edt_searchRule.text];
        }
        controller.delegate = self;
        [controller setInfoData:self.edt_tableName.text :columnArray];
        [self.navigationController pushViewController:controller animated:YES];

    }
    return NO;
}
- (void)AdminTableConfControllerDelegate_Data:(NSString *)data :(int)type
{
    if(type == 0){
        if([self.edt_columns.text isEqualToString:data])
            return;
        self.edt_searchRule.text = @"";
        self.edt_columns.text = data;
    }else if(type == 1){
        self.edt_searchRule.text = data;
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.sub_selectTableView.alpha = 0.f;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Build" style:UIBarButtonItemStyleBordered target:self action:@selector(onBuild)];
    
    if(m_defaultInformation){
        [self.edt_tableName setText:m_defaultInformation.query_tableName];
        MySqlServerConnection * sharedConnection = [MySqlServerConnection getInstance:self :1];
        [sharedConnection getColumNamesInTable:m_defaultInformation.query_tableName];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [m_tableArray count] + 1;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(row == 0){
        return @"select table";
    }
    NSDictionary * dict  = [m_tableArray objectAtIndex:row-1];
    return [dict objectForKey:@"name"];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(row == 0)
        return;
    NSDictionary * dict  = [m_tableArray objectAtIndex:row-1];
    selectedTableName =[dict objectForKey:@"name"];
}

- (void)onBuild
{
    if(self.edt_tableName.text.length == 0){
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"MS Sqlser Connection" message:@"Please insert Table name for Search" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }else if(self.edt_columns.text.length == 0){
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"MS Sqlser Connection" message:@"Please insert Column names for Search" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }else if(self.edt_searchRule.text.length == 0){
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"MS Sqlser Connection" message:@"Please insert Search Rule for Search" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    NSString * tableName = self.edt_tableName.text;
    NSString * searchRule = self.edt_searchRule.text;
    NSString * columns = self.edt_columns.text;
    if(!m_defaultInformation)
        [[DBConnector new] insertBuildQuery:m_selectDb :tableName :columns :searchRule];
    else{
        m_defaultInformation.query_tableName = tableName;
        m_defaultInformation.query_columns = columns;
        m_defaultInformation.query_searchRule = searchRule;
        [[DBConnector new] updateBuildQuery:m_defaultInformation];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    [self.delegate BuildViewControllerDelegate_needUpdate];
}
- (void)recivedDataArray:(NSArray *)result :(BOOL)res :(int)signalId
{
    if(result == nil || [result count] == 0)
        return;
    if(signalId == 0){
        self.sub_selectTableView.alpha = 0.f;
        m_selectedTableColumns = [result objectAtIndex:0];
    }else if(signalId ==1){
        m_selectedTableColumns = [result objectAtIndex:0];
        [self.edt_columns setText:m_defaultInformation.query_columns];
        [self.edt_searchRule setText:m_defaultInformation.query_searchRule];
    }
}
////////////
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
