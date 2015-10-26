//
//  HelpCenterViewController.m
//  CaidaoFinance
//
//  Created by LJ on 15/5/6.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "HelpCenterViewController.h"
#import "HelpCenterTableViewCell.h"
#import "HelpDetailViewController.h"
#import "NounViewController.h"
#import <FlatUIKit.h>

@interface HelpCenterViewController ()<UITableViewDataSource,UITableViewDelegate,FUIAlertViewDelegate>
{
    NSArray*datas;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation HelpCenterViewController

-(void)viewDidAppear:(BOOL)animated
{
    [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"帮助中心";
    
    datas = @[@"欢迎加入我们",@"如何投资",@"账户设置",@"名词解释"];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView*view = [UIView new];
    [view setBackgroundColor:[UIColor clearColor]];
    [_tableView setTableFooterView:view];
    // Do any additional setup after loading the view from its nib.
}


#pragma mark FUIAlertViewDelegate
- (void)alertView:(FUIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            
            break;
        case 1:
            TEL(@"4009658588");
            break;
        default:
            break;
    }
}


#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3) {
        [self.navigationController pushViewController:[NounViewController new] animated:YES];
    }
    else
    {
        [self.navigationController pushViewController:[[HelpDetailViewController alloc] initWithName:datas[indexPath.row] type:indexPath.row] animated:YES];
    }
}

#pragma mark UITableViewDatasource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellId = @"cellId";
    HelpCenterTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HelpCenterTableViewCell" owner:self options:nil] lastObject];
    }
    cell.text.text = datas[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [datas count];
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

- (IBAction)phoneAction:(id)sender {
    FUIAlertView *alertView = [[FUIAlertView alloc] initWithTitle:nil
                                                          message:@"确认拨打客服电话吗？"
                                                         delegate:self cancelButtonTitle:@"取消"
                                                otherButtonTitles:@"拨打",nil];
    alertView.titleLabel.textColor = [UIColor cloudsColor];
    alertView.alertButtonStyle = FUIAlertViewButtonLayoutHorizontal;
    alertView.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    alertView.messageLabel.textColor = [UIColor grayColor];
    alertView.messageLabel.font = [UIFont flatFontOfSize:14];
    alertView.backgroundOverlay.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    alertView.alertContainer.backgroundColor = [UIColor whiteColor];
    alertView.defaultButtonColor = RGBCOLOR(138, 32, 35);
    alertView.defaultButtonShadowHeight = 0;
    alertView.defaultButtonFont = [UIFont boldFlatFontOfSize:16];
    alertView.defaultButtonTitleColor = [UIColor whiteColor];
    alertView.defaultButtonCornerRadius = 10;
    [alertView show];

    
}
@end
