//
//  ShowResultViewController.h
//  MysqlConnection
//
//  Created by Galaxy39 on 10/28/13.
//  Copyright (c) 2013 oDesk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseSearchCell.h"

@interface ShowResultViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSArray * m_showResult;
    NSArray * m_keyDataArray;
    
    int showPageIndex;
}
@property (weak, nonatomic) IBOutlet UITableView *tbl_dataContainer;
@property (weak, nonatomic) IBOutlet UILabel *lbl_pageInfo;
- (void)setDataArray:(NSArray*)array;
- (void)setKeyArray:(NSArray*)array;
- (IBAction)onGotoBefore:(id)sender;
- (IBAction)onGotoNext:(id)sender;
@end
