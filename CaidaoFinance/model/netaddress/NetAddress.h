//
//  NetAddress.h
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/6/5.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  测试服务器域名地址
 */
static NSString * TEST_NETADDRESS  = @"http://www.186886.com/";
//static NSString * TEST_NETADDRESS  = @"http://qilujinfu110.oicp.net/qilu/";

/**
 *  测试服务器图片域名地址
 */
static NSString * TEST_IMG_NETADDRESS  = @"http://www.186886.com";
//static NSString * TEST_IMG_NETADDRESS  = @"http://qilujinfu110.oicp.net";



/**
 * 正式服务器域名地址
 */
static NSString * NETADDRESS = @"http://www.186886.com/app/";

/**
 * 首页
 */
static NSString * INDEX = @"app/index.do";

/**
 * 获取注册验证码
 */
static NSString * SMS = @"app/registerSendSms.do";

/**
 * 获取验证码
 */
static NSString * GETSMS = @"app/sendSms.do";


/**
 * 注册
 */
static NSString * REGISTER = @"app/register.do";

/**
 * 完善资料
 */
static NSString * CONSUM = @"app/addAndUpdateUserDetial.do";

/**
 * 登录
 */
static NSString * LOGIN = @"app/login.do";

/**
 * 验证验证码
 */
static NSString * VERTYSMS = @"app/checkSmsCode.do";

/**
 * 注册验证验证码
 */
static NSString * VERTYREGSMS = @"app/registerCheckSmsCode.do";

/**
 * 自动输入金额
 */
static NSString * GETTOTALNOSUCCESS = @"app/getTotalNoSuccess.do";

/**
 * 忘记密码（第二步）
 */
static NSString * FORGETPASSTWO = @"app/upPass.do";

/**
 * 实名认证
 */
static NSString * REALNAMEVERTY = @"app/requestRealnameAttestation.do";

/**
 * 修改绑定手机
 */
static NSString * UPDATEUSERTEL = @"app/updateUserTel.do";


/**
 * 签到
 */
static NSString * SIGN = @"app/sign.do";

/**
 * 上传头像
 */
static NSString * UPLOADIMG = @"upload/editorImg.do";

/**
 * 更新头像
 */
static NSString * UPDATEAVATAR = @"app/userAvater.do";

/**
 * 头像列表
 */
static NSString * USERHEAD = @"app/userHead.do";

/**
 * 资金管理
 */
static NSString * TRANSITIONRECORD = @"app/transcationRecord.do";


/**
 * 提现申请
 */
static NSString * APPLY = @"app/applyWithDraw.do";



/**
 * 检查签到
 */
static NSString * CHECKSIGN = @"app/checkSign.do";


/**
 * 投资
 */
static NSString * TENDER = @"app/tender.do";

/**
 * 投资列表
 */
static NSString * INVESTLSIT = @"app/showBorrowStatusInfoPageByParam.do";

/**
 * 投资列表
 */
static NSString * INVESTDETAIL = @"app/showBorrow/";

/**
 * 省
 */
static NSString * GETPROVINCE = @"app/getProvince.do";

/**
 * 市
 */
static NSString * GETCITY = @"app/getCityOrArea.do";

/**
 * 区
 */
static NSString * GETAREA = @"app/getCityOrArea.do";

/**
 * 借贷
 */
static NSString * BORROW = @"app/saveBorrowIntention.do";

/**
 * 投资记录
 */
static NSString * TENDERLIST = @"app/shwoBorrowTenderInfoByPage.do";

/**
 * 留言
 */
static NSString * MESSAGELIST = @"app/borrowMessage.do";

/**
 * 发送留言
 */
static NSString * SENDMESSAGE = @"app/insertBorrowMessage.do";

/**
 * 个人信息
 */
static NSString * PERSONDATA = @"app/personalData.do";

/**
 * 资金流水
 */
static NSString * TRANRECORD = @"app/transcationRecordPage.do";

/**
 * 个人资产管理
 */
static NSString * ZICHANGUANLI = @"app/transcationRecord.do";

/**
 * 个人银行信息
 */
static NSString * BANKINFO = @"app/userBankAttestation.do";

/**
 * 绑定银行卡
 */
static NSString * ADDBANKCARD = @"app/addBankCard.do";

