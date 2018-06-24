//
//  User.m
//  NanShaProject
//
//  Created by 马腾飞 on 16/4/5.
//  Copyright © 2016年 chains. All rights reserved.
//

#import "User.h"

NSString *const kUserPath = @"user.archiver";

@implementation User

+ (instancetype)modelWithDic:(NSDictionary *)dic
{
    User *user = [[self alloc] initWithDic:dic replacedSpecialKeyDic:@{@"userID":@"id",@"nickName":@"nickname"}];
    
    return user;
}

//登录成功后设置请求头的safeToken
//- (void)setSafeToken:(NSString *)safeToken
//{
//    _safeToken = safeToken;
//    [NetworkManager sharedManager].safeToken = safeToken;
//}

+ (void)saveCurrentUserToLocal:(User *)user
{
    [ApplicationContext sharedInstance].currentUser = user;
    //对象归档
    NSString *documentPath = [NSFileManager chains_getDocumentsPath];
    NSString *path = [documentPath stringByAppendingPathComponent:kUserPath];
    BOOL archiverSuccess = [NSKeyedArchiver archiveRootObject:user toFile:path];
    NSLog(@"存储用户:%d",archiverSuccess);
}

+ (BOOL)autoLoginSuccess
{
    NSString *userPath = [[NSFileManager chains_getDocumentsPath] stringByAppendingPathComponent:kUserPath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:userPath])
    {
        NSLog(@"用户文件存在,自动登录");
        //对象解档
        User *model = [NSKeyedUnarchiver unarchiveObjectWithFile:userPath];
        [ApplicationContext sharedInstance].currentUser = model;
        NSLog(@"当前用户:%@",model);
        return YES;
    }
    else
    {
        NSLog(@"用户文件不存在,手动登录");
        return NO;
    }
}

+ (void)clearLocalInfo
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [ApplicationContext sharedInstance].currentUser = nil;
    NSString *userPath = [[NSFileManager chains_getDocumentsPath] stringByAppendingPathComponent:kUserPath];
    NSError *error;
    if (![[NSFileManager defaultManager] removeItemAtPath:userPath error:&error]) {
        NSLog(@"remove currentuser Fail:%@",error);
    }
}

@end
