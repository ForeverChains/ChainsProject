//
//  NSData+Chains.m
//  Summary
//
//  Created by 马腾飞 on 16/6/15.
//  Copyright © 2016年 chains. All rights reserved.
//

#import "NSData+Chains.h"
#import <CommonCrypto/CommonCryptor.h>

@implementation NSData (Chains)

- (NSData *)chains_AES256EncryptWithKey:(NSString*)key
{
    char keyPtr[kCCKeySizeAES256 + 1]; // room for terminator (unused)
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    NSUInteger dataLength = [self length];
    
    size_t bufferSize           = dataLength + kCCBlockSizeAES128;
    void *buffer                = malloc(bufferSize);
    
    size_t numBytesEncrypted    = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES256,
                                          NULL /* initialization vector (optional) */,
                                          [self bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess)
    {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    
    free(buffer);
    return nil;
}

- (NSData *)chains_AES256DecryptWithKey:(NSString*)key
{
    char keyPtr[kCCKeySizeAES256 + 1]; // room for terminator (unused)
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    
    // fetch key data
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [self length];
    
    size_t bufferSize           = dataLength + kCCBlockSizeAES128;
    void *buffer                = malloc(bufferSize);
    
    size_t numBytesDecrypted    = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES256,
                                          NULL /* initialization vector (optional) */,
                                          [self bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesDecrypted);
    
    if (cryptStatus == kCCSuccess)
    {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    
    free(buffer); //free the buffer;
    return nil;
}

- (NSString *)chains_transformToString
{
    return [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
}

@end
