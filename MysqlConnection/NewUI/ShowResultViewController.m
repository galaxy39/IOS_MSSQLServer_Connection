//
//  ShowResultViewController.m
//  MysqlConnection
//
//  Created by Galaxy39 on 10/28/13.
//  Copyright (c) 2013 oDesk. All rights reserved.
//

#import "ShowResultViewController.h"

@interface ShowResultViewController ()

@end

@implementation ShowResultViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        showPageIndex = 0;
    }
    return self;
}
- (void)setDataArray:(NSArray*)array
{
    m_showResult =array;
    m_keyDataArray = [[m_showResult objectAtIndex:0] allKeys];
}
- (void)setKeyArray:(NSArray*)array
{
    m_keyDataArray = array;
}

- (IBAction)onGotoBefore:(id)sender {
    if(showPageIndex <= 0)
        return;
    showPageIndex--;
    [self.lbl_pageInfo setText:[NSString stringWithFormat:@"%d/%d",showPageIndex+1,[m_showResult count]]];
    [_tbl_dataContainer reloadData];
}

- (IBAction)onGotoNext:(id)sender {
    if(showPageIndex >= [m_showResult count]-1)
        return;
    showPageIndex++;
    [self.lbl_pageInfo setText:[NSString stringWithFormat:@"%d/%d",showPageIndex+1,[m_showResult count]]];
    [_tbl_dataContainer reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if([[UIDevice currentDevice].systemVersion floatValue] >= 7){
        _tbl_dataContainer.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    _tbl_dataContainer.delegate = self;
    _tbl_dataContainer.dataSource = self;
    [_tbl_dataContainer reloadData];
    
    [self.lbl_pageInfo setText:[NSString stringWithFormat:@"%d/%d",showPageIndex+1,[m_showResult count]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_keyDataArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseSearchCell * cellView = (BaseSearchCell*)[[[NSBundle mainBundle] loadNibNamed:@"BaseSearchCell" owner:nil options:nil] objectAtIndex:0];
    NSDictionary * dict = [m_showResult objectAtIndex:showPageIndex];
    NSString * tableTitle = [m_keyDataArray objectAtIndex:indexPath.row];
    cellView.lbl_columnName.text = tableTitle;
    cellView.edt_search.enabled = NO;
    cellView.edt_search.text = [dict objectForKey:tableTitle];
    cellView.edt_search.placeholder = @"No Data";
    return cellView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
