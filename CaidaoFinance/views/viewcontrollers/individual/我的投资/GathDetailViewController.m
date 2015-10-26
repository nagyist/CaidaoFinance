//
//  GathDetailViewController.m
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/28.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "GathDetailViewController.h"
#import "GathDetailCell.h"

@interface GathDetailViewController ()<UITableViewDataSource,UITableViewDelegate> {
    NSDictionary * gathDetail;
    NSMutableArray*lists;
}

@end

@implementation GathDetailViewController
- (id)initWithDetailData:(NSDictionary *)data {
    if (self) {
        gathDetail = data;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"收款明细记录";
    lists = [NSMutableArray new];
    [lists addObject:gathDetail];
    
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // Do any additional setup after loading the view from its nib.
}

#pragma mark UITableViewDelegate




#pragma mark UITableViewDataSource

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellId = @"cellId";
    NSDictionary * currentData = [[lists objectAtIndex:indexPath.row] objectForKey:@"borrow"];
    NSDictionary * tenderData = [[lists objectAtIndex:indexPath.row] objectForKey:@"borrowTender"];
    GathDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"GathDetailCell" owner:self options:nil]lastObject];
    }
    cell.date.text = [[currentData objectForKey:@"endTime"] substringWithRange:NSMakeRange(0, 10)];
    cell.times.text = @"总1期";
    [cell.benjin countFrom:[[tenderData objectForKey:@"effectiveAmount"] floatValue] to:[[tenderData objectForKey:@"effectiveAmount"] floatValue]];
    [cell.lixi countFrom:[[tenderData objectForKey:@"interestAmount"] floatValue] to:[[tenderData objectForKey:@"interestAmount"] floatValue]];
    [cell.jine countFrom:[[tenderData objectForKey:@"paidAmount"] floatValue] +  [[tenderData objectForKey:@"interestPaid"] floatValue]to:[[tenderData objectForKey:@"paidAmount"] floatValue] + [[tenderData objectForKey:@"interestPaid"] floatValue]];
    cell.state.text = [self getStateByIndex:[[[[lists objectAtIndex:indexPath.row] objectForKey:@"borrowTender"] objectForKey:@"tenderStatus"] integerValue]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [lists count];
}

- (NSString*)getStateByIndex:(NSInteger)index {
    NSString * state = @"";
    switch (index) {
        case 1:
            state = @"待审核";
            break;
        case 2:
            state = @"投标失败";
            break;
        case 3:
            state = @"还款中";
            break;
        case 4:
            state = @"还款成功";
            break;
        case 5:
            state = @"已逾期";
            break;
        case 7:
            state = @"已转让";
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
