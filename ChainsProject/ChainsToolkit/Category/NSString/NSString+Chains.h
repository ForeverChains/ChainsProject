//
//  NSString+Chains.h
//  MyConclusion
//
//  Created by 马腾飞 on 15/8/21.
//  Copyright (c) 2015年 mtf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Chains)


- (NSString *)chains_URLEncoding;
- (NSString *)chains_URLDecoding;

- (NSString *)chains_md5Str;

//有的二维码生成的含有中文的数据编码是GBK编码,需处理后才能正常显示中文
- (NSString *)chains_GBKDecode;

//字符串加密机密，可用于安全性要求较高的应用。
+ (NSData *)chains_AES256Encrypt:(NSString*)strSource withKey:(NSString*)key;
+ (NSString *)chains_AES256Decrypt:(NSData*)dataSource withKey:(NSString*)key;


/**
 判断字符串是否为空
 用类方法避免实例对象为nil，调用方法只能返回0
 */
+ (BOOL)chains_isEmpty:(NSString *)str;


/**
 *  字符串转数据
 */
- (NSData *)chains_transformToData;


/**
 将url参数转换成NSDictionary
 反向转换：- (NSString *)chains_URLQueryString;
 */
- (NSDictionary *)chains_transformURLQueryToParamsDic;

/**
 Json字串转字典
 反向转换：- (NSString *)chains_jsonString;
 */
- (NSDictionary *)chains_transformJsonStringToDictionary;


/**
 xml字符串转换成NSDictionary
 */
- (NSDictionary *)chains_dictionaryFromXML;

/**
 *  设置字符串中的特殊字符
 *
 *  @param identifyStringArray 目标字符
 *
 *  @return 转换结果
 */
- (NSMutableAttributedString *)chains_setAttributedWithIdentifyStringArray:(NSArray *)identifyStringArray color:(UIColor *)color font:(UIFont *)font;

/**
 提取字符串中的数字
 */
- (float)chains_extractNumber;

/**
 *  判断字符串是否包含中文
 */
- (BOOL)chains_includeChineseString;

/**
 *  删除字符串中的某段字符
 *
 *  @param str 需删除的字符
 */
- (NSString *)chains_deleteString:(NSString *)str;

/**
 *  倒序输出字符串
 *
 *  @param str 目标字符串
 *
 *  @return 倒序字符串
 */
+ (NSString *)chains_inversionOutputString:(NSString *)str;

/**
 *  正则表达式判断字符串
 */
- (BOOL)chains_regularExpressionMatchWithExpression:(NSString *)expression;

- (void)chains_regularExpressionMatchWithExpression:(NSString *)expression complete:(void(^)(BOOL existMatchResult, NSArray *resultArr))complete;

@end
