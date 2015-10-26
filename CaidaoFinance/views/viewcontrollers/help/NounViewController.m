//
//  NounViewController.m
//  CaidaoFinance
//
//  Created by LJ on 15/5/7.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "NounViewController.h"
#import "NounDetailViewController.h"

@interface NounViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray * contents;
    NSArray * heads;
}

@end

@implementation NounViewController

-(void)viewDidAppear:(BOOL)animated
{
    [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"名词解释";
    _tableView.dataSource = self;
    _tableView.delegate = self;
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.sectionIndexColor = RGBCOLOR(146, 27, 35);
    contents = @[@[@{@"content":@"充值",@"detail":@"指通过本网站的账户充值界面，向会员本人的财道金融账户转入资金的行为。"}],
                 @[@{@"content":@"代偿",@"detail":@"指由担保机构提供担保的借款标，借款人逾期达30天或发生其它违约行为时，担保机构代债务人向债权人、财道金融及相关方偿还应还的借款本息及相关费用的行为。"},@{@"content":@"等额本息还款",@"detail":@"等额本息还款法是一种被广泛采用的还款方式。在还款期内，每月偿还同等数额的借款(包括本金和利息)。借款人每月还款额中的本金比重逐月递增、利息比重逐月递减。"}],
                 @[@{@"content":@"发标",@"detail":@"指借款个人/企业在本网站申请，发布借款标的行为。"}],
                 @[@{@"content":@"借款标",@"detail":@"指在本网站发布的包含借款金额、借款期限、还款方式、利率、招标期限、借款人信息、担保企业信息等借款信息的借款申请。"}],
                 @[@{@"content":@"流标",@"detail":@"指借款人在借款标招期期间放弃或终止招标，或者借款标在招标期限内累计投资金额未能达到借款标额度的100%的状态。"}],
                 @[@{@"content":@"满标",@"detail":@"指借款标在招标期限内，会员累计投资金额已达到借款标额度的100%的状态。"}],
                 @[@{@"content":@"年化利率",@"detail":@"年化利率是把真实利率换算成以年为单位的利率。"},@{@"content":@"年化收益率",@"detail":@"指投资人对应一年投资所获的收益率。"}],
                 @[@{@"content":@"受让人",@"detail":@"指通过本网站，投资债权转让标的会员。（受让人也是债权人）。"},@{@"content":@"手机投标",@"detail":@"财道金融专为本网站注册会员开通的手机端投标服务功能。"}],
                 @[@{@"content":@"提现",@"detail":@"指通过本网站的账户充值界面，向会员本人的财道金融账户转入资金的行为。"},@{@"content":@"投资人",@"detail":@"指在本网站已注册并符合条件，进行资金出借活动的会员。"},@{@"content":@"投标",@"detail":@"投标是指投资人对通过财道金融网站发布的尚未满标的借款标，在认可该借款标的借款条件信息后，以不低于该借款标规定的最低投标金额的可投资金对该标进行投资的行为。投标包括自动投标和手动投标。（自动投标规则详见本网站相关）。"},@{@"content":@"提前还款",@"detail":@"指借款人在借款计划还款日前归还借款的行为，包括部分提前还款和全额提前还款。部分提前还款指借款人在还款日前偿还部分借款金额的行为，全额提前还款指借款人在还款日前一次性结清全部借款本息及相关费用的行为。"}],
                 @[@{@"content":@"先息后本还款",@"detail":@"先息后本还款是财道金融常用的一种还款方式。在还款期内，每天偿还同等金额的利息，到期后一次性偿还最后一天的利息和本金。"}],
                 @[@{@"content":@"逾期",@"detail":@"指借款人在约定付息还本时间未及时足额还款的，即为逾期。"},@{@"content":@"一次性还款",@"detail":@"所谓一次性偿还贷款，就是在贷款期限到期前，一次性还清本金和利息。一次性偿还贷款的借款目的一般是有特定用途的，如用于应付临时性的资金短缺，因此一次性偿还贷款一般期限较短，数额较大。"}],
                 @[@{@"content":@"债权人",@"detail":@"指通过投资本网站的借款标的而成功出借资金的会员，又称投资人/出借人。"},@{@"content":@"债务人",@"detail":@"指通过在本网站发布借款标的而成功融入资金的个人/企业，又称借款人。"},@{@"content":@"转让人",@"detail":@"指通过本网站发起申请，转让自己所持有未到期债权的会员。"},@{@"content":@"债权收购",@"detail":@"逾期的债权根据财道金融本息保障计划，由财道金融“风险备用金”先行回购未到期的本金和利息，回购完成后债权转移至财道金融名下。"},@{@"content":@"自定义还款",@"detail":@"担保机构为借款个人/企业设定的还款计划\nA必须以天为单位。 \nB不允许部分提前还款。\nC允许提前全额还款，还清所有本金及实际借款天数的利息，支付提前还款罚息，借款人居间服务费多退少补。\nD到期还款本金及利息。\nE任何一期逾期产生逾期利息，逾期30天强制担保机构代偿所有本金及产生的利息及逾期利息。"},@{@"content":@"自动投标",@"detail":@"投资人提前设置自动投标的标准，借款标开始前1分钟，若借款标满足投资人设定的标准，系统会自动安排投标。"}]];
    
    heads = @[@"C",@"D",@"F",@"J",@"L",@"M",@"N",@"S",@"T",@"X",@"Y",@"Z"];
    // Do any additional setup after loading the view from its nib.
}


#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary*currentData = [[contents objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:[[NounDetailViewController alloc] initWithContent:[currentData objectForKey:@"detail"] title:[currentData objectForKey:@"content"]] animated:YES];
}


#pragma mark UITableViewDataSource
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *toBeReturned = [[NSMutableArray alloc]init];
    for(char c = 'A';c<='Z';c++)
        [toBeReturned addObject:[NSString stringWithFormat:@"%c",c]];
    return toBeReturned;
    
}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    NSInteger count = 0;
    for(NSString *character in heads)
    {
        if([character isEqualToString:title])
        {
            return count;
        }
        count ++;
    }
    return 0;
    
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if([heads count]==0)
    {
        return @"";
    }
        return [heads objectAtIndex:section];
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellId = @"cellId";
    NSDictionary*currentData = [[contents objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.textColor = RGBCOLOR(139, 32, 35);
    cell.textLabel.text = [currentData objectForKey:@"content"];
    return cell;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView*view=[UIView new];
    view.backgroundColor = RGBCOLOR(189, 189, 189);
    UILabel*label=[[UILabel alloc] initWithFrame:CGRectMake(10, 3, 100, 20)];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"HiraginoSansGB-W3" size:15];
    label.text = heads[section];
    [view addSubview:label];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [contents[section] count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [contents count];
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
