//
//  NSDictionary+Chains.h
//  CommonProject
//
//  Created by lianzun on 2017/9/16.
//  Copyright © 2017年 MTF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Chains)

/**
 NSDictionary转换成JSON字符串
 反向转换：- (NSDictionary *)chains_transformJsonStringToDictionary;
 */
- (NSString *)chains_jsonString;

- (NSString *)chains_jsonPrettyString;

/**
 将NSDictionary转换成url 参数字符串
 反向转换：- (NSDictionary *)chains_transformURLQueryToParamsDic
 */
- (NSString *)chains_URLQueryString;


/**
 将NSDictionary转换成XML 字符串
 反向转换：- (NSDictionary *)chains_dictionaryFromXML;
 */
- (NSString *)chains_XMLString;

@end
