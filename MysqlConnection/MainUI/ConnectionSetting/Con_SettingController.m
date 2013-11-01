//
//  Con_SettingController.m
//  MysqlConnection
//
//  Created by Galaxy39 on 10/15/13.
//  Copyright (c) 2013 oDesk. All rights reserved.
//

#import "Con_SettingController.h"
#import "BaseEditTableCell.h"
#import "CommonApi.h"
#import "DBConnector.h"

@interface Con_SettingController ()
- (void)onGoBack;
- (void)onSave;
@end

@implementation Con_SettingController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(onGoBack)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:self action:@selector(onSave)];
    
    if([[UIDevice currentDevice].systemVersion floatValue] >= 7){
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.table_setting.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    
    [self performSelector:@selector(onSetInfors) withObject:nil afterDelay:0.2];
    
}
- (void)onSetInfors
{
    if(isEditMode && m_information){
        [self getTextFieldAt:0].text = m_information.dbHost;
        [self getTextFieldAt:1].text = m_information.dbUserName;
        [self getTextFieldAt:2].text = m_information.dbPasswd;
        [self getTextFieldAt:3].text = m_information.dbName;
        [self getTextFieldAt:4].text = m_information.dbPort;
        [self getTextFieldAt:5].text = m_information.dbDescription;
    }
}
- (void)setInformation:(Obj_Database*)item
{
    m_information = item;
    isEditMode = YES;
    
}
///
- (void)onGoBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)onSave
{
    for (int i=0; i<6; i++) {
        if([[self getTextAt:i] isEqualToString:@""]){
            ///show error message
            return;
        }
    }
    if(!isEditMode){
        Obj_Database * item = [[Obj_Database alloc] init];
        item.dbHost = [self getTextAt:0];
        item.dbUserName = [self getTextAt:1];
        item.dbPasswd = [self getTextAt:2];
        item.dbName = [self getTextAt:3];
        item.dbPort = [self getTextAt:4];
        item.dbDescription = [self getTextAt:5];
        item.dbDateStr = [CommonApi dateToString:[NSDate date]];
    
        [[[DBConnector alloc] init] insertIntoHistory:item];
        /////show succcess message
    
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        if(!m_information)
            return;
        m_information.dbHost = [self getTextAt:0];
        m_information.dbUserName = [self getTextAt:1];
        m_information.dbPasswd = [self getTextAt:2];
        m_information.dbName = [self getTextAt:3];
        m_information.dbPort = [self getTextAt:4];
        m_information.dbDescription = [self getTextAt:5];
        m_information.dbDateStr = [CommonApi dateToString:[NSDate date]];
        [[[DBConnector alloc] init] updateHistory:m_information];
        /////show succcess message
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}
////
- (NSString *)getTextAt:(int)index
{
    NSString * title = @"";
    BaseEditTableCell * cellView = (BaseEditTableCell*)[self.table_setting cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    title = cellView.txt_value.text;
    return title;
}
- (UITextField*)getTextFieldAt:(int)index
{
     BaseEditTableCell * cellView = (BaseEditTableCell*)[self.table_setting cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    return cellView.txt_value;
}
///
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{return 0;}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{return 0;}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseEditTableCell * cellView = (BaseEditTableCell*)[[[NSBundle mainBundle] loadNibNamed:@"BaseEditTableCell" owner:nil options:nil] objectAtIndex:0];
    cellView.txt_value.tag = indexPath.row;
    if(indexPath.row == 0){
        cellView.lbl_title.text = @"Database Host";
    }else if(indexPath.row == 1){
        cellView.lbl_title.text = @"User Name";
    }else if(indexPath.row == 2){
        cellView.lbl_title.text = @"Password";
    }else if(indexPath.row == 3){
        cellView.lbl_title.text = @"Database Name";
    }else if(indexPath.row == 4){
        cellView.lbl_title.text = @"Database Port";
    }else if(indexPath.row == 5){
        cellView.lbl_title.text = @"Description";
    }else if(indexPath.row == 6){
        [cellView setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        cellView.lbl_title.text = @"Advanced";
        [cellView.txt_value setAlpha:0.f];
    }
    return cellView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
@end
