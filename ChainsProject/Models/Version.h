//
//  Version.h
//  LeChuangProject
//
//  Created by lianzun on 2017/9/6.
//  Copyright © 2017年 Chains. All rights reserved.
//

#import "BaseModel.h"

@interface Version : BaseModel

@property (strong, nonatomic) NSString *appName;
@property (strong, nonatomic) NSString *versionNumber;
@property (strong, nonatomic) NSString *versionDescribe;
@property (strong, nonatomic) NSString *marketUrl;
@property (strong, nonatomic) NSString *qRCode;
@property (strong, nonatomic) NSString *type;//1:androd     2:iOS

@end
