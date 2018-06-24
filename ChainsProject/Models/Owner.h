//
//  Owner.h
//  LeChuangProject
//
//  Created by lianzun on 2017/9/13.
//  Copyright © 2017年 Chains. All rights reserved.
//

#import "BaseModel.h"

@interface Owner : BaseModel

@property (strong, nonatomic) NSString *ali_pid;
@property (strong, nonatomic) NSString *jpush_appkey;
@property (strong, nonatomic) NSString *um_appkey;
@property (strong, nonatomic) NSString *url_schemes;
@property (strong, nonatomic) NSString *wx_appkey;
@property (strong, nonatomic) NSString *url_host;
@property (strong, nonatomic) NSString *app_name;
@property (strong, nonatomic) NSString *ali_baichuan_appkey;

@end
