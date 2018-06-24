//
//  Owner.m
//  LeChuangProject
//
//  Created by lianzun on 2017/9/13.
//  Copyright © 2017年 Chains. All rights reserved.
//

#import "Owner.h"

@implementation Owner
+ (instancetype)modelWithDic:(NSDictionary *)dic
{
    return [[self alloc] initWithDic:dic replacedSpecialKeyDic:@{@"app_name":@"CFBundleDisplayName"}];
}
@end
