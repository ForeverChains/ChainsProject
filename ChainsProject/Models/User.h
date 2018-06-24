//
//  User.h
//  NanShaProject
//
//  Created by 马腾飞 on 16/4/5.
//  Copyright © 2016年 chains. All rights reserved.
//

#import "BaseModel.h"

UIKIT_EXTERN NSString *const kUserPath;

@interface User : BaseModel

@property (copy, nonatomic) NSString *name;

+ (BOOL)autoLoginSuccess;
+ (void)saveCurrentUserToLocal:(User *)user;
+ (void)clearLocalInfo;

@end
