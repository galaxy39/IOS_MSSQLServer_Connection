//
//  SearchResultController.h
//  MysqlConnection
//
//  Created by Galaxy39 on 10/19/13.
//  Copyright (c) 2013 oDesk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSArray * searchResults;
    
    NSMutableArray * m_cur_keyArray;
    NSDictionary * m_cur_dict;
    
    NSArray * m_filterArray;
    
    int curPage;
}
@property (retain, nonatomic) IBOutlet UILabel *lbl_resultCount;
@property (retain, nonatomic) IBOutlet UITableView *dataContainer;
- (void)setSearchResult:(NSArray*)array;
- (void)setFilterArray:(NSArray*)array;
- (IBAction)onBeforeResult:(id)sender;
- (IBAction)onNextResult:(id)sender;
@end