/**
 * 个人实名认证信息
 */
static NSString * SHIMING = @"app/realnameAttestation.do";

/**
 * 会员中心首页
 */
static NSString * ACCOUNTINDEX = @"app/accountIndex.do";

/**
 * 实名认证信息
 */
static NSString * REALNAMEINFO = @"app/realnameAttestation.do";

/**
 * 银行卡绑定信息
 */
static NSString * BINDBANKINFO = @"app/userBankAttestation.do";

/**
 * 我的投资
 */
static NSString * MYINVEST = @"app/inRepayingPage.do";

/**
 * 投资详情(普通标)
 */
static NSString * CHECKINVESTDETAIL = @"app/checkDetail.do";

/**
 * 投资详情(债权标)
 */
static NSString * BIDINVESTDETAIL = @"app/inBidDetails.do";

/**
 * 申请债权转让
 */
static NSString * REDEEMTRANSFER = @"app/redeemTransfer/";

/**
 * 申请债权转让(下一步)
 */
static NSString * RELEASETRANSFER = @"app/redeemTransfer/releaseTransfer.do";


/**
 * 我的借贷
 */
static NSString * MYBORROW = @"app/borrowStatusPages.do";

/**
 * 发布签署
 */
static NSString * SAVEBORROW = @"app/saveBorrow.do";

/**
 * 站内信未读数量
 */
static NSString * UNREADMESCOUNT = @"app/accountIndexToJson.do";


/**
 * 站内信标记为已读
 */
static NSString * MESSAGECONTENT = @"app/messageContent.do";


/**
 * 我的站内信
 */
static NSString * MYMESSAGES = @"app/userReceiveMessagePage.do";


/**
 * 我的好友
 */
static NSString * MYFRIENDS = @"app/myFriendsPage.do";

/**
 * 添加好友
 */
static NSString * ADDFRIEND = @"app/addFriend.do";

/**
 * 发送私信
 */
static NSString * SENDMSG = @"app/sendFriendMsg.do";

/**
 * 推荐系统
 */
static NSString * RECOMMED = @"app/recommend.do";

/**
 * 我推荐的好友
 */
static NSString * MYRECOMMEDFRIEND = @"app/myRecommend.do";

/**
 * 推荐登记
 */
static NSString * RECOMMENDREG = @"app/recommendRegAddRequest.do";

/**
 * 七日走势图
 */
static NSString * WEEKEARNING = @"app/selectWeekEarnings.do";

/**
 * 资金日历
 */
static NSString * SELCALENDAR = @"app/selCalendar.do";

/**
 * 日历详情
 */
static NSString * CALENDARDETAIL = @"app/showCalendarDetail.do";

/**
 * 我的债权转让
 */
static NSString * MYTRANSFERLIST = @"app/getTransferList.do";

/**
 * 债权转让详情
 */
static NSString * TRANSFERDETAIL = @"app/transferDetail.do";

/**
 * 债权转让明细表
 */
static NSString * TENDERINFOLIST = @"app/shwoBorrowTenderInfoByPage.do";

/**
 * 检查是否能修改昵称和生日
 */
static NSString * CHECKACCOUNTBIRTH = @"app/checkuserAccountAnduserBirthday.do";

/**
 * 验证交易密码
 */
static NSString * CHECKPAYPW = @"app/checkLoginAndPaypw.do";

/**
 * 修改交易密码
 */
static NSString * MODIFYPAYPASS = @"app/requestSaveUserPayPass.do";

/**
 * 修改登陆密码
 */
static NSString * MODIFYLOGINPASS = @"app/requestSaveUserLoginPass.do";

/**
 * 重置交易密码
 */
static NSString * UPADATEPAYPASS = @"app/updateUserPayPwd.do";

/**
 * 自动投标
 */
static NSString * AUTOTENDER = @"app/saveAutoTender.do";

/**
 * 修改自动投标状态
 */
static NSString * MODIFYAUTOTENDER = @"app/modifyAutoTenderStatus.do";

/**
 * 检查自动投标状态
 */
static NSString * AUTOTENDERSTATUS = @"app/selectAutoTenderStatus.do";



/**
 * 关于我们
 */
static NSString * ABOUTUS = @"app/channelDetail/43.do";

@interface NetAddress : NSObject




@end
