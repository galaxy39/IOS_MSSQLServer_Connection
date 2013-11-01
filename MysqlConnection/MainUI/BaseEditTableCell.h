//
//  BaseTableCell.h
//  MysqlConnection
//
//  Created by Galaxy39 on 10/15/13.
//  Copyright (c) 2013 oDesk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseEditTableCell : UITableViewCell<UITextFieldDelegate>

@property (retain, nonatomic) IBOutlet UILabel *lbl_title;
@property (retain, nonatomic) IBOutlet UITextField *txt_value;
@end
