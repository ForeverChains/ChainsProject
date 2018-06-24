//
//  NSData+Chains.h
//  Summary
//
//  Created by 马腾飞 on 16/6/15.
//  Copyright © 2016年 chains. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Chains)

/*
 加密和解密方法使用的参数密钥均为32位长度的字符串，所以可以将任意的字符串经过md5计算32位字符串作为密钥，
 这样可以允许客户输入任何长度的密钥，并且不同密钥的MD5值也不会重复。
 */
- (NSData *)chains_AES256EncryptWithKey:(NSString*)key;
- (NSData *)chains_AES256DecryptWithKey:(NSString*)key;

/**
 *  数据转字符串
 */
- (NSString *)chains_transformToString;

@end
