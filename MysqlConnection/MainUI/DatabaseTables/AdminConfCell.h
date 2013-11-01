//
//  AdminConfCell.h
//  MysqlConnection
//
//  Created by Galaxy39 on 10/22/13.
//  Copyright (c) 2013 oDesk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdminConfCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *lbl_columnName;
@property (retain, nonatomic) IBOutlet UILabel *lbl_columnType;
@property (retain, nonatomic) IBOutlet UILabel *lbl_otherInfo;
@property (retain, nonatomic) IBOutlet UISwitch *check_show;
@property (weak, nonatomic) IBOutlet UILabel *lbl_recommond;
@end
