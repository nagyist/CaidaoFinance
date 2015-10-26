//
//  HelpDetailViewController.m
//  CaidaoFinance
//
//  Created by LJ on 15/5/7.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "HelpDetailViewController.h"
#import "HelpDetailCell.h"

@interface HelpDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger viewType;
    NSArray * heads;
    NSArray * contents;

}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation HelpDetailViewController

-(id)initWithName:(NSString *)name type:(NSInteger)index
{
    if (self) {
        self.title = name;
        viewType = index;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat top = 25; // 顶端盖高度
    CGFloat bottom = 25 ; // 底端盖高度
    CGFloat left = 10; // 左端盖宽度
    CGFloat right = 10; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    // 指定为拉伸模式，伸缩后重新赋值
    _bgImg.image = [_bgImg.image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView setShowsVerticalScrollIndicator:NO];
    //set the tableHeaderView so that the required height can be determined
    switch (viewType) {
        case 0:
            heads = @[@"了解我们",@"选择财道金融的理由",@"注册登录",@"实名认证会员",@"邮箱认证",@"Vip申请"];
            contents = @[@"财道金融总部位于中国的金融中心上海，是中国领先的互联网金融公司，获得国家工商部门批准“金融信息服务”资质，公司秉承“诚信、创新、激情、共赢”的服务理念，旨在为出借人和借款人搭建一个安全、透明、规范、高效的P2P互动平台。",@"财道金融的标为资产抵押标、机构担保标。\n全面的本息保障计划，所有财道金融的投资人都享受“本金保障计划”。如借款标出现逾期违约时，财道金融将启动“风险准备金”提前赎回债权，先行付给投资人本金和本息（详见本金保障计划 ），保障投资人的资金安全。\n注册成为财道金融出借人，享受多重资金安全保障，轻松实现超过15%的年化收益。",@"指通过本网站注册页面，使用手机号码注册，设置密码并填写推荐码，成功注册的会员。",@"指在本网站注册成功后，提交个人身份信息，并通过国家权威认证的第三方身份认证机构认证的会员。",@"邮箱认证",@"指在本网站通过提交VIP申请并通过的会员。"];
            break;
        case 1:
            heads = @[@"Q:我能在财道金融投资么？",@"Q:具体要怎样在财道金融投资呢？",@"Q:需要支付哪些费用呢？",@"Q:我在财道金融的投资安全么？",@"Q:我投资了长期的项目，现在急需用钱，怎么办？",@"Q:财道账户里的资金，要如何提现？",@"Q:提现多久可以到账？",@"Q:平时没有时间守着电脑投标，怎么办？",@"Q:如何查看我的投资项目？",@"Q:如何查看投资项目的合同？",@"Q:什么类型的债权可以进行转让？",@"Q:什么时间可以发布债权转让标？",@"Q:债权转让的费用如何？",@"Q:债权转让的价格如何计算？",@"Q:债权成功转让后何时能收到交易资金？",@"Q:提交债权转让申请后可以撤销吗？",@"Q:如何查看投资项目的合同？"];
            contents = @[@"A:只要您是年满18周岁，具有完全民事行为能力的中国籍大陆居民，有稳定的收入来源，且您所在区域正好有我们的合作担保机构，便可在线申请投资。",@"第一步：登录财道金融网站，填写注册信息；\n第二步：完成身份认证,成为合格的合拍会员；\n第三步：账户充值；\n第四步：开始投资；",@"充值费用：以第三方支付机构收费为准。\n提现费用：以第三方支付机构收费为准。\n居间服务费：利息收益10%。\n债权转让费用：转让金额的千分之一，最低25元。",@"这点您可以放心。我们目前所有借款都是有信誉卓著的合作担保机构来担保的，而且每笔企业借款都有连带反担保企业。倘若项目逾期，平台会用风险准备金垫付投资人的本息，回购债权，最晚将在逾期第30天由担保机构进行本息的全额代偿或者全额的债权收购，以保证您投资无忧 。",@"考虑到您资金的流动性，我们提供了债权转让的服务。您可以将符合条件的项目申请债权转让，提早收回债权。（债权转让具体操作详见债权转让介绍）",@"对于可用资金，您进入“会员中心”→“资金管理”→“账户提现”界面，选择提现收款银行，输入交易密码，即可申请提现。",@"......",@"1、财道金融为方便那些没有时间逐个查看筛选借款列表并进行投标的投资人提供了自动投标服务，投资人可根据自己的风险偏好、投资习惯在自动投标中设置各种条件，若有符合相应条件的借款出现，将由程序自动完成投标。\n2、财道金融为本网站注册VIP会员开通的手机端投标服务功能。财道金融注册VIP会员只需在电脑终端登录 会员中心，在线申请开通手机投标功能，并使用数字证书签署《财道金融移动终端网站服务协议》，即可使用手机，通过手机端浏览器、合拍微信订阅号等入口登录 合拍微站点（m.he-pai.cn），随时随地使用合拍账户余额进行投标，进行账户余额查询等操作。",@"在“会员管理中心”→“我的投资”→“投资列表”中，选择您想查看的项目，点开“项目详情”界面，即可查看该项目的详情。",@"在“会员管理中心”→“我的投资”→“投资列表”中，选择您想查看的项目，点开“项目详情”界面，即可查看该项目的相关所有合同。",@"投资人持符合下列条件的债权可以申请转让 （1）借款债权是通过财道金融网站提供居间服务达成、且已经放款但尚未结清的借款标的债权； （2）申请人持有该债权已满1天，剩余的还款期限大于等于8天； （3）债权的还款方式为到期一次还本付息。 （4）债权的当前还款状态正常，即非逾期或非展期状态。 （5）申请转让日不能是借款计划还款日。 （6）债权为普通借款标债权，即不能是投资债权转让标的债权。 （7）财道金融届时要求的其他条件。",@"债权转让标的招标时间为每日8：00－22：00，当天17:00前提交的申请可选择当日或次日在上述招标时间范围内发布转让标，超过17点提交的申请，发标日期为次日。 申请转让的债权必须是全部债权，若当日未能100%转让成功，剩余债权可以次日及以后再次发起转让。",@"债权转让方需按成功转让金额的千分之一（最低25元）向财道金融支付债权转让费。 投资人在收到所投资债权的借款利息时按利息10%向财道金融支付居间服务费",@"债权转让价格＝转让的债权本金+截止至转让日应收利息 转让的债权本金：指成功交易的债权本金金额。 截止至转让生效日应收利息是指自借款人截止至债权转让日（不含）转让的债权本金对应的应收利息减去应付给合拍的居间服务费后的金额。",@"投资人成功投资债权转让标时，投资资金即从投资人的合拍账户划转至债权转让人的合拍账户。同时为了保证债权转让的安全，债权转让人收到的债权交易金额将冻结至交易当天的24点，如债权转让交易数据无异常，则交易资金届时自动解冻。如债权转让交易数据有异常，债权转让交易资金冻结时间将延长1个工作日，在财道金融在审核、更正、确认数据正确后再进行解冻。",@"债权出让人在提交转让申请后，可随时在线将未达成交易的剩余债权撤销转让申请，申请撤销前已经交易的债权转让继续有效，未交易的债权转让终结交易。",@"在“会员管理中心”→“我的投资”→“投资列表”中，选择您想查看的项目，点开“项目详情”界面，即可查看该项目的相关所有合同。",];
            break;
        case 2:
            heads = @[@"密码管理：",@"添加银行卡：",@"债权转让：",@"自动投标：",@"个人资料：",@"推荐好友："];
            contents = @[@"会员管理中心的基本设置中，有“修改密码”的服务，您可以修改登录密码或者交易密码。",@"会员管理中心的基本设置中，有“银行卡绑定”的服务，您可以添加提现的银行卡号。",@"债权转让是指财道金融投资人，通过财道金融网站将已投资但尚未到期的借款标债权转让给财道金融其它投资人。",@"投资人提前设置自动投标的标准，借款标发布前10分钟，若借款标满足投资人设定的标准，系统会自动安排投标。",@"会员管理中心的基本设置中，在“我的资料”中，您可以添加昵称等基本信息。",@"推荐方式有4种\n推广链接，每位会员都有一个独立的推广链接网址，通过您的推广链接注册成功的会员，就是您的下线用户。\n邀请码，在会员注册页面，填写邀请码。\n二维码，手机端扫描二维码注册。\n推荐登记，已注册会员可以添加被推荐人的真实姓名和手机号码，此会员如成功注册，推荐成功。（注册登记有效期为15天，超过15天推荐登记失效，需要重新登记）"];
            break;
        case 3:
            heads = @[@"免责声明",@"版权说明"];
            contents = @[@"尊敬的用户您好，感谢您访问财道金融此免责条款由上海骄荣金融信息服务有限公司提供！您若购买了软件内部的理财产品，就认同并接受了此条款。请您在投资前仔细阅读此条款！\n上海骄荣金融信息服务有限公司将尽最大的努力使产品说明尽可能的准确。如果上海骄荣金融信息服务有限公司提供的产品本身并非如说明所述，与苹果商城无关，请您联系财道金融的客服，说明情况，我们将在用户条款和投资条款支持的情况下尽一切努力，挽回您的经济损失。",@"上海骄荣金融信息服务有限公司上所有的内容，注入文字、图表、标识、按钮图标、声音文字片段、数字下载、数据编辑和软件、商标都是上海骄荣金融信息服务有限公司所有，受中国相关法律的保护。未经上海骄荣金融信息服务有限公司书面授权或许可，禁止任何人以任何目的对本网站或其任何部分进行复制、复印、伪造、出售、转售、访问或其他的方式加以利用。"];
            
            break;
            
        default:
            break;
    }
    
    // Do any additional setup after loading the view from its nib.
}


#pragma mark UITableViewDelegate



#pragma mark UITableViewDataSource
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    HelpDetailCell*cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HelpDetailCell" owner:self options:nil] lastObject];
    }
    cell.content.text = [contents objectAtIndex:indexPath.row];
    cell.head.text = heads[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    static HelpDetailCell *cell = nil;
    static dispatch_once_t onceToken;
    //只会走一次
    dispatch_once(&onceToken, ^{
        cell = (HelpDetailCell*)[tableView dequeueReusableCellWithIdentifier:@"cellId2"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"HelpDetailCell" owner:self options:nil] lastObject];
        }
    });
    
    CGFloat height = [cell calulateHeightWithDesrip:[contents objectAtIndex:indexPath.row] head:heads[indexPath.row]];
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [heads count];
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
