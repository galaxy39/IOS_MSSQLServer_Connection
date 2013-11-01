//
//  BuildViewController.h
//  MysqlConnection
//
//  Created by Galaxy39 on 10/28/13.
//  Copyright (c) 2013 oDesk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Obj_Database.h"
#import "MySqlServerConnection.h"
#import "AdminTableConfController.h"
@protocol BuildViewControllerDelegate
- (void)BuildViewControllerDelegate_needUpdate;
@end

@interface BuildViewController : UIViewController<MySqlServerConnectionDeegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,AdminTableConfControllerDelegate>
{
    Obj_Database * m_selectDb;
    NSArray * m_tableArray;
    NSArray* m_selectedTableColumns;
    
    BOOL isUpdateMode;
    Obj_Query * m_defaultInformation;
    
    NSString * selectedTableName;
}
@property (nonatomic,retain)id<BuildViewControllerDelegate>delegate;
@property (weak, nonatomic) IBOutlet UITextField *edt_tableName;
@property (weak, nonatomic) IBOutlet UITextField *edt_columns;
@property (weak, nonatomic) IBOutlet UITextField *edt_searchRule;
@property (weak, nonatomic) IBOutlet UIView *sub_selectTableView;
@property (weak, nonatomic) IBOutlet UIPickerView *tableSelector;
- (IBAction)onSelectTable:(id)sender;
- (void)setUpdateQueryItem:(Obj_Query*)item;
- (void)setInformations:(Obj_Database*)selectDb :(NSArray*)tableArray;
@end
