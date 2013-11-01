//
//  CretoriaViewController.h
//  MysqlConnection
//
//  Created by Galaxy39 on 10/28/13.
//  Copyright (c) 2013 oDesk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Obj_Database.h"
#import "MySqlServerConnection.h"
#import "ShowResultViewController.h"

@interface CretoriaViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MySqlServerConnectionDeegate,UITextFieldDelegate>
{
    Obj_Query * m_data_query;
    Obj_Database * m_data_base;
    
    NSMutableArray * m_columns;
    
    NSString * searchQuery;
}
@property (weak, nonatomic) IBOutlet UITableView *dataContainer;
- (void)setQueryInfo:(Obj_Query*)query :(Obj_Database*)dataBase;
@end
