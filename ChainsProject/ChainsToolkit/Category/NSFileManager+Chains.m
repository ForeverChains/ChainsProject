//
//  NSFileManager+Chains.m
//  MyConclusion
//
//  Created by 马腾飞 on 15/9/1.
//  Copyright (c) 2015年 mtf. All rights reserved.
//

#import "NSFileManager+Chains.h"

@implementation NSFileManager (Chains)

+ (long long)chains_fileSizeAtPath:(NSString*)filePath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath])
    {
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize]/(1024.0*1024.0);
    }
    return 0;
}

+ (long long)chains_folderSizeAtPath:(NSString*)folderPath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil)
    {
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [[self class] chains_fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize;
}

+ (void)chains_clearCache:(NSString *)path
{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
}

+ (NSString *)chains_getDocumentsPath
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

+ (NSString *)chains_getCachesPath
{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

+ (NSString *)chains_getTmpPath
{
    return NSTemporaryDirectory();
}

+ (NSString *)chains_getBundleResourcePathWithFileName:(NSString *)name fileType:(NSString *)type
{
    return [[NSBundle mainBundle] pathForResource:name ofType:type];
}

@end
