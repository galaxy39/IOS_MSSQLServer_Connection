//
//  BaseSearchCell.h
//  MysqlConnection
//
//  Created by Galaxy39 on 10/19/13.
//  Copyright (c) 2013 oDesk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseSearchCell : UITableViewCell<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lbl_columnName;
@property (retain, nonatomic) IBOutlet UITextField *edt_search;

@end
