//
//  Con_SettingController.h
//  MysqlConnection
//
//  Created by Galaxy39 on 10/15/13.
//  Copyright (c) 2013 oDesk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Obj_Database.h"

@interface Con_SettingController : UIViewController
{
    BOOL isEditMode;
    
    Obj_Database * m_information;
}

@property (retain, nonatomic) IBOutlet UITableView *table_setting;
- (void)setInformation:(Obj_Database*)item;
@end
