//
//  Parameters.h
//  GAZREY.FRAME_1.0
//
//  Created by ZhuWeijie on 14-7-30.
//  Copyright (c) 2014年 zwj. All rights reserved.
//

#import "LanguageController.h"

//百度翻译api
#define BAIDU_TRANSLATE_KEY @"UytAaMHTexSgzKFGXIUPcs9d"

#define BAIDU_TRANSLATE_URL @"http://openapi.baidu.com/public/2.0/bmt/translate"

#define ZH @"zh"

#define ENG @"en"

#define KOR @"kor"

#define FRA @"fra"

#define RU  @"ru"

#define JP  @"jp"

#define DE @"de"

//有道翻译api
#define YOUDAO_TRANSLATE_KEY @"580394278"

#define YOUDAO_TRANSLATE_URL(from,key,text) [NSString stringWithFormat:@"http://fanyi.youdao.com/openapi.do?keyfrom=%@&key=%@&type=data&doctype=json&version=1.1&q=%@"]

//本地存储的 可支持语言列表数据id
#define DOCUMENT_LANGUAGE_LIST  @"DOCUMENT_LANGUAGE_LIST"



/***********UerDefault***************/
#define USER_DEFAULT_USER_TYPE @"USER_DEFAULT_USER_TYPE"

//海外
#define USER_TYPE_ABROAD 1

//大陆
#define USER_TYPE_LAND 0

#define USER_DEFAULT_USER_ID @"USER_DEFAULT_USER_ID"

//引导页图片
#define USER_DEFAULT_INTRODUCTION_IMAGE @"USER_DEFAULT_INTRODUCTION_IMAGE"
#define USER_DEFAULT_INTRODUCTION_IMAGE_PATH @"USER_DEFAULT_INTRODUCTION_IMAGE_PATH"
#define USER_DEFAULT_INTRODUCTION_IMAGE_ID @"USER_DEFAULT_INTRODUCTION_IMAGE_ID"


#define TOKEN @"TOKEN"

#define USER_DEFAULT_LOGIN_STATE @"USER_DEFAULT_LOGIN_STATE"

#define USER_DEFAULT_IS_LOGIN 1

#define USER_DEFAULT_IS_UNLOGIN 0

#define USER_DEFAULT_ACCOUNT @"USER_DEFAULT_ACCOUNT"

#define USER_DEFAULT_BINDING_EMAIL @"USER_DEFAULT_BINDING_EMAIL"

#define USER_DEFAULT_TEL @"USER_DEFAULT_TEL"


//当前语言版本
#define USER_DEFAULT_LANGUAGE_STATE @"USER_DEFAULT_LANGUAGE_STATE"

#define USER_DEFAULT_CHINESE  @"0"

#define USER_DEFAULT_ENGLISH  @"1"

#define USER_DEFAULT_KOREAN  @"2"

#define USER_DEFAULT_JPANESE  @"3"

#define USER_DEFAULT_FRENCH  @"4"

#define USER_DEFAULT_RUSSIAN  @"5"



/******************login and register***************************/
//登陆用户名
#define USER_DEFAULT_USER_NAME @"USER_DEFAULT_USER_NAME"

//昵称
#define USER_DEFAULT_NICK_NAME @"USER_DEFAULT_NICK_NAME"

//登陆密码
#define USER_DEFAULT_PASSWORD @"USER_DEFAULT_PASSWORD"
//性别
#define USER_DEFAULT_USER_SEX @"USER_DEFAULT_USER_SEX"
//城市
#define USER_DEFAULT_USER_CITY @"USER_DEFAULT_USER_CITY"
//大学
#define USER_DEFAULT_USER_UNIVERSITY @"USER_DEFAULT_USER_UNIVERSITY"
//职业
#define USER_DEFAULT_USER_JOB @"USER_DEFAULT_USER_JOB"
//简介
#define USER_DEFAULT_USER_INTRO @"USER_DEFAULT_USER_INTRO"
//积分
#define USER_DEFAULT_USER_INTEGRAL @"USER_DEFAULT_USER_INTEGRAL"

//翻译引擎
#define USER_DEFAULT_TRANSLATE_ENGINE @"USER_DEFAULT_TRANSLATE_ENGINE"

#define UDID @"UDID"

//注册邮箱
#define USER_DEFAULT_EMAIL @"USER_DEFAULT_EMAIL"

#define POINT_OPEN_APP @"POINT_OPEN_APP"

#define POINT_OPEN_INFO @"POINT_OPEN_INFO"

#define POINT_VOTE   @"POINT_VOTE"


/***************asihttp 相关******************/
#define HTTP_DOMAIN @"http://123.57.208.169:8080/"

//修改积分
#define CHANGE_POINTS @"changepoint"

//注销
#define LOG_OUT @"logout"

//引导页
#define INTRODUCITON @"newest_introduction"

//引导页更新状态
#define INTRODUCTION_UPDATA @"if_update_introduction"

//参赛选手列表
#define GET_PLAYERS @"get_players/"
//搜索参赛选手
#define SEARCH_PLAYERS @"search_players/"

//传设备uid
#define GET_USER_BY_UID @"get_user_by_uid_or_create/"
//设置设备语言
#define SET_LANGUAGE @"set_language"

//语言列表
#define GET_LANGUAGE_LIST @"get_language_list"
//比赛主题列表
#define GET_COMPOTIONS_SUBJECTS @"get_competitionSubjects"
//比赛列表
#define GET_COMPETITIONS @"get_competitions"
//投票
#define VOTE @"vote"

//翻译
#define TRANSLATE @"translate/"

//咨询列表
#define GET_NEWS @"get_messages"
//资讯详情
#define GET_MESSAGE_INFO @"get_message/"
//匹配通讯录列表
#define IF_CELLPHONE_EXIST @"if_cellphones_exist"


//好友列表
#define GET_FRIENDS @"get_friends_list"
//注册
#define REGISTER @"reg"
//短信验证
#define CREAT_TOKEN @"createtoken"
//登录
#define LOGIN @"login"
//用户详情
#define GET_USER_INFO @"get_user/"

//主题列表
#define GET_SUBJECTS @"get_subjects"

//更新资料
#define UPDATE_USER_INFO @"update_user_info"

//修改密码
#define MODIFY_PASSWORD  @"modify_password"

//邀请
#define INVITE @"invite"

//true or false
#define HTTP_TRUE @"true"
//false
#define HTTP_FALSE @"false"

#define GET_NEWEST_VERSION @"newest_version"

//版本
#define VERSION @"VERSION"

/******************投票界面***********************/
#define VOTE_INFO_IS_CLOSE @"VOTE_INFO_IS_CLOSE"
#define VOTE_INFO_IS_OPEN @"VOTE_INFO_IS_OPEN"


/************************其他常用的类**************************************/
#define LANGUAGE(id)  [[LanguageController sharedController]getLanguage:id]



