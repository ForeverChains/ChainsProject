//
//  NSFileManager+Chains.h
//  MyConclusion
//
//  Created by 马腾飞 on 15/9/1.
//  Copyright (c) 2015年 mtf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (Chains)

/**
 *  获取文件大小
 *
 *  @param filePath 文件路径
 *
 *  @return 文件大小（单位：Mb）
 */
+ (long long)chains_fileSizeAtPath:(NSString*)filePath;

/**
 *  获取文件夹大小
 *
 *  @param folderPath 文件夹路径
 *
 *  @return 文件大小（单位：Mb）
 */
+ (long long)chains_folderSizeAtPath:(NSString*)folderPath;

/**
 *  清理缓存
 *
 *  @param path 缓存文件路径
 */
+ (void)chains_clearCache:(NSString *)path;

/**
 *  获取Documents目录路径
 */
+ (NSString *)chains_getDocumentsPath;

/**
 *  获取Caches目录路径
 */
+ (NSString *)chains_getCachesPath;

/**
 *  获取tmp目录路径
 */
+ (NSString *)chains_getTmpPath;

/**
 *  获取程序包中资源路径
 *
 *  @param name 资源名
 *  @param type 资源类型
 */
+ (NSString *)chains_getBundleResourcePathWithFileName:(NSString *)name fileType:(NSString *)type;

@end
