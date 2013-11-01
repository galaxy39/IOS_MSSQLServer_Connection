//
//  SearchResultController.m
//  MysqlConnection
//
//  Created by Galaxy39 on 10/19/13.
//  Copyright (c) 2013 oDesk. All rights reserved.
//

#import "SearchResultController.h"

@interface SearchResultController ()

@end

@implementation SearchResultController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        curPage = 0;
    }
    return self;
}
- (void)setSearchResult:(NSArray*)array
{
    searchResults = array ;
}
- (void)setFilterArray:(NSArray*)array
{
    m_filterArray = array ;
}

- (IBAction)onBeforeResult:(id)sender {
    if(curPage == 0)
        return;
    curPage--;
    m_cur_dict = [searchResults objectAtIndex:curPage];
//    m_cur_keyArray = [[NSMutableArray alloc]initWithArray:[m_cur_dict allKeys]];
    [_dataContainer reloadData];
}

- (IBAction)onNextResult:(id)sender {
    if(!searchResults || curPage == [searchResults count] -1 || [searchResults count] <= curPage)
        return;
    curPage++;
    m_cur_dict = [searchResults objectAtIndex:curPage];
//    m_cur_keyArray = [[NSMutableArray alloc]initWithArray:[m_cur_dict allKeys]];
    [_dataContainer reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if(searchResults && [searchResults count] > 0){
        m_cur_dict = [searchResults objectAtIndex:0];
        m_cur_keyArray = [[NSMutableArray alloc]initWithArray:[m_cur_dict allKeys]];
        NSMutableArray * array = [NSMutableArray new];
        for(NSString* keyStr in m_cur_keyArray){
            if([m_filterArray containsObject:keyStr]){
                [array addObject:keyStr];
            }
        }
        m_cur_keyArray = array;
    }

    
    [self.lbl_resultCount setText:[NSString stringWithFormat:@"Search Result Count:%d",[searchResults count]]];
    
    if([[UIDevice currentDevice].systemVersion floatValue] >= 7){
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//        self.extendedLayoutIncludesOpaqueBars = NO;
//        self.automaticallyAdjustsScrollViewInsets = NO;
        _dataContainer.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    _dataContainer.delegate = self;
    _dataContainer.dataSource = self;
    [_dataContainer reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_cur_keyArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellIndenitfier = @"cellIndenitfier";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIndenitfier];
//    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndenitfier];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ : %@",[m_cur_keyArray objectAtIndex:indexPath.row],[m_cur_dict objectForKey:[m_cur_keyArray objectAtIndex:indexPath.row]]];
//    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
