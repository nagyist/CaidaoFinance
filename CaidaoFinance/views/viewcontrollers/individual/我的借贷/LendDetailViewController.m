//
//  LendDetailViewController.m
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/27.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "LendDetailViewController.h"
#import "LendDetailCell.h"

@interface LendDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray * datas;
    NSArray * texts;
    NSDictionary * currentData;
}

@end

@implementation LendDetailViewController

- (id)initWithBorrowerData:(NSDictionary *)data {
    if (self) {
        currentData = data;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"借贷";
    datas = @[@"姓名",@"性别",@"借款金额",@"借款期限",@"手机号码",@"所在地区",@"初审状态",@"复审状态"];
    texts = @[@"Leo",@"男",@"￥20,000.00",@"3个月",@"15800044411",@"上海市杨浦区",@"申请中",@"申请中"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // Do any additional setup after loading the view from its nib.
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellId = @"cellId";
    LendDetailCell*cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LendDetailCell" owner:self options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.name.text = datas[indexPath.row];
    cell.text.text = [self getDataByIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 54;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [datas count];
}


- (NSString*)getDataByIndex:(NSInteger)index {
    NSString * str = @"";
    switch (index) {
        case 0:
            str = [currentData objectForKey:@"user_name"];
            break;
        case 1:
            str = [self getSex:[[currentData objectForKey:@"user_sax"] integerValue]];
            break;
        case 2:
            str = [[currentData objectForKey:@"borrow_money"] stringValue];
            break;
        case 3:
            str = [NSString stringWithFormat:@"%@天",[[currentData objectForKey:@"borrow_time_limit"] stringValue]];
            break;
        case 4:
            str = [currentData objectForKey:@"user_tel"];
            break;
        case 5:
            str = [NSString stringWithFormat:@"%@%@",[currentData objectForKey:@"user_province"],[currentData objectForKey:@"user_city"]];
            break;
        case 6:
            str = [self getState:[[currentData objectForKey:@"status01"] integerValue]];
            break;
        case 7:
            str = [self getState:[[currentData objectForKey:@"status02"] integerValue]];
            break;
            
        default:
            break;
    }
    return str;
}

- (NSString*)getSex:(NSInteger)index {
    NSString *sex = @"";
    switch (index) {
        case 1:
            sex = @"保密";
            break;
        case 2:
            sex = @"男";
            break;
        case 3:
            sex = @"女";
            break;
            
        default:
            break;
    }
    return sex;
}

- (NSString *)getState:(NSInteger)index {
    NSString * state = @"";
    switch (index) {
        case 0:
            state = @"申请中";
            break;
        case 1:
            state = @"初审通过";
            break;
        case -1:
            state = @"初审未通过";
            break;
            
        default:
            break;
    }
    return state;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
