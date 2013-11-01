//
//  BaseSearchCell.m
//  MysqlConnection
//
//  Created by Galaxy39 on 10/19/13.
//  Copyright (c) 2013 oDesk. All rights reserved.
//

#import "BaseSearchCell.h"

@implementation BaseSearchCell
- (id)init
{
    self = [super init];
    if(self){
    }
    return self;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
//        cellView = (BaseSearchCell*)[[[NSBundle mainBundle] loadNibNamed:@"BaseSearchCell" owner:nil options:nil] objectAtIndex:0];
    }
    return self;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
