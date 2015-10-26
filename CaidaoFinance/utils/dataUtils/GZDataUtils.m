//
//  GZDataUtils.m
//  GAZREY.FRAME_1.0
//
//  Created by ZhuWeijie on 14-6-19.
//  Copyright (c) 2014年 zwj. All rights reserved.
//

#import "GZDataUtils.h"

@implementation GZDataUtils

+(NSString*)MD5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    
    //官方封装好的加密方法把cStr字符串转换成了32位的16进制数列（这个过程不可逆转） 存储到了result这个空间中
    
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
    /*
     x表示十六进制，%02X  意思是不足两位将用0补齐，如果多余两位则不影响
     NSLog("%02X", 0x888);  //888
     NSLog("%02X", 0x4); //04
     */
}

+(NSString *)replaceUnicode:(NSString *)unicodeStr {
    
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    
    //NSLog(@"Output = %@", returnStr);
    
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
}

+(CGFloat)getTextHeightByString:(NSString *)str font:(UIFont* )font size:(CGSize)size
{
    CGRect rect = [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil] context:nil];
    return rect.size.height;
}

+(CGFloat)getTextWithByString:(NSString *)str font:(UIFont* )font size:(CGSize)size
{
    CGRect rect = [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil] context:nil];
    return rect.size.width;
}

+(NSString*)replaceMicrosoftFrameHead:(NSString *)str
{
    NSString * replaceStr = [str stringByReplacingOccurrencesOfString:@"<string xmlns=\"http://schemas.microsoft.com/2003/10/Serialization/\">" withString:@""];
    NSString * replaceStr2 = [replaceStr stringByReplacingOccurrencesOfString:@"</string>" withString:@""];
    
    return replaceStr2;
}

#pragma mark GetDate
+(NSString*)stringFromDate:(NSDate*)date
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *destDateString = [formatter stringFromDate:date];
    
    return destDateString;
}

+(NSString*)stringFromDateDay:(NSDate*)date
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *destDateString = [formatter stringFromDate:date];
    
    return destDateString;
}

+(NSString*)getYYMMDDByString:(NSString *)date
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * date2 = [formatter dateFromString:date];
    NSDateFormatter * formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:@"yyyy-MM-dd"];
    NSString *destDateString = [formatter2 stringFromDate:date2];
    return destDateString;
}
+(NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"&lt" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@"&gt;" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@&gt;",text] withString:@""];
    }
    NSScanner * scanner2 = [NSScanner scannerWithString:html];
    NSString * text2 = nil;
    while([scanner2 isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner2 scanUpToString:@"&amp" intoString:nil];
        //找到标签的结束位置
        [scanner2 scanUpToString:@"&gt;" intoString:&text2];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@&gt;",text2] withString:@""];
    }
    NSString * str = [html stringByReplacingOccurrencesOfString:@"&amp;nbsp;" withString:@""];
    NSString * str1 = [str stringByReplacingOccurrencesOfString:@"p&amp;gt;" withString:@""];
    NSString * str2 = [str1 stringByReplacingOccurrencesOfString:@"&amp;lt;" withString:@""];
    NSString * str3 = [str2 stringByReplacingOccurrencesOfString:@"/" withString:@""];
    NSString * str4 = [str3 stringByReplacingOccurrencesOfString:@"&amp;amp;nbsp;" withString:@""];
    return str4;
    
}

#pragma mark saveFile
+(BOOL)writeApplicationData:(NSData *)data toFile:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    if (!docDir) {
        NSLog(@"Documents directory not found!");
        return NO;
    }
    NSString *filePath = [docDir stringByAppendingPathComponent:fileName];
    return [data writeToFile:filePath atomically:YES];
}

+(BOOL)writeApplicationDictionary:(NSDictionary *)data toFile:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    if (!docDir) {
        NSLog(@"Documents directory not found!");
        return NO;
    }
    NSString *filePath = [docDir stringByAppendingPathComponent:fileName];
    return [data writeToFile:filePath atomically:YES];
}

+(BOOL)writeApplicationArray:(NSArray *)data toFile:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    if (!docDir) {
        NSLog(@"Documents directory not found!");
        return NO;
    }
    NSString *filePath = [docDir stringByAppendingPathComponent:fileName];
    return [data writeToFile:filePath atomically:YES];
}

#pragma mark isExsitFile
//文件是否不存在
+(BOOL)isExist:(NSString *)address
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    // 传递 0 代表是找在Documents 目录下的文件。
    NSString *documentDirectory = [directoryPaths objectAtIndex:0];
    // DBNAME 是要查找的文件名字，文件全名
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:address];
    return ![fileManager fileExistsAtPath:filePath];
}

#pragma mark readFile
+(NSData *)applicationDataFromFile:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *filePath = [docDir stringByAppendingPathComponent:fileName];
    NSLog(@"%@",filePath);
    NSData *data = [[NSData alloc] initWithContentsOfFile:filePath];
    return data;
}

+(NSMutableDictionary *)applicationDictionaryFromFile:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *filePath = [docDir stringByAppendingPathComponent:fileName];
    NSLog(@"%@",filePath);
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    return data;
}

+(NSMutableArray *)applicationArrayFromFile:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *filePath = [docDir stringByAppendingPathComponent:fileName];
    NSLog(@"%@",filePath);
    NSMutableArray *data = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    return data;
}



+(NSString*)filterPhythonDate:(NSString*)dateTime
{
    dateTime = [dateTime substringToIndex:10];
    return dateTime;
}

+(NSString*)GetUUID
{
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}

@end
