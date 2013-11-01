//
//  Con_SearchController.h
//  MysqlConnection
//
//  Created by Galaxy39 on 10/16/13.
//  Copyright (c) 2013 oDesk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseSearchCell.h"
#import "SearchResultController.h"
#import "MySqlServerConnection.h"

@interface Con_SearchController : UIViewController<UITableViewDataSource,UITableViewDelegate,MySqlServerConnectionDeegate>
{
    NSArray * m_columArray;
    NSString * m_tableName;
    NSString * m_confData;
    NSArray * m_confArray;
    
    NSMutableArray * tmpArray;
}
@property (retain, nonatomic) IBOutlet UITableView *m_dataContainer;
- (void)setInitialData:(NSString*)tableName :(NSArray*)columnArray;
- (void)setConfData:(NSString*)conf;
@end
