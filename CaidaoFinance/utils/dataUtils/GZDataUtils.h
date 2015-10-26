//
//  GZDataUtils.h
//  GAZREY.FRAME_1.0
//
//  Created by ZhuWeijie on 14-6-19.
//  Copyright (c) 2014年 zwj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>


@interface GZDataUtils : NSObject

+(NSString*)MD5:(NSString*)str;

///计算富文本高度
+(CGFloat)getTextHeightByString:(NSString*)str font:(UIFont*)font size:(CGSize)size;
///计算文本宽度
+(CGFloat)getTextWithByString:(NSString *)str font:(UIFont* )font size:(CGSize)size;


///去除phyton的date格式
+(NSString*)filterPhythonDate:(NSString*)dateTime;

///去除C#等后端框架返回数据自带的head
+(NSString*)replaceMicrosoftFrameHead:(NSString*)str;

///解析unicode格式编码
+(NSString *)replaceUnicode:(NSString *)unicodeStr;

///当前日期转字符串 //增加多种形式
+(NSString*)stringFromDate:(NSDate*)date;


+(NSString*)stringFromDateDay:(NSDate*)date;

+(NSString*)getYYMMDDByString:(NSString*)date;

///去除html标签
+(NSString *)filterHTML:(NSString *)html;
+(NSString *)flattenHTML:(NSString *)html trimWhiteSpace:(BOOL)trim;

///把数据写入本地沙盒中
+(BOOL)writeApplicationData:(NSData *)data toFile:(NSString *)fileName;

///把数据写入本地沙盒中   字典类型
+(BOOL)writeApplicationDictionary:(NSDictionary *)data toFile:(NSString *)fileName;

///把数据写入本地沙盒中   数组类型
+(BOOL)writeApplicationArray:(NSArray *)data toFile:(NSString *)fileName;

///查找是否有该数据存在于本地
+(BOOL)isExist:(NSString*)address;

///获取通用唯一识别码
+(NSString*)GetUUID;

+(NSData *)applicationDataFromFile:(NSString *)fileName;

///根据plist文件名得到相对应的字典
+(NSMutableDictionary *)applicationDictionaryFromFile:(NSString *)fileName;

///根据plist文件名得到相对应的数组
+(NSMutableArray *)applicationArrayFromFile:(NSString *)fileName;

@end
