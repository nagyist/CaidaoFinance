//
//  ChooseBankLocationViewController.m
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/25.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "SearchBankViewController.h"

@interface SearchBankViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSArray * banks;
}

@end

@implementation SearchBankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择银行网点";
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView setShowsVerticalScrollIndicator:YES];
    [_tableView setTableFooterView:[UIView new]];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 50, 50)];
    [button setTitle:@"保存" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    
    ///可加入分类 Category
    UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSeperator.width = -12;
    
    UIBarButtonItem *barbtn=[[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItems = @[negativeSeperator,barbtn];

    
    banks = @[@"上海工商银行杨浦支行",@"上海工商银行杨浦支行",@"上海工商银行杨浦支行",@"上海工商银行杨浦支行",@"上海工商银行杨浦支行",@"上海工商银行杨浦支行",@"上海工商银行杨浦支行",@"上海工商银行杨浦支行"];
    // Do any additional setup after loading the view from its nib.
}

- (void)saveAction {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SearchBankViewControllerSelected" object:nil userInfo:@{@"text":_searchTxt.text}];
    [self.navigationController popViewControllerAnimated:YES];

}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SearchBankViewControllerSelected" object:nil userInfo:@{@"text":banks[indexPath.row]}];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UITableViewDataSource
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellId = @"cellId";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.text = banks[indexPath.row];
    cell.textLabel.textColor = [UIColor lightGrayColor];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [banks count];
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
