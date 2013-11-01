//
//  BaseTableCell.m
//  MysqlConnection
//
//  Created by Galaxy39 on 10/15/13.
//  Copyright (c) 2013 oDesk. All rights reserved.
//

#import "BaseTableCell.h"

@implementation BaseTableCell
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)onAddButtonClicked:(id)sender {
    int index = self.tag;
    [self.delegate BaseTableCellDelegate_AddAction:index];
}

- (IBAction)onDeleteButtonClicked:(id)sender {
    int index = self.tag;
    [self.delegate BaseTableCellDelegate_DeleteAction:index];
}
@end
