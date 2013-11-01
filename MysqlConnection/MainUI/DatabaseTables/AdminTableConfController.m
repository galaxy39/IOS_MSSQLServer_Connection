//
//  AdminTableConfController.m
//  MysqlConnection
//
//  Created by Galaxy39 on 10/22/13.
//  Copyright (c) 2013 oDesk. All rights reserved.
//

#import "AdminTableConfController.h"
#import "AdminConfCell.h"

@interface AdminTableConfController ()

@end

@implementation AdminTableConfController
@synthesize delegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        selectedItemArray = [NSMutableArray new];
    }
    return self;
}
- (void)setType:(int)type
{
    typeId = type;
}
- (void)setInfoData:(NSString*)tableName :(NSArray*)columnArray
{
    m_tableName = tableName;
    m_columnArray = columnArray ;
}
- (void)setConfData:(NSString*)conf;
{
    m_confData = conf;
    m_confArray = [NSArray new];
    m_confArray = [m_confData componentsSeparatedByString:@","];
    selectedItemArray = [[NSMutableArray alloc] initWithArray:m_confArray];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:self action:@selector(onSave)];
    // Do any additional setup after loading the view from its nib.
    if([[UIDevice currentDevice].systemVersion floatValue] >= 7){
        _m_dataContainer.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    _m_dataContainer.delegate = self;
    _m_dataContainer.dataSource = self;
    [_m_dataContainer reloadData];

}
////
- (NSString*)getConfString
{
//    NSMutableArray * array = [NSMutableArray new];
//    for(int i =0;i<[m_columnArray count];i++){
////        UITableViewCell * cellView = (UITableViewCell*)[_m_dataContainer cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
//        NSString * cellIndenitfier = [NSString stringWithFormat:@"cellIndenitfier%d", i];
//        UITableViewCell * cellView = [_m_dataContainer dequeueReusableCellWithIdentifier:cellIndenitfier];
//        NSLog(@"%@",cellView);
//        UISwitch * switchView;
//        for(UIView * subView in cellView.contentView.subviews){
//            if([subView isKindOfClass:[UISwitch class]])
//                switchView = (UISwitch*)subView;
//        }
//        if([switchView isOn]){
//            if([[m_columnArray objectAtIndex:i] isKindOfClass:[NSDictionary class]]){
//                NSString * str = [(NSDictionary*)[m_columnArray objectAtIndex:i] objectForKey:@"name"];
//                [array addObject:str];
//            }else if ([[m_columnArray objectAtIndex:i] isKindOfClass:[NSString class]]){
//                [array addObject:[m_columnArray objectAtIndex:i]];
//            }
//        }
//    }
    return [selectedItemArray componentsJoinedByString:@","];
}
- (void)onSave
{
    NSString * dataStr = [self getConfString];
//    [[MySqlServerConnection getInstance:self :0] admin_conf_mgr_isSet:m_tableName];
    [self.navigationController popViewControllerAnimated:YES];
    [self.delegate AdminTableConfControllerDelegate_Data:dataStr :typeId];
}
-(void)recivedDataArray:(NSArray *)result :(BOOL)res :(int)signalId
{
    if(result == nil || [result count] == 0)
        return;
    if(signalId == 0){
        NSDictionary * dict = [[result objectAtIndex:0] objectAtIndex:0];
        int count = [[[dict allValues] objectAtIndex:0] intValue];
        NSString * dataStr = [self getConfString];
        if(count ==0){
            [[MySqlServerConnection getInstance:self :1] insert_admin_conf_mgr:m_tableName :dataStr];
        }else{
            [[MySqlServerConnection getInstance:self :2] update_admin_conf_mgr:m_tableName :dataStr];
        }
    }
    if(signalId ==1 || signalId ==2){
        [self.navigationController popViewControllerAnimated:YES];
    }
}

////

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)onChangeValue:(UISwitch*)mswitch
{
    int tag = mswitch.tag;
    NSString * columnName;
    if([[m_columnArray objectAtIndex:tag] isKindOfClass:[NSDictionary class]]){
        columnName = [(NSDictionary*)[m_columnArray objectAtIndex:tag] objectForKey:@"name"];
    }else if ([[m_columnArray objectAtIndex:tag] isKindOfClass:[NSString class]]){
        columnName = [m_columnArray objectAtIndex:tag];
    }

    if([mswitch isOn]){
        [selectedItemArray addObject:columnName];
    }else{
        for(NSString * subStr in selectedItemArray){
            if([subStr isEqualToString:columnName]){
                [selectedItemArray removeObject:subStr];
            }
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_columnArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 32;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellIndenitfier = [NSString stringWithFormat:@"cellIndenitfier%d", indexPath.row];
    UITableViewCell * cellView = [tableView dequeueReusableCellWithIdentifier:cellIndenitfier];
    if (!cellView){
        cellView = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndenitfier];
        UILabel * lbl_columnName = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 146, 32)];
        [lbl_columnName setFont:[UIFont boldSystemFontOfSize:15]];
        UILabel * lbl_recommond = [[UILabel alloc]initWithFrame:CGRectMake(144, 0, 109, 32)];
        [lbl_recommond setFont:[UIFont systemFontOfSize:11]];
        [lbl_recommond setText:@"Show this column?"];
        UISwitch * check_show = [[UISwitch alloc] initWithFrame:CGRectMake(272, 0, 51, 32)];
        check_show.tag = indexPath.row;
        [check_show addTarget:self action:@selector(onChangeValue:) forControlEvents:UIControlEventValueChanged];
        [cellView.contentView addSubview:lbl_columnName];
        [cellView.contentView addSubview:lbl_recommond];
        [cellView.contentView addSubview:check_show];
        
        if([[m_columnArray objectAtIndex:indexPath.row] isKindOfClass:[NSDictionary class]]){
            NSDictionary * dict = (NSDictionary*)[m_columnArray objectAtIndex:indexPath.row];
            NSString * columnName = [dict objectForKey:@"name"];
            lbl_columnName.text = columnName;
            BOOL res = NO;
            if(m_confArray != nil || [m_confArray count] > 0){
                for(NSString * key in m_confArray){
                    if([key isEqualToString:columnName]){
                        res = YES;
                        break;
                    }
                }
                [check_show setOn:res];
            }else{
                [check_show setOn:res];
            }
            
        }else if ([[m_columnArray objectAtIndex:indexPath.row] isKindOfClass:[NSString class]]){
            lbl_columnName.text = [m_columnArray objectAtIndex:indexPath.row];
            BOOL res = NO;
            if(m_confArray != nil || [m_confArray count] > 0){
                for(NSString * key in m_confArray){
                    if([key isEqualToString:[m_columnArray objectAtIndex:indexPath.row]]){
                        res = YES;
                        break;
                    }
                }
                [check_show setOn:res];
            }else{
                [check_show setOn:res];
            }
            
        }
        if(typeId == 1){
            lbl_recommond.text = @"Make this to Criterial";
        }

        
    }
    return cellView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}


@end
