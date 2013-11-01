//
//  BaseTableCell.h
//  MysqlConnection
//
//  Created by Galaxy39 on 10/15/13.
//  Copyright (c) 2013 oDesk. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol BaseTableCellDelegate
- (void)BaseTableCellDelegate_AddAction:(int)index;
- (void)BaseTableCellDelegate_DeleteAction:(int)index;
@end

@interface BaseTableCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *lbl_name;
@property (retain, nonatomic) IBOutlet UILabel *lbl_description;
@property (retain, nonatomic) IBOutlet UILabel *lbl_newConnection;
@property (retain, nonatomic) IBOutlet UIButton *btn_add;
@property (retain, nonatomic) IBOutlet UIButton *btnDelete;
@property (nonatomic,retain) id<BaseTableCellDelegate>delegate;
- (IBAction)onAddButtonClicked:(id)sender;
- (IBAction)onDeleteButtonClicked:(id)sender;
@end
