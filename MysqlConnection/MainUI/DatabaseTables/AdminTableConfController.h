//
//  AdminTableConfController.h
//  MysqlConnection
//
//  Created by Galaxy39 on 10/22/13.
//  Copyright (c) 2013 oDesk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MySqlServerConnection.h"


@protocol AdminTableConfControllerDelegate
- (void)AdminTableConfControllerDelegate_Data:(NSString*)data :(int)type;
@end

@interface AdminTableConfController : UIViewController<UITableViewDataSource,UITableViewDelegate,MySqlServerConnectionDeegate>
{
    NSArray * m_columnArray;
    NSString * m_tableName;
    NSString * m_confData;
    NSArray * m_confArray;
    
    int typeId;
    NSMutableArray * selectedItemArray;

}
@property(nonatomic,retain)id<AdminTableConfControllerDelegate>delegate;
- (void)setType:(int)type;
- (void)setInfoData:(NSString*)tableName :(NSArray*)columnArray;
- (void)setConfData:(NSString*)conf;
@property (retain, nonatomic) IBOutlet UITableView *m_dataContainer;
@end
